//
//  BYC_BaseChannelCollectionViewHandler.m
//  kpie
//
//  Created by 元朝 on 16/7/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelCollectionViewHandler.h"
#import "BYC_BaseChannelBannerCell.h"
#import "BYC_BaseChannelScrollSubtitleCell.h"
#import "NSString+BYC_Tools.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import "BYC_ScrollSubtitleView.h"
#import "BYC_HttpServers+HomeVC.h"
#import "BYC_BaseChannelModels.h"
#import "BYC_HomeCollectionViewCell.h"
#import "BYC_BaseShowPromptWithNoMoreDataCell.h"
#import "BYC_HttpServers+BYC_MotifData.h"
#import "BYC_BaseChannelModelHandler.h"
#import "HL_JumpToVideoPlayVC.h"

static NSString * const key_IsUpType              = @"upType";
static NSString * const key_IsVideoId             = @"videoId";
static NSString * const key_IsMyType              = @"key_IsMyType";
static NSString * const key_IsColumnId            = @"columnId";

static NSString * const Key_ModelIndex            = @"Key_ModelIndex";
static CGFloat const float_DefualtSubTitleHeight  = 30;
static CGFloat const float_DefualtContentInsetTop = KHeightNavigationBar + float_DefualtSubTitleHeight;

@interface BYC_BaseChannelCollectionViewHandler ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BYC_ScrollSubtitleViewDelegate,BaseShowPromptWithNoMoreDataCellDelegate>

@property (nonatomic, strong) NSArray <  NSString   *>      *array_CellIdentifier;
@property (nonatomic, strong) BYC_BaseChannelViewController *vc;
@property (nonatomic, assign) CGFloat                       float_DefualtOffset;

/**处理模型*/
@property (nonatomic, strong)  BYC_BaseChannelModelHandler  *handel_BaseChannelModel;
@end

@implementation BYC_BaseChannelCollectionViewHandler

#pragma mark - 本类系统相关方法(包括自定义的初始化方法)

+ (instancetype)initBaseChannelCollectionViewHandle:(BYC_BaseChannelViewController *)vc {
    
    BYC_BaseChannelCollectionViewHandler *my_Self = [[BYC_BaseChannelCollectionViewHandler alloc] init];;
    if (my_Self) {
        
        my_Self.vc = vc;
        [my_Self initSubViews];
    }
    return my_Self;
}

#pragma mark - 初始化子视图

-(void)initSubViews
{
    _handel_BaseChannelModel = [BYC_BaseChannelModelHandler baseChannelModelHandel];
    _handel_BaseChannelModel.indexPath_CurrentData = [NSIndexPath indexPathForRow:0 inSection:0];
    
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
    
    _array_CellIdentifier = @[@"BaseChannelBannerCell",@"BaseChannelScrollSubtitleCell",@"HomeCollectionCell",@"BaseShowPromptWithNoMoreDataCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_BaseChannelBannerCell" bundle:nil] forCellWithReuseIdentifier:_array_CellIdentifier[0]];
    [_collectionView registerClass:[BYC_BaseChannelScrollSubtitleCell class] forCellWithReuseIdentifier:_array_CellIdentifier[1]];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:_array_CellIdentifier[2]];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_BaseShowPromptWithNoMoreDataCell" bundle:nil] forCellWithReuseIdentifier:_array_CellIdentifier[3]];
    [_collectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    QNWSWeakSelf(self);
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{[weakself requestData];}];
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{[weakself requestData];}];
}

#pragma mark - 属性的get 及 set 方法
- (void)setMotifModels:(BYC_BaseChannelModels *)models_Motif index:(NSUInteger)index{

    _models_Motif = models_Motif;
    _handel_BaseChannelModel.index = index;
    _handel_BaseChannelModel.model_Motif = _models_Motif.model_Motif;
    _handel_BaseChannelModel.model_ChannelData = _models_Motif.arr_ChannelDataModels[index];
    
    if (index == 0) {//第一次
    
        _handel_BaseChannelModel.arr_ColumnModels = _models_Motif.arr_ColumnModels;
        
        [_handel_BaseChannelModel getColumnModelsWithDifferentIndex:0].arr_GroupModels = _models_Motif.arr_GroupModels;
        BYC_BaseChannelModels *models_CurrentTemp = [self getCurrentModel];
        [models_CurrentTemp baseChannelChildModelWithVideoModels:_models_Motif.arr_VideoModels themeModels:_models_Motif.arr_ThemeModels groupModels:_models_Motif.arr_GroupModels secCoverModels:_models_Motif.arr_SecCoverModels andShareUrl:_models_Motif.str_ShareUrl];
        [_collectionView reloadData];
    }else [self requestData];
}

