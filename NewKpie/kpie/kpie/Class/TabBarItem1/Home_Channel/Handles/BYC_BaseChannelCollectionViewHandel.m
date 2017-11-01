//
//  BYC_BaseChnnelCollectionViewHandel.m
//  kpie
//
//  Created by 元朝 on 16/7/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelCollectionViewHandel.h"

#import "BYC_BaseChannelBannerCell.h"
#import "BYC_BaseChannelScrollSubtitleCell.h"
#import "NSString+BYC_Tools.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import "BYC_ScrollSubtitleView.h"
#import "BYC_HttpServers+HomeVC.h"
#import "BYC_BaseChannelChildModel.h"
#import "BYC_HomeCollectionViewCell.h"
#import "WX_VoideDViewController.h"

static NSString * const Key_BaseChannelChildModel =  @"Key_BaseChannelChildModel";
static CGFloat const float_DefualtSubTitleHeight =  30;
static CGFloat const float_DefualtContentInsetTop = KHeightNavigationBar + float_DefualtSubTitleHeight;

@interface BYC_BaseChannelCollectionViewHandel ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BYC_ScrollSubtitleViewDelegate>

@property (nonatomic, strong) NSArray <  NSString   *>      *array_CellIdentifier;
@property (nonatomic, strong) BYC_BaseChannelViewController *vc;
@property (nonatomic, assign) CGFloat                       float_DefualtOffset;
@property (nonatomic, strong) NSIndexPath                   *indexPath_CurrentData;
@property (nonatomic, strong) NSMutableDictionary <id , BYC_BaseChannelChildModel     *> *mDic_Data;

@end

@implementation BYC_BaseChannelCollectionViewHandel

+ (instancetype)initBaseChannelCollectionViewHandle:(BYC_BaseChannelViewController *)vc {

    BYC_BaseChannelCollectionViewHandel *my_Self = [[BYC_BaseChannelCollectionViewHandel alloc] init];;
    if (my_Self) {
        
        my_Self.vc = vc;
        [my_Self initParam];
        [my_Self initSubViews];
    }
    return my_Self;
}

- (void)initParam{

    _mDic_Data = [NSMutableDictionary dictionary];
}

- (void)setArr_Models:(NSArray<BYC_OtherViewControllerModel *> *)arr_Models {

    if (arr_Models.count > 0) {
        
        _arr_Models = arr_Models;
        
        self.indexPath_CurrentData = [NSIndexPath indexPathForRow:0 inSection:0];
        BYC_BaseChannelChildModel *model = [self getBaseChannelChildModelWithIndexPath];
        if (!model) {//默认创建的时候就是最新
            
            [self creatBaseChannelChildModel];
            [self requesrFirstData];
        }
    }
}

#pragma mark - 布局视图
-(void)initSubViews
{
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing = 0.f;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //创建UICollectionView
    _collectionView = [[BYC_BaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,screenHeight)  collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(float_DefualtContentInsetTop, 0, KHeightTabBar, 0);
    _collectionView.showsVerticalScrollIndicator = NO;
    [_vc.view addSubview:_collectionView];
    
    _array_CellIdentifier = @[@"BaseChannelBannerCell",@"BaseChannelScrollSubtitleCell",@"HomeCollectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_BaseChannelBannerCell" bundle:nil] forCellWithReuseIdentifier:_array_CellIdentifier[0]];
    [_collectionView registerClass:[BYC_BaseChannelScrollSubtitleCell class] forCellWithReuseIdentifier:_array_CellIdentifier[1]];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:_array_CellIdentifier[2]];
    [_collectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    QNWSWeakSelf(self);
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself requesrRefreshData];
    }];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself requesrRefreshData];
    }];
}


