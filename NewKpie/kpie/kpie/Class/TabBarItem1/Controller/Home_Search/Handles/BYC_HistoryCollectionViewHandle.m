//
//  BYC_HistoryCollectionViewHandle.m
//  kpie
//
//  Created by 元朝 on 16/5/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HistoryCollectionViewHandle.h"
#import "BYC_HistoryCollectionViewCell.h"
#import "NSString+BYC_Tools.h"
#import "BYC_HistoyCollectionViewFlowLayout.h"
#import "BYC_HistoryCollectionReusableView.h"
#import "BYC_HistoryKeywordsHandel.h"

@interface BYC_HistoryCollectionViewHandle()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**数据*/
@property (nonatomic, strong)  NSMutableArray <NSArray *> *array_Data;

@end

@implementation BYC_HistoryCollectionViewHandle

- (instancetype)initHistoryCollectionViewHandle {

   self = [self init];
    if (self) {
        
        [self initParameters];
        [self setupCollectionView];
        [self requstNetWork];
    }
    return self;
}

- (void)initParameters {
    
    _array_Data = [NSMutableArray array];
    NSMutableArray *mArr_Keywords = [BYC_HistoryKeywordsHandel getHistoryKeyword];
    if (mArr_Keywords) [_array_Data addObject:mArr_Keywords];
}

- (void)requstNetWork {
    
    [BYC_HttpServers Get:KQNWS_GetListSearchUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *rows = responseObject[@"rows"];
        if (rows.count != 0)[_array_Data addObject:rows];
        [_collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIView alloc] showAndHideHUDWithTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress];
    }];
}

- (void)setupCollectionView {

    //设置布局
    BYC_HistoyCollectionViewFlowLayout *layout = [[BYC_HistoyCollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 20.f;
    layout.minimumLineSpacing = 20.f;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,screenHeight - KHeightNavigationBar)  collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView registerClass:[BYC_HistoryCollectionViewCell class] forCellWithReuseIdentifier:@"HistoryCollectionViewCell"];
    [_collectionView registerClass:[BYC_HistoryCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return _array_Data.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _array_Data[section].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BYC_HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionViewCell" forIndexPath:indexPath];
    cell.string_Text = _array_Data[indexPath.section][indexPath.row];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(kind == UICollectionElementKindSectionHeader)
    {
        
        BYC_HistoryCollectionReusableView  *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        if (indexPath.section == 0 && _array_Data.count != 1) header.dic_Data = @{@"title":@"历史记录",@"isHidden":@"0"};
        else if (indexPath.section == 0 && _array_Data.count == 1 && [BYC_HistoryKeywordsHandel getHistoryKeyword]/*表示是历史数据*/)
            header.dic_Data = @{@"title":@"历史记录",@"isHidden":@"0"};
            else header.dic_Data =  @{@"title":@"大家都在搜",@"isHidden":@"1"};
        __weak __typeof(self) weakSelf = self;
        header.clearRecodBlock = ^(){
        
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
            NSMutableArray *mArr = [_array_Data mutableCopy];
            [mArr removeObjectAtIndex:indexPath.section];
            _array_Data = [mArr copy];
            [weakSelf.collectionView deleteSections:indexSet];
        };
        return header;
    }
    
    return nil;
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [QNWSNotificationCenter postNotificationName:@"SearchListCollectionDidSelectItemNotification" object:nil userInfo:@{@"text":_array_Data[indexPath.section][indexPath.item]}];
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [self computeLabelSizeWithString:_array_Data[indexPath.section][indexPath.item]];
    return CGSizeMake(30 + size.width, 30);
}

//设置段头大小，竖着滚高有用，横着滚宽有用
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(screenWidth, 36);
}

- (CGSize)computeLabelSizeWithString:(NSString *)string {

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.text = string;
    [label sizeToFit];
    return label.ksize;
}

@end