#pragma mark - 网络请求数据

- (void)requestData {
    
    BYC_BaseChannelModels *model = [self getCurrentModel];
    BYC_BaseChannelColumnModel *model_ColumnTemp = [self getCurrentColumnModel].models_Column;
    BYC_BaseChannelDataModel *model_ChannelDataTemp = _handel_BaseChannelModel.model_ChannelData;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic_Temp = [NSMutableDictionary dictionary];
    @try {
    
        if ([[self getCurrentColumnModel] getCurrentGroupId].length > 0) {
        
            QNWSDictionarySetObjectForKey(parameters, @(0), @"sortBy") //新接口 也需要传个默认值0
            QNWSDictionarySetObjectForKey(parameters, [[self getCurrentColumnModel] getCurrentGroupId], @"groupId")
        }
    else QNWSDictionarySetObjectForKey(parameters, @([self getCurrentColumnModel].type), @"sortBy")
    if (model.arr_VideoModels.count == 0) {//表示刷新之前没有视频数据,那就走正常逻辑去请求数据
        QNWSDictionarySetObjectForKey(parameters,_handel_BaseChannelModel.model_Motif.motifid, @"motifId")
        QNWSDictionarySetObjectForKey(parameters, model_ChannelDataTemp.channelid, @"channelId")
        QNWSDictionarySetObjectForKey(parameters, @0, key_IsUpType)
        if (_handel_BaseChannelModel.arr_ColumnModels.count > 0 && _handel_BaseChannelModel.indexPath_CurrentData.row != 0) {//频道全部请求
            QNWSDictionarySetObjectForKey(parameters, model_ColumnTemp.columnid, key_IsColumnId)
            QNWSDictionarySetObjectForKey(parameters, model_ColumnTemp.isactive, @"columnType")
        }
        
    }else {//表示刷新之前，已经有数据
        
        BYC_BaseVideoModel *model_Video;
        if (_collectionView.header.isRefreshing) model_Video = [model.arr_VideoModels firstObject];
        else if(_collectionView.footer.isRefreshing) model_Video = [model.arr_VideoModels lastObject];
        else return;
        
        QNWSDictionarySetObjectForKey(parameters,_models_Motif.model_Motif.motifid, @"motifId")
        QNWSDictionarySetObjectForKey(parameters, model_ChannelDataTemp.channelid, @"channelId")
        QNWSDictionarySetObjectForKey(parameters, _collectionView.header.isRefreshing ? @1 : @2, key_IsUpType)
        QNWSDictionarySetObjectForKey(parameters, model_Video.onmstime, @"onmsTime")
        QNWSDictionarySetObjectForKey(parameters, model_Video.videoid, key_IsVideoId)
        QNWSDictionarySetObjectForKey(parameters, @(model_Video.views), @"amount")
        
        if (_handel_BaseChannelModel.arr_ColumnModels.count > 0 && _handel_BaseChannelModel.indexPath_CurrentData.row != 0) {//频道全部请求
            
            QNWSDictionarySetObjectForKey(parameters, model_ColumnTemp.columnid, key_IsColumnId)
            QNWSDictionarySetObjectForKey(parameters, model_ColumnTemp.isactive, @"columnType")
        }
    }
        
        QNWSDictionarySetObjectForKey(parameters, @(0), @"sortType")
        QNWSDictionarySetObjectForKey(dic_Temp, @([self getCurrentColumnModel].type), key_IsMyType)
        QNWSDictionarySetObjectForKey(dic_Temp, @(_handel_BaseChannelModel.indexPath_CurrentData.row), Key_ModelIndex)
        QNWSDictionarySetObjectForKey(parameters, dic_Temp, KSTR_DictionaryTemp)
    } @catch (NSException *exception) { QNWSShowException(exception); }

    [self requestDataWithParam:parameters];
}