#pragma mark - collection的DataSource 和 Delegate方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _array_CellIdentifier.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0) return 1;
    if (section == 1) return 1;
    if (section == 2) return [self getBaseChannelChildModelWithIndexPath].arr_VideoModels.count;
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_array_CellIdentifier[indexPath.section] forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        BYC_BaseChannelBannerCell *cell1 = (BYC_BaseChannelBannerCell *)cell;
        cell1.model_Other = [self getBaseChannelChildModelWithIndexPath].model_Other;
        cell1.arr_BannerModels = [self getBaseChannelChildModelWithIndexPath].arr_BannerModels;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        BYC_ScrollSubtitleView *viewCell;
        if (!_vc.view_Suspension) {
            
            CGFloat floatCell;
            [(BYC_BaseChannelScrollSubtitleCell *)cell creatView:&viewCell DefualtOffset:&floatCell andVC:_vc andCollectionV:self.collectionView];
            viewCell.delegate = self;
            viewCell.arr_Models = _arr_Models;
            _vc.view_Suspension = viewCell;
            self.float_DefualtOffset = floatCell;
        }else {//重置高度以及当悬停视图悬停状态的时候，点击切换到其他不足以支撑悬停视图悬停的数据的时候，悬停视图会消失。因为没有添加到cell上，而scrollViewDidScroll又是在cell创建之前调用，所以在此要从新判断是否添加上到cell上。没有添加上，就添加。
            
            CGFloat edgeTop = _float_DefualtOffset - (collectionView.mj_offsetY + float_DefualtContentInsetTop);
            if (edgeTop > KHeightNavigationBar + float_DefualtSubTitleHeight) {
            
                BOOL isOK = NO;
                for (UIView *view in cell.subviews) if ([view isKindOfClass:[BYC_ScrollSubtitleView class]])isOK = YES;
                if (!isOK) {

                    [cell addSubview:_vc.view_Suspension];
                    _vc.view_Suspension.frame = CGRectMake(_vc.view_Suspension.left, 0, _vc.view_Suspension.kwidth, _vc.view_Suspension.kheight);
                }
            }
            
            float top = CGRectGetMinY(cell.frame);
            float insetTop = collectionView.contentInset.top;
            viewCell = (BYC_ScrollSubtitleView *)_vc.view_Suspension;
            if (viewCell.arr_Models.count == 0)viewCell.arr_Models = _arr_Models;
            self.float_DefualtOffset = top + insetTop;
        }
    }
    
    if (indexPath.section == 2) {
        
        BYC_HomeCollectionViewCell *cell1 = (BYC_HomeCollectionViewCell *)cell;
        cell1.model = [self getBaseChannelChildModelWithIndexPath].arr_VideoModels[indexPath.row];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        NSString *str = [self getBaseChannelChildModelWithIndexPath].model_Other.columnDesc;
        
        CGSize size = [str sizeWithfont:12 boundingRectWithSize:CGSizeMake(screenWidth - 24, MAXFLOAT)];
        return CGSizeMake(screenWidth, 137 + size.height);
    }
    if (indexPath.section == 1) return CGSizeMake(screenWidth, KWidthOnTheBasisOfIPhone6Size(40));
    if (indexPath.section == 2) return CGSizeMake(screenWidth / 2 - .5f , 180.f);
    
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 2) {
        
    WX_VoideDViewController *videoVC = [[WX_VoideDViewController alloc]init];
    BYC_HomeViewControllerModel *model = [self getBaseChannelChildModelWithIndexPath].arr_VideoModels[indexPath.row];
    if (model.isVR ==1) videoVC.isVR = YES;
    else videoVC.isVR = NO;
    videoVC.hidesBottomBarWhenPushed = YES;
    [videoVC receiveTheModelWith:[self getBaseChannelChildModelWithIndexPath].arr_VideoModels WithNum:indexPath.row WithType:1];
    [_vc.navigationController pushViewController:videoVC animated:YES];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([object isEqual:_collectionView]) {
        
        CGFloat edgeTop = _float_DefualtOffset - (_collectionView.mj_offsetY + float_DefualtContentInsetTop);
        
        if (edgeTop > KHeightNavigationBar + float_DefualtSubTitleHeight) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
            [cell addSubview:_vc.view_Suspension];
            _vc.view_Suspension.frame = CGRectMake(_vc.view_Suspension.left, 0, _vc.view_Suspension.kwidth, _vc.view_Suspension.kheight);
            
        }else {
            
            [_vc.view addSubview:_vc.view_Suspension];
            _vc.view_Suspension.frame = CGRectMake(_vc.view_Suspension.left, KHeightNavigationBar + float_DefualtSubTitleHeight, _vc.view_Suspension.kwidth, _vc.view_Suspension.kheight);
        }
    }
}

#pragma mark - BYC_ScrollSubtitleViewDelegate

