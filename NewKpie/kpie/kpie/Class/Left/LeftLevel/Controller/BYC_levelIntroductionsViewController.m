//
//  BYC_levelIntroductionsViewController.m
//  kpie
//
//  Created by 元朝 on 16/1/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_levelIntroductionsViewController.h"
#import "BYC_levelIntroductionsCVCell.h"
#import "BYC_HttpServers+BYC_Settings.h"

@interface BYC_levelIntroductionsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)  UICollectionView  *collectionView;
@property (nonatomic, strong)  NSArray<BYC_UpgradeDescriptionModel *> *arr_Models;

@end

@implementation BYC_levelIntroductionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"等级说明";
    [self makeUI];
    [self requestData];;
}

#pragma mark - 布局视图
-(void)makeUI
{
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing = 0.f;
    layout.itemSize = CGSizeMake(screenWidth , 25.f);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //创建UICollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, screenWidth,screenHeight-64)  collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_levelIntroductionsCVCell" bundle:nil] forCellWithReuseIdentifier:@"levelIntroductionsCVCell"];
    [_collectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
}
- (void)requestData {
    
    [BYC_HttpServers requestUpgradeDescriptionDataWithParameters:nil success:^(AFHTTPRequestOperation *operation, NSArray<BYC_UpgradeDescriptionModel *> *arr_Models) {
        
        _arr_Models = arr_Models;
        [_collectionView reloadData];
        
    } failure:nil];
}

#pragma mark - collection的DataSource 和 Delegate方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arr_Models.count + 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BYC_levelIntroductionsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"levelIntroductionsCVCell" forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    if (indexPath.item == 0) {
        return cell;
    }
    cell.model = _arr_Models[indexPath.item - 1];
    return cell;
}


-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footer.backgroundColor = KUIColorBackgroundCuttingLine;
        
        return footer;
    }
    
    return nil;
}

//设置段头大小，竖着滚高有用，横着滚宽有用
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(screenWidth, 25);
}

@end
