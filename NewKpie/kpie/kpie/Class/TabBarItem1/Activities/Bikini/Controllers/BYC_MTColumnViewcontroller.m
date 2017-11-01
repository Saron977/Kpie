//
//  BYC_MTColumnViewcontroller.m
//  kpie
//
//  Created by 元朝 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_MTColumnViewcontroller.h"
#import "AFHTTPRequestOperationManager.h"
#import "BYC_HomeCollectionViewCell.h"
#import "WX_VoideDViewController.h"
#import "BYC_SetBackgroundColor.h"
#import "WX_MovieCViewController.h"
#import "BYC_TopHiddenView.h"

#import "BYC_MTHandleSelectArea.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import "BYC_ShareView.h"
#import "WX_DrawLotteryView.h"
#import "HL_JumpToVideoPlayVC.h"

#import "BYC_HttpServers+HL_ColumnVC.h"
#import "BYC_MotifModel.h"
#import "BYC_MTVideoGroupModel.h"
#import "BYC_BaseVideoModel.h"
#import "HL_ColumnVideoThemeModel.h"
#import "HL_ColumnVideoChannelsModel.h"
#import "BYC_MTBannerModel.h"

#import "BYC_InStepColumnCollectionHeader.h"
#import "BYC_MTColumnCollectionHeader.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#define BYC_ColumnCollectionHeaderLabelSize CGSizeMake(screenWidth - 16, 12)
/**侧边栏的右边离手机屏幕右边的间隙*/
#define VC_CONST_SELECT_AREA_GAP 75
#define VC_CONST_COLLECTION_HEADER 237
#define CueWords @"本届精彩即将开始，敬请期待! \n 请移步精彩花絮观看往届精彩视频~"

@interface BYC_MTColumnViewcontroller()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UMSocialUIDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {

    BOOL _isNewFocusWhetherMore;  //赛区看点最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotFocusWhetherMore;  //赛区看点最热是否已经上拉加载更多加载完毕所有数据
    
    BOOL _isNewOtherFocusWhetherMore;  //某赛区看点最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotOtherFocusWhetherMore;  //某赛区看点最热是否已经上拉加载更多加载完毕所有数据
    
    BOOL _isNewFavoriteWhetherMore;  //热门选手最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotFavoriteWhetherMore;  //热门选手最热是否已经上拉加载更多加载完毕所有数据
    
    BOOL _isNewTitbitsWhetherMore;  //精彩花絮最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotTitbitsWhetherMore;  //精彩花絮最热是否已经上拉加载更多加载完毕所有数据

    BOOL    _isOpen;//YES:代表选地区视图是打开状态  NO:代表选地区视图是关闭状态
    
    UICollectionViewFlowLayout   *_layout;
    CGSize                       _headerSize;
    UIImageView                  *_imageV_Header;
    BYC_TopHiddenView            *_topView;
    BYC_InStepColumnCollectionHeader      *_header_InStep;
    BYC_MTColumnCollectionHeader          *_header_MT;

    __weak IBOutlet UIView           *view_SelectArea;
    __weak IBOutlet UIView           *view_SelectAreaLeft;
    __weak IBOutlet UIImageView      *imageV_Arrow;
    __weak IBOutlet UICollectionView *collection_SelectArea;
    
    BYC_MTHandleSelectArea        *_MTHandleSelectArea;
    
    int                          _sortBy;
    NSArray<BYC_BaseVideoModel      *> *_array_Video;
    NSArray<BYC_MTVideoGroupModel *> *_array_VideoGroup;
    NSArray<HL_ColumnVideoThemeModel     *> *_array_Theme;
    NSArray<BYC_MTBannerModel *> *_array_SecCover;
    BYC_OtherViewControllerModel *_columnModel;

}

@property (weak, nonatomic) IBOutlet UILabel *label_Title;

@property (nonatomic, copy  )  NSString *string_themeID;//(默认为空，不为空时组别编号为空)
@property (nonatomic, copy  )  NSString *string_groupID;
@property (nonatomic, assign)  Enum_ActionSelectType type_ActionSelect;

/**最新赛区看点数据*/
@property (nonatomic, strong)  NSMutableArray  *cellNewArrayFocusModels;
/**最热赛区看点数据*/
@property (nonatomic, strong)  NSMutableArray  *cellHotArrayFocusModels;

/**最新某赛区看点数据*/
@property (nonatomic, strong)  NSMutableArray  *cellNewArrayOtherFocusModels;
/**最热某赛区看点数据*/
@property (nonatomic, strong)  NSMutableArray  *cellHotArrayOtherFocusModels;
/**最新热门选手数据*/
@property (nonatomic, strong)  NSMutableArray  *cellNewArrayFavoriteModels;
/**最热热门选手数据*/
@property (nonatomic, strong)  NSMutableArray  *cellHotArrayFavoriteModels;
/**最新精彩花絮数据*/
@property (nonatomic, strong)  NSMutableArray  *cellNewArrayTitbitsModels;
/**最热精彩花絮数据*/
@property (nonatomic, strong)  NSMutableArray  *cellHotArrayTitbitsModels;

/**赛区看点标识:排序方式？ 0上架时间（最新） 1点击量（最热） 2收藏数（喜欢数） 3制作数 4投票数*/
@property (nonatomic, assign)  int  sortByFocus;
/**热门选手标识:0最新（时间）、1最热（播放数）、2最喜欢（喜欢数）、再加个3最热（制作数）*/
@property (nonatomic, assign)  int  sortByFavorite;

/**精彩花絮标识:0:表示最新  1:表示最热*/
@property (nonatomic, assign)  int  sortByTitbits;

