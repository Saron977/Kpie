//
//  BYC_MononokeViewcontroller.m
//  kpie
//
//  Created by 元朝 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//
//  合拍 定制栏目 以后其他类似栏目可以借用
//  合拍 定制栏目 以后其他类似栏目可以借用
//  合拍 定制栏目 以后其他类似栏目可以借用

#import "BYC_MononokeViewcontroller.h"
#import "BYC_InStepCollectionViewCell.h"
#import "WX_VoideDViewController.h"
#import "BYC_InStepCollectionViewCellModel.h"
#import "BYC_SetBackgroundColor.h"
#import "BYC_InStepColumnCollectionHeader.h"
#import "BYC_MTColumnCollectionHeader.h"
#import "WX_MovieCViewController.h"
#import "BYC_TopHiddenView.h"

#import "BYC_MTBannerModel.h"
#import "WX_DrawLotteryView.h"
#import "BYC_ShareView.h"
#import "BYC_LoginAndRigesterView.h"
#import "HL_JumpToVideoPlayVC.h"

#import "BYC_HttpServers+HL_ColumnVC.h"
#import "BYC_MotifModel.h"
#import "BYC_MTVideoGroupModel.h"
#import "BYC_BaseVideoModel.h"
#import "HL_ColumnVideoThemeModel.h"
#import "HL_ColumnVideoChannelsModel.h"
#import "BYC_MTBannerModel.h"

#define BYC_ColumnCollectionHeaderLabelSize CGSizeMake(screenWidth - 16, 12)
#define VC_CONST_COLLECTION_HEADER 237

@interface BYC_MononokeViewcontroller()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {

    BOOL _isNewFocusWhetherMore;  //赛区看点最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotFocusWhetherMore;  //赛区看点最热是否已经上拉加载更多加载完毕所有数据

    BOOL _isNewFavoriteWhetherMore;  //热门选手最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotFavoriteWhetherMore;  //热门选手最热是否已经上拉加载更多加载完毕所有数据
    
    UICollectionViewFlowLayout   *_layout;
    CGSize                       _headerSize;
    UIImageView                  *_imageV_Header;
    BYC_TopHiddenView            *_topView;
    BYC_InStepColumnCollectionHeader *_header;
    int                          _sortBy;
    
    NSArray<BYC_BaseVideoModel      *> *_array_Video;
    NSArray<BYC_MTVideoGroupModel *> *_array_VideoGroup;
    NSArray<HL_ColumnVideoThemeModel     *> *_array_Theme;
    NSArray<BYC_MTBannerModel *> *_array_SecCover;
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

/**赛区看点标识:排序方式？ 0上架时间（最新） 1点击量（最热） 2收藏数（喜欢数） 3制作数 4投票数*/
@property (nonatomic, assign)  int  sortByFocus;
/**热门选手标识:0最新（时间）、1最热（播放数）、2最喜欢（喜欢数）、再加个3最热（制作数）*/
@property (nonatomic, assign)  int  sortByFavorite;

@property (weak, nonatomic  ) IBOutlet UICollectionView  *collectionView;
@property (strong, nonatomic) IBOutlet BYC_TopHiddenView *topHiddenView;

/**提示语视图*/
@property (nonatomic, weak)  UIView *view_CueWords;

@property (nonatomic, strong) WX_GeekModel  *model_Geek;        /**<   怪咖模型 */
@end

@implementation BYC_MononokeViewcontroller

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

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 监听 怪咖
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGeekModel:) name:@"NSNotification_Mononoke" object:nil];
//    self.isShowJoinInStepButton = YES;//先写死
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotification_Mononoke" object:nil];

}

/// 获取模型
-(void)getGeekModel:(NSNotification*)notif
{
    if (!_model_Geek) {
        _model_Geek = [[WX_GeekModel alloc]init];
    }
    _model_Geek = (WX_GeekModel*)notif.object;
    QNWSLog(@"通知返回模型更新 %@",_model_Geek);
}

//点击事件
-(void)clickJoinInStepAction:(UIButton *)button
{
    BYC_AccountModel *model_Account = [BYC_AccountTool userAccount];
    if (!_model_Geek) {
        
        _model_Geek = [[WX_GeekModel alloc]init];
    }
    _model_Geek.str_phoneNum = model_Account.cellphonenumber;
    _model_Geek.userID = model_Account.userid;
    [WX_DrawLotteryView showDrawLotteryViewWith:ENUM_Activities_JoinShooting ViewController:self GeekModel:_model_Geek];
}

