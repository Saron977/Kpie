//
//  BYC_OtherViewController.m
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_OtherViewController.h"
#import "BYC_OtherCollectionViewCell.h"
#import "BYC_OtherViewControllerModel.h"
#import "BYC_MainNavigationController.h"
/************▼▼▼比基尼大赛栏目▼▼▼**********/
#import "BYC_MTColumnViewcontroller.h"
#import "BYC_BaseCollectionView.h"
#import "BYC_JumpToVCHandler.h"
#import "BYC_HttpServers+BYC_MotifData.h"
/************▲▲▲比基尼大赛栏目▲▲▲**********/
@interface BYC_OtherViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**主题模型*/
@property (nonatomic, strong)  BYC_MotifModel  *model_Motif;

@property (nonatomic, strong)  UICollectionView *collectionView;
@property (nonatomic, strong)  NSArray <BYC_BaseChannelColumnModel *> *arrayModels;
@end

@implementation BYC_OtherViewController

- (instancetype)initWithMotifModel:(BYC_MotifModel *)motifModel {
    
    self = [super init];
    if (self) {
        
        self.model_Motif = motifModel;
    }
    return self;
}

-(void)viewDidLoad {

    [super viewDidLoad];
    
    //初始化Cell
    [self makeUI];
    [self requestData];
}

-(NSArray<BYC_BaseChannelColumnModel *> *)arrayModels {

    if (_arrayModels == nil) _arrayModels = [NSMutableArray array];
    return _arrayModels;


}
- (void)requestData {
    
    
    [BYC_HttpServers requestMotifDataWithParameters:@{@"motifId":self.model_Motif.motifid} success:^(AFHTTPRequestOperation *operation, NSArray<BYC_MotifModel *> *arr_MotifModels, BYC_BaseChannelModels *models) {
        
        _arrayModels = models.arr_ColumnModels;
        [_collectionView reloadData];
    } failure:nil];
}

#pragma mark - 布局视图
-(void)makeUI
{
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    layout.itemSize = CGSizeMake(screenWidth , KImageHeight_ActivityOut);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //创建UICollectionView
    _collectionView = [[BYC_BaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,screenHeight) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    //当数据不多，collectionView.contentSize小于collectionView.frame.size的时候，UICollectionView是不会滚动的设置alwaysBounceVertical就可以了
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(KHeightNavigationBar, 0, KHeightTabBar, 0);
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_OtherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"otherCollectionViewCell"];

}

#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"otherCollectionViewCell";
    
    BYC_OtherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];

    BYC_OtherViewControllerModel *model = (BYC_OtherViewControllerModel *)_arrayModels[indexPath.row];
    [cell.imageV_picture sd_setImageWithURL:[NSURL URLWithString:model.firstcover] placeholderImage:nil];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BYC_OtherViewControllerModel *model = (BYC_OtherViewControllerModel *)_arrayModels[indexPath.row];
    [BYC_JumpToVCHandler jumpToColumnWithColumnId:model.columnid];
}
@end
