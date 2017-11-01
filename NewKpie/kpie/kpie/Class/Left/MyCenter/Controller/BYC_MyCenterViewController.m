//
//  BYC_MyCenterViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/2.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_MyCenterViewController.h"
#import "BYC_AccountTool.h"
#import "BYC_CenterCollectionViewCell.h"
#import "UIImage+ImageEffects.h"
#import "BYC_PersonalDataViewController.h"
#import "BYC_CenterFocusCollectionViewCell.h"
#import "BYC_FocusAndFansModel.h"
#import "BYC_ShowHeaderImageViewController.h"
#import "BYC_HomeViewControllerModel.h"
#import "HL_JumpToVideoPlayVC.h"



@interface BYC_MyCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate> {
    
    /**是否已经打开过控制器*/
    BOOL _isOpenTheVC;
    /**YES:自己点击自己  NO:点击别人的个人中心*/
    BOOL  _isSelfOpenCenter;
    
    /**没有更多作品*/
    BOOL _isWhetherMoreWorks;
    /**没有更多关注*/
    BOOL _isWhetherMoreFocus;
    /**没有更多粉丝*/
    BOOL _isWhetherMoreFans;
    
    /**YES是关注状态 NO是未关注状态*/
    BOOL             _isWhetherFocusState;
    /**YES是关注状态 NO是未关注状态*/
    BOOL             _isPersonalCenterWhetherFocusState;
    /**当我们点击某个用户进行关注或者取消操作之后的状态结果*/
    WhetherFocusForCell _whenClickFocusStateResult;
    
    /**当前登录用户的个人信息*/
    BYC_AccountModel *_userModel;
    //加入黑名单按钮
    __weak IBOutlet UIButton *button_BlackList;
    
    __weak IBOutlet UILabel *label_Title;
    
}
/**作品集合*/
@property (nonatomic, strong) NSMutableArray<BYC_HomeViewControllerModel *> *array_WorksModels;
/**关注集合*/
@property (nonatomic, strong) NSMutableArray<BYC_FocusAndFansModel *>       *array_FocusModels;
/**粉丝集合*/
@property (nonatomic, strong) NSMutableArray<BYC_FocusAndFansModel *>       *array_FansModels;
/**当我们点击某个用户进行关注或者取消操作之后的作品关注粉丝的数量数组数据下标0作品1关注2粉丝*/
@property (nonatomic, strong) NSMutableArray<NSString *> *arrayWorksFocusFansNumber;
/**当我们点击某个用户进行关注或者取消操作之后的作品关注粉丝的数量数组数据下标0作品1关注2粉丝*/
@property (nonatomic, strong) NSMutableArray<NSString *> *arrayWorksFocusFansNumberSomebody;
@property (weak, nonatomic  ) IBOutlet UIImageView      *imageV_header;

@property (weak, nonatomic  ) IBOutlet UILabel          *label_NickName;
@property (weak, nonatomic  ) IBOutlet UILabel          *label_Introduction;
@property (weak, nonatomic) IBOutlet UIImageView        *imageV_Sex;
@property (weak, nonatomic) IBOutlet UIButton           *button_whetherFocus;
@property (weak, nonatomic) IBOutlet UIButton *button_Works;
@property (weak, nonatomic) IBOutlet UIButton *button_Focus;
@property (weak, nonatomic) IBOutlet UIButton *button_Fans;

/**当前用户的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel          *toCurrentUserModel;
/**需要被关注或取消关注的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel           *toFocusUserModel;
/**作品*/
@property (strong, nonatomic  ) UICollectionView          *collectionViewWorks;
/**关注*/
@property (strong, nonatomic  ) UICollectionView          *collectionViewFocus;
/**粉丝*/
@property (strong, nonatomic  ) UICollectionView          *collectionViewFans;

@property (weak, nonatomic  ) IBOutlet UIImageView        *imageV_blur;
/**作品第几页数据*/
@property (nonatomic, assign) int              pageWorks;
/**关注第几页数据*/
@property (nonatomic, assign) int              pageFocus;
/**粉第几页数据*/
@property (nonatomic, assign) int              pageFans;

@property (strong, nonatomic  ) UIView         *view_MaskWorks;
@property (strong, nonatomic  ) UIView         *view_MaskFocus;
@property (strong, nonatomic  ) UIView         *view_MaskFans;

@property (copy, nonatomic, readonly) NSArray<NSString *> *collectionNibNames;
@property (copy, nonatomic, readonly) NSArray<NSString *> *collectionReuseIdentifiers;

/**数量集合*/
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray<UILabel *> *arrayNumber;
/**作品、关注、粉丝*/
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray<UILabel *> *arrayZpGzFs;
/**BottomViews*/
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView *> *arrayBottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_HeaderViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_BottmViewHeight;

/**容器View*/
@property (weak, nonatomic) IBOutlet UIView *view_Container;
@property (nonatomic, strong)  UIScrollView *scrollView_Container;

/**相对于我：YES:代表已加入黑名单 NO:未加入黑名单*/
@property (nonatomic, assign)  BOOL  isBlackList;
@end

