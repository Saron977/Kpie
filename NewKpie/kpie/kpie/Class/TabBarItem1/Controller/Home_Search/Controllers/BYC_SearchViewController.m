//
//  BYC_SearchViewController.m
//  kpie
//
//  Created by 元朝 on 16/5/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_SearchViewController.h"
#import "BYC_HistoryCollectionViewHandler.h"
#import "BYC_SearchListCollectionViewHandler.h"
#import "BYC_ResultCollectionViewHandler.h"
#import "BYC_SearchBar.h"
#import "BYC_MediaPlayer.h"
#import "BYC_BaseNavigationController.h"

@interface BYC_SearchViewController ()<BYC_SearchBarDelegate>

/**导航栏的搜索框*/
@property (nonatomic, strong)  BYC_SearchBar     *seachrBar;
/**容器视图*/
@property (nonatomic, strong)  UIView            *view_Content;
/**处理历史搜索的对象*/
@property (nonatomic, strong)  BYC_HistoryCollectionViewHandler     *handle_HistoryCollectionView;
/**处理搜索列表的对象*/
@property (nonatomic, strong)  BYC_SearchListCollectionViewHandler  *handle_SearchListCollectionView;
/**处理结果列表的对象*/
@property (nonatomic, strong)  BYC_ResultCollectionViewHandler      *handle_ResultCollectionView;

/**已经加载vc*/
@property (nonatomic, assign)  BOOL  isOpen;

@end

@implementation BYC_SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _initParams];
    [self initSubViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isOpen) {
        _isOpen = YES;
        [_seachrBar becomeFirstResponder];
    }
    [self.handle_ResultCollectionView.handle_ResultDynamicCollectionView.tableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];

    [self.handle_ResultCollectionView.handle_ResultDynamicCollectionView.playerView resetPlayer];
    
}
- (void)_initParams {
    
    //注册选中要搜索的结果的通知
    [QNWSNotificationCenter addObserver:self selector:@selector(receiveNotificationAction:) name:@"SearchListCollectionDidSelectItemNotification" object:nil];
    [QNWSNotificationCenter addObserver:self selector:@selector(receiveNotificationAction:) name:@"SearchKeyWordsNotification" object:nil];
}

- (void)initSubViews {

    UIView *view_NavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, KHeightNavigationBar)];
    view_NavBar.backgroundColor = KUIColorBaseGreenNormal;
    [self.view addSubview:view_NavBar];
    
    _seachrBar = ({
    
        BYC_SearchBar *seachrBar = [[BYC_SearchBar alloc] init];
        seachrBar.delegate_SearchBar = self;
        [view_NavBar addSubview: seachrBar];
        seachrBar;
    });
    
    _view_Content = ({
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight - KHeightNavigationBar)];
        [self.view addSubview:view];
        [view addSubview: self.handle_HistoryCollectionView.collectionView];
        view;
    });
}

#pragma mark - BYC_SearchBarDelegate
- (void)searchBar:(BYC_SearchBar *)searchBar showInterfaceType:(ENUM_ShowInterfaceType)showInterfaceType {

    [self removeViewContentSubViews];
    UIView *view;
    switch (showInterfaceType) {
        case ENUM_ShowInterfaceTypeIsHistory: {
            
            view = self.handle_HistoryCollectionView.collectionView;
            break;
        }
        case ENUM_ShowInterfaceTypeIsSearchList: {
            
            view = self.handle_SearchListCollectionView.collectionView;
            break;
        }
        case ENUM_ShowInterfaceTypeIsResultList: {
            
            view = self.handle_ResultCollectionView.view_Container;
            break;
        }
    }
    [_view_Content addSubview:view];
}

- (void)removeViewContentSubViews {

    for (UIView *suView in _view_Content.subviews) [suView removeFromSuperview];
}

#pragma mark - get方法
-(BYC_HistoryCollectionViewHandler *)handle_HistoryCollectionView {

    if (_handle_HistoryCollectionView == nil) _handle_HistoryCollectionView = [[BYC_HistoryCollectionViewHandler alloc] initHistoryCollectionViewHandle];
    return _handle_HistoryCollectionView;
}

-(BYC_SearchListCollectionViewHandler *)handle_SearchListCollectionView {

    if (_handle_SearchListCollectionView == nil) _handle_SearchListCollectionView = [[BYC_SearchListCollectionViewHandler alloc] initSearchListCollectionViewHandle];
    return _handle_SearchListCollectionView;
}
-(BYC_ResultCollectionViewHandler *)handle_ResultCollectionView {
    
    if (_handle_ResultCollectionView == nil) _handle_ResultCollectionView = [[BYC_ResultCollectionViewHandler alloc] initResultCollectionViewHandle];
    return _handle_ResultCollectionView;
}

- (void)receiveNotificationAction:(NSNotification *)notification {
    
    self.handle_ResultCollectionView.string_KeyWords = notification.userInfo[@"text"];
}

-(void)dealloc {
    
    [_seachrBar removeFromSuperview];
    _seachrBar = nil;
}

@end
