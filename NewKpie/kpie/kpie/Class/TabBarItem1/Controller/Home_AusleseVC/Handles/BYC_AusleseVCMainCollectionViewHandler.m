//
//  BYC_AusleseVCMainCollectionViewHandler.h
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//


#import "BYC_AusleseVCMainCollectionViewHandler.h"
#import "BYC_HomeCollectionViewCell.h"
#import "BYC_AusleseBannerCollectionViewCell.h"
#import "BYC_AusleseRecommendCollectionViewCell.h"
#import "BYC_BaseCollectionView.h"
#import "BYC_HttpServers+HomeVC.h"
#import "HL_JumpToVideoPlayVC.h"

static NSString * const key_IsUpType  = @"upType";
static NSString * const key_IsVideoId = @"videoId";

@interface BYC_AusleseVCMainCollectionViewHandler ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray            *cellArrayModels;
@property (nonatomic, strong) NSArray <NSString *> *array_CellIdentifier;
/**标示是否还有数据*/
@property (nonatomic, assign) BOOL                      isNewWhetherNoMoreData;
/**数据*/
@property (nonatomic, strong) BYC_AusleseVCModels       *models;
@property (nonatomic, strong) BYC_AusleseViewController *vc;
@end

@implementation BYC_AusleseVCMainCollectionViewHandler

#pragma mark - 本类系统相关方法(包括自定义的初始化方法)

+ (instancetype)initAusleseVCMainCollectionViewHandel:(BYC_AusleseViewController *)vc {

    BYC_AusleseVCMainCollectionViewHandler *my_Self = [[BYC_AusleseVCMainCollectionViewHandler alloc] init];;
    if (my_Self) {
        
        my_Self.vc = vc;
        [my_Self initParam];
        [my_Self initSubViews];
        //网络请求
        if (my_Self.collectionView) [my_Self.collectionView.header beginRefreshing];
        else [my_Self requestData];
    }
    return my_Self;
}
#pragma mark - 初始化子视图

- (void)initParam {

    _cellArrayModels   = [NSMutableArray array];
}

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
    _collectionView.contentInset = UIEdgeInsetsMake(KHeightNavigationBar, 0, KHeightTabBar, 0);
    _collectionView.showsVerticalScrollIndicator = NO;
    [_vc.view addSubview:_collectionView];
    
    _array_CellIdentifier = @[@"AusleseBannerCollectionViewCell",@"AusleseRecommendCollectionViewCell",@"HomeCollectionCell"];
    [_collectionView registerClass:[BYC_AusleseBannerCollectionViewCell class] forCellWithReuseIdentifier:_array_CellIdentifier[0]];
    [_collectionView registerClass:[BYC_AusleseRecommendCollectionViewCell class] forCellWithReuseIdentifier:_array_CellIdentifier[1]];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:_array_CellIdentifier[2]];
    [_collectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestData];
    }];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self requestData];
    }];
}
#pragma mark - 属性的get 及 set 方法
#pragma mark - 网络请求数据

- (void)requestData {
    
    NSMutableDictionary *mDic_Param  = [NSMutableDictionary dictionary];
    @try {
        
        BYC_BaseVideoModel *model_Video;
        if (_models.arr_VideoModels.count == 0) mDic_Param = [@{key_IsUpType:@0} mutableCopy];//表示刷新之前没有视频数据,那就走正常逻辑去请求数据
        else {//表示刷新之前，已经有数据
            
            if (_collectionView.header.isRefreshing) model_Video = [_models.arr_VideoModels firstObject];
            else if(_collectionView.footer.isRefreshing) model_Video = [_models.arr_VideoModels lastObject];
            else return;
            QNWSDictionarySetObjectForKey(mDic_Param, _collectionView.header.isRefreshing ? @1 : @2, key_IsUpType);
            QNWSDictionarySetObjectForKey(mDic_Param, model_Video.onmstime, @"onmsTime");
            QNWSDictionarySetObjectForKey(mDic_Param, model_Video.videoid, key_IsVideoId);
        }
    } @catch (NSException *exception) { QNWSShowException(exception); }
    
    [self requestDataWithParam:mDic_Param];
}