- (void)requestDataWithParam:(NSDictionary *)dicParameters {
    
    [BYC_HttpServers requestMotifDataWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, NSArray<BYC_MotifModel *> *arr_MotifModels, BYC_BaseChannelModels *models) {

        if (self.collectionView.footer.isRefreshing) [self.collectionView.footer endRefreshing];//上拉结束
        if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];//下拉结束
        
        int isIndex     = [[BYC_HttpServers getValueWithRequestOperation:operation key:Key_ModelIndex] intValue];
        int isType      = [[BYC_HttpServers getValueWithRequestOperation:operation key:key_IsMyType] intValue];
        id  isUpType    = [BYC_HttpServers getValueWithRequestOperation:operation key:key_IsUpType];
        id  isVideoId   = [BYC_HttpServers getValueWithRequestOperation:operation key:key_IsVideoId];
        id  isColumnId  = [BYC_HttpServers getValueWithRequestOperation:operation key:key_IsColumnId];

        BYC_BaseColumnModelHandler *handel_ColumnModel = [_handel_BaseChannelModel getColumnModelsWithDifferentIndex:isIndex];
        
        NSMutableArray<BYC_BaseChannelVideoModel *> *mArr_VideoModels_Temp = [NSMutableArray array];

        if (isVideoId) {//上下拉
            
            int flag = [isUpType intValue];
            NSMutableArray<BYC_BaseChannelVideoModel *> *mArr_VideoModels = [[_handel_BaseChannelModel getVideoDataWithIndex:isIndex andType:isType] mutableCopy];
            for (BYC_BaseChannelVideoModel *videoModel1 in models.arr_VideoModels) {//上下拉排重
                BOOL isRepeat = NO;//NO 没有重复 YES 有重复
                for (BYC_BaseChannelVideoModel *videoModel2 in mArr_VideoModels) if ([videoModel1.videoid isEqualToString:videoModel2.videoid]) isRepeat = YES;
                if (!isRepeat) [mArr_VideoModels_Temp addObject:videoModel1];
            }
            
            if (flag == 1) {//下拉
                
                if (mArr_VideoModels_Temp.count == 0) return;//无数据
                else {//有数据
                    
                    NSMutableArray *mArr_Temp = mArr_VideoModels;
                    mArr_VideoModels = [mArr_VideoModels_Temp mutableCopy];
                    [mArr_VideoModels addObjectsFromArray:mArr_Temp];
                }
            }else if(flag == 2) {//上拉
                
                if (mArr_VideoModels_Temp.count == 0) {//无数据
                    
                    [self.collectionView.footer endRefreshingWithNoMoreData];//变为没有更多数据的状态
                    [handel_ColumnModel setIsWhetherNoMoreDataWithDifferentType:isType andNumber:@1];
                    return;
                }else [mArr_VideoModels addObjectsFromArray:mArr_VideoModels_Temp];//有数据
            }
            
            BYC_BaseChannelModels *models_Current = [_handel_BaseChannelModel getCurrentModelsWithDifferentIndex:isIndex andType:isType];
            [models_Current baseChannelChildModelWithVideoModels:[mArr_VideoModels copy] themeModels:nil groupModels:nil secCoverModels:nil andShareUrl:nil];
        }else {//非上下拉
        
            BYC_BaseChannelModels  *models_Current = [_handel_BaseChannelModel getCurrentModelsWithDifferentIndex:isIndex andType:isType];
            [models_Current baseChannelChildModelWithVideoModels:models.arr_VideoModels themeModels:models.arr_ThemeModels groupModels:models.arr_GroupModels secCoverModels:models.arr_SecCoverModels andShareUrl:models.str_ShareUrl];
            if (_handel_BaseChannelModel.index != 0 && isColumnId == nil)
                _handel_BaseChannelModel.arr_ColumnModels = models.arr_ColumnModels;//非第一个频道的第一个全部数据
            [_handel_BaseChannelModel getColumnModelsWithDifferentIndex:isIndex].arr_GroupModels = models.arr_GroupModels;//全部组
            handel_ColumnModel.isWhetherShowPromptWithNoMoreData = models.arr_VideoModels.count == 0 ? YES : NO;//是否展示空提示cell
        }
        [_collectionView byc_reloadData];
        
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
    if (section == 2) return [self getCurrentColumnModel].isWhetherShowPromptWithNoMoreData == YES ? 1 : [self getCurrentModel].arr_VideoModels.count;
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_array_CellIdentifier[indexPath.section] forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        BYC_BaseChannelBannerCell *cell1 = (BYC_BaseChannelBannerCell *)cell;
        if (_handel_BaseChannelModel.indexPath_CurrentData.row == 0)
            [self getCurrentColumnModel].models_Column.secondcover = _handel_BaseChannelModel.model_ChannelData.channelimg;
        cell1.model_Other = [self getCurrentColumnModel].models_Column;
        cell1.arr_BannerModels = [self getCurrentModel].arr_SecCoverModels;
        
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        BYC_ScrollSubtitleView *viewCell = ((BYC_BaseChannelScrollSubtitleCell *)cell).viewCell;
        viewCell.delegate = self;
        if (viewCell.arr_ColumnModels.count == 0)viewCell.arr_ColumnModels = _handel_BaseChannelModel.arr_ColumnModels;
        if ([self getCurrentColumnModel].type == 0)
            viewCell.arr_GroupModels  = [self getCurrentColumnModel].arr_GroupModels;
    }
    if (indexPath.section == 2) {
        
        if ([self getCurrentColumnModel].isWhetherShowPromptWithNoMoreData) {//没有数据的时候给个提示cell
            
            BYC_BaseShowPromptWithNoMoreDataCell *cell_NoMoreData = (BYC_BaseShowPromptWithNoMoreDataCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_array_CellIdentifier[indexPath.section + 1] forIndexPath:indexPath];
            cell_NoMoreData.delegate_BaseShowPromptWithNoMoreDataCell = self;
            return cell_NoMoreData;
        }else {
        
            BYC_HomeCollectionViewCell *cell1 = (BYC_HomeCollectionViewCell *)cell;
            cell1.model = [self getCurrentModel].arr_VideoModels[indexPath.row];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        NSString *str = [self getCurrentColumnModel].models_Column.columndesc;
        
        CGSize size = [str sizeWithfont:12 boundingRectWithSize:CGSizeMake(screenWidth - 24, MAXFLOAT)];
        return CGSizeMake(screenWidth, 137 - 90 + KImageHeight_Channel + size.height);
    }
    if (indexPath.section == 1) return CGSizeMake(screenWidth, KWidthOnTheBasisOfIPhone6Size(40));
    if (indexPath.section == 2) {
    
        if ([self getCurrentColumnModel].isWhetherShowPromptWithNoMoreData) {
            
            NSString *str = [self getCurrentColumnModel].models_Column.columndesc;
            CGSize size = [str sizeWithfont:12 boundingRectWithSize:CGSizeMake(screenWidth - 24, MAXFLOAT)];
           return  CGSizeMake(_collectionView.kwidth , _collectionView.kheight - (137 + size.height + KWidthOnTheBasisOfIPhone6Size(40) + _collectionView.contentInset.top + KHeightTabBar));
        } else return CGSizeMake(screenWidth / 2 - .5f , 180.f);
    }
    
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        BYC_BaseChannelVideoModel *model = [self getCurrentModel].arr_VideoModels[indexPath.row];
        [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
    }
}