@property (weak, nonatomic  ) IBOutlet UICollectionView  *collectionView;
@property (strong, nonatomic) IBOutlet BYC_TopHiddenView *topHiddenView;

/**提示语视图*/
@property (nonatomic, weak)  UIView *view_CueWords;

@property (nonatomic, strong) WX_GeekModel  *model_Geek;        /**<   怪咖模型 */

@end

@implementation BYC_MTColumnViewcontroller

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

//设置分享
- (void)setUpActivity {
    
    if (![const_ShareActivityUrl isEqualToString:const_ShareKpieDownloadUrl] && const_ShareActivityUrl.length > 0) {
        
        const_ShareActivityContent = [NSString stringWithFormat:@"我在参加#%@#活动,快来看看吧~%@",_otherModel.columnname,const_ShareActivityUrl];
        const_ShareActivityImageUrl =  _otherModel.firstcover.length == 0 ? _idModel.advertimg : _otherModel.firstcover;
        const_ShareActivityTitle = _otherModel.columnname;
        self.isShowShareButton = YES;
    }
}



//不使用懒加载了，直接初始化所有数据,以免数据混乱
- (void)initProperty {
    
    _array_Video       = [NSArray array];
    _array_VideoGroup  = [NSArray array];
    _array_Theme       = [NSArray array];
    _array_SecCover    = [NSArray array];
    
    _cellHotArrayFocusModels        = [NSMutableArray array];
    _cellNewArrayFocusModels        = [NSMutableArray array];
    _cellHotArrayOtherFocusModels   = [NSMutableArray array];
    _cellNewArrayOtherFocusModels   = [NSMutableArray array];
    _cellNewArrayFavoriteModels     = [NSMutableArray array];
    _cellHotArrayFavoriteModels     = [NSMutableArray array];
    _cellNewArrayTitbitsModels      = [NSMutableArray array];
    _cellHotArrayTitbitsModels      = [NSMutableArray array];
    
    _columnModel        = [[BYC_OtherViewControllerModel alloc]init];

    _sortByFocus    = 0;
    _sortByFavorite = 0;
    _sortByTitbits  = 0;
    
    _type_ActionSelect = Enum_ActionSelectTypeFocus;
//    _headerSize = CGSizeMake(screenWidth, VC_CONST_COLLECTION_HEADER);
    view_SelectArea.transform = CGAffineTransformMakeTranslation(-(screenWidth - VC_CONST_SELECT_AREA_GAP), 0);
}

- (void)initViews {
    
    __weak __typeof(self) weakSelf = self;
    self.topHiddenView.commentsType = ENUM_CommentsTypeCustom;
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
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_InStepColumnCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    view_SelectArea.hidden = YES;
    
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //数据下拉更新
        switch (weakSelf.type_ActionSelect) {
            case Enum_ActionSelectTypeFocus:{
                
                BYC_HomeViewControllerModel *model;
                if (weakSelf.string_themeID) model = (BYC_HomeViewControllerModel *)[weakSelf.sortByFocus == 0 ? weakSelf.cellNewArrayOtherFocusModels:weakSelf.cellHotArrayOtherFocusModels firstObject];
                else if (weakSelf.string_groupID) model = (BYC_HomeViewControllerModel *)[weakSelf.sortByFocus == 0 ? weakSelf.cellNewArrayFocusModels:weakSelf.cellHotArrayFocusModels firstObject];
                [weakSelf refreshParameterWithModel:model SortBy:weakSelf.sortByFocus == 0 ? weakSelf.sortByFocus : _sortBy upType:1 themeidOrgroupId:YES];
            }

                break;
            case Enum_ActionSelectTypeFavorite:{
                
                BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)[weakSelf.sortByFavorite == 0 ? weakSelf.cellNewArrayFavoriteModels:weakSelf.cellHotArrayFavoriteModels firstObject];
                [weakSelf refreshParameterWithModel:model SortBy:weakSelf.sortByFavorite == 0 ? weakSelf.sortByFavorite : _sortBy upType:1 themeidOrgroupId:NO];
            }
                break;
            case Enum_ActionSelectTypeTitbits:{
                
                BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)[weakSelf.sortByTitbits == 0 ? weakSelf.cellNewArrayTitbitsModels:weakSelf.cellHotArrayTitbitsModels firstObject];
                [weakSelf refreshParameterWithModel:model SortBy:weakSelf.sortByTitbits == 0 ? weakSelf.sortByFavorite : _sortBy upType:1 themeidOrgroupId:NO];
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
                BYC_HomeViewControllerModel *model ;
                
                if (weakSelf.string_themeID) model = (BYC_HomeViewControllerModel *)[weakSelf.sortByFocus == 0 ? weakSelf.cellNewArrayOtherFocusModels:weakSelf.cellHotArrayOtherFocusModels lastObject];
                else if (weakSelf.string_groupID) model = (BYC_HomeViewControllerModel *)[weakSelf.sortByFocus == 0 ? weakSelf.cellNewArrayFocusModels:weakSelf.cellHotArrayFocusModels lastObject];
                [weakSelf refreshParameterWithModel:model SortBy:weakSelf.sortByFocus == 0 ? weakSelf.sortByFavorite : _sortBy upType:2 themeidOrgroupId:YES];
            }
                break;
            case Enum_ActionSelectTypeFavorite:
            {
                BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)[weakSelf.sortByFavorite == 0 ? weakSelf.cellNewArrayFavoriteModels:weakSelf.cellHotArrayFavoriteModels lastObject];
                [weakSelf refreshParameterWithModel:model SortBy:weakSelf.sortByFavorite == 0 ? weakSelf.sortByFavorite : _sortBy upType:2 themeidOrgroupId:NO];
            }
                break;
            case Enum_ActionSelectTypeTitbits:
            {
                BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)[weakSelf.sortByTitbits == 0 ? weakSelf.cellNewArrayTitbitsModels:weakSelf.cellHotArrayTitbitsModels lastObject];
                [weakSelf refreshParameterWithModel:model SortBy:weakSelf.sortByTitbits == 0 ? weakSelf.sortByFavorite : _sortBy upType:2 themeidOrgroupId:NO];
            }
                break;
                
            default:
                break;
        }
    }];
}


