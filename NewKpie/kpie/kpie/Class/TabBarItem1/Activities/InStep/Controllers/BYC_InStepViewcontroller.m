//
//  BYC_InStepViewcontroller.m
//  kpie
//
//  Created by 元朝 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//
//  合拍 定制栏目 以后其他类似栏目可以借用
//  合拍 定制栏目 以后其他类似栏目可以借用
//  合拍 定制栏目 以后其他类似栏目可以借用

#import "BYC_InStepViewcontroller.h"
#import "BYC_InStepCollectionViewCell.h"
#import "BYC_InStepCollectionViewCellModel.h"
#import "BYC_SetBackgroundColor.h"
#import "BYC_InStepColumnCollectionHeader.h"
#import "WX_MovieCViewController.h"
#import "BYC_TopHiddenView.h"

#import "BYC_MTVideoGroupModel.h"
#import "BYC_MTBannerModel.h"
#import "BYC_ShareView.h"
#import "HL_JumpToVideoPlayVC.h"

#define BYC_ColumnCollectionHeaderLabelSize CGSizeMake(screenWidth - 16, 12)
#define VC_CONST_COLLECTION_HEADER 277

@interface BYC_InStepViewcontroller()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UMSocialUIDelegate> {

    BOOL _isNewFocusWhetherMore;  //赛区看点最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotFocusWhetherMore;  //赛区看点最热是否已经上拉加载更多加载完毕所有数据

    BOOL _isNewFavoriteWhetherMore;  //热门选手最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotFavoriteWhetherMore;  //热门选手最热是否已经上拉加载更多加载完毕所有数据
    
    UICollectionViewFlowLayout   *_layout;
    CGSize                       _headerSize;
    UIImageView                  *_imageV_Header;
    BYC_TopHiddenView            *_topView;
    BYC_InStepColumnCollectionHeader *_header;
    
    NSArray<BYC_MTBannerModel     *> *_array_SecCover;
    NSArray<BYC_InStepCollectionViewCellModel      *> *_array_Video;
    NSArray<BYC_MTVideoGroupModel *> *_array_VideoGroup;
}

@property (nonatomic, copy  )  NSString *string_groupID;
@property (nonatomic, assign)  Enum_ActionSelectType type_ActionSelect;

/**最新赛区看点数据*/
@property (nonatomic, strong)  NSMutableArray  *cellNewArrayFocusModels;
/**最热赛区看点数据*/
@property (nonatomic, strong)  NSMutableArray  *cellHotArrayFocusModels;

/**最新热门选手数据*/
@property (nonatomic, strong)  NSMutableArray  *cellNewArrayFavoriteModels;
/**最热热门选手数据*/
@property (nonatomic, strong)  NSMutableArray  *cellHotArrayFavoriteModels;

/**赛区看点标识:0最新（时间）、1最热（播放数）、2最喜欢（喜欢数）、再加个3最热（制作数）*/
@property (nonatomic, assign)  int  isFocusTag;
/**热门选手标识:0最新（时间）、1最热（播放数）、2最喜欢（喜欢数）、再加个3最热（制作数）*/
@property (nonatomic, assign)  int  isFavoriteTag;

@property (weak, nonatomic  ) IBOutlet UICollectionView  *collectionView;
@property (strong, nonatomic) IBOutlet BYC_TopHiddenView *topHiddenView;

/**提示语视图*/
@property (nonatomic, weak)  UIView *view_CueWords;

@end

@implementation BYC_InStepViewcontroller

-(instancetype)init {

    if (self = [super init]) {
        
        [self loadView];
        
        // 设置背景色
        [[BYC_SetBackgroundColor alloc] setBackgroundViewColor:self];
        // 初始化子视图
        [self initViews];
        //不使用懒加载了，直接初始化所有数据,以免数据混乱
        [self initProperty];
    }
    
    return self;
}