#pragma mark - 其它系统类的代理（例如UITextField,UITextView等）

#pragma mark - 自定义类的代理

- (void)scrollSubtitleView:(BYC_ScrollSubtitleView *)scrollSubtitleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _handel_BaseChannelModel.indexPath_CurrentData.section && indexPath.row == _handel_BaseChannelModel.indexPath_CurrentData.row) return;
    _handel_BaseChannelModel.indexPath_CurrentData = indexPath;
    scrollSubtitleView.type = [self getCurrentColumnModel].type;
}

-(void)scrollSubtitleView:(BYC_ScrollSubtitleView *)scrollSubtitleView didSelectType:(NSUInteger)type {

    BYC_BaseColumnModelHandler *model = [self getCurrentColumnModel];
    model.type = type;
    if ([[model getIsWhetherNoMoreDataWithDifferentType:type] integerValue] == 0) [_collectionView.footer resetNoMoreData];
    else [_collectionView.footer endRefreshingWithNoMoreData];
    [self reloadData];
}

-(void)baseShowPromptWithNoMoreDataCellTouchBegin:(BYC_BaseShowPromptWithNoMoreDataCell *)cell {

    [self reloadData];
}
#pragma mark - 本类创建的的相关方法（不是本类系统的方法）

-(BYC_BaseChannelModels *)getCurrentModel {

    return  _handel_BaseChannelModel.models_Current;
}

-(BYC_BaseColumnModelHandler *)getCurrentColumnModel {
    
    return  _handel_BaseChannelModel.handel_ColumnModels;
}

-(BYC_BaseColumnModelHandler *)getColumnModelWithType:(int)type {
    
    return  _handel_BaseChannelModel.handel_ColumnModels;
}

- (void)reloadData {
        
    BYC_BaseChannelModels *model = [self getCurrentModel];
    if (!model.arr_VideoModels) {
    
        _collectionView.footer.alpha = 0;
        [_collectionView reloadData];
        [_collectionView.header beginRefreshing];
    } else [_collectionView byc_reloadData];
}

@end