- (void)scrollSubtitleView:(BYC_ScrollSubtitleView *)scrollSubtitleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == _indexPath_CurrentData.section && indexPath.row == _indexPath_CurrentData.row) return;
    self.indexPath_CurrentData = indexPath;
    BYC_BaseChannelChildModel *model = [self getBaseChannelChildModelWithIndexPath];
    if (!model) model = [self creatBaseChannelChildModel];
    scrollSubtitleView.selectStatue = model.type == ENUM_BaseChannelChildModelTypeNew ? ENUM_SelectStatueNew : ENUM_SelectStatueOld;
}

-(void)scrollSubtitleView:(BYC_ScrollSubtitleView *)scrollSubtitleView didSelectStatue:(ENUM_SelectStatue)statue {
    
    BYC_BaseChannelChildModel *model = [self getBaseChannelChildModelWithIndexPath];
    ENUM_BaseChannelChildModelType type;
    switch (statue) {
        case ENUM_SelectStatueNew: {

            type = ENUM_BaseChannelChildModelTypeNew;
            if (!model.isNewWhetherNoMoreData) [_collectionView.footer resetNoMoreData];
            else [_collectionView.footer endRefreshingWithNoMoreData];
            break;
        }
        case ENUM_SelectStatueOld: {

            type = ENUM_BaseChannelChildModelTypeHot;
            if (!model.isHotWhetherNoMoreData) [_collectionView.footer resetNoMoreData];
            else [_collectionView.footer endRefreshingWithNoMoreData];
            break;
        }
    }
    
    model.type = type;
    [self reloadData];
}

//点击没有的时候就直接创建数据模型:YES表示需要创建模型
- (BYC_BaseChannelChildModel *)creatBaseChannelChildModel{

    BYC_BaseChannelChildModel *model = [BYC_BaseChannelChildModel baseChannelChildModelWithOtherModel:nil arr_BannerModels:nil arr_VideoModels:nil];
        [_mDic_Data setObject:model forKey:@(_indexPath_CurrentData.row)];
    return model;
}

-(BYC_BaseChannelChildModel *)getBaseChannelChildModelWithIndexPath {

    return  [_mDic_Data objectForKey:@(_indexPath_CurrentData.row)];
}

- (void)reloadData {
        
    BYC_BaseChannelChildModel *model = [self getBaseChannelChildModelWithIndexPath];
    if (!model) [self creatBaseChannelChildModel];//默认创建的时候就是最新
    else if (!model.arr_VideoModels)[self requesrFirstData];
    else [_collectionView byc_reloadData];
}


- (void)requesrFirstData{
    
    if (_arr_Models.count > 0) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        @try {
            
            BYC_BaseChannelChildModel *model = [self getBaseChannelChildModelWithIndexPath];
            BYC_OtherViewControllerModel *model_Other = _arr_Models[_indexPath_CurrentData.row];
            [parameters setObject:@(model.type == ENUM_BaseChannelChildModelTypeNew ? 0 : 1) forKey:@"type"];
            [parameters setObject:model_Other.columnID forKey:@"columnid"];
            [parameters setObject:@((int)_indexPath_CurrentData.row) forKey:Key_BaseChannelChildModel];
            
        } @catch (NSException *exception) {
            QNWSLog(@"exception = %@",exception);
        }
        
        [self requestDataWithParam:parameters];
    }else {
    
        [_vc reloadData];
    }
}

- (void)requesrRefreshData {
    
    BYC_BaseChannelChildModel *model = [self getBaseChannelChildModelWithIndexPath];
    BYC_HomeViewControllerModel *model_Video;
    
    if (model.arr_VideoModels.count > 0) {//表示刷新之前，已经有数据
        
        if (_collectionView.header.isRefreshing) model_Video = [model.arr_VideoModels firstObject];
        else if(_collectionView.footer.isRefreshing) model_Video = [model.arr_VideoModels lastObject];
        else return;
    }else {//表示刷新之前没有视频数据,那就走正常逻辑去请求数据
    
        [self requesrFirstData];
        return;
    }
    
    BYC_OtherViewControllerModel *model_Other = model.model_Other != nil ? model.model_Other : _arr_Models[_indexPath_CurrentData.row];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    @try {
        
        [parameters setObject:model.type == ENUM_BaseChannelChildModelTypeNew ? @0 : @1 forKey:@"type"];
        [parameters setObject:model_Other.columnID forKey:@"columnid"];
        [parameters setObject:model_Video.onOffTime forKey:@"onofftime"];
        [parameters setObject:_collectionView.header.isRefreshing ? @0 : @1 forKey:@"upType"];
        [parameters setObject:model_Video.videoID forKey:@"videoId"];
        [parameters setObject:@(model_Video.views) forKey:@"views"];
        [parameters setObject:@((int)_indexPath_CurrentData.row) forKey:Key_BaseChannelChildModel];
        
    } @catch (NSException *exception) {
        QNWSLog(@"exception = %@",exception);
    }

    [self requestDataWithParam:parameters];
}

