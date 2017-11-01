//
//  HL_CenterViewController.m
//  kpie
//
//  Created by sunheli on 16/9/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_CenterViewController.h"
#import "BYC_HttpServers.h"
#import "BYC_HttpServers+BYC_MyCenterVC.h"
#import "TYSlidePageScrollView.h"
#import "TYTitlePageTabBar.h"
#import "HL_CollectionViewVC.h"
#import "HL_MyCenterheaderView.h"
#import "BYC_MyCenterNavigationBar.h"
#import "BYC_HttpServers+HL_SaveOrRemoveFriend.h"

@interface HL_CenterViewController ()<TYSlidePageScrollViewDataSource,TYSlidePageScrollViewDelegate,ShowSelectedBlackListDelegate,UIActionSheetDelegate,UIAlertViewDelegate> {
    
    BYC_MyCenterHandler *_handle;
}

/**头视图*/
@property (nonatomic, strong)  HL_MyCenterheaderView  *view_Header;
/**个人中心处理*/
@property (nonatomic, strong)  BYC_MyCenterHandler *handle;

@property (nonatomic, weak) TYSlidePageScrollView *slidePageScrollView;

@property (nonatomic, strong) TYTitlePageTabBar *titlePageTabBar;

@property (nonatomic,assign) TYPageTabBarState tabBarState;

@property (nonatomic, strong) BYC_MyCenterNavigationBar *View_NavBar;

@property (nonatomic, assign) NSInteger selectedPage;

/**相对于我：YES:代表已加入黑名单 NO:未加入黑名单*/
@property (nonatomic, assign)  BOOL  isBlackList;

@property (nonatomic, strong) BYC_AccountModel *toUserModel;
@end

@implementation HL_CenterViewController

-(void)dealloc{
    [QNWSNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSlidePageScrollView];
    [self addTabPageMenu];
    [self addCollectionViewWithPage:0];
    [self addCollectionViewWithPage:1];
    [self addCollectionViewWithPage:2];

    [self.slidePageScrollView reloadData];
    [self requestData];
    [QNWSNotificationCenter addObserver:self selector:@selector(requestData) name:@"SaveOrRemove" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.view_Header) {
        QNWSWeakSelf(self);
        self.view_Header.sendWorksAndFocusAndFansCountBlock = ^(NSArray *titleArray){
            weakself.titlePageTabBar.titleArray = titleArray;
        };
    }
    [self.titlePageTabBar setSelectedPage:self.selectedPage];
}

