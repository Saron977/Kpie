//
//  BYC_LeftIntegralViewController.m
//  kpie
//
//  Created by 元朝 on 16/1/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_LeftIntegralViewController.h"
#import "BYC_IntegralCollectionViewCell1.h"
#import "BYC_IntegralCollectionViewCell2.h"
#import "BYC_levelIntroductionsViewController.h"
#import "BYC_HttpServers+BYC_Settings.h"

@interface BYC_LeftIntegralViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)  UICollectionView  *collectionView;
@property (nonatomic, strong)   NSArray <NSArray <BYC_MyLevelModel *> *> *arr_Models;
@property (nonatomic, strong)  BYC_UpgradeStatusModel *model;
@end

@implementation BYC_LeftIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的等级";
    UIBarButtonItem *item  = [[UIBarButtonItem alloc] initWithTitle:@"等级说明" style:UIBarButtonItemStylePlain target:self action:@selector(levelIntroductions)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self makeUI];
    [self requestData];
}

#pragma mark - 布局视图
-(void)makeUI
{
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing = 0.f;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //创建UICollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, screenWidth,screenHeight-64)  collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_IntegralCollectionViewCell1" bundle:nil] forCellWithReuseIdentifier:@"IntegralCollectionViewCell1"];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_IntegralCollectionViewCell2" bundle:nil] forCellWithReuseIdentifier:@"IntegralCollectionViewCell2"];
    
    [_collectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header1"];
    [_collectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
}

- (void)levelIntroductions {

    BYC_levelIntroductionsViewController *levelIntroductionsVC = [[BYC_levelIntroductionsViewController alloc] init];
    [self.navigationController pushViewController:levelIntroductionsVC animated:YES];
}

- (void)requestData {
    
    [BYC_HttpServers requestMyLevelDataWithParameters:@[[BYC_AccountTool userAccount].userid] success:^(AFHTTPRequestOperation *operation,  NSArray <NSArray <BYC_MyLevelModel *> *> *arr_Models, BYC_UpgradeStatusModel *model) {
        
        _arr_Models = arr_Models;
        _model = model;
        [self.collectionView reloadData];
    } failure:nil];
}

#pragma mark - collection的DataSource 和 Delegate方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    if(_arr_Models) return _arr_Models.count + 1;
    else return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (section == 0) return 1;
    return ((NSArray *)_arr_Models[section - 1]).count + 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell;
    if (indexPath.section == 0) {
        BYC_IntegralCollectionViewCell1 *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"IntegralCollectionViewCell1" forIndexPath:indexPath];
        cell1.model = _model;
        cell = cell1;
    }else {
        
       BYC_IntegralCollectionViewCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"IntegralCollectionViewCell2" forIndexPath:indexPath];
        cell2.indexPath = indexPath;
        if (indexPath.item != 0) cell2.model = _arr_Models[indexPath.section - 1][indexPath.item - 1];
        cell = cell2;
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    CGSize size;
    if (indexPath.section == 0) {
        
        size = CGSizeMake(screenWidth , 185);
    }else {
        
        size = CGSizeMake(screenWidth , 25);
    }
    return  size;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    UIView  *viewTop;
    UILabel *label2;
    if(kind == UICollectionElementKindSectionFooter)
    {
        
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        reusableView.backgroundColor = KUIColorBackgroundCuttingLine;
        return reusableView;
        
    }else {
        
        viewTop     = [[UIView alloc] init];
        viewTop.backgroundColor = KUIColorBackground;
        label2     = [[UILabel alloc] init];
        if (indexPath.section == 1) {
            
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
            UILabel *label1;
            UIView  *view1;
            UIView  *view2;
            if (![reusableView viewWithTag:1001]) {
                
                viewTop.tag = 1001;
                label2      = [[UILabel alloc] init];
                view1       = [[UIView alloc] init];
                label1      = [[UILabel alloc] init];
                view2       = [[UIView alloc] init];
                
                [reusableView addSubview:viewTop];
                [reusableView addSubview:label2];
                [reusableView addSubview:view1];
                [reusableView addSubview:label1];
                [reusableView addSubview:view2];
                
                view1.backgroundColor = KUIColorBaseGreenNormal;
                view2.backgroundColor = KUIColorBackgroundTouchDown;
                
                label1.text = @"升级宝典";
                label1.textColor = KUIColorBaseGreenNormal;
                label1.font = [UIFont systemFontOfSize:15];
                
                label2.text = @"基础奖励";
                label2.textColor = KUIColorFromRGB(0X6E314D);
                label2.font = [UIFont systemFontOfSize:14];
                
                [viewTop  mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.offset(screenWidth);
                    make.height.offset(10);
                    make.top.mas_equalTo(reusableView.top).offset(0);
                    make.left.mas_equalTo(reusableView.left).offset(0);
                }];

                [view1  mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.offset(5);
                    make.height.offset(15);
                    make.top.mas_equalTo(viewTop.mas_bottom).offset(14);
                    make.left.mas_equalTo(reusableView.left).offset(14);
                }];

                [label1  mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.offset(150);
                    make.height.offset(15);
                    make.top.mas_equalTo(viewTop.mas_bottom).offset(14);
                    make.left.mas_equalTo(view1.mas_right).offset(10);
                }];
                
                [view2  mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.offset(screenWidth);
                    make.height.offset(.5);
                    make.top.mas_equalTo(view1.mas_bottom).offset(14);
                    make.left.mas_equalTo(reusableView.mas_left).offset(0);
                }];
                
                [label2  mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.offset(150);
                    make.height.offset(14);
                    make.top.mas_equalTo(reusableView.top).offset(64);
                    make.left.mas_equalTo(reusableView.right).offset(14);
                }];
            }

        }else {
        
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header1" forIndexPath:indexPath];
            if (![reusableView viewWithTag:1002]) {
                
                label2.tag = 1002;
                label2.font = [UIFont systemFontOfSize:14];
                [reusableView addSubview:viewTop];
                [reusableView addSubview:label2];
                
                [viewTop  mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.offset(screenWidth);
                    make.height.offset(10);
                    make.top.mas_equalTo(reusableView.top).offset(0);
                    make.left.mas_equalTo(reusableView.left).offset(0);
                }];
                
                
                [label2  mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.offset(150);
                    make.height.offset(14);
                    make.top.mas_equalTo(reusableView.top).offset(24);
                    make.left.mas_equalTo(reusableView.right).offset(14);
                }];
            }
            
            switch (indexPath.section) {
                case 2:
                {
                    
                    label2.text = @"快速升级";
                    label2.textColor = KUIColorFromRGB(0X225B57);
                }
                    break;
                case 3:
                {
                    
                    label2.text = @"新手任务";
                    label2.textColor = KUIColorFromRGB(0X6E5A35);
                }
                    break;
                    
                default:
                    
                    break;
            }
        }
        
        reusableView.backgroundColor = KUIColorBackgroundModule1;
        return reusableView;
    }
    return nil;
}

//设置段头大小，竖着滚高有用，横着滚宽有用
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) return CGSizeZero;
    return CGSizeMake(screenWidth, 25);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return CGSizeZero;
            break;
        case 1:
            return CGSizeMake(screenWidth, 90);
            break;
        case 2:
            return CGSizeMake(screenWidth, 50);
            break;
        case 3:
            return CGSizeMake(screenWidth, 50);
            break;
            
        default:
            return CGSizeZero;
            break;
    }
}

@end