@implementation BYC_MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (KCurrentDeviceIsIphone4) {
        
        _constraint_HeaderViewHeight.constant =  KHeightOnTheBasisOfIPhone6SizeNONeed6P(_constraint_HeaderViewHeight.constant) + 50;
        _constraint_BottmViewHeight.constant =   KHeightOnTheBasisOfIPhone6SizeNONeed6P(_constraint_BottmViewHeight.constant) + 5;
        
    }
    
    if (KCurrentDeviceIsIphone5) {
        
        _constraint_HeaderViewHeight.constant =  KHeightOnTheBasisOfIPhone6SizeNONeed6P(_constraint_HeaderViewHeight.constant) + 20;
        _constraint_BottmViewHeight.constant =   KHeightOnTheBasisOfIPhone6SizeNONeed6P(_constraint_BottmViewHeight.constant) + 5;
    }
    
    if (KCurrentDeviceIsIphone6p) {
        
        _constraint_HeaderViewHeight.constant =  KHeightOnTheBasisOfIPhone6SizeNONeed6P(_constraint_HeaderViewHeight.constant - 30);
        _constraint_BottmViewHeight.constant =   KHeightOnTheBasisOfIPhone6SizeNONeed6P(_constraint_BottmViewHeight.constant);
    }
    
    
}
- (void)reloadUserInfo {
    
    //获取个人信息
    [self requestDataWithUrl:KQNWS_GetUserUrl parameters:@{@"user.userid":_userID,
                                                           @"userid":_userModel.userid ? _userModel.userid : @""}
                        type:3
                  completion:nil];
    //判断是否关注
    [self requestDataWithUrl:KQNWS_IsSaveUserUrl parameters:@{@"token":_userModel.token ? _userModel.token : @"",
                                                              @"user.userid":_userModel.userid ? _userModel.userid : @"",
                                                              @"userid":_userModel.userid ? _userModel.userid : @"" ,
                                                              @"touserid":_userID}
                        type:4
                  completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    //防止被顶号，只能在此方法类重写
    _userModel = [BYC_AccountTool userAccount];
    
    //YES:自己点击自己  NO:点击别人的个人中心
    _isSelfOpenCenter = [_userModel.userid isEqualToString:_userID] || _isFromLeftHeader;
    _userID = _isSelfOpenCenter ?  _userModel.userid : _userID;
    _toCurrentUserModel = _isSelfOpenCenter ?  _userModel : self.toCurrentUserModel;
    
    
    if (_isSelfOpenCenter) {
        
        label_Title.text = @"我的主页";
        
        //自己打开自己个人中心的隐藏关注Button
        _button_whetherFocus.hidden = YES;
        button_BlackList.hidden = YES;
        //初始化子视图
        [self initViews:_userModel];
    }
    
    //获取用户的资料
    [self reloadUserInfo];
    if (_isFromLeftHeader || _isFromLeftFocus) {//从左侧栏Push进来的
        
        _isFromLeftHeader = NO;
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES; //禁用ios7手势滑动返回功能(因为在BYC_MyCenterViewController页面中，侧滑BYC_MyCenterViewController页面的时候,导致再次进入BYC_MyCenterViewController页面push到其他页面的时候，self.title闪现之后又消失)
    
    if (!_isFromLeftHeader && !_isOpenTheVC) {//从左侧栏Push进来的,解决了加载xib上面的子界面需要等到布局完成之后才能布局自己代码写的子界面的问题，而且在push到其他页面在pop回来的时候不会在重复调用
        _isOpenTheVC = YES;//第一次进来了，pop回来就不需要在进来了
        [self initScrollContainer];
        
        //初始化collectionView
        [self initCollectionView];
        _pageWorks = 1;
        _pageFocus = 1;
        _pageFans  = 1;
    }
    
    
    //默认先加载作品页(一起加载完算了)
    [self loadDataCollection:BYC_MyCenterVCSelectedCollectionWorks WithPage:1];
    [self loadDataCollection:BYC_MyCenterVCSelectedCollectionFocus WithPage:1];
    [self loadDataCollection:BYC_MyCenterVCSelectedollectionFans WithPage:1];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES; //开启ios7手势滑动返回功能(因为在BYC_MyCenterViewController页面中，侧滑BYC_MyCenterViewController页面的时候,导致再次进入BYC_MyCenterViewController页面push到其他页面的时候，self.title闪现之后又消失)
}

- (void)initViews:(BYC_AccountModel *)userModel {
    
    _arrayNumber[0].text = [NSString stringWithFormat:@"%ld",(long)(userModel.videos <= 0 ? 0 : userModel.videos)];
    _arrayNumber[1].text = [NSString stringWithFormat:@"%ld",(long)(userModel.focus <= 0 ? 0 : userModel.focus)];
    _arrayNumber[2].text = [NSString stringWithFormat:@"%ld",(long)(userModel.fans <= 0 ? 0 : userModel.fans)];
    
    _imageV_header.layer.borderWidth = 2.0f;
    _imageV_header.layer.borderColor=KUIColorFromRGB(0X085E6D).CGColor;
    _imageV_header.layer.masksToBounds = YES;
    _imageV_header.layer.cornerRadius = 85 / 2.0f;
    if (userModel) {
        
        __weak __typeof(self) weakSelf = self;
        
        [_imageV_header sd_setImageWithURL:[NSURL URLWithString:userModel.headportrait] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            __block UIImage *imageBlur =  image;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                imageBlur = [imageBlur blurImageWithRadius:20];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.imageV_blur.image = imageBlur;
                });
                
            });
            
            
        }];
        _label_NickName.text = userModel.nickname;
        if (userModel.mydescription.length > 0) {
            
            _label_Introduction.text = userModel.mydescription;
        }else {
            
            _label_Introduction.text = @"此人很懒，没留下描述...";
        }
    }
    
    if (userModel.sex == 0) {
        
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nan"];
    }else if(userModel.sex == 1) {
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nv-xiao"];
    }else {
        _imageV_Sex.image = [UIImage imageNamed:@"baomi"];
    }
}

- (void)initScrollContainer {
    
    _scrollView_Container = [[UIScrollView alloc] initWithFrame:_view_Container.bounds];
    [_view_Container addSubview:_scrollView_Container];
    _scrollView_Container.bounces = NO;
    _scrollView_Container.pagingEnabled = YES;
    _scrollView_Container.delegate = self;
    _scrollView_Container.backgroundColor = [UIColor clearColor];
    _scrollView_Container.showsHorizontalScrollIndicator = NO;
    
    _scrollView_Container.contentSize = CGSizeMake(_scrollView_Container.kwidth * _arrayZpGzFs.count, _scrollView_Container.kheight);
}

- (void)initCollectionView {
    
    
    _collectionNibNames = @[@"BYC_CenterCollectionViewCell",@"BYC_CenterFocusCollectionViewCell",@"BYC_CenterFocusCollectionViewCell"];
    _collectionReuseIdentifiers = @[@"centerCollectionViewCell",@"centerFocusCollectionViewCell",@"centerFansCollectionViewCell"];
    
    for (__block int i = 0; i < _collectionNibNames.count; i++) {
        
        //设置布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = .5f;
        layout.minimumLineSpacing      = 0.f;
        layout.itemSize = i == 0 ? CGSizeMake(screenWidth , 70.f) : CGSizeMake(screenWidth , 50.f);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collection  = [[UICollectionView alloc] initWithFrame:CGRectMake(_scrollView_Container.kwidth * i, _scrollView_Container.top, _scrollView_Container.kwidth, _scrollView_Container.kheight) collectionViewLayout:layout];
        collection.delegate                     = self;
        collection.dataSource                   = self;
        collection.showsVerticalScrollIndicator = YES;
        collection.backgroundColor = [UIColor clearColor];
        [collection registerNib:[UINib nibWithNibName:_collectionNibNames[i] bundle:nil] forCellWithReuseIdentifier:_collectionReuseIdentifiers[i]];
        
        switch (i) {
            case 0:
                _collectionViewWorks = collection;
                break;
            case 1:
                _collectionViewFocus = collection;
                _collectionViewFocus.backgroundColor = [UIColor clearColor];
                break;
            case 2:
                _collectionViewFans = collection;
                _collectionViewFans.backgroundColor = [UIColor clearColor];
                break;
                
            default:
                break;
        }
        [_scrollView_Container addSubview:collection];
        
        __weak __typeof(self) weakSelf = self;
        __block int page = 1;
        // 上拉更新
        collection.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            switch (weakSelf.myCenterVCSelectedCollection) {
                case BYC_MyCenterVCSelectedCollectionWorks://作品
                    page = ++weakSelf.pageWorks;
                    break;
                case BYC_MyCenterVCSelectedCollectionFocus://关注
                    page = ++weakSelf.pageFocus;
                    break;
                case BYC_MyCenterVCSelectedollectionFans://粉丝
                    page = ++weakSelf.pageFans;
                    break;
                    
                default:
                    break;
            }
            
            [weakSelf loadDataCollection:weakSelf.myCenterVCSelectedCollection WithPage:page];
        }];
    }
}