- (void)requestDataWithParam:(NSDictionary *)dicParameters {
    
    [BYC_HttpServers requestHomeVCChannelChildDataWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, NSArray<BYC_BaseChannelBannerModel *> *array_BannerModels, NSArray<BYC_HomeViewControllerModel *> *array_VideoModels) {
        
        if (self.collectionView.footer.isRefreshing) [self.collectionView.footer endRefreshing];//上拉结束
        if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];//下拉结束
        
        int Value_BaseChannelChildModel =  [[BYC_HttpServers getValueWithRequestOperation:operation key:Key_BaseChannelChildModel] intValue];
        int type   =  [[BYC_HttpServers getValueWithRequestOperation:operation key:@"type"] intValue];
        id  value_RefreshFlag = [BYC_HttpServers getValueWithRequestOperation:operation key:@"upType"];
        BYC_BaseChannelChildModel *model = [_mDic_Data objectForKey:@(Value_BaseChannelChildModel)];
        
        NSMutableArray<BYC_HomeViewControllerModel *> *mArr_VideoModels_Temp = [NSMutableArray array];
        
        if (value_RefreshFlag) {//上下拉

            int flag = [value_RefreshFlag intValue];
            NSMutableArray<BYC_HomeViewControllerModel *> *mArr_VideoModels = [[model getVideoDataWithType:type == 0 ? ENUM_BaseChannelChildModelTypeNew : ENUM_BaseChannelChildModelTypeHot] mutableCopy];
            for (BYC_HomeViewControllerModel *videoModel1 in array_VideoModels) {//上下拉排重
                BOOL isRepeat = NO;//NO 没有重复 YES 有重复
                for (BYC_HomeViewControllerModel *videoModel2 in mArr_VideoModels) if ([videoModel1.videoID isEqualToString:videoModel2.videoID]) isRepeat = YES;
                if (!isRepeat) [mArr_VideoModels_Temp addObject:videoModel1];
            }
            
            if (flag == 0) {//下拉
            
                if (mArr_VideoModels_Temp.count == 0) return;//无数据
                else {//有数据
                
                    NSMutableArray *mArr_Temp = mArr_VideoModels;
                    mArr_VideoModels = [mArr_VideoModels_Temp mutableCopy];
                    [mArr_VideoModels addObjectsFromArray:mArr_Temp];
                }
            }else if(flag == 1) {//上拉
                
                if (mArr_VideoModels_Temp.count == 0) {//无数据
                    
                    [self.collectionView.footer endRefreshingWithNoMoreData];//变为没有更多数据的状态
                    if (type == 0) model.isNewWhetherNoMoreData = YES;
                    else model.isHotWhetherNoMoreData = YES;
                    return;
                }else [mArr_VideoModels addObjectsFromArray:mArr_VideoModels_Temp];//有数据
            }
            
            [model baseChannelChildModelWithOtherModel:nil arr_BannerModels:nil arr_VideoModels:mArr_VideoModels type:type == 0 ? ENUM_BaseChannelChildModelTypeNew : ENUM_BaseChannelChildModelTypeHot];
        }else [model baseChannelChildModelWithOtherModel:_arr_Models[Value_BaseChannelChildModel] arr_BannerModels:array_BannerModels arr_VideoModels:array_VideoModels type:type == 0 ? ENUM_BaseChannelChildModelTypeNew : ENUM_BaseChannelChildModelTypeHot];//非上下拉

        [_collectionView byc_reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        if (self.collectionView.footer.isRefreshing) [self.collectionView.footer endRefreshing];
        if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
    }];
}

@end