//设置分享
- (void)setUpActivity {
    
    if (![const_ShareActivityUrl isEqualToString:const_ShareKpieDownloadUrl]  && const_ShareActivityUrl.length > 0) {
        
        const_ShareActivityContent = [NSString stringWithFormat:@"我在参加#%@#活动,快来看看吧~%@",_model.columnname,const_ShareActivityUrl];
        const_ShareActivityImageUrl = _model.firstcover;
        const_ShareActivityTitle = _model.columnname;
        self.isShowShareButton = YES;
    }
}


//不使用懒加载了，直接初始化所有数据,以免数据混乱
- (void)initProperty {

    _isNewFocusWhetherMore      = NO;
    _isHotFocusWhetherMore      = NO;
    _isNewFavoriteWhetherMore   = NO;
    _isHotFavoriteWhetherMore   = NO;

    
    _array_Video      = [NSArray array];
    _array_SecCover   = [NSArray array];
    _array_VideoGroup = [NSArray array];
    
    _cellHotArrayFocusModels        = [NSMutableArray array];
    _cellNewArrayFocusModels        = [NSMutableArray array];
    _cellNewArrayFavoriteModels     = [NSMutableArray array];
    _cellHotArrayFavoriteModels     = [NSMutableArray array];

    
    _isFocusTag    = 0;
    _isFavoriteTag = 0;

    _type_ActionSelect = Enum_ActionSelectTypeFocus;
    _headerSize = CGSizeMake(screenWidth, VC_CONST_COLLECTION_HEADER);
}

- (void)initViews {
    
    __weak __typeof(self) weakSelf = self;
    self.topHiddenView.buttonAction = ^(NSInteger flag){
    
        [weakSelf buttonAction:flag];
    };
    //设置布局
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = .5f;
    _layout.minimumLineSpacing      = 0.f;
    _layout.itemSize = CGSizeMake(screenWidth / 2 - .5f , 180.f);
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView.collectionViewLayout = _layout;
    _collectionView.backgroundColor      = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_InStepCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"InStepCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_InStepColumnCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //数据下拉更新
        switch (weakSelf.type_ActionSelect) {
            case Enum_ActionSelectTypeFocus:
            {
                BYC_InStepCollectionViewCellModel *model;
                if (weakSelf.string_groupID) model = (BYC_InStepCollectionViewCellModel *)[weakSelf.isFocusTag == 0 ? weakSelf.cellNewArrayFocusModels:weakSelf.cellHotArrayFocusModels firstObject];
                [weakSelf refreshParameterWithModel:model Type:weakSelf.isFocusTag upType:@"0"];
            }

                break;
            case Enum_ActionSelectTypeFavorite:
            {
                BYC_InStepCollectionViewCellModel *model = (BYC_InStepCollectionViewCellModel *)[weakSelf.isFavoriteTag == 0 ? weakSelf.cellNewArrayFavoriteModels:weakSelf.cellHotArrayFavoriteModels firstObject];
                [weakSelf refreshParameterWithModel:model Type:weakSelf.isFavoriteTag upType:@"0"];
            }
                break;
                
            default:
                break;
        }
    }];
    // 上拉更新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        switch (weakSelf.type_ActionSelect) {
            case Enum_ActionSelectTypeFocus:
            {
                BYC_InStepCollectionViewCellModel *model ;
                
                if (weakSelf.string_groupID) model = (BYC_InStepCollectionViewCellModel *)[weakSelf.isFocusTag == 0 ? weakSelf.cellNewArrayFocusModels:weakSelf.cellHotArrayFocusModels lastObject];
                [weakSelf refreshParameterWithModel:model Type:weakSelf.isFocusTag == 0 ? weakSelf.isFocusTag : 3  upType:@"1"];
            }
                
                break;
            case Enum_ActionSelectTypeFavorite:
            {
                BYC_InStepCollectionViewCellModel *model = (BYC_InStepCollectionViewCellModel *)[weakSelf.isFavoriteTag == 0 ? weakSelf.cellNewArrayFavoriteModels:weakSelf.cellHotArrayFavoriteModels lastObject];
                [weakSelf refreshParameterWithModel:model Type:weakSelf.isFavoriteTag upType:@"1"];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)refreshParameterWithModel:(BYC_InStepCollectionViewCellModel *)model Type:(int)type upType:(NSString *)upType {

    NSMutableDictionary *dic_Parameters = [NSMutableDictionary dictionary];
    dic_Parameters[@"type"]      = [NSNumber numberWithInt:type];
    dic_Parameters[@"upType"]    = upType;
    dic_Parameters[@"videoId"]   = model.videoid;
    dic_Parameters[@"onofftime"] = model.onofftime;
    dic_Parameters[@"views"]     = [NSNumber numberWithInteger:model.views];
    if (self.string_groupID)dic_Parameters[@"groupId"] = self.string_groupID;
    
    [self refreshRequestWithParameters:dic_Parameters];
}