- (void)addSlidePageScrollView
{
    TYSlidePageScrollView *slidePageScrollView = [[TYSlidePageScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    slidePageScrollView.pageTabBarIsStopOnTop = YES;
    slidePageScrollView.pageTabBarStopOnTopHeight = KHeightNavigationBar;
    slidePageScrollView.parallaxHeaderEffect = YES;
    slidePageScrollView.dataSource = self;
    slidePageScrollView.delegate = self;
    slidePageScrollView.headerView = self.view_Header;
    [slidePageScrollView addSubview:self.View_NavBar];
    [self.view addSubview:slidePageScrollView];
    self.slidePageScrollView = slidePageScrollView;
}

- (void)addTabPageMenu
{
    self.titlePageTabBar = [[TYTitlePageTabBar alloc]initWithTitleArray:@[@"0\n作品",@"0\n关注",@"0\n粉丝"]];
    self.titlePageTabBar.frame = CGRectMake(0, 0, CGRectGetWidth(_slidePageScrollView.frame), 44);
    self.titlePageTabBar.backgroundColor = KUIColorFromRGB(0xECECEC);
    _slidePageScrollView.pageTabBar = self.titlePageTabBar;
}

- (void)addCollectionViewWithPage:(NSInteger)page
{
    HL_CollectionViewVC *collectionViewVC = [[HL_CollectionViewVC alloc]init];
    switch (page) {
        case 0:
            collectionViewVC.arr_CellData = @[@0,@"BYC_CenterCollectionViewCell",@70];
            break;
        case 1:
            collectionViewVC.arr_CellData = @[@1,@"BYC_CenterFocusCollectionViewCell",@50];
            break;
        case 2:
            collectionViewVC.arr_CellData = @[@2,@"BYC_CenterFocusCollectionViewCell",@50];
            break;
        default:
            break;
    }
    [self addChildViewController:collectionViewVC];
}

-(BYC_MyCenterHandler *)handle {
    
    if (!_handle) _handle = [BYC_MyCenterHandler new];
    return _handle;
}

-(void)setHandle:(BYC_MyCenterHandler *)handle {
    
    _handle = handle;
    [self loadData];
}
-(BYC_MyCenterNavigationBar *)View_NavBar{
    
    if (!_View_NavBar) {
        _View_NavBar = [[BYC_MyCenterNavigationBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, KHeightNavigationBar)];
        _View_NavBar.blackDelegate = self;
    }
    return _View_NavBar;
}


- (void)loadData {
    
    for (HL_CollectionViewVC *vc in self.childViewControllers) vc.handle = _handle;
    _view_Header.handle = _handle;
    _View_NavBar.handle = _handle;
}

- (void)requestData {

    //    @{@"userid":self.handle.model_User.userid,@"touserid":_str_ToUserID.length == 0 ? self.handle.model_User.userid : _str_ToUserID}
    //获取个人信息
    //loadType:   0--默认加载  1--作品  2--关注  3--粉丝
    //toUserId:   他人主页-----他人的UserId    个人主页 ----self.userInfoModel.userid
    //upType:     0--默认   1--下拉  2--上拉
    //userid     登陆用户Id   self.userInfoModel.userid
    
    [BYC_HttpServers requestMyCenterDataWithParameters:@{@"loadType":@0,@"toUserId":_str_ToUserID.length == 0 ? self.handle.model_User.userid : _str_ToUserID,@"upType":@0,@"userId":self.handle.model_User.userid} success:^(AFHTTPRequestOperation *operation, BYC_MyCenterHandler *handle) {
        self.handle = handle;
    } failure:nil];
    
}
- (HL_MyCenterheaderView *)view_Header
{
    if (!_view_Header) {
        _view_Header = [[HL_MyCenterheaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
    }
    return _view_Header;
}

#pragma mark - dataSource

- (NSInteger)numberOfPageViewOnSlidePageScrollView
{
    return self.childViewControllers.count;
}

- (UIScrollView *)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index
{
    HL_CollectionViewVC *collectionViewVC = self.childViewControllers[index];
    return collectionViewVC.collectionView;
}


- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView verticalScrollViewDidScroll:(UIScrollView *)pageScrollView
{
    UIColor * color = KUIColorBaseGreenNormal;
    CGFloat headerContentViewHeight = -(CGRectGetHeight(slidePageScrollView.headerView.frame)+CGRectGetHeight(slidePageScrollView.pageTabBar.frame));
    // 获取当前偏移量
    CGFloat offsetY = pageScrollView.contentOffset.y;
    
    // 获取偏移量差值
    CGFloat delta = offsetY - headerContentViewHeight;
    
    CGFloat alpha = delta / (CGRectGetHeight(slidePageScrollView.headerView.frame) - KHeightNavigationBar);
    self.View_NavBar.backgroundColor = [color colorWithAlphaComponent:alpha];    
}

- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView horizenScrollToPageIndex:(NSInteger)index
{
    self.selectedPage = index;
}

-(void)ShowSelectedBlackListDelegate:(BYC_MyCenterUserModel *)model{
    _isBlackList = model.isblack;
    self.toUserModel = model;
    [self showSelectedBlacklist];
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
    NSArray *arr_params;
    // userid/touserid/type 0--移除  1--拉黑
    if (_isBlackList) {
        arr_params = @[[BYC_AccountTool userAccount].userid,self.toUserModel.userid,@"0"];
    }
    else{
        arr_params = @[[BYC_AccountTool userAccount].userid,self.toUserModel.userid,@"1"];
    }
    [BYC_HttpServers requestBlackWithParameters:arr_params success:^(BOOL isBlackSuccess) {
        if (isBlackSuccess) {
            _isBlackList = !_isBlackList;
            [self requestData];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