- (void)requestDataWithParam:(NSDictionary *)dic_Param {
    
    [BYC_HttpServers requestHomeVCAusleseDataWithParameters:dic_Param success:^(AFHTTPRequestOperation *operation, BYC_AusleseVCModels *models) {
        
        if (self.collectionView.footer.isRefreshing) [self.collectionView.footer endRefreshing];//上拉结束
        if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];//下拉结束
        
        id  isUpType = [BYC_HttpServers getValueWithRequestOperation:operation key:key_IsUpType];
        id  isVideoId = [BYC_HttpServers getValueWithRequestOperation:operation key:key_IsVideoId];
        if (isVideoId) {//上下拉
            
            int flag = [isUpType intValue];
            NSMutableArray<BYC_BaseVideoModel *> *mArr_VideoModels_Temp = [NSMutableArray array];
            for (BYC_HomeViewControllerModel *videoModel1 in models.arr_VideoModels) {//上下拉排重
                BOOL isRepeat = NO;//NO 没有重复 YES 有重复
                for (BYC_BaseVideoModel *videoModel2 in _models.arr_VideoModels) if ([videoModel1.videoid isEqualToString:videoModel2.videoid]) isRepeat = YES;
                if (!isRepeat) [mArr_VideoModels_Temp addObject:videoModel1];
            }
            
            if (flag == 1) {//下拉
                
                if (mArr_VideoModels_Temp.count == 0) return;//无数据
                else {//有数据
                    
                    [mArr_VideoModels_Temp addObjectsFromArray:_models.arr_VideoModels];
                    _models.arr_VideoModels = [mArr_VideoModels_Temp copy];
                    if (models.arr_BannerModels.count > 0) _models.arr_BannerModels = models.arr_BannerModels;
                    if (models.arr_RecommendModels.count > 0) _models.arr_RecommendModels = models.arr_RecommendModels;
                }
            }else if(flag == 2) {//上拉
                
                if (mArr_VideoModels_Temp.count == 0) {//无数据
                    
                    [self.collectionView.footer endRefreshingWithNoMoreData];//变为没有更多数据的状态
                    _isNewWhetherNoMoreData = YES;
                    return;
                }else {//有数据
                    
                    NSMutableArray *mArr_Temp = [NSMutableArray array];
                    mArr_Temp  = [_models.arr_VideoModels mutableCopy];
                    [mArr_Temp addObjectsFromArray:mArr_VideoModels_Temp];
                    _models.arr_VideoModels = [mArr_Temp copy];
                    
                }
            }
            
        }else {//非上下拉
        
            _models = models;
            [self.vc setupMotif:_models.arr_MotifModels];
        }
        [_collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (self.collectionView.footer.isRefreshing) [self.collectionView.footer endRefreshing];
        if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
    }];
}
#pragma mark - UIScrollView 以及其子类的数据源和代理

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _array_CellIdentifier.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0) return 1;
    if (section == 1) return 1;
    if (section == 2) return _models.arr_VideoModels.count;
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_array_CellIdentifier[indexPath.section] forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            BYC_AusleseBannerCollectionViewCell *cell_Banner = (BYC_AusleseBannerCollectionViewCell *)cell;
            cell_Banner.arr_BannerModels = _models.arr_BannerModels;
        }
            break;
        case 1:
        {
        
            BYC_AusleseRecommendCollectionViewCell *cell_Recommend = (BYC_AusleseRecommendCollectionViewCell *)cell;
            cell_Recommend.arr_RecommendModels= _models.arr_RecommendModels;
        }
            
            break;
        case 2:
        {
        
            BYC_HomeCollectionViewCell *cell1 = (BYC_HomeCollectionViewCell *)cell;
            cell1.model = _models.arr_VideoModels[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (![header viewWithTag:1001]) {
            
            UIView *view_Base = [[UIView alloc] init];
            view_Base.tag = 1001;
            [header addSubview:view_Base];
            
            [view_Base mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.bottom.insets(UIEdgeInsetsMake(0, 9, 9, 0));
                make.width.offset(screenWidth - 18);
                make.height.offset(17);
            }];
            
            UIView *view_TopLine = [[UIView alloc] init];
            [header addSubview:view_TopLine];
            view_TopLine.backgroundColor = KUIColorFromRGB(0XDEDEDE);
            
            [view_TopLine mas_makeConstraints:^(MASConstraintMaker *make) {
                
                (void)make.leading.top;
                make.width.equalTo(view_TopLine.superview);
                make.height.offset(.5);
            }];
            
            
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.tag = 1;
            [view_Base addSubview:imageV];
            imageV.contentMode = UIViewContentModeScaleAspectFit;
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                
                (void)make.top.leading;
                make.height.width.offset(17);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.tag = 2;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = KUIColorFromRGB(0X4D606F);
            label.textAlignment = NSTextAlignmentCenter;
            [view_Base addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(imageV.mas_trailing).offset(5);
                make.centerYWithinMargins.equalTo(imageV.superview);
                make.height.equalTo(label.superview);
            }];
        }
        
        UIImageView *imageV = (UIImageView *)[header viewWithTag:1];
        UILabel     *label  = (UILabel *)[header viewWithTag:2];
        if (indexPath.section == 1) {
            
            imageV.image = [UIImage imageNamed:@"home_icon_kptj_n"];
            label.text = @"看拍推荐";
            
        }else if (indexPath.section == 2) {
            
            imageV.image = [UIImage imageNamed:@"home_icon_rmsp_n"];
            label.text = @"热门视频";
        }
        
        return header;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return CGSizeMake(screenWidth, KImageHeight_Banner);
    if (indexPath.section == 1) return CGSizeMake(screenWidth, KWidthOnTheBasisOfIPhone6Size(62));
    if (indexPath.section == 2) return CGSizeMake(screenWidth / 2 - .5f , 180.f);
    return CGSizeZero;
}

//设置段头大小，竖着滚高有用，横着滚宽有用
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 1) return CGSizeMake(screenWidth, 39);
    if (section == 2) return CGSizeMake(screenWidth, 39);
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 2) {
        [HL_JumpToVideoPlayVC jumpToVCWithModel:_models.arr_VideoModels[indexPath.row] andVideoTepy:_models.arr_VideoModels[indexPath.row].isvr andisComment:NO andFromType:ENU_FromOtherVideo];
    }
}
#pragma mark - 其它系统类的代理（例如UITextField,UITextView等）

#pragma mark - 自定义类的代理

#pragma mark - 本类创建的的相关方法（不是本类系统的方法）

@end