-(void)setIdModel:(BYC_ADModel *)idModel {
    
    _idModel = idModel;
    BYC_OtherViewControllerModel  *model = [[BYC_OtherViewControllerModel alloc] init];
    model.columnid    = idModel.columnID;
    model.columnname  = idModel.columnName;
    model.secondcover = idModel.secondCover;
    model.columndesc  = idModel.columnDesc;
    model.themename   = idModel.theMeName;
    model.channelid   = idModel.channelID;
    model.isactive    = [NSNumber numberWithInteger:idModel.advertType - 3];
    self.model = model;
}
- (void)setModel:(BYC_OtherViewControllerModel *)model {

    [super setModel:model];
    self.topHiddenView.commentsType = ENUM_CommentsTypeCustom;
    self.title = _model.columnname;
    //默认加载最新
    _isFocusTag = 0;
    
    NSString *string = _model.columndesc;
        
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(BYC_ColumnCollectionHeaderLabelSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    _headerSize =  CGSizeMake(screenWidth, _headerSize.height + titleSize.height - BYC_ColumnCollectionHeaderLabelSize.height);
    
    [self.view showHUDWithTitle:@"正在加载..." WithState:BYC_MBProgressHUDShowTurnplateProgress];
    [self firstRequestData];
}

- (void)requestWithTheme {

    //这句可以删除。只是为了快速刷新到无数据状态。
    [_collectionView reloadData];
    _collectionView.contentOffset = CGPointMake(0, -64);
    
        
    if (_cellNewArrayFocusModels.count > 0 || _cellHotArrayFocusModels.count > 0){//全部数据是有的就刷新
        
        [_collectionView reloadData];
        if (!_isNewFocusWhetherMore) [_collectionView.footer resetNoMoreData];
    }else [self requestGroupWithType];//否则请求全部就是请求赛区看点的最新或者最热数据
    
    
}

- (void)hideCueWordsView {
    
    [_view_CueWords removeFromSuperview];
    _view_CueWords = nil;
}


- (void)showAndHideCueWords:(NSUInteger)uinteger {
    
    if (uinteger)[self hideCueWordsView];
    else [self showCueWordsView];
}

- (void)showCueWordsView {
    
    if (!_view_CueWords && _header) {

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_header.frame), screenWidth,  screenHeight - CGRectGetHeight(_header.frame) - KHeightNavigationBar)];
        _view_CueWords = view;
        UIView *View_CueWords = [self createMaskViewInViewMore:_view_CueWords content:@"精彩即将开始，敬请期待!"];
        [_view_CueWords addSubview:View_CueWords];
        [_collectionView addSubview:_view_CueWords];
    }
}