- (void)refreshParameterWithModel:(BYC_HomeViewControllerModel *)model SortBy:(int)sortBy upType:(int) upType themeidOrgroupId:(BOOL)flag {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    QNWSDictionarySetObjectForKey(params, _otherModel.columnid, @"columnId");
    QNWSDictionarySetObjectForKey(params, _otherModel.isactive, @"columnType")
    QNWSDictionarySetObjectForKey(params,  @(sortBy), @"sortBy")
    QNWSDictionarySetObjectForKey(params,  @0, @"sortType") // 0---视频  1---剧本
    QNWSDictionarySetObjectForKey(params,  @(upType), @"upType")
    if (flag) {
        if (self.string_themeID)  QNWSDictionarySetObjectForKey(params, self.string_themeID, @"themeId")
        else if (self.string_groupID) QNWSDictionarySetObjectForKey(params, _string_groupID, @"groupId")
    }
    else if (self.string_groupID) QNWSDictionarySetObjectForKey(params, _string_groupID, @"groupId")
    
    [self refreshRequestWithParameters:params];
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

-(void)setColumnID:(NSString *)columnID{
    
    _columnModel.columnid = columnID;
    [self firstRequestData];
}
-(void)setOtherModel:(BYC_OtherViewControllerModel *)otherModel{
    //isactive: 0--普通栏目   1--比基尼  2--世纪樱花       3--合拍   4--怪咖  5--国庆
    //_sortBy:  0--上架时间   1--点击量  2--收藏数（喜欢数） 3--制作数 4--投票数
    _otherModel = otherModel;
    if ([_otherModel.isactive integerValue] == 0 || [_otherModel.isactive integerValue] == 1) _sortBy = 1;
    else if ([_otherModel.isactive integerValue] == 2) _sortBy = 4;
    else if ([_otherModel.isactive integerValue] == 3) _sortBy = 3;
    else if ([_otherModel.isactive integerValue] == 4 || [_otherModel.isactive integerValue] == 5) _sortBy = 2;
    view_SelectArea.hidden = [_otherModel.isactive integerValue] == 1 ? NO : YES;
    [_collectionView registerNib:[UINib nibWithNibName:[_otherModel.isactive integerValue] == 1 ? @"BYC_MTColumnCollectionHeader": @"BYC_InStepColumnCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    //默认加载最新
    _sortByFocus = 0;
    self.topHiddenView.commentsType = ENUM_CommentsTypeCustom;
    self.title = _otherModel.columnname;
    NSString *string = _otherModel.columndesc;
    _string_themeID   = nil;
    _topHiddenView.model = _otherModel;
    const_ShareActivityUrl = _otherModel.shareurl;
    [self setUpActivity];
    //默认加载最新
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(BYC_ColumnCollectionHeaderLabelSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    //初始化默认值
    _headerSize = [_otherModel.isactive integerValue] == 2 ? CGSizeMake(screenWidth, VC_CONST_COLLECTION_HEADER + titleSize.height - BYC_ColumnCollectionHeaderLabelSize.height) :_array_VideoGroup.count > 1 ? CGSizeMake(screenWidth, VC_CONST_COLLECTION_HEADER + titleSize.height - BYC_ColumnCollectionHeaderLabelSize.height +40): CGSizeMake(screenWidth, VC_CONST_COLLECTION_HEADER + titleSize.height - BYC_ColumnCollectionHeaderLabelSize.height);
}

-(void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    [self initSelectArea];
}

- (IBAction)selectAreaAction {

    [self selectAreaAnimation];
}

- (void)selectAreaAnimation {

    [self addOrRomoveMaskView];
    [UIView animateWithDuration:.35 animations:^{
        
        if (_isOpen) {
            
            imageV_Arrow.transform = CGAffineTransformIdentity;
            view_SelectArea.transform = CGAffineTransformMakeTranslation(-(screenWidth - VC_CONST_SELECT_AREA_GAP), 0);
        }else {
            
            imageV_Arrow.transform = CGAffineTransformMakeRotation(-M_PI);
            view_SelectArea.transform = CGAffineTransformIdentity;
        }
        
        
    } completion:^(BOOL finished) {
        
        _isOpen = !_isOpen;
    }];
}
- (void)initSelectArea {

    __weak __typeof(self) weakSelf = self;
    if (!_MTHandleSelectArea) {
    
    _MTHandleSelectArea = [[BYC_MTHandleSelectArea alloc] initWithCollection:collection_SelectArea WithData:nil selectAreaBlock:^(NSIndexPath *indexPath) {
        
        if (indexPath.item == 0)weakSelf.string_themeID = nil;
        else weakSelf.string_themeID = _array_Theme[indexPath.item - 1].themeid;
        if (indexPath.item == 0)weakSelf.label_Title.text = @"全部赛区";
        else {
            NSString *themeName = [_array_Theme[indexPath.item - 1].themename stringByReplacingOccurrencesOfString:@"#hide" withString:@""];
            themeName = [themeName stringByReplacingOccurrencesOfString:@"#" withString:@""];
            weakSelf.label_Title.text = [NSString stringWithFormat:@"%@赛点",themeName];
        }
        
        //清空上个数据
        [weakSelf.cellNewArrayOtherFocusModels removeAllObjects];
        [weakSelf.cellHotArrayOtherFocusModels removeAllObjects];
        [weakSelf threeRequestGroupWithThemeIsRefreshRequest];
        [weakSelf selectAreaAnimation];
    }];
    }
    
    _MTHandleSelectArea.frame = collection_SelectArea.frame;
}

- (void)addOrRomoveMaskView {
    UIView *maskView;
    maskView = [self.view viewWithTag:2016];
    if (!_isOpen) {
        if (!maskView) {
            maskView = [[UIView alloc] initWithFrame:KQNWS_KeyWindow.bounds];
            maskView.tag = 2016;
            maskView.backgroundColor = KUIColorFromRGBA(0X000000, .6);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAreaAction)];
            [maskView addGestureRecognizer:tap];
        }
        [self.view insertSubview:maskView belowSubview:view_SelectArea];
        
    }else {
    
        [maskView removeFromSuperview];
        maskView = nil;
    }
}

- (void)buttonAction:(NSInteger)flag {
    
    switch (flag) {
        case Enum_SelectTypeNew://最新
            
            switch (_type_ActionSelect) {
                case Enum_ActionSelectTypeFocus://赛区看点
                    _sortByFocus = 0;
                    if (_array_VideoGroup.count>0) {
                        _string_groupID = _array_VideoGroup[0].groupid;
                    }
                    self.topHiddenView.selectButton = _sortByFocus + 1;
                    if ([_otherModel.isactive integerValue] == 1) _header_MT.selectButton = _sortByFocus + 1;
                    else _header_InStep.selectButton = _sortByFocus + 1;
                    
                    if (_string_themeID) {
                        //根据地区删选
                        if (_cellNewArrayOtherFocusModels.count == 0)[self threeRequestGroupWithThemeIsRefreshRequest];
                        else [_collectionView reloadData];
                        if (!_isNewOtherFocusWhetherMore)[_collectionView.footer resetNoMoreData];
                        
                    }else {
                        
                        if (_cellNewArrayFocusModels.count == 0)[self secondRequestGroupWithType];
                        else [_collectionView reloadData];
                        if (!_isNewFocusWhetherMore)[_collectionView.footer resetNoMoreData];
                    }
                    
                    break;
                case Enum_ActionSelectTypeFavorite://热门选手
                    _sortByFavorite = 0;
                    if (_array_VideoGroup.count>0) {
                        _string_groupID = _array_VideoGroup[1].groupid;
                    }
                    self.topHiddenView.selectButton = _sortByFavorite + 1;
                    if ([_otherModel.isactive integerValue] == 1) _header_MT.selectButton = _sortByFavorite + 1;
                    else _header_InStep.selectButton = _sortByFavorite + 1;
                    if (_cellNewArrayFavoriteModels.count == 0)[self secondRequestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewFavoriteWhetherMore)[_collectionView.footer resetNoMoreData];
                    break;
                    
                case Enum_ActionSelectTypeTitbits://精彩花絮
                    _sortByTitbits = 0;
                    if (_array_VideoGroup.count>0) {
                        _string_groupID = _array_VideoGroup[2].groupid;
                    }
                    self.topHiddenView.selectButton = _sortByTitbits + 1;
                    _header_MT.selectButton = _sortByTitbits + 1;
                    if (_cellNewArrayTitbitsModels.count == 0)[self secondRequestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewTitbitsWhetherMore)[_collectionView.footer resetNoMoreData];
                    break;
                    
                default:
                    break;
            }
            
            break;
        case Enum_SelectTypeHot://最热
            
            switch (_type_ActionSelect) {
                case Enum_ActionSelectTypeFocus://赛区看点
                    _sortByFocus = 1;
                    if (_array_VideoGroup.count>0) {
                        _string_groupID = _array_VideoGroup[0].groupid;
                    }
                    self.topHiddenView.selectButton = _sortByFocus + 1;
                    if ([_otherModel.isactive integerValue] == 1) _header_MT.selectButton = _sortByFocus + 1;
                    else _header_InStep.selectButton = _sortByFocus + 1;
                    
                    if (_string_themeID) {
                        //根据地区删选
                        if (_cellHotArrayOtherFocusModels.count == 0)[self threeRequestGroupWithThemeIsRefreshRequest];
                        else [_collectionView reloadData];
                        if (!_isHotOtherFocusWhetherMore)[_collectionView.footer resetNoMoreData];

                    }else {
                        
                        if (_cellHotArrayFocusModels.count == 0) {
                            
                            [_collectionView reloadData];//没有数据提前刷新一下，把上个数据刷掉
                            [self secondRequestGroupWithType];
                        } else [_collectionView reloadData];
                        if (!_isHotFocusWhetherMore)[_collectionView.footer resetNoMoreData];
                    }
                    
                    break;
                case Enum_ActionSelectTypeFavorite://热门选手
                    _sortByFavorite = 1;
                    if (_array_VideoGroup.count>0) {
                        _string_groupID = _array_VideoGroup[1].groupid;
                    }
                    self.topHiddenView.selectButton = _sortByFavorite + 1;
                    if ([_otherModel.isactive integerValue] == 1) _header_MT.selectButton = _sortByFavorite + 1;
                    else _header_InStep.selectButton = _sortByFavorite + 1;
                    if (_cellHotArrayFavoriteModels.count == 0)[self secondRequestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewFavoriteWhetherMore)[_collectionView.footer resetNoMoreData];
                    break;
                case Enum_ActionSelectTypeTitbits://精彩花絮
                    _sortByTitbits = 1;
                    if (_array_VideoGroup.count>0) {
                        _string_groupID = _array_VideoGroup[2].groupid;
                    }
                    self.topHiddenView.selectButton = _sortByTitbits + 1;
                    _header_MT.selectButton = _sortByTitbits + 1;
                    if (_cellHotArrayTitbitsModels.count == 0)[self secondRequestGroupWithType];
                    else [_collectionView reloadData];
                    if (!_isNewTitbitsWhetherMore)[_collectionView.footer resetNoMoreData];
                    break;
                    
                default:
                    break;
            }

            break;
            
        case Enum_ActionSelectTypeFocus://赛区看点
        {
            
            view_SelectArea.hidden = [_otherModel.isactive integerValue] == 1 ? NO : YES;
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
            if ([_otherModel.isactive integerValue] == 1) _header_MT.selectButton = _sortByFocus + 1;
            else _header_InStep.selectButton = _sortByFocus + 1;
        }
            
            break;
        case Enum_ActionSelectTypeFavorite://热门选手
        {
            
            view_SelectArea.hidden = YES;
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
            self.topHiddenView.selectButton =  + 1;
            if ([_otherModel.isactive integerValue] == 1) _header_MT.selectButton = _sortByFavorite + 1;
            else _header_InStep.selectButton = _sortByFavorite + 1;
        }
            
            break;
        case Enum_ActionSelectTypeTitbits://精彩花絮
        {
            
            view_SelectArea.hidden = YES;
            _string_groupID = _array_VideoGroup[2].groupid;
            //记录选中的类型
            _type_ActionSelect = Enum_ActionSelectTypeTitbits;
            
            if (_sortByTitbits == 0) {
                
                if (_cellNewArrayTitbitsModels.count == 0) [self secondRequestGroupWithType];
                else [_collectionView reloadData];
            }else {
                
                if (_cellHotArrayTitbitsModels.count == 0) [self secondRequestGroupWithType];
                else [_collectionView reloadData];
            }
            self.topHiddenView.selectButton = _sortByTitbits + 1;
            _header_MT.selectButton = _sortByTitbits + 1;
        }
            break;
            
        default:
            break;
    }
    
}


- (void)requestDataStatus:(BOOL)status {

    if (self.collectionView.footer.isRefreshing) {
        
        // 变为没有更多数据的状态
        if (status) [self.collectionView.footer endRefreshingWithNoMoreData];
        else [self.collectionView.footer endRefreshing];
    }
    if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
}

- (void)noDataWithType {

    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
        {
            
            if (self.collectionView.footer.isRefreshing) {
                
                if (_sortByFocus == 0) {
                    
                    if (_string_themeID) {
                        
                        // 变为没有更多数据的状态
                        [self.collectionView.footer endRefreshingWithNoMoreData];
                        _isNewOtherFocusWhetherMore = YES;
                    }else {
                        
                        // 变为没有更多数据的状态
                        [self.collectionView.footer endRefreshingWithNoMoreData];
                        _isNewFocusWhetherMore = YES;
                    }
                    
                }
                if (_sortByFocus == 1) {

                    if (_string_themeID) {
                        
                        // 变为没有更多数据的状态
                        [self.collectionView.footer endRefreshingWithNoMoreData];
                        _isHotOtherFocusWhetherMore = YES;
                    }else {
                        
                        // 变为没有更多数据的状态
                        [self.collectionView.footer endRefreshingWithNoMoreData];
                        _isHotFocusWhetherMore = YES;
                    }
                }
                
            }else {
                
                if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
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
        case Enum_ActionSelectTypeTitbits:
        {
            
            if (self.collectionView.footer.isRefreshing) {
                
                if (_sortByTitbits == 0) {
                    
                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isNewTitbitsWhetherMore = YES;
                }
                if (_sortByTitbits == 1) {
                    
                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isHotTitbitsWhetherMore = YES;
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
- (void)firstRequestData{
    
    //{"columnId":栏目编号"8aad310a560bf9700156252f9ed014b4","columnType":栏目类型 0普通 >0活动 4,"sortBy":排序方式？ 0上架时间 1点击量 2收藏数（喜欢数） 3制作数 4投票数,"sortType":类型？ 0视频 1 剧本,"upType":加载类型？ 0自动加载 1下拉刷新 2上拉加载}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    QNWSDictionarySetObjectForKey(parameters, _columnModel.columnid == nil ? @"" : _columnModel.columnid, @"columnId");
    QNWSDictionarySetObjectForKey(parameters, @0, @"columnType")
     QNWSDictionarySetObjectForKey(parameters,@1, @"isExter")
    QNWSDictionarySetObjectForKey(parameters, @0, @"sortBy")
    QNWSDictionarySetObjectForKey(parameters, @0 , @"sortType")
    QNWSDictionarySetObjectForKey(parameters, @0, @"upType")
    [BYC_HttpServers requestColumnDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, HL_ColumModel *models) {
        _array_SecCover = models.arr_BannerModel;
        _array_VideoGroup = models.arr_GroupModels;
        _array_Theme        = models.arr_ThemeModels;
        _columnModel        = models.columnModel;
        self.otherModel = _columnModel;
        if (_array_VideoGroup.count>0) {
            _string_groupID = _array_VideoGroup[0].groupid;
        }
        [self secondRequestGroupWithType];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            _MTHandleSelectArea.array_Data = _array_Theme;
        });
        [self.view hideHUDWithTitle:@"加载完成！" WithState:BYC_MBProgressHUDHideProgress];
        [_collectionView reloadData];
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
    QNWSDictionarySetObjectForKey(mDic, _otherModel.columnid, @"columnId");
    QNWSDictionarySetObjectForKey(mDic, _otherModel.isactive, @"columnType")
    QNWSDictionarySetObjectForKey(mDic,  @0, @"sortBy")
    QNWSDictionarySetObjectForKey(mDic,  @0, @"sortType")
    QNWSDictionarySetObjectForKey(mDic,  @0, @"upType")
    if (_string_groupID != nil) {
        QNWSDictionarySetObjectForKey(mDic, _string_groupID, @"groupId")
    }
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
            mDic[@"sortBy"] = [NSString stringWithFormat:@"%d",_sortByFocus == 0 ? _sortByFocus : _sortBy];
            [self requestGroupFocus:mDic];
            break;
        case Enum_ActionSelectTypeFavorite:
            mDic[@"sortBy"] = [NSString stringWithFormat:@"%d",_sortByFavorite == 0 ? _sortByFavorite : _sortBy];
            [self requestGroupFavorite:mDic];
            break;
        case Enum_ActionSelectTypeTitbits:
            mDic[@"sortBy"] = [NSString stringWithFormat:@"%d",_sortByTitbits == 0 ? _sortByTitbits : _sortBy];
            [self requestGroupTitbits:mDic];
            break;
            
        default:
            break;
    }

}
#pragma mark --- 根据赛区themeID执行第三次请求
-(void)threeRequestGroupWithThemeIsRefreshRequest{
    //这句可以删除。只是为了快速刷新到无数据状态。
        [_collectionView reloadData];
        _collectionView.contentOffset = CGPointMake(0, -64);
    if (_string_themeID) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        QNWSDictionarySetObjectForKey(parameters, _otherModel.columnid, @"columnId");
        QNWSDictionarySetObjectForKey(parameters, _otherModel.isactive, @"columnType")
        QNWSDictionarySetObjectForKey(parameters, [_otherModel.isactive integerValue] == 3 ? @1 : @0 , @"sortType")
        QNWSDictionarySetObjectForKey(parameters, @0, @"upType")
        QNWSDictionarySetObjectForKey(parameters, @(_sortByFocus), @"sortBy")
        QNWSDictionarySetObjectForKey(parameters,_string_themeID, @"themeId")
        
        [BYC_HttpServers requestColumnDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, HL_ColumModel *models) {
            _array_Video        = models.arr_VideoModels;
            switch (_sortByFocus) {
                case 0://最新
                    self.cellNewArrayOtherFocusModels = [_array_Video mutableCopy];
                    break;
                case 1://最热
                    self.cellHotArrayOtherFocusModels = [_array_Video mutableCopy];
                    break;
                default:
                    break;
            }
            [_collectionView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        }];
    }
    else{
        if (_cellNewArrayFocusModels.count > 0 || _cellHotArrayFocusModels.count > 0){//全部数据是有的就刷新
            
            [_collectionView reloadData];
            if (!_isNewFocusWhetherMore) [_collectionView.footer resetNoMoreData];
        }else [self secondRequestGroupWithType];//否则请求全部就是请求赛区看点的最新或者最热数据
    }
    
}

- (void)refreshRequestWithParameters:(NSDictionary *)parameters{
    
    //cell数据
    NSMutableArray *bodyArrayModels = [NSMutableArray array];
    __block BOOL isRepeat = NO;//NO 没有重复 YES 有重复
    
    switch (_type_ActionSelect) {
            
        case Enum_ActionSelectTypeFocus:
        {
            
            if (_sortByFocus == 0) {
                [self requestResponseObject:parameters isRefreshRequest:YES success:^(NSArray *array_Data) {
                    
                    for (BYC_BaseVideoModel *model in array_Data) {
                        
                        if (_string_themeID.length > 0) {
                            
                            for (BYC_BaseVideoModel *CellModel in _cellNewArrayOtherFocusModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                        }else
                            for (BYC_BaseVideoModel *CellModel in _cellNewArrayFocusModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                        
                        if (!isRepeat)[bodyArrayModels addObject:model];
                    }
                    [self resultDataProcessing:bodyArrayModels];
                } failure:^(NSError *error) {
                    
                    if (_string_themeID) [self requestDataStatus:_isNewOtherFocusWhetherMore];
                    else [self requestDataStatus:_isNewFocusWhetherMore];
                }];
                
            }else if (_sortByFocus == 1) {
                
                [self requestResponseObject:parameters isRefreshRequest:YES success:^(NSArray *array_Data) {
                    
                    for (BYC_BaseVideoModel *model in array_Data) {
                        
                        if (_string_themeID.length > 0) {
                            
                            for (BYC_BaseVideoModel *CellModel in _cellHotArrayOtherFocusModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                        } else
                            for (BYC_BaseVideoModel *CellModel in _cellHotArrayFocusModels)
                                if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                        if (!isRepeat)[bodyArrayModels addObject:model];
                    }
                    [self resultDataProcessing:bodyArrayModels];
                } failure:^(NSError *error) {
                    
                    if (_string_themeID) [self requestDataStatus:_isHotOtherFocusWhetherMore];
                    else [self requestDataStatus:_isHotFocusWhetherMore];
                }];
            }
        }
            break;
        case Enum_ActionSelectTypeFavorite:
        {
            
            if (_sortByFavorite == 0) {
                
                [self requestResponseObject:parameters isRefreshRequest:YES success:^(NSArray *array_Data) {
                    
                    for (BYC_BaseVideoModel *model in array_Data) {
                        
                        for (BYC_BaseVideoModel *CellModel in _cellNewArrayFavoriteModels)
                            if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                        if (!isRepeat)[bodyArrayModels addObject:model];
                    }
                    [self resultDataProcessing:bodyArrayModels];
                } failure:^(NSError *error) {
                    [self requestDataStatus:_isNewFavoriteWhetherMore];
                }];
                
            }else if (_sortByFavorite == 1) {
                
                [self requestResponseObject:parameters isRefreshRequest:YES success:^(NSArray *array_Data) {
                    
                    for (BYC_BaseVideoModel *model in array_Data) {
                        
                        for (BYC_BaseVideoModel *CellModel in _cellHotArrayFavoriteModels)
                            if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                        if (!isRepeat)[bodyArrayModels addObject:model];
                    }
                    [self resultDataProcessing:bodyArrayModels];
                } failure:^(NSError *error) {
                    [self requestDataStatus:_isHotFavoriteWhetherMore];
                }];
            }
        }
            break;
        case Enum_ActionSelectTypeTitbits:
        {
            
            if (_sortByTitbits == 0) {
                
                [self requestResponseObject:parameters isRefreshRequest:YES success:^(NSArray *array_Data) {
                    
                    for (BYC_BaseVideoModel *model in array_Data) {
                        
                        for (BYC_BaseVideoModel *CellModel in _cellNewArrayTitbitsModels)
                            if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                        if (!isRepeat)[bodyArrayModels addObject:model];
                    }
                    [self resultDataProcessing:bodyArrayModels];
                } failure:^(NSError *error) {
                    [self requestDataStatus:_isNewTitbitsWhetherMore];
                }];
                
            }else if (_sortByTitbits == 1) {
                
                [self requestResponseObject:parameters isRefreshRequest:YES success:^(NSArray *array_Data) {
                    
                    for (BYC_BaseVideoModel *model in array_Data) {
                        
                        for (BYC_BaseVideoModel *CellModel in _cellHotArrayTitbitsModels)
                            if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                        if (!isRepeat)[bodyArrayModels addObject:model];
                    }
                    [self resultDataProcessing:bodyArrayModels];
                } failure:^(NSError *error) {
                    [self requestDataStatus:_isHotTitbitsWhetherMore];
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)refreshDataWith:(NSDictionary *)paramas{
    
    [BYC_HttpServers requestColumnDataWithParameters:paramas success:^(AFHTTPRequestOperation *operation, HL_ColumModel *models) {
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

- (void)requestGroupTitbits:(NSDictionary *)dicParameters {

    [BYC_HttpServers requestColumnDataWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, HL_ColumModel *models) {
        _array_Video        = models.arr_VideoModels;
        switch (_sortByTitbits) {
            case 0://最新
                self.cellNewArrayTitbitsModels = [_array_Video mutableCopy];
                break;
            case 1://最热
                self.cellHotArrayTitbitsModels = [_array_Video mutableCopy];
                break;
            default:
                break;
        }
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        
    }];
}

/**
 *  视频数据通用请求方法
 *
 *  @param dicParameters 请求参数
 *  @param success       成功回调
 */
- (void)requestResponseObject:(NSDictionary *)dicParameters  isRefreshRequest:(BOOL)isRefreshRequest success:(void (^)(NSArray *array_Data))success failure:(void (^)(NSError *error))failure{

    [BYC_HttpServers requestColumnDataWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, HL_ColumModel *models) {
        _array_Video        = models.arr_VideoModels;
        if (models.arr_VideoModels.count == 0) {
            [self noDataWithType];
            [_collectionView reloadData];
            return;
        }
        return success(_array_Video);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
    }];
}

/** 数据处理 */
- (void)resultDataProcessing:(NSMutableArray *)mArray{
    Enum_ActionSelectType  type_SelectAction = [_otherModel.isactive integerValue] == 1 ? _header_MT.type_SelectAction :_header_InStep.type_SelectAction;
    switch (type_SelectAction) {
        case Enum_ActionSelectTypeFocus:
        {
        
            if (_string_themeID) {
                
                if (self.collectionView.footer.isRefreshing) {
                    
                    [_sortByFocus == 0 ? self.cellNewArrayOtherFocusModels:self.cellHotArrayOtherFocusModels addObjectsFromArray:mArray];
                    
                    if (mArray.count == 0) [self noDataWithType];// 变为没有更多数据的状态
                    else [self.collectionView.footer endRefreshing];// 结束刷新
                }else if (self.collectionView.header.isRefreshing) {
                    
                    NSMutableArray *mmArray = _sortByFocus == 0 ? self.cellNewArrayOtherFocusModels:self.cellHotArrayOtherFocusModels;
                    if (_sortByFocus == 0) self.cellNewArrayOtherFocusModels = [mArray mutableCopy];
                    if (_sortByFocus == 1) self.cellHotArrayOtherFocusModels = [mArray mutableCopy];
                    [_sortByFocus == 0 ? self.cellNewArrayOtherFocusModels:self.cellHotArrayOtherFocusModels addObjectsFromArray:mmArray];
                    // 结束刷新
                    [self.collectionView.header endRefreshing];
                    
                }else {
                    
                    if (_sortByFocus == 0) self.cellNewArrayOtherFocusModels = mArray;
                    if (_sortByFocus == 1) self.cellHotArrayOtherFocusModels = mArray;
                }

            }else {

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
        case Enum_ActionSelectTypeTitbits:
        {
        
            if (self.collectionView.footer.isRefreshing) {
                
                [_sortByTitbits == 0 ? self.cellNewArrayTitbitsModels:self.cellHotArrayTitbitsModels addObjectsFromArray:mArray];
                if (mArray.count == 0) [self noDataWithType];// 变为没有更多数据的状态
                else [self.collectionView.footer endRefreshing];// 结束刷新
                
            }else if (self.collectionView.header.isRefreshing) {
                
                NSMutableArray *mmArray = _sortByTitbits == 0 ? self.cellNewArrayTitbitsModels:self.cellHotArrayTitbitsModels;
                if (_sortByTitbits == 0) self.cellNewArrayTitbitsModels = [mArray mutableCopy];
                if (_sortByTitbits == 1) self.cellHotArrayTitbitsModels = [mArray mutableCopy];
                [_sortByTitbits == 0 ? self.cellNewArrayTitbitsModels:self.cellHotArrayTitbitsModels addObjectsFromArray:mmArray];
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
    
    NSInteger count = 0;
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
            if (_string_themeID) count = _sortByFocus == 0 ? _cellNewArrayOtherFocusModels.count : _cellHotArrayOtherFocusModels.count;
            else count = _sortByFocus == 0 ? _cellNewArrayFocusModels.count : _cellHotArrayFocusModels.count;
            break;
        case Enum_ActionSelectTypeFavorite:
            count = _sortByFavorite == 0 ? _cellNewArrayFavoriteModels.count : _cellHotArrayFavoriteModels.count;
            break;
        case Enum_ActionSelectTypeTitbits:
            count = _sortByTitbits == 0 ? _cellNewArrayTitbitsModels.count : _cellHotArrayTitbitsModels.count;
            break;
            
        default:
            break;
    }
    return count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"HomeCollectionCell";
    
    BYC_HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
            if (_string_themeID)
                cell.model = _sortByFocus == 0 ? _cellNewArrayOtherFocusModels[indexPath.row] : _cellHotArrayOtherFocusModels[indexPath.row];
            else
                cell.model = _sortByFocus == 0 ? _cellNewArrayFocusModels[indexPath.row] : _cellHotArrayFocusModels[indexPath.row];
            break;
        case Enum_ActionSelectTypeFavorite:
            cell.model = _sortByFavorite == 0 ? _cellNewArrayFavoriteModels[indexPath.row] : _cellHotArrayFavoriteModels[indexPath.row];
            break;
        case Enum_ActionSelectTypeTitbits:
            cell.model = _sortByTitbits == 0 ? _cellNewArrayTitbitsModels[indexPath.row] : _cellHotArrayTitbitsModels[indexPath.row];
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
        if ([_otherModel.isactive integerValue] == 1) {
    
        if (!_header_MT) _header_MT = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
            _imageV_Header = _header_MT.imageV_BG;
            __weak __typeof(self) weakSelf = self;
            _header_MT.headerButtonAction = ^(NSInteger flag){
            
                [weakSelf buttonAction:flag];
                };
            _header_MT.dic_Data = @{@"bannerData":_array_SecCover,@"groupData":_array_VideoGroup};
            return _header_MT;
        }
        else{
            if (!_header_InStep) {
                _header_InStep = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
                if ([self.model.isactive integerValue] != 1) {
                    _header_InStep.isHiddenView_ChangeDataType = [_otherModel.isactive integerValue] == 2 ? YES: _array_VideoGroup.count > 1 ? NO : YES;
                }
            }
            _imageV_Header = _header_InStep.imageV_BG;
            __weak __typeof(self) weakSelf = self;
            _header_InStep.headerButtonAction = ^(NSInteger flag){
                [weakSelf buttonAction:flag];
            };
            _header_InStep.model = _otherModel;
            _header_InStep.dic_Data = @{@"bannerData":_array_SecCover,@"groupData":_array_VideoGroup};
            return _header_InStep;
        }
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
    
    WX_VoideDViewController *voideVC = [[WX_VoideDViewController alloc]init];
    voideVC.hidesBottomBarWhenPushed = YES;
    BYC_BaseVideoModel *model = [[BYC_BaseVideoModel alloc]init];
    
    switch (_type_ActionSelect) {
        case Enum_ActionSelectTypeFocus:
            if (_string_themeID) model = _sortByFocus == 0 ? _cellNewArrayOtherFocusModels[indexPath.row]: _cellHotArrayOtherFocusModels[indexPath.row];
            else model = _sortByFocus == 0 ? _cellNewArrayFocusModels[indexPath.row]: _cellHotArrayFocusModels[indexPath.row];
            break;
        case Enum_ActionSelectTypeFavorite:
           model = _sortByFavorite == 0 ? _cellNewArrayFavoriteModels[indexPath.row]: _cellHotArrayFavoriteModels[indexPath.row];
            break;
        case Enum_ActionSelectTypeTitbits:
            model = _sortByTitbits == 0 ? _cellNewArrayTitbitsModels[indexPath.row]: _cellHotArrayTitbitsModels[indexPath.row];
            break;
        default:
            break;
    }

    [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
}

#pragma mark - UIScrollDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //获取偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    //centrView的frame
    if (_headerSize.height == 0) {
        self.topHiddenView.hidden = YES;
    }
    else{
        if (_headerSize.height - offsetY - 64 <= 27)self.topHiddenView.hidden = NO;
        else self.topHiddenView.hidden = YES;

    }
}

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, KHeightNavigationBar+_headerSize.height, screenWidth,screenHeight-KHeightNavigationBar-_headerSize.height)];
    _view_CueWords = view;
    UIView *View_CueWords = [self createMaskViewInViewMore:_view_CueWords content:@"本届精彩即将开始，敬请期待! "];
    [_view_CueWords addSubview:View_CueWords];
    return _view_CueWords;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return _headerSize.height/2+20;
}


-(void)dealloc {

    QNWSLog(@"23456789");
    _collectionView.delegate = nil;
}

@end