//设置分享
- (void)setUpActivity {
    
    if (![const_ShareActivityUrl isEqualToString:const_ShareKpieDownloadUrl] && const_ShareActivityUrl.length > 0) {
        
        const_ShareActivityContent = [NSString stringWithFormat:@"我在参加#%@#活动,快来看看吧~%@",_model.columnname,const_ShareActivityUrl];
        const_ShareActivityImageUrl =  _model.firstcover.length == 0 ? _idModel.advertimg : _model.firstcover;
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

    
//    _array_Motif       = [NSArray array];
    _array_Video       = [NSArray array];
    _array_VideoGroup  = [NSArray array];
    _array_Theme       = [NSArray array];
//    _array_Channel     = [NSArray array];
    _array_SecCover    = [NSArray array];
    
    _cellHotArrayFocusModels        = [NSMutableArray array];
    _cellNewArrayFocusModels        = [NSMutableArray array];
    _cellNewArrayFavoriteModels     = [NSMutableArray array];
    _cellHotArrayFavoriteModels     = [NSMutableArray array];

    
    _sortByFocus    = 0;
    _sortByFavorite = 0;

    _type_ActionSelect = Enum_ActionSelectTypeFocus;
    _headerSize = CGSizeMake(screenWidth, VC_CONST_COLLECTION_HEADER);
}

- (void)initViews {
    
    __weak __typeof(self) weakSelf = self;
    self.topHiddenView.buttonAction = ^(NSInteger flag){
    
        [weakSelf buttonAction:flag];
    };
    _topHiddenView.model = _model;
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
                if (weakSelf.string_groupID) model = (BYC_InStepCollectionViewCellModel *)[weakSelf.sortByFocus == 0 ? weakSelf.cellNewArrayFocusModels:weakSelf.cellHotArrayFocusModels firstObject];
                [weakSelf refreshParameterWithModel:model Type:weakSelf.sortByFocus == 0 ? weakSelf.sortByFocus : _sortBy upType:@"1"];
            }

                break;
            case Enum_ActionSelectTypeFavorite:
            {
                BYC_InStepCollectionViewCellModel *model = (BYC_InStepCollectionViewCellModel *)[weakSelf.sortByFavorite == 0 ? weakSelf.cellNewArrayFavoriteModels:weakSelf.cellHotArrayFavoriteModels firstObject];
                [weakSelf refreshParameterWithModel:model Type:weakSelf.sortByFavorite == 0 ? weakSelf.sortByFavorite : _sortBy upType:@"1"];
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
                
                if (weakSelf.string_groupID) model = (BYC_InStepCollectionViewCellModel *)[weakSelf.sortByFocus == 0 ? weakSelf.cellNewArrayFocusModels:weakSelf.cellHotArrayFocusModels lastObject];
                [weakSelf refreshParameterWithModel:model Type:weakSelf.sortByFocus == 0 ? weakSelf.sortByFocus : _sortBy upType:@"2"];
            }
                
                break;
            case Enum_ActionSelectTypeFavorite:
            {
                BYC_InStepCollectionViewCellModel *model = (BYC_InStepCollectionViewCellModel *)[weakSelf.sortByFavorite == 0 ? weakSelf.cellNewArrayFavoriteModels:weakSelf.cellHotArrayFavoriteModels lastObject];
                [weakSelf refreshParameterWithModel:model Type:weakSelf.sortByFavorite == 0 ? weakSelf.sortByFavorite : _sortBy upType:@"2"];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark ----- 刷新加载数据
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
    if (model.themename.length > 0) {
        self.isShowJoinInStepButton = YES;
    }
    else self.isShowJoinInStepButton = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:[_model.isactive integerValue] == 1 ? @"BYC_MTColumnCollectionHeader": @"BYC_InStepColumnCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    //isactive: 0--普通栏目   1--比基尼  2--世纪樱花       3--合拍   4--怪咖  5--国庆
    //_sortBy:  0--上架时间   1--点击量  2--收藏数（喜欢数） 3--制作数 4--投票数
    if ([_model.isactive integerValue] == 0 || [_model.isactive integerValue] == 1) _sortBy = 1;
    else if ([_model.isactive integerValue] == 2) _sortBy = 4;
    else if ([_model.isactive integerValue] == 3) _sortBy = 3;
    else if ([_model.isactive integerValue] == 4 || [_model.isactive integerValue] == 5) _sortBy = 2;
    
    self.topHiddenView.commentsType = ENUM_CommentsTypeCustom;
    self.title = _model.columnname;
    //默认加载最新
    _sortByFocus = 0;
    NSString *string = _model.columndesc;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(BYC_ColumnCollectionHeaderLabelSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if ([model.isactive integerValue] == 1 || [model.isactive integerValue] == 4) {
        _headerSize =  CGSizeMake(screenWidth, _headerSize.height + titleSize.height - BYC_ColumnCollectionHeaderLabelSize.height + 40);
    }
    else{
     _headerSize =  CGSizeMake(screenWidth, _headerSize.height + titleSize.height - BYC_ColumnCollectionHeaderLabelSize.height);
    }
    [self.view showHUDWithTitle:@"正在加载..." WithState:BYC_MBProgressHUDShowTurnplateProgress];
    [self firstRequestData];
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
        UIView *View_CueWords = [self createMaskViewInViewMore:_view_CueWords content:@"本届精彩即将开始，敬请期待! "];
        [_view_CueWords addSubview:View_CueWords];
        [_collectionView addSubview:_view_CueWords];
    }
}

- (void)buttonAction:(NSInteger)flag {
    
    switch (flag) {
        case Enum_SelectTypeNew://最新
            
            switch (_type_ActionSelect) {
                case Enum_ActionSelectTypeFocus:
                    _sortByFocus = 0;
                    
                    self.topHiddenView.selectButton = _sortByFocus + 1;
                    _header.selectButton = _sortByFocus + 1;
                    if (_cellNewArrayFocusModels.count == 0)[self secondRequestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewFocusWhetherMore)[_collectionView.footer resetNoMoreData];
                    
                    break;
                case Enum_ActionSelectTypeFavorite:
                    _sortByFavorite = 0;
                    
                    self.topHiddenView.selectButton = _sortByFavorite + 1;
                    _header.selectButton = _sortByFavorite + 1;
                    
                    if (_cellNewArrayFavoriteModels.count == 0)[self secondRequestGroupWithType];
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
                    _sortByFocus = 1;
                    
                    self.topHiddenView.selectButton = _sortByFocus + 1;
                    _header.selectButton = _sortByFocus + 1;

                    if (_cellHotArrayFocusModels.count == 0) {
                        
                        [_collectionView reloadData];//没有数据提前刷新一下，把上个数据刷掉
                        [self secondRequestGroupWithType];
                    } else [_collectionView reloadData];
                    if (!_isHotFocusWhetherMore)[_collectionView.footer resetNoMoreData];
                    
                    break;
                case Enum_ActionSelectTypeFavorite:
                    _sortByFavorite = 1;
                    
                    self.topHiddenView.selectButton = _sortByFavorite + 1;
                    _header.selectButton = _sortByFavorite + 1;
                    if (_cellHotArrayFavoriteModels.count == 0)[self secondRequestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewFavoriteWhetherMore)[_collectionView.footer resetNoMoreData];
                    break;
                    
                default:
                    break;
            }

            break;
        case Enum_ActionSelectTypeFocus://初赛
        {
        
            _string_groupID = _array_VideoGroup[0].groupid;
            //记录选中的类型
            _type_ActionSelect = Enum_ActionSelectTypeFocus;
            
            if (_sortByFocus == 0) {
                
                if (_cellNewArrayFocusModels.count == 0) [self secondRequestGroupWithType];
                else [_collectionView reloadData];
            }else {
                
                if (_cellHotArrayFocusModels.count == 0) [self secondRequestGroupWithType];
                else [_collectionView reloadData];
            }
            
            
            self.topHiddenView.selectButton = _sortByFocus + 1;
            _header.selectButton = _sortByFocus + 1;
        }
            
            break;
        case Enum_ActionSelectTypeFavorite://决赛
        {
        
            _string_groupID = _array_VideoGroup[1].groupid;
            //记录选中的类型
            _type_ActionSelect = Enum_ActionSelectTypeFavorite;
            
            if (_sortByFavorite == 0) {
                
                if (_cellNewArrayFavoriteModels.count == 0) [self secondRequestGroupWithType];
                else [_collectionView reloadData];
            }else {
                
                if (_cellHotArrayFavoriteModels.count == 0) [self secondRequestGroupWithType];
                else [_collectionView reloadData];
            }
            
            
            self.topHiddenView.selectButton = _sortByFavorite + 1;
            _header.selectButton = _sortByFavorite + 1;
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)refreshRequestWithParameters:(NSDictionary *)parameters{

    [BYC_HttpServers Get:KQNWS_GetGroupJsonArrayListVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
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
                        
                        if (_sortByFocus == 0) {
                            
                            for (BYC_InStepCollectionViewCellModel *CellModel in _cellNewArrayFocusModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                            
                            if (!isRepeat)[bodyArrayModels addObject:model];
                        }else if (_sortByFocus == 1) {
                            
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
                        
                        if (_sortByFavorite == 0) {
                            
                            for (BYC_InStepCollectionViewCellModel *CellModel in _cellNewArrayFavoriteModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                            if (!isRepeat)[bodyArrayModels addObject:model];
                        }else if (_sortByFavorite == 1) {
                            
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

        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];

        switch (_type_ActionSelect) {
            case Enum_ActionSelectTypeFocus:
            {
            
                if (self.collectionView.footer.isRefreshing) {
                    
                    if (_sortByFocus == 0) {
                        
                        // 变为没有更多数据的状态
                        if (_isNewFocusWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                        else [self.collectionView.footer endRefreshing];

                    }
                    if (_sortByFocus == 1) {
                            
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
                    
                    if (_sortByFavorite == 0) {
                        
                        // 变为没有更多数据的状态
                        if (_isNewFavoriteWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                            else [self.collectionView.footer endRefreshing];
                        
                    }
                    if (_sortByFavorite == 1) {
                        
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
                
                if (_sortByFocus == 0) {

                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isNewFocusWhetherMore = YES;
                }
                if (_sortByFocus == 1) {

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
                
                if (_sortByFavorite == 0) {
                    
                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isNewFavoriteWhetherMore = YES;
                }
                if (_sortByFavorite == 1) {
                    
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

#pragma mark - 网络请求
- (void)firstRequestData {
//{"columnId":栏目编号"8aad310a560bf9700156252f9ed014b4","columnType":栏目类型 0普通 >0活动 4,"sortBy":排序方式？ 0上架时间 1点击量 2收藏数（喜欢数） 3制作数 4投票数,"sortType":类型？ 0视频 1 剧本,"upType":加载类型？ 0自动加载 1下拉刷新 2上拉加载}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    QNWSDictionarySetObjectForKey(parameters, _model.columnid, @"columnId");
    QNWSDictionarySetObjectForKey(parameters, _model.isactive, @"columnType")
    QNWSDictionarySetObjectForKey(parameters, @0, @"sortBy")
    QNWSDictionarySetObjectForKey(parameters, [_model.isactive integerValue] == 3 ? @1 : @0 , @"sortType")
    QNWSDictionarySetObjectForKey(parameters, @0, @"upType")
   
    [BYC_HttpServers requestColumnDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, HL_ColumModel *models) {
        _array_SecCover = models.arr_BannerModel;
        _array_VideoGroup = models.arr_GroupModels;
        _array_Video        = models.arr_VideoModels;
        _array_Theme        = models.arr_ThemeModels;
//        _array_Channel      = models.arr_ChannelModels;
//        _array_Motif        = models.arr_MotifModels;
        
        //初始化默认值
        if (_array_VideoGroup.count > 0) {
        _string_groupID   = _array_VideoGroup[0].groupid;
        }
        _topHiddenView.model = _model;
        const_ShareActivityUrl = _model.shareurl;
        [self setUpActivity];
        switch (_sortByFocus) {
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

#pragma mark ----- 根据GroupType执行第二次请求
- (void)secondRequestGroupWithType {
    
    //这句可以删除。只是为了快速刷新到无数据状态。
    [_collectionView reloadData];
    _collectionView.contentOffset = CGPointMake(0, -64);
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    QNWSDictionarySetObjectForKey(mDic, _model.columnid, @"columnId");
    QNWSDictionarySetObjectForKey(mDic, _model.isactive, @"columnType")
    QNWSDictionarySetObjectForKey(mDic,  @0, @"sortBy")
    QNWSDictionarySetObjectForKey(mDic, [_model.isactive integerValue] == 3 ? @1 : @0, @"sortType")
    QNWSDictionarySetObjectForKey(mDic, @0, @"upType")
    if (_string_groupID != nil) {
        QNWSDictionarySetObjectForKey(mDic, _string_groupID, @"groupId")
    }
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus://初赛
            mDic[@"sortBy"] = [NSString stringWithFormat:@"%d",_sortByFocus == 0 ? _sortByFocus : _sortBy];
            [self requestGroupFocus:mDic];
            break;
        case Enum_ActionSelectTypeFavorite://决赛
            mDic[@"sortBy"] = [NSString stringWithFormat:@"%d",_sortByFavorite == 0 ? _sortByFavorite : _sortBy];
            [self requestGroupFavorite:mDic];
            break;
            
        default:
            break;
    }
}

- (void)requestGroupFocus:(NSDictionary *)dicParameters {
    
    [BYC_HttpServers requestColumnDataWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, HL_ColumModel *models) {
        _array_Video        = models.arr_VideoModels;
        switch (_sortByFocus) {
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        
    }];

}

- (void)requestGroupFavorite:(NSDictionary *)dicParameters {
    
    [BYC_HttpServers requestColumnDataWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, HL_ColumModel *models) {
        _array_Video        = models.arr_VideoModels;
        switch (_sortByFavorite) {
            case 0://最新
                self.cellNewArrayFavoriteModels = [_array_Video mutableCopy];
                break;
            case 1://最热
                self.cellHotArrayFavoriteModels = [_array_Video mutableCopy];
                break;
            default:
                break;
        }
        [_collectionView reloadData];
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
                 [_sortByFocus == 0 ? self.cellNewArrayFocusModels:self.cellHotArrayFocusModels addObjectsFromArray:mArray];
                if (mArray.count == 0) [self noDataWithType];// 变为没有更多数据的状态
                else [self.collectionView.footer endRefreshing];// 结束刷新
                
            }else if (self.collectionView.header.isRefreshing) {
                
                NSMutableArray *mmArray = _sortByFocus == 0 ? self.cellNewArrayFocusModels:self.cellHotArrayFocusModels;
                if (_sortByFocus == 0) self.cellNewArrayFocusModels = [mArray mutableCopy];
                if (_sortByFocus == 1) self.cellHotArrayFocusModels = [mArray mutableCopy];
                [_sortByFocus == 0 ? self.cellNewArrayFocusModels:self.cellHotArrayFocusModels addObjectsFromArray:mmArray];
                // 结束刷新
                [self.collectionView.header endRefreshing];
                
            }else {
                
                if (_sortByFocus == 0) self.cellNewArrayFocusModels = mArray;
                if (_sortByFocus == 1) self.cellHotArrayFocusModels = mArray;
            }
        }
            
            break;
        case Enum_ActionSelectTypeFavorite:
        {
        
            if (self.collectionView.footer.isRefreshing) {
                
                [_sortByFavorite == 0 ? self.cellNewArrayFavoriteModels:self.cellHotArrayFavoriteModels addObjectsFromArray:mArray];
                
                if (mArray.count == 0) [self noDataWithType];// 变为没有更多数据的状态
                else [self.collectionView.footer endRefreshing];// 结束刷新
                
            }else if (self.collectionView.header.isRefreshing) {
                
                NSMutableArray *mmArray = _sortByFavorite == 0 ? self.cellNewArrayFavoriteModels:self.cellHotArrayFavoriteModels;
                if (_sortByFavorite == 0) self.cellNewArrayFavoriteModels = [mArray mutableCopy];
                
                if (_sortByFavorite == 1) self.cellHotArrayFavoriteModels = [mArray mutableCopy];
                [_sortByFavorite == 0 ? self.cellNewArrayFavoriteModels:self.cellHotArrayFavoriteModels addObjectsFromArray:mmArray];
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
             count = _sortByFocus == 0 ? _cellNewArrayFocusModels.count : _cellHotArrayFocusModels.count;
            break;
        case Enum_ActionSelectTypeFavorite:
            count = _sortByFavorite == 0 ? _cellNewArrayFavoriteModels.count : _cellHotArrayFavoriteModels.count;
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
            cell.model = _sortByFocus == 0 ? _cellNewArrayFocusModels[indexPath.row] : _cellHotArrayFocusModels[indexPath.row];
            break;
        case Enum_ActionSelectTypeFavorite:
            cell.model = _sortByFavorite == 0 ? _cellNewArrayFavoriteModels[indexPath.row] : _cellHotArrayFavoriteModels[indexPath.row];
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
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    

    BYC_InStepCollectionViewCellModel *model;
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
 
            if (_sortByFocus == 0) {
                model = _cellNewArrayFocusModels[indexPath.row];
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
            }
            else{
                model = _cellHotArrayFocusModels[indexPath.row];
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];            }
            break;
        case Enum_ActionSelectTypeFavorite:
            if (_sortByFavorite == 0) {
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