- (void)buttonAction:(NSInteger)flag {
    
    switch (flag) {
        case Enum_SelectTypeNew://最新
            
            switch (_type_ActionSelect) {
                case Enum_ActionSelectTypeFocus:
                    _isFocusTag = 0;
                    
                    self.topHiddenView.selectButton = _isFocusTag + 1;
                    _header.selectButton = _isFocusTag + 1;
                    if (_cellNewArrayFocusModels.count == 0)[self requestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewFocusWhetherMore)[_collectionView.footer resetNoMoreData];
                    
                    break;
                case Enum_ActionSelectTypeFavorite:
                    _isFavoriteTag = 0;
                    
                    self.topHiddenView.selectButton = _isFavoriteTag + 1;
                    _header.selectButton = _isFavoriteTag + 1;
                    
                    if (_cellNewArrayFavoriteModels.count == 0)[self requestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewFavoriteWhetherMore)[_collectionView.footer resetNoMoreData];
                    break;
                    
                default:
                    break;
            }
            
            break;
        case Enum_SelectTypeHot://最热
            
            switch (_type_ActionSelect) {
                case Enum_ActionSelectTypeFocus:
                    _isFocusTag = 1;
                    
                    self.topHiddenView.selectButton = _isFocusTag + 1;
                    _header.selectButton = _isFocusTag + 1;

                    if (_cellHotArrayFocusModels.count == 0) {
                        
                        [_collectionView reloadData];//没有数据提前刷新一下，把上个数据刷掉
                        [self requestGroupWithType];
                    } else [_collectionView reloadData];
                    if (!_isHotFocusWhetherMore)[_collectionView.footer resetNoMoreData];
                    
                    break;
                case Enum_ActionSelectTypeFavorite:
                    _isFavoriteTag = 1;
                    
                    self.topHiddenView.selectButton = _isFavoriteTag + 1;
                    _header.selectButton = _isFavoriteTag + 1;
                    if (_cellHotArrayFavoriteModels.count == 0)[self requestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewFavoriteWhetherMore)[_collectionView.footer resetNoMoreData];
                    break;
                    
                default:
                    break;
            }

            break;
        case Enum_ActionSelectTypeFocus://赛区看点
        {
        
            _string_groupID = _array_VideoGroup[0].videoGroup_Id;
            //记录选中的类型
            _type_ActionSelect = Enum_ActionSelectTypeFocus;
            
            if (_isFocusTag == 0) {
                
                if (_cellNewArrayFocusModels.count == 0) [self requestGroupWithType];
                else [_collectionView reloadData];
            }else {
                
                if (_cellHotArrayFocusModels.count == 0) [self requestGroupWithType];
                else [_collectionView reloadData];
            }
            
            
            self.topHiddenView.selectButton = _isFocusTag + 1;
            _header.selectButton = _isFocusTag + 1;
        }
            
            break;
        case Enum_ActionSelectTypeFavorite://热门选手
        {
        
            _string_groupID = _array_VideoGroup[1].videoGroup_Id;
            //记录选中的类型
            _type_ActionSelect = Enum_ActionSelectTypeFavorite;
            
            if (_isFavoriteTag == 0) {
                
                if (_cellNewArrayFavoriteModels.count == 0) [self requestGroupWithType];
                else [_collectionView reloadData];
            }else {
                
                if (_cellHotArrayFavoriteModels.count == 0) [self requestGroupWithType];
                else [_collectionView reloadData];
            }
            
            
            self.topHiddenView.selectButton = _isFavoriteTag + 1;
            _header.selectButton = _isFavoriteTag + 1;
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)refreshRequestWithParameters:(NSDictionary *)parameters{

    [BYC_HttpServers Get:KQNWS_GetGroupJsonArrayListVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *bodyRows = responseObject[@"rows"];
        
        if (bodyRows.count > 0 ) {
        
            //cell数据
            NSMutableArray *bodyArrayModels = [NSMutableArray array];
            
            switch (_type_ActionSelect) {
                case Enum_ActionSelectTypeFocus:
                {
                    
                    for (NSArray *arrayModel in bodyRows) {
                        
                        BOOL isRepeat = NO;//NO 没有重复 YES 有重复
                        BYC_InStepCollectionViewCellModel *model = [BYC_InStepCollectionViewCellModel initModelWithArray:arrayModel];
                        
                        if (_isFocusTag == 0) {
                            
                            for (BYC_InStepCollectionViewCellModel *CellModel in _cellNewArrayFocusModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                            
                            if (!isRepeat)[bodyArrayModels addObject:model];
                        }else if (_isFocusTag == 1) {
                            
                            for (BYC_InStepCollectionViewCellModel *CellModel in _cellHotArrayFocusModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                            
                            if (!isRepeat)[bodyArrayModels addObject:model];
                        }
                            
                    }
                }
                    break;
                case Enum_ActionSelectTypeFavorite:
                {
                    
                    for (NSArray *arrayModel in bodyRows) {
                        
                        BOOL isRepeat = NO;//NO 没有重复 YES 有重复
                        BYC_InStepCollectionViewCellModel *model = [BYC_InStepCollectionViewCellModel initModelWithArray:arrayModel];
                        
                        if (_isFavoriteTag == 0) {
                            
                            for (BYC_InStepCollectionViewCellModel *CellModel in _cellNewArrayFavoriteModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                            if (!isRepeat)[bodyArrayModels addObject:model];
                        }else if (_isFavoriteTag == 1) {
                            
                            for (BYC_InStepCollectionViewCellModel *CellModel in _cellHotArrayFavoriteModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                            if (!isRepeat)[bodyArrayModels addObject:model];
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            [self resultDataProcessing:bodyArrayModels];
        }else {
            
            
            [self noDataWithType];
            
        }


        [_collectionView reloadData];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];

        switch (_type_ActionSelect) {
            case Enum_ActionSelectTypeFocus:
            {
            
                if (self.collectionView.footer.isRefreshing) {
                    
                    if (_isFocusTag == 0) {
                        
                        // 变为没有更多数据的状态
                        if (_isNewFocusWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                        else [self.collectionView.footer endRefreshing];

                    }
                    if (_isFocusTag == 1) {
                            
                        // 变为没有更多数据的状态
                        if (_isHotFocusWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                        else [self.collectionView.footer endRefreshing];
                    }
                    
                }
            }
                break;
            case Enum_ActionSelectTypeFavorite:
            {
                
                if (self.collectionView.footer.isRefreshing) {
                    
                    if (_isFavoriteTag == 0) {
                        
                        // 变为没有更多数据的状态
                        if (_isNewFavoriteWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                            else [self.collectionView.footer endRefreshing];
                        
                    }
                    if (_isFavoriteTag == 1) {
                        
                        // 变为没有更多数据的状态
                        if (_isHotFavoriteWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                        else [self.collectionView.footer endRefreshing];
                    }
                    
                }
            }
                break;
                
            default:
                break;
        }
        
        if (self.collectionView.header.isRefreshing) {
            [self.collectionView.header endRefreshing];
        }
    }];
}

- (void)noDataWithType {

    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
        {
            
            if (self.collectionView.footer.isRefreshing) {
                
                if (_isFocusTag == 0) {

                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isNewFocusWhetherMore = YES;
                }
                if (_isFocusTag == 1) {

                        // 变为没有更多数据的状态
                        [self.collectionView.footer endRefreshingWithNoMoreData];
                        _isHotFocusWhetherMore = YES;
                }
                
            }else {
                
                if (self.collectionView.header.isRefreshing) {
                    [self.collectionView.header endRefreshing];
                    
                }
            }
            
        }
            break;
        case Enum_ActionSelectTypeFavorite:
        {
            
            if (self.collectionView.footer.isRefreshing) {
                
                if (_isFavoriteTag == 0) {
                    
                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isNewFavoriteWhetherMore = YES;
                }
                if (_isFavoriteTag == 1) {
                    
                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isHotFavoriteWhetherMore = YES;
                }
                
            }else {
                
                if (self.collectionView.header.isRefreshing)[self.collectionView.header endRefreshing];

            }
        }
            break;
            
        default:
            break;
    }
}



- (void)requestGroupWithType {

    //这句可以删除。只是为了快速刷新到无数据状态。
    [_collectionView reloadData];
    _collectionView.contentOffset = CGPointMake(0, -64);
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"groupId"] = _string_groupID;
    
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
            mDic[@"type"] = [NSString stringWithFormat:@"%d",_isFocusTag == 0 ? _isFocusTag : 3];
            [self requestGroupFocus:mDic];
            break;
        case Enum_ActionSelectTypeFavorite:
            mDic[@"type"] = [NSString stringWithFormat:@"%d",_isFavoriteTag];
            [self requestGroupFavorite:mDic];
            break;
            
        default:
            break;
    }
}

- (void)requestGroupFocus:(NSDictionary *)dicParameters {

    [BYC_HttpServers Get:KQNWS_GetGroupJsonArrayListVideoUrl parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array_Data = [BYC_InStepCollectionViewCellModel initModelsWithArray:responseObject[@"rows"]];
        
        if (array_Data.count == 0 ) {

            [_collectionView reloadData];
            return;
        }
        
        if (_isFocusTag == 0) _cellNewArrayFocusModels = [array_Data mutableCopy];
        else if (_isFocusTag == 1) _cellHotArrayFocusModels = [array_Data mutableCopy];
        [_collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
    }];
}

- (void)requestGroupFavorite:(NSDictionary *)dicParameters {
    
    [BYC_HttpServers Get:KQNWS_GetGroupJsonArrayListVideoUrl parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array_Data = [BYC_InStepCollectionViewCellModel initModelsWithArray:responseObject[@"rows"]];
        
        if (array_Data.count == 0 ) {
            
            [_collectionView reloadData];
            return;
        }
        
        if (_isFavoriteTag == 0) _cellNewArrayFavoriteModels = [array_Data mutableCopy];
        else if (_isFavoriteTag == 1) _cellHotArrayFavoriteModels = [array_Data mutableCopy];
        [_collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
    }];
}

#pragma mark - 网络请求
- (void)firstRequestData {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    QNWSDictionarySetObjectForKey(parameters, [NSNumber numberWithInteger:_isFocusTag == 0 ? _isFocusTag : 3], @"type")
    QNWSDictionarySetObjectForKey(parameters, _model.isactive, @"columnType")
    QNWSDictionarySetObjectForKey(parameters, _model.columnid, @"columnid")
    
    [BYC_HttpServers Get:KQNWS_GetGroupAllJsonArrayListVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _array_SecCover   = [BYC_MTBannerModel initModelsWithArray:responseObject[@"secCover"]];
        _array_Video      = [BYC_InStepCollectionViewCellModel initModelsWithArray:responseObject[@"video"]];
        _array_VideoGroup = [BYC_MTVideoGroupModel initModelsWithArray:responseObject[@"videoGroup"]];
        const_ShareActivityUrl = responseObject[@"shareUrl"];
        [self setUpActivity];
        //初始化默认值
        _string_groupID   = _array_VideoGroup[0].videoGroup_Id;
        
        switch (_isFocusTag) {
            case 0://最新
                
                self.cellNewArrayFocusModels = [_array_Video mutableCopy];
                break;
            case 1://最热
                
                self.cellHotArrayFocusModels = [_array_Video mutableCopy];
                break;
                
            default:
                break;
        }

        [_collectionView reloadData];

        [self.view hideHUDWithTitle:@"加载完成！" WithState:BYC_MBProgressHUDHideProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
    }];
}

/** 数据处理 */
- (void)resultDataProcessing:(NSMutableArray *)mArray{
    
    switch (_header.type_SelectAction) {
        case Enum_ActionSelectTypeFocus:
        {
        
            if (self.collectionView.footer.isRefreshing) {
                
               
                 [_isFocusTag == 0 ? self.cellNewArrayFocusModels:self.cellHotArrayFocusModels addObjectsFromArray:mArray];
                if (mArray.count == 0) [self noDataWithType];// 变为没有更多数据的状态
                else [self.collectionView.footer endRefreshing];// 结束刷新
                
            }else if (self.collectionView.header.isRefreshing) {
                
                NSMutableArray *mmArray = _isFocusTag == 0 ? self.cellNewArrayFocusModels:self.cellHotArrayFocusModels;
                if (_isFocusTag == 0) self.cellNewArrayFocusModels = [mArray mutableCopy];
                if (_isFocusTag == 1) self.cellHotArrayFocusModels = [mArray mutableCopy];
                [_isFocusTag == 0 ? self.cellNewArrayFocusModels:self.cellHotArrayFocusModels addObjectsFromArray:mmArray];
                // 结束刷新
                [self.collectionView.header endRefreshing];
                
            }else {
                
                if (_isFocusTag == 0) self.cellNewArrayFocusModels = mArray;
                if (_isFocusTag == 1) self.cellHotArrayFocusModels = mArray;
            }
        }
            
            break;
        case Enum_ActionSelectTypeFavorite:
        {
        
            if (self.collectionView.footer.isRefreshing) {
                
                [_isFavoriteTag == 0 ? self.cellNewArrayFavoriteModels:self.cellHotArrayFavoriteModels addObjectsFromArray:mArray];
                
                if (mArray.count == 0) [self noDataWithType];// 变为没有更多数据的状态
                else [self.collectionView.footer endRefreshing];// 结束刷新
                
            }else if (self.collectionView.header.isRefreshing) {
                
                NSMutableArray *mmArray = _isFavoriteTag == 0 ? self.cellNewArrayFavoriteModels:self.cellHotArrayFavoriteModels;
                if (_isFavoriteTag == 0) self.cellNewArrayFavoriteModels = [mArray mutableCopy];
                
                if (_isFavoriteTag == 1) self.cellHotArrayFavoriteModels = [mArray mutableCopy];
                [_isFavoriteTag == 0 ? self.cellNewArrayFavoriteModels:self.cellHotArrayFavoriteModels addObjectsFromArray:mmArray];
                // 结束刷新
                [self.collectionView.header endRefreshing];
                
            }
        }
            break;
            
        default:
            break;
    }
    
    }

#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger count;
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
             count = _isFocusTag == 0 ? _cellNewArrayFocusModels.count : _cellHotArrayFocusModels.count;
            break;
        case Enum_ActionSelectTypeFavorite:
            count = _isFavoriteTag == 0 ? _cellNewArrayFavoriteModels.count : _cellHotArrayFavoriteModels.count;
            break;

        default:
            break;
    }
    
    [self showAndHideCueWords:count];
    return count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"InStepCollectionViewCell";
    
    BYC_InStepCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
            cell.model = _isFocusTag == 0 ? _cellNewArrayFocusModels[indexPath.row] : _cellHotArrayFocusModels[indexPath.row];
            break;
        case Enum_ActionSelectTypeFavorite:
            cell.model = _isFavoriteTag == 0 ? _cellNewArrayFavoriteModels[indexPath.row] : _cellHotArrayFavoriteModels[indexPath.row];
            break;

        default:
            break;
    }
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader)
    {
        
        
        if (!_header) _header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        _imageV_Header = _header.imageV_BG;
        __weak __typeof(self) weakSelf = self;
        _header.headerButtonAction = ^(NSInteger flag){
            
            [weakSelf buttonAction:flag];
        };
        _header.dic_Data = @{@"bannerData":_array_SecCover,@"groupData":_array_VideoGroup};
        _header.model = _model;
        return _header;
    }

    return nil;
}

//设置段头大小，竖着滚高有用，横着滚宽有用
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return _headerSize;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 通知中心
    NSNotification *notification = [NSNotification notificationWithName:@"hiddenTheButton" object:nil userInfo:@{@"1":@"1"}];
    [QNWSNotificationCenter postNotification:notification];
    

    BYC_InStepCollectionViewCellModel *model;
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
 
            if (_isFocusTag == 0) {
                model = _cellNewArrayFocusModels[indexPath.row];
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
            }
            else{
                model = _cellHotArrayFocusModels[indexPath.row];
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
            }
            break;
        case Enum_ActionSelectTypeFavorite:
            if (_isFavoriteTag == 0) {
                model = _cellNewArrayFavoriteModels[indexPath.row];
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
            }
            else{
                model = _cellHotArrayFavoriteModels[indexPath.row];
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
            }
            
            break;
            
        default:
            break;
    }

//    [self.navigationController pushViewController:voideVC animated:YES];
    
}


#pragma mark - UIScrollDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //获取偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    //centrView的frame
    if (_headerSize.height - offsetY - 64 <= 27) self.topHiddenView.hidden = NO;
    else self.topHiddenView.hidden = YES;
}

-(void)dealloc {

    QNWSLog(@"23456789");
    _collectionView.delegate = nil;
}

@end
