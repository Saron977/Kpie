//
//  BYC_SearchListCollectionViewHandle.m
//  kpie
//
//  Created by 元朝 on 16/5/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_SearchListCollectionViewHandle.h"
#import "BYC_SearchListCollectionViewCell.h"
#import "UICollectionView+BYC_PlaceHolder.h"


@interface BYC_SearchListCollectionViewHandle()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end

@implementation BYC_SearchListCollectionViewHandle

- (instancetype)initSearchListCollectionViewHandle {
    
    self = [self init];
    if (self) {
        
        [self _initParams];
        [self setupCollectionView];
    }
    
    return self;
}

- (void)_initParams {

    [QNWSNotificationCenter addObserver:self selector:@selector(receiveNotificationAction:) name:@"RealTimeKeywordsRequstNotification" object:nil];    
}

- (void)setupCollectionView {
    
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(screenWidth , 45);
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,screenHeight - KHeightNavigationBar)  collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView registerClass:[BYC_SearchListCollectionViewCell class] forCellWithReuseIdentifier:@"HistoryCollectionViewCell"];
}

-(void)setArray_Data:(NSArray *)array_Data {
    
    _array_Data = array_Data;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _array_Data.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BYC_SearchListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionViewCell" forIndexPath:indexPath];
    cell.string_Text = _array_Data[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [QNWSNotificationCenter postNotificationName:@"SearchListCollectionDidSelectItemNotification" object:nil userInfo:@{@"text":_array_Data[indexPath.item]}];
    
}

- (void)receiveNotificationAction:(NSNotification *)notification {

    NSString *string_KeyWorks = notification.userInfo[@"SearchText"];
    
    if (string_KeyWorks.length == 0) {
        
        _array_Data = @[];
        [_collectionView byc_reloadData:@"换个关键词试一试"];
        return;
    }
    
    [self requestDataWithDic:@{@"keyWord":string_KeyWorks}];
    
}

- (void)requestDataWithDic:(NSDictionary *)parameters {

    [BYC_HttpServers Get:KQNWS_GetUVMatchVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *rows = responseObject[@"rows"];
        
        if (rows.count == 0) _array_Data = @[];//无数据
        else {//有数据
            
            NSArray *rows = responseObject[@"rows"];
            NSMutableArray *marr = [NSMutableArray array];
            for (NSArray <NSString *> *row in rows)
                [marr addObject:row[0].length > 0 ?  row[0] : row[1]];
            _array_Data = [marr copy];
        }
        [_collectionView byc_reloadData:@"换个关键词试一试"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIView alloc] showAndHideHUDWithTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress];
    }];
}

-(void)dealloc {
    
    [QNWSNotificationCenter removeObserver:self];
}
@end