- (void)loadDataCollection:(BYC_MyCenterVCSelectedCollection)selectedCollection WithPage:(int)page {
    
    NSDictionary *dic;
    switch (selectedCollection) {
        case BYC_MyCenterVCSelectedCollectionWorks:
            dic = @{@"page":[NSNumber numberWithInt:page],@"rows":@"20",@"video.userid": _userID};
            break;
        case BYC_MyCenterVCSelectedCollectionFocus:
            dic = @{@"page":[NSNumber numberWithInt:page],@"rows":@"20",@"userid":_userModel.userid ? _userModel.userid : @"", @"touserid":  _userID};
            break;
        case BYC_MyCenterVCSelectedollectionFans:
            dic = @{@"page":[NSNumber numberWithInt:page],@"rows":@"20",@"userid":_userModel.userid ? _userModel.userid : @"",@"touserid": _userID};
            break;
            
        default:
            break;
    }
    
    //网络请求
    [self requestDataWithUrl:selectedCollection == BYC_MyCenterVCSelectedCollectionWorks ? KQNWS_GetMineVideoUrl : selectedCollection == BYC_MyCenterVCSelectedCollectionFocus ? KQNWS_GetFocusUserUrl : KQNWS_GetFansUserUrl parameters:dic type:selectedCollection completion:nil];
}

