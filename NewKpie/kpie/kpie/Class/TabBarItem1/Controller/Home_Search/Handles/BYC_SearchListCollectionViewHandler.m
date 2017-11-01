//
//  BYC_SearchListCollectionViewHandler.m
//  kpie
//
//  Created by 元朝 on 16/5/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_SearchListCollectionViewHandler.h"
#import "BYC_SearchListCollectionViewCell.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_ControllerCustomView.h"
#import "BYC_HttpServers+BYC_Search.h"

@interface BYC_SearchListCollectionViewHandler()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@end

@implementation BYC_SearchListCollectionViewHandler

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
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.emptyDataSetSource = self;
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
        return;
    }
    
    [self requestDataWithDic:@[string_KeyWorks]];
}

- (void)requestDataWithDic:(NSArray *)parameters {

    [BYC_HttpServers requestSearchListDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, NSArray *arr) {

        _array_Data = arr;
        [self.collectionView reloadData];
    } failure:nil];
}

#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"img_kbzt_wssdxgnr"];
    return image;
}
@end
