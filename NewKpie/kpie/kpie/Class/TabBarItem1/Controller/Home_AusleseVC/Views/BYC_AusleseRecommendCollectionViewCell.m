//
//  BYC_AusleseRecommendCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 16/7/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AusleseRecommendCollectionViewCell.h"
#import "BYC_RecommendCollectionViewCell.h"
#import "BYC_ScrollViewPanGestureRecognizer.h"
#import "BYC_AusleseJumpToVCHandler.h"

@interface BYC_AusleseRecommendCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**轮播banner*/
@property (nonatomic, strong)  UICollectionView  *collectionView;
@end

@implementation BYC_AusleseRecommendCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
    }
    return self;
}

-(void)setArr_RecommendModels:(NSArray *)arr_RecommendModels {

    _arr_RecommendModels = arr_RecommendModels;
    [_collectionView reloadData];
    
}

#pragma mark - 初始化子视图
- (void)initSubViews {
    
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 7.f;
    layout.minimumLineSpacing = 7.f;
    layout.itemSize = CGSizeMake(140, KWidthOnTheBasisOfIPhone6Size(62) - 7);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //创建UICollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds  collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 9, 7, 9);
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[BYC_RecommendCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendCollectionViewCell"];
}

#pragma mark - collection的DataSource 和 Delegate方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _arr_RecommendModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BYC_RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCollectionViewCell" forIndexPath:indexPath];
    cell.str_Url = _arr_RecommendModels[indexPath.row].elitetype == 0 || _arr_RecommendModels[indexPath.row].elitetype == 2 ? _arr_RecommendModels[indexPath.row].picturejpg : [_arr_RecommendModels[indexPath.row].picturejpg componentsSeparatedByString:@","][0];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    BYC_BaseVideoModel *model = _arr_RecommendModels[indexPath.row];
    [BYC_AusleseJumpToVCHandler jumpToVCWithModel:model];
}
@end