- (void)requestDataWithUrl:(NSString *)url parameters:(id)parameters type:(NSInteger)integer completion:(void(^)(BOOL success))completion{
    
    [BYC_HttpServers Get:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        switch (integer) {
            case BYC_MyCenterVCSelectedCollectionWorks://作品展示
            {
                
                NSArray *bodyRows = responseObject[@"rows"];
                
                if (bodyRows.count > 0) {
                    
                    //cell数据
                    NSMutableArray *bodyArrayModels = [NSMutableArray array];
                    for (NSArray *arrayModel in bodyRows) {
                        
                        BYC_HomeViewControllerModel *model = [BYC_HomeViewControllerModel initModelWithArray:arrayModel];
                        [bodyArrayModels addObject:model];
                    }
                    
                    if (self.collectionViewWorks.footer.isRefreshing) {
                        
                        // 结束刷新
                        [self.array_WorksModels addObjectsFromArray:bodyArrayModels];
                        [self.collectionViewWorks.footer endRefreshing];
                        
                    }else {
                        
                        self.array_WorksModels = bodyArrayModels;
                        
                    }
                    
                    
                }else {
                    
                    if (self.collectionViewWorks.footer.isRefreshing) {//上拉加载数据，没有了，提示没有更多数据
                        [self.collectionViewWorks.footer endRefreshingWithNoMoreData];
                    }else {//不是上拉加载数据，那么就是真正的没有数据了，此时就要把数组清零
                        
                        [self.array_WorksModels removeAllObjects];
                        
                    }
                }
                
                [_collectionViewWorks reloadData];
                
                if (self.array_WorksModels.count > 0) {//移除遮罩不占用内存
                    
                    [self.view_MaskWorks removeFromSuperview];
                    self.view_MaskWorks = nil;
                    
                }else {//展现遮罩
                    
                    [_scrollView_Container insertSubview:self.view_MaskWorks belowSubview:_collectionViewWorks];
                    
                }
            }
                break;
                
            case BYC_MyCenterVCSelectedCollectionFocus://关注展示
            {
                NSArray *bodyRows = responseObject[@"rows"];
                
                if (bodyRows.count > 0) {
                    
                    //cell数据
                    NSMutableArray *bodyArrayModels = [NSMutableArray array];
                    for (NSArray *arrayModel in bodyRows) {
                        
                        BYC_FocusAndFansModel *model = [BYC_FocusAndFansModel initModelWithArray:arrayModel];
                        [bodyArrayModels addObject:model];
                    }
                    
                    if (self.collectionViewFocus.footer.isRefreshing) {
                        
                        // 结束刷新
                        [self.array_FocusModels addObjectsFromArray:bodyArrayModels];
                        [self.collectionViewFocus.footer endRefreshing];
                        
                    }else {
                        
                        self.array_FocusModels = bodyArrayModels;
                    }
                    
                }else {
                    
                    if (self.collectionViewFocus.footer.isRefreshing) {//上拉加载数据，没有了，提示没有更多数据
                        [self.collectionViewFocus.footer endRefreshingWithNoMoreData];
                    }else {//不是上拉加载数据，那么就是真正的没有数据了，此时就要把数组清零
                        
                        [self.array_FocusModels removeAllObjects];
                        
                    }
                }
                
                [_collectionViewFocus reloadData];
                
                if (self.array_FocusModels.count > 0) {//移除遮罩不占用内存
                    
                    [self.view_MaskFocus removeFromSuperview];
                    self.view_MaskFocus = nil;
                    
                }else {//展现遮罩
                    
                    [_scrollView_Container insertSubview:self.view_MaskFocus belowSubview:_collectionViewFocus];
                    
                }
                
            }
                break;
                
            case BYC_MyCenterVCSelectedollectionFans://粉丝展示
            {
                NSArray *bodyRows = responseObject[@"rows"];
                
                if (bodyRows.count > 0) {
                    
                    //cell数据
                    NSMutableArray *bodyArrayModels = [NSMutableArray array];
                    for (NSArray *arrayModel in bodyRows) {
                        
                        BYC_FocusAndFansModel *model = [BYC_FocusAndFansModel initModelWithArray:arrayModel];
                        
                        [bodyArrayModels addObject:model];
                    }
                    
                    if (self.collectionViewFans.footer.isRefreshing) {
                        
                        // 结束刷新
                        [self.array_FansModels addObjectsFromArray:bodyArrayModels];
                        [self.collectionViewFans.footer endRefreshing];
                        
                    }else {
                        
                        self.array_FansModels = bodyArrayModels;
                    }
                    
                    
                }else {
                    
                    if (self.collectionViewFans.footer.isRefreshing) {//上拉加载数据，没有了，提示没有更多数据
                        [self.collectionViewFans.footer endRefreshingWithNoMoreData];
                    }else {//不是上拉加载数据，那么就是真正的没有数据了，此时就要把数组清零
                        
                        [self.array_FansModels removeAllObjects];
                        
                    }
                }
                
                [_collectionViewFans reloadData];
                
                if (self.array_FansModels.count > 0) {//移除遮罩不占用内存
                    
                    [self.view_MaskFans removeFromSuperview];
                    self.view_MaskFans = nil;
                    
                }else {//展现遮罩
                    
                    [_scrollView_Container insertSubview:self.view_MaskFans belowSubview:_collectionViewFans];
                    
                }
            }
                break;
                
            case 3://获取个人信息
            {
                [self.arrayWorksFocusFansNumber removeAllObjects];
                [self.arrayWorksFocusFansNumberSomebody removeAllObjects];
                NSArray *userArray = responseObject[@"user"];
                
                //_isSelfOpenCenter = YES 自己的个人中心 NO : /别人的个人中心
                self.toCurrentUserModel = _isSelfOpenCenter ? [BYC_AccountTool userAccount] : self.toCurrentUserModel;
                if (userArray && [responseObject[@"result"] integerValue] == 0) {
                    
                    self.toCurrentUserModel.userid        = userArray[0];
                    self.toCurrentUserModel.nickname      = userArray[1];
                    self.toCurrentUserModel.headportrait  = userArray[2];
                    self.toCurrentUserModel.mydescription = userArray[3];
                    self.toCurrentUserModel.sex           = [userArray[4] integerValue];
                    self.toCurrentUserModel.videos        = [userArray[5] integerValue];
                    self.toCurrentUserModel.fans          = [userArray[6] integerValue];
                    self.toCurrentUserModel.focus         = [userArray[7] integerValue];
//                    self.toCurrentUserModel.levelImg      = userArray[8];
//                    self.toCurrentUserModel.titleImg      = userArray[9];
//                    self.toCurrentUserModel.titleName     = userArray[10];

                    if (_isSelfOpenCenter) {
                        [self.arrayWorksFocusFansNumber addObject:[NSString stringWithFormat:@"%ld",(long)[userArray[5] integerValue]]];
                        [self.arrayWorksFocusFansNumber addObject:[NSString stringWithFormat:@"%ld",(long)[userArray[7] integerValue]]];
                        [self.arrayWorksFocusFansNumber addObject:[NSString stringWithFormat:@"%ld",(long)[userArray[6] integerValue]]];
                    }else {
                        
                        [self.arrayWorksFocusFansNumberSomebody addObject:[NSString stringWithFormat:@"%ld",(long)[userArray[5] integerValue]]];
                        [self.arrayWorksFocusFansNumberSomebody addObject:[NSString stringWithFormat:@"%ld",(long)[userArray[7] integerValue]]];
                        [self.arrayWorksFocusFansNumberSomebody addObject:[NSString stringWithFormat:@"%ld",(long)[userArray[6] integerValue]]];
                        
                        //登录用户和当前个人主页用户之间的是否存在拉黑关系状态码
                        self.isBlackList = [userArray[11] boolValue];
                    }
                    
                    if (_isSelfOpenCenter) {//把自己的个人中心账户模型归档
                        
                        [BYC_AccountTool saveAccount:self.toCurrentUserModel];//操作后的归档
                        
                    }
                    //初始化子视图
                    [self initViews:self.toCurrentUserModel];
                }
                
            }
                break;
            case 4://获取关注状态
            {
                
                NSDictionary *dic = responseObject;
                
                if (_isSelfOpenCenter) {//在自己个人中心对自己进行操作
                    
                    BYC_AccountModel *userModel =  [BYC_AccountTool userAccount];
                    
                    //0 已关注 2 未关注 3 互相关注
                    if ([dic[@"result"] intValue] == 0) {
                        
                        _isPersonalCenterWhetherFocusState = YES;
                        userModel.whetherFocusForCell = WhetherFocusForCellYES;
                    }else if([dic[@"result"] intValue] == 3)  {
                        
                        _isPersonalCenterWhetherFocusState = YES;
                        userModel.whetherFocusForCell = WhetherFocusForCellHXFocus;
                    }else {
                        
                        _isPersonalCenterWhetherFocusState = NO;
                        userModel.whetherFocusForCell = WhetherFocusForCellNO;
                    }
                    
                    [BYC_AccountTool saveAccount:userModel];
                    [_button_whetherFocus setImage:[UIImage imageNamed: _isPersonalCenterWhetherFocusState ? @"icon-ygzs-h" : @"icon-gzs-n"] forState:UIControlStateNormal];
                    
                    [self whetherSelectFocus:YES toUserID:_userModel completion:nil];//~~~~!20160223 新需求，自己不能关注自己。
                }else {//在别人个人中心进行操作（注意此时在别人的个人中心对自己做关注和取消操作）
                    
                    //0 已关注 2 未关注 3 互相关注
                    if ([dic[@"result"] intValue] == 0) {
                        
                        _isPersonalCenterWhetherFocusState = YES;
                    }else if([dic[@"result"] intValue] == 3)  {
                        
                        _isPersonalCenterWhetherFocusState = YES;
                    }else {
                        
                        _isPersonalCenterWhetherFocusState = NO;
                    }
                    
                    [_button_whetherFocus setImage:[UIImage imageNamed: _isPersonalCenterWhetherFocusState ? @"icon-ygzs-h" : @"icon-gzs-n"] forState:UIControlStateNormal];
                }
                
            }
                break;
            case 5://取消关注或者添加关注
            {
                
                if (_isSelfOpenCenter) {//~~~~!20160223 新需求，自己不能关注自己。
                    
                    if ([_userModel.userid isEqualToString:_toFocusUserModel.userid]) {
                        
                        if (completion) completion(YES);//可以继续点击
                        return;
                    }
                }
                NSDictionary *dic = responseObject;
             
                if ([dic[@"result"] intValue] == 6) {//被需要关注的人拉黑了。所以关注失败
                    
                    [self.view showAndHideHUDWithTitle:@"抱歉，无法关注" WithState:BYC_MBProgressHUDHideProgress];
                    if (completion) completion(YES);//可以继续点击
                    return ;
                }

                switch ([dic[@"rows"][1] intValue]) {
                    case 0://已关注
                        _whenClickFocusStateResult = WhetherFocusForCellYES;
                        break;
                    case 2://未关注
                        _whenClickFocusStateResult = WhetherFocusForCellNO;
                        break;
                    case 3://互相关注
                        _whenClickFocusStateResult = WhetherFocusForCellHXFocus;
                        break;
                        
                    default:
                        break;
                }
//                if (_searchUserListFocusStateBlock) _searchUserListFocusStateBlock([dic[@"rows"][1] intValue]);//此处是给搜索列表的block回调信息。
                self.toFocusUserModel.whetherFocusForCell = _whenClickFocusStateResult;
                
                if ([dic[@"result"] intValue] == 0) {
                    
                    [self.view showAndHideHUDWithTitle:_isWhetherFocusState ? @"取消关注成功":@"添加关注成功" WithState:BYC_MBProgressHUDHideProgress];
                    
                    if (( _isSelfOpenCenter && [_userModel.userid isEqualToString:self.toFocusUserModel.userid] ) || [_toCurrentUserModel.userid isEqualToString:self.toFocusUserModel.userid]){
                        
                        _isPersonalCenterWhetherFocusState = !_isPersonalCenterWhetherFocusState;
                        [_button_whetherFocus setImage:[UIImage imageNamed: _isPersonalCenterWhetherFocusState ? @"icon-ygzs-h" : @"icon-gzs-n"] forState:UIControlStateNormal];
                    }
                    
                    _isWhetherFocusState = !_isWhetherFocusState;
                    
                    if (_isSelfOpenCenter) {
                        
                        if ([_userModel.userid isEqualToString:_toFocusUserModel.userid]) {
                            
                            self.arrayWorksFocusFansNumber[0] = [NSString stringWithFormat:@"%ld",(long)[dic[@"rows"][0][0] integerValue]];
                            self.arrayWorksFocusFansNumber[1] = [NSString stringWithFormat:@"%ld",(long)[dic[@"rows"][0][2] integerValue]];
                            self.arrayWorksFocusFansNumber[2] = [NSString stringWithFormat:@"%ld",(long)[dic[@"rows"][0][1] integerValue]];
                            
                        }else {
                            
                            NSString *numFocusString;
                            if (_isWhetherFocusState) {
                                
                                numFocusString = [NSString stringWithFormat:@"%ld",(long)([self.arrayWorksFocusFansNumber[1] integerValue] + 1)];
                            }else {
                                NSInteger integ = ([self.arrayWorksFocusFansNumber[1] integerValue] - 1) <= 0 ? 0 : [self.arrayWorksFocusFansNumber[1] integerValue] - 1;
                                numFocusString = [NSString stringWithFormat:@"%ld",(long)integ];
                            }
                            self.arrayWorksFocusFansNumber[1] = numFocusString;
                        }
                    }else {
                        
                        if ([_toCurrentUserModel.userid isEqualToString:_toFocusUserModel.userid]) {
                            
                            self.arrayWorksFocusFansNumberSomebody[0] = [NSString stringWithFormat:@"%ld",(long)[dic[@"rows"][0][0] integerValue]];
                            self.arrayWorksFocusFansNumberSomebody[1] = [NSString stringWithFormat:@"%ld",(long)[dic[@"rows"][0][2] integerValue]];
                            self.arrayWorksFocusFansNumberSomebody[2] = [NSString stringWithFormat:@"%ld",(long)[dic[@"rows"][0][1] integerValue]];
                        }
                    }
                    
                    
                }else {
                    
                    [self.view showAndHideHUDWithTitle:_isWhetherFocusState ? @"抱歉，取消关注失败":@"抱歉，无法关注" WithState:BYC_MBProgressHUDHideProgress];
                    if (completion) completion(YES);//可以继续点击
                    return;
                }
                
                
                if (_isSelfOpenCenter) {//在自己个人中心进行操作
                    
                    if (_isWhetherFocusState) {//成功添加关注
                        
                        if ([_userModel.userid isEqualToString:self.toFocusUserModel.userid]) {//对自己操作
                            
                            [self.array_FocusModels insertObject:self.toFocusUserModel atIndex:0];
                            [_collectionViewFocus reloadData];//因为每个cell颜色不一样，所以不能刷新单个cell，只能全部刷新
                            _arrayNumber[1].text = _arrayWorksFocusFansNumber[1];//关注数+1
                            
                            [self.array_FansModels insertObject:self.toFocusUserModel atIndex:0];
                            [_collectionViewFans reloadData];//因为每个cell颜色不一样，所以不能刷新单个cell，只能全部刷新
                            _arrayNumber[2].text = _arrayWorksFocusFansNumber[2];//粉丝数+1
                        }else {//对别人操作
                            
                            [self.array_FocusModels insertObject:self.toFocusUserModel atIndex:0];
                            [_collectionViewFocus reloadData];//因为每个cell颜色不一样，所以不能刷新单个cell，只能全部刷新
                            _arrayNumber[1].text = _arrayWorksFocusFansNumber[1];//关注数+1
                            
                            for (int i = 0; i < self.array_FansModels.count; i++) {
                                
                                if ([self.array_FansModels[i] isEqual:self.toFocusUserModel]) {//刷新单个Item
                                    
                                    self.array_FansModels[i].whetherFocusForCell = _whenClickFocusStateResult;
                                    
                                    [_collectionViewFans reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                            
                        }
                    }else {//取消关注成功
                        
                        if ([_userModel.userid isEqualToString:self.toFocusUserModel.userid]) {//对自己操作
                            
                            for (int i = 0; i < self.array_FocusModels.count; i++) {
                                
                                if ([self.array_FocusModels[i].userid isEqualToString:self.toFocusUserModel.userid]) {
                                    
                                    [self.array_FocusModels removeObject:self.array_FocusModels[i]];
                                    [_collectionViewFocus reloadData];
                                    _arrayNumber[1].text = _arrayWorksFocusFansNumber[1];//关注数-1
                                }
                            }
                            
                            for (int i = 0; i < self.array_FansModels.count; i++) {
                                
                                if ([self.array_FansModels[i].userid isEqualToString:self.toFocusUserModel.userid])  {//移除自己在粉丝中得对应位置的item
                                    
                                    [self.array_FansModels removeObject:self.array_FansModels[i]];
                                    [_collectionViewFans reloadData];//因为每个cell颜色不一样，所以不能刷新单个cell，只能全部刷新
                                    _arrayNumber[2].text = _arrayWorksFocusFansNumber[2];//粉丝数-1
                                }
                            }
                        }else {//对别人操作
                            
                            for (int i = 0; i < self.array_FocusModels.count; i++) {
                                
                                if ([self.array_FocusModels[i].userid isEqualToString:self.toFocusUserModel.userid]) {
                                    
                                    [self.array_FocusModels removeObject:self.array_FocusModels[i]];
                                    [_collectionViewFocus reloadData];
                                    _arrayNumber[1].text = _arrayWorksFocusFansNumber[1];//关注数-1
                                }
                            }
                            
                            for (int i = 0; i < self.array_FansModels.count; i++) {
                                
                                if ([self.array_FansModels[i].userid isEqualToString:self.toFocusUserModel.userid])  {//改变在粉丝位置中得状态
                                    self.array_FansModels[i].whetherFocusForCell = _whenClickFocusStateResult;
                                    [_collectionViewFans reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                        }
                }
                    
                    
                }else {//在别人个人中心进行操作（注意此时在别人的个人中心对自己做关注和取消操作）
                    
                    
                    if (_isWhetherFocusState) {//成功添加关注
                        
                        if ([self.toCurrentUserModel.userid isEqualToString:self.toFocusUserModel.userid]) {//对当前个人主页的用户做操作
                            
                            [self.array_FansModels insertObject:_userModel atIndex:0];
                            [_collectionViewFans reloadData];//因为每个cell颜色不一样，所以不能刷新单个cell，只能全部刷新
                            _arrayNumber[2].text = _arrayWorksFocusFansNumberSomebody[2];//粉丝数+1
                            
                            for (int i = 0; i < self.array_FocusModels.count; i++) {
                                
                                if ([self.array_FocusModels[i].userid isEqualToString:self.toFocusUserModel.userid]) {//刷新在关注列表的状态Item
                                    
                                    self.array_FocusModels[i].whetherFocusForCell = _whenClickFocusStateResult;
                                    [_collectionViewFocus reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                            
                            for (int i = 0; i < self.array_FansModels.count; i++) {
                                
                                if ([self.array_FansModels[i].userid isEqualToString:self.toFocusUserModel.userid]) {//刷新在关注列表的状态Item
                                    
                                    self.array_FansModels[i].whetherFocusForCell = _whenClickFocusStateResult;
                                    [_collectionViewFans reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                            
                        }else {//对不是当前个人中心用户进行操作
                            
                            for (int i = 0; i < self.array_FocusModels.count; i++) {
                                
                                if ([self.array_FocusModels[i].userid isEqualToString:self.toFocusUserModel.userid])  {//改变在关注位置中得状态
                                    self.array_FocusModels[i].whetherFocusForCell = _whenClickFocusStateResult;
                                    [_collectionViewFocus reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                            
                            for (int i = 0; i < self.array_FansModels.count; i++) {
                                
                                if ([self.array_FansModels[i].userid isEqualToString:self.toFocusUserModel.userid])  {//改变在粉丝位置中得状态
                                    self.array_FansModels[i].whetherFocusForCell = _whenClickFocusStateResult;
                                    [_collectionViewFans reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                            
                        }
                    }
                    else {//成功取消关注
                        
                        if ([self.toCurrentUserModel.userid isEqualToString:self.toFocusUserModel.userid])  {
                            
                            for (int i = 0; i < self.array_FansModels.count; i++) {
                                
                                if ([self.array_FansModels[i].userid isEqualToString:_userModel.userid])  {//移除自己在粉丝中得对应位置的item
                                    
                                    [self.array_FansModels removeObject:self.array_FansModels[i]];
                                    [_collectionViewFans reloadData];
                                    _arrayNumber[2].text = _arrayWorksFocusFansNumberSomebody[2];//粉丝数-1
                                    
                                }
                            }
                            
                            for (int i = 0; i < self.array_FocusModels.count; i++) {
                                
                                if ([self.array_FocusModels[i].userid isEqualToString:_toFocusUserModel.userid])  {//移除自己在粉丝中得对应位置的item
                                    self.array_FocusModels[i].whetherFocusForCell = WhetherFocusForCellNO;
                                    [_collectionViewFocus reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                        }else {//对不是当前个人中心用户进行操作
                            
                            for (int i = 0; i < self.array_FocusModels.count; i++) {
                                
                                if ([self.array_FocusModels[i].userid isEqualToString:_toFocusUserModel.userid])  {//移除自己在粉丝中得对应位置的item
                                    self.array_FocusModels[i].whetherFocusForCell = WhetherFocusForCellNO;
                                    [_collectionViewFocus reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                            
                            for (int i = 0; i < self.array_FansModels.count; i++) {
                                
                                if ([self.array_FansModels[i].userid isEqualToString:_toFocusUserModel.userid])  {//移除自己在粉丝中得对应位置的item
                                    self.array_FansModels[i].whetherFocusForCell = WhetherFocusForCellNO;
                                    [_collectionViewFans reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                                }
                            }
                        }
                    }
                }
                
                if (self.array_FansModels.count > 0) {//移除遮罩不占用内存
                    
                    [self.view_MaskFans removeFromSuperview];
                    self.view_MaskFans = nil;
                    
                }else {//展现遮罩
                    
                    [_scrollView_Container insertSubview:self.view_MaskFans belowSubview:_collectionViewFans];
                    
                }
                
                if (self.array_FocusModels.count > 0) {//移除遮罩不占用内存
                    
                    [self.view_MaskFocus removeFromSuperview];
                    self.view_MaskFocus = nil;
                    
                }else {//展现遮罩
                    
                    [_scrollView_Container insertSubview:self.view_MaskFocus belowSubview:_collectionViewFocus];
                    
                }
                
                if (completion) completion(YES);//可以继续点击
            }
                break;
            case 6:
            {
                if (_isBlackList == NO) {
                  
                    if ([responseObject[@"result"] integerValue] == 0) {
                        
                        _isBlackList = !_isBlackList;
                        [self.view showAndHideHUDWithTitle:@"已加入黑名单" WithState:BYC_MBProgressHUDHideProgress];
                    }else {
                        
                        [self.view showAndHideHUDWithTitle:@"加入黑名单失败" WithState:BYC_MBProgressHUDHideProgress];
                    }
                }else {
                
                    if ([responseObject[@"result"] integerValue] == 0) {
                        
                        _isBlackList = !_isBlackList;
                        [self.view showAndHideHUDWithTitle:@"已移出黑名单" WithState:BYC_MBProgressHUDHideProgress];
                    }else {
                        
                        [self.view showAndHideHUDWithTitle:@"移出黑名单失败" WithState:BYC_MBProgressHUDHideProgress];
                    }
                }
                
                
            }
                break;
                
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error.code == -1100) {
            
            [self.view showAndHideHUDWithDetailsTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress completion:nil];
        }else {
            
            [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        }
        switch (integer) {
            case BYC_MyCenterVCSelectedCollectionWorks:
            {
                
                if (self.collectionViewWorks.footer.isRefreshing) {
                    
                    [self.collectionViewWorks.footer endRefreshing];
                }
                
                if (self.array_WorksModels.count > 0) {//移除遮罩不占用内存
                    
                    [self.view_MaskWorks removeFromSuperview];
                    self.view_MaskWorks = nil;
                    
                }else {//展现遮罩
                    
                    [_scrollView_Container insertSubview:self.view_MaskWorks belowSubview:_collectionViewWorks];
                    
                }
            }
                
                break;
            case BYC_MyCenterVCSelectedCollectionFocus:
            {
                
                if (self.collectionViewFocus.footer.isRefreshing) {
                    
                    [self.collectionViewFocus.footer endRefreshing];
                }
                
                if (self.array_FocusModels.count > 0) {//移除遮罩不占用内存
                    
                    [self.view_MaskFocus removeFromSuperview];
                    self.view_MaskFocus = nil;
                    
                }else {//展现遮罩
                    
                    [_scrollView_Container insertSubview:self.view_MaskFocus belowSubview:_collectionViewFocus];
                    
                }
                
            }
                
                break;
            case BYC_MyCenterVCSelectedollectionFans:
            {
                
                if (self.collectionViewFocus.footer.isRefreshing) {
                    
                    [self.collectionViewFans.footer endRefreshing];
                }
                
                
                if (self.array_FansModels.count > 0) {//移除遮罩不占用内存
                    
                    [self.view_MaskFans removeFromSuperview];
                    self.view_MaskFans = nil;
                    
                }else {//展现遮罩
                    
                    [_scrollView_Container insertSubview:self.view_MaskFans belowSubview:_collectionViewFans];
                    
                }
            }
                break;
                
            default:
                break;
        }
        
        if (completion) completion(YES);//可以继续点击
        
    }];
}

#pragma mark - 懒加载

-(NSMutableArray<NSString *> *)arrayWorksFocusFansNumber {
    
    if (_arrayWorksFocusFansNumber == nil) {
        
        _arrayWorksFocusFansNumber = [[NSMutableArray alloc] init];
    }
    
    return _arrayWorksFocusFansNumber;
}

-(NSMutableArray<NSString *> *)arrayWorksFocusFansNumberSomebody {
    
    if (_arrayWorksFocusFansNumberSomebody == nil) {
        
        _arrayWorksFocusFansNumberSomebody = [[NSMutableArray alloc] init];
    }
    
    return _arrayWorksFocusFansNumberSomebody;
}

-(NSMutableArray<BYC_AccountModel *> *)array_FocusModels {
    
    if (_array_FocusModels == nil) {
        
        _array_FocusModels = [[NSMutableArray alloc] init];
    }
    
    return _array_FocusModels;
}

-(NSMutableArray<BYC_AccountModel *> *)array_FansModels {
    
    if (_array_FansModels == nil) {
        
        _array_FansModels = [[NSMutableArray alloc] init];
    }
    
    return _array_FansModels;
}

-(BYC_AccountModel *)toCurrentUserModel {
    
    if (_toCurrentUserModel == nil) {
        
        _toCurrentUserModel = [[BYC_AccountModel alloc] init];
    }
    
    return _toCurrentUserModel;
    
}

-(BYC_AccountModel *)toFocusUserModel {
    
    if (_toFocusUserModel == nil) {
        
        
        _toFocusUserModel = [[BYC_FocusAndFansModel alloc] init];
    }
    
    return _toFocusUserModel;
    
}



//创建遮罩

-(UIView *)view_MaskWorks {
    
    if (_view_MaskWorks == nil) {
        
        _view_MaskWorks = [self createMaskView:_collectionViewWorks];
    }
    
    return  _view_MaskWorks;
}

-(UIView *)view_MaskFocus {
    
    if (_view_MaskFocus == nil) {
        
        _view_MaskFocus = [self createMaskView:_collectionViewFocus];
    }
    
    return  _view_MaskFocus;
}

-(UIView *)view_MaskFans {
    
    if (_view_MaskFans == nil) {
        
        _view_MaskFans = [self createMaskView:_collectionViewFans];
        
    }
    
    return  _view_MaskFans;
}


- (UIView *)createMaskView:(UICollectionView *)collection{
    
    if ([_scrollView_Container viewWithTag:(collection.left / collection.kwidth) + 100]) {
        
        return [_scrollView_Container viewWithTag:(collection.left / collection.kwidth) + 100];
    }
    UIView *view_Mask = [[UIView alloc] initWithFrame:collection.frame];
    view_Mask.backgroundColor = [UIColor clearColor];
    int i = ((int)(collection.left / collection.kwidth));
    view_Mask.tag = i + 100;
    
    CGFloat labelW = view_Mask.kwidth - 100;
    CGFloat labelH = 150;
    CGFloat labelX = view_Mask.left - view_Mask.kwidth * i + (view_Mask.kwidth - labelW) / 2.0f;
    CGFloat labelY = (view_Mask.bottom - labelH) / 2.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = KUIColorFromRGB(0x9BA0AA);;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    label.text = _isSelfOpenCenter ? (collection == _collectionViewWorks ?  @"您还没有作品，快去创作吧！" : collection == _collectionViewFocus ?  @"您还没有关注任何人，看见喜欢的就别错过，赶紧关注！" : @"您还没有粉丝，好的作品，能吸引更多粉丝") : (collection == _collectionViewWorks ?  @"Ta没有作品呐(=@__@=)！" : collection == _collectionViewFocus ?  @"Ta没有关注任何人呐(=@__@=)" : @"Ta还没有粉丝(=@__@=)");
    [view_Mask addSubview:label];
    return view_Mask;
}

#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  collectionView == _collectionViewWorks ? self.array_WorksModels.count : collectionView == _collectionViewFocus ? self.array_FocusModels.count : self.array_FansModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (collectionView == _collectionViewWorks) {
        
        BYC_CenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionReuseIdentifiers[0] forIndexPath:indexPath];
        cell.model = self.array_WorksModels[indexPath.row];
        if (indexPath.row % 2) {
            
            cell.backgroundColor = KUIColorBackgroundModule1;
        }else {
            cell.backgroundColor = KUIColorBackgroundModule1;
            
        }
        return cell;
    }
    if (collectionView == _collectionViewFocus) {
        
        BYC_CenterFocusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionReuseIdentifiers[1] forIndexPath:indexPath];
        cell.model = self.array_FocusModels[indexPath.row];
        
        if (indexPath.row % 2) {
            
            cell.backgroundColor = KUIColorBackgroundModule1;
        }else {
            cell.backgroundColor = KUIColorBackgroundModule1;
            
        }
        
        __weak __typeof(self) weakSelf = self;
        cell.whetherFocusBlock = ^(BOOL whetherFocus,BYC_AccountModel *model , UIButton *button ,BOOL isLogin){//添加或取消关注
            button.enabled = NO;
            [weakSelf whetherSelectFocus:whetherFocus toUserID:model completion:^(BOOL success) {
                button.enabled = YES;
            }];
        };
        
        return cell;
    }
    if (collectionView == _collectionViewFans) {
        
        BYC_CenterFocusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionReuseIdentifiers[2] forIndexPath:indexPath];
        cell.model = self.array_FansModels[indexPath.row];
        if (indexPath.row % 2) {
            
            cell.backgroundColor = KUIColorBackgroundModule1;
        }else {
            cell.backgroundColor = KUIColorBackgroundModule1;
            
        }
        
        __weak __typeof(self) weakSelf = self;
        cell.whetherFocusBlock = ^(BOOL whetherFocus,BYC_AccountModel *model ,UIButton *button, BOOL isLogin){//添加或取消关注
            
            button.enabled = NO;
            [weakSelf whetherSelectFocus:whetherFocus toUserID:model completion:^(BOOL success) {
                button.enabled = YES;
            }];
        };
        return cell;
    }
    
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == _collectionViewWorks) {
        
        // 通知中心
        NSNotification *notification = [NSNotification notificationWithName:@"hiddenTheButton" object:nil userInfo:@{@"1":@"1"}];
        [QNWSNotificationCenter postNotification:notification];
        
        
        BYC_HomeViewControllerModel *model = self.array_WorksModels[indexPath.section*20+indexPath.row];
        [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isVR andisComment:NO andFromType:ENU_FromOtherVideo];
    }
    if (collectionView == _collectionViewFocus) {
        
        
        BYC_CenterFocusCollectionViewCell *item = (BYC_CenterFocusCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if ([item.model.userid isEqualToString:_toCurrentUserModel.userid]) {
            
            [self.view showAndHideHUDWithTitle:@"不能继续点击当前用户主页" WithState:BYC_MBProgressHUDHideProgress];
            return;
        }
        BYC_MyCenterViewController *myCenterVCFromFocus = [[BYC_MyCenterViewController alloc] init];
        myCenterVCFromFocus.userID = item.model.userid;
        [self.navigationController pushViewController:myCenterVCFromFocus animated:YES];
        
    }
    if (collectionView == _collectionViewFans) {
        
        BYC_CenterFocusCollectionViewCell *item = (BYC_CenterFocusCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if ([item.model.userid isEqualToString:_toCurrentUserModel.userid]) {
            
            [self.view showAndHideHUDWithTitle:@"不能继续点击当前用户主页" WithState:BYC_MBProgressHUDHideProgress];
            return;
        }
        BYC_MyCenterViewController *myCenterVCFromFans = [[BYC_MyCenterViewController alloc] init];
        myCenterVCFromFans.userID = item.model.userid;
        [self.navigationController pushViewController:myCenterVCFromFans animated:YES];
    }
}

- (IBAction)buttonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self selectBottomButtom:sender.tag];
    
    switch (sender.tag) {
        case 1://返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 2://关注
        {
            static BOOL isOK = YES;
            if (isOK) {
                
                isOK = NO;
                [self whetherSelectFocus:_isPersonalCenterWhetherFocusState toUserID:_toCurrentUserModel completion:^(BOOL success) {
                    
                    isOK = YES;
                }];
            }
        }

            break;
        case 3://作品数
            [_scrollView_Container setContentOffset:CGPointMake(_scrollView_Container.kwidth * (sender.tag - 3), 0) animated:NO];
            break;
        case 4://关注数
            [_scrollView_Container setContentOffset:CGPointMake(_scrollView_Container.kwidth * (sender.tag - 3), 0) animated:NO];
            break;
        case 5://粉丝数
            [_scrollView_Container setContentOffset:CGPointMake(_scrollView_Container.kwidth * (sender.tag - 3), 0) animated:NO];
            break;
        case 6://拉黑
            [self showSelectedBlacklist];
            
            break;
            
            
        default:
            break;
    }
}

- (void)showSelectedBlacklist {

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:_isBlackList == NO ? @"加入黑名单" : @"移除黑名单"
                                  otherButtonTitles:nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0://保存到本地
        {
            
            _isBlackList == NO ? [self showAlert] : [self addAndRemoveBlacklist];;
        }
            break;
            
        default:
            break;
    }
}

- (void)showAlert {

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定加入黑名单吗？"
                                                   message:@"该用户将无法再关注你、给你发评论，避免对你造成骚扰"
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:@"取消", nil];
    [alert show];

}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    QNWSLog(@"buttonIndex == %ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:
            [self addAndRemoveBlacklist];
            break;
            
        default:
            break;
    }
}

/**
 *  加入黑名单或者移除黑名单
 */
- (void)addAndRemoveBlacklist {

    [self requestDataWithUrl:KQNWS_UpdateBlackListUserUrl parameters:@{@"token":_userModel.token ? _userModel.token : @"" ,@"type":[NSNumber numberWithBool:!_isBlackList],@"userid":_userModel.userid ? _userModel.userid : @"" ,@"touserid":_userID} type:6 completion:nil];
}

//选择是否关注:userID 被关注或取消对象的UserID
- (void)whetherSelectFocus:(BOOL)whetherSelectFocus toUserID:(BYC_AccountModel *)model completion:(void(^)(BOOL success))completion {
    
    self.toFocusUserModel  = model;
    if (self.toFocusUserModel.userid == nil) return;
    _isWhetherFocusState = whetherSelectFocus;
    [self requestDataWithUrl:whetherSelectFocus ? KQNWS_RemoveFriendsUserUrl : KQNWS_SaveFriendsUserUrl parameters:@{@"token":_userModel.token ? _userModel.token : @"" ,@"user.userid":_userModel.userid ? _userModel.userid : @"",@"userid":_userModel.userid ? _userModel.userid : @"" , @"touserid":self.toFocusUserModel.userid}  type:5 completion:^(BOOL success) {
        
        if (completion) {
            
            completion(YES);
        }
    }];
    
}

#pragma mark - scrollView 和 Delegate方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (_scrollView_Container == scrollView) {
        
        NSInteger i = _scrollView_Container.contentOffset.x / _scrollView_Container.kwidth;
        
        [self selectBottomButtom:i + 3];
        
    }
}

#pragma mark - 选择
- (void)selectBottomButtom:(NSInteger)selectedIndex {
    
    switch (selectedIndex - 3) {
        case 0://作品
        {
            _myCenterVCSelectedCollection = BYC_MyCenterVCSelectedCollectionWorks;
        }
            break;
        case 1://关注
        {
            _myCenterVCSelectedCollection = BYC_MyCenterVCSelectedCollectionFocus;
            
            if (self.array_FocusModels.count == 0 ) {//没有数据就加载
                
                [self loadDataCollection:_myCenterVCSelectedCollection WithPage:_pageFocus];
            }
        }
            break;
        case 2://粉丝
        {
            _myCenterVCSelectedCollection = BYC_MyCenterVCSelectedollectionFans;
            
            if (self.array_FansModels.count == 0 ) {//没有数据就加载
                
                [self loadDataCollection:_myCenterVCSelectedCollection WithPage:_pageFans];
            }
        }
            break;
            
        default:
            break;
    }
    
    if (selectedIndex > 2 && selectedIndex < 6) {
        
        for (int i = 0; i < _arrayNumber.count; i++) {
            if (i + 3 == selectedIndex) {
                
                _arrayNumber[i].textColor = KUIColorBaseGreenNormal;
                _arrayZpGzFs[i].textColor = KUIColorBaseGreenNormal;
                _arrayBottomView[i].hidden = NO;
            }else {
                
                _arrayNumber[i].textColor = KUIColorFromRGB(0xFFFFFF);
                _arrayZpGzFs[i].textColor = KUIColorFromRGB(0x9BA0AA);
                _arrayBottomView[i].hidden = YES;
            }
        }
    }
    
}

- (IBAction)tapHeaderAction:(UITapGestureRecognizer *)sender {
    
    if ([_userModel.userid isEqualToString:_toCurrentUserModel.userid]) {

        BYC_PersonalDataViewController *personalDataVC = [[BYC_PersonalDataViewController alloc] init];
        [self.navigationController pushViewController:personalDataVC animated:YES];
    }else {
        
        BYC_ShowHeaderImageViewController *showHeaderImageVC = [[BYC_ShowHeaderImageViewController alloc] init];
        showHeaderImageVC.imageUrl = _toCurrentUserModel.headportrait;
        
        [self presentViewController:showHeaderImageVC animated:YES completion:nil];
    }
}
@end
