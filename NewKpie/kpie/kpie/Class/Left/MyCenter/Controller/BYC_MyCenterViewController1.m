//
//  BYC_MyCenterViewController1.m
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MyCenterViewController1.h"
#import "BYC_MyCenterCollectionController.h"
#import "BYC_MyCenterHeaderView.h"
#import "BYC_MyCenterNavigationBar.h"
#import "BYC_HttpServers.h"
#import "BYC_HttpServers+BYC_MyCenterVC.h"

@interface BYC_MyCenterViewController1 () {

    BYC_MyCenterHandler *_handle;
}

/**头视图*/
@property (nonatomic, strong)  BYC_MyCenterHeaderView  *view_Header;
/**个人中心处理*/
@property (nonatomic, strong)  BYC_MyCenterHandler *handle;
@end

@implementation BYC_MyCenterViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setChildVcs];
}

-(void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    
    if (!_view_Header) {
    
        [self initSubViews];
        [self requestData];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (_view_Header) [self requestData];
}

- (void)initSubViews {

    [self setupHeaderView];
    [self setupNavgationBar];
}

-(BYC_MyCenterHandler *)handle {

    if (!_handle) _handle = [BYC_MyCenterHandler new];
    return _handle;
}

-(void)setHandle:(BYC_MyCenterHandler *)handle {
    
    _handle = handle;
    [self loadData];
}


- (void)loadData {

    for (BYC_MyCenterCollectionController *vc in self.childViewControllers) vc.handle = _handle;
    _view_Header.handle = _handle;
}

- (void)requestData {

    [BYC_HttpServers requestMyCenterDataWithParameters:@{@"userid":self.handle.model_User.userid,@"touserid":_str_ToUserID.length == 0 ? self.handle.model_User.userid : _str_ToUserID} success:^(AFHTTPRequestOperation *operation, BYC_MyCenterHandler *handle) {
        self.handle = handle;
    } failure:nil];
}

- (void)setupNavgationBar {

    BYC_MyCenterNavigationBar *navgationBar = (BYC_MyCenterNavigationBar *)[BYC_MyCenterNavigationBar myCenterNavigationBar];
    [self.view addSubview:navgationBar];
}

- (void)setupHeaderView {

    _view_Header = [[NSBundle mainBundle] loadNibNamed:@"BYC_MyCenterHeaderView" owner:nil options:nil][0];
    [self.view_Container addSubview:_view_Header];
    [_view_Header mas_makeConstraints:^(MASConstraintMaker *make) {(void)make.top.left.bottom.right;}];
}

- (void)setChildVcs{
    
    BYC_MyCenterCollectionController *vc1 = [BYC_MyCenterCollectionController new];
    vc1.collectionView.backgroundColor = [UIColor orangeColor];
    vc1.arr_CellData = @[@0,@"BYC_CenterCollectionViewCell",@70];
    [self addChildViewController:vc1];
    
    BYC_MyCenterCollectionController *vc2 = [BYC_MyCenterCollectionController new];
    vc2.collectionView.backgroundColor = [UIColor yellowColor];
    vc2.arr_CellData = @[@1,@"BYC_CenterFocusCollectionViewCell",@50];
    [self addChildViewController:vc2];
    
    BYC_MyCenterCollectionController *vc3 = [BYC_MyCenterCollectionController new];
    vc3.collectionView.backgroundColor = [UIColor blueColor];
    vc3.arr_CellData = @[@2,@"BYC_CenterFocusCollectionViewCell",@50];
    [self addChildViewController:vc3];
}

@end
