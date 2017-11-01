//
//  HL_MyFansVC.m
//  kpie
//
//  Created by sunheli on 16/7/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_MyFansVC.h"
#import "BYC_CenterFocusCollectionViewCell.h"
#import "BYC_FocusAndFansModel.h"
#import "BYC_AccountTool.h"
#import "HL_CenterViewController.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_HttpServers+HL_PersonalVC.h"
#import "BYC_HttpServers+HL_SaveOrRemoveFriend.h"
#import "BYC_MyCenterFocusRequestDataHandler.h"
#import "BYC_MyCenterHandler.h"

@interface HL_MyFansVC () <UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    
    /**当前登录用户的个人信息*/
    BYC_AccountModel *_userModel;
    /**当我们点击某个用户进行关注或者取消操作之后的状态结果*/
    WhetherFocusForCell _whenClickFocusStateResult;
        
    BYC_MyCenterHandler *_handle;

}

@property (nonatomic, strong)  BYC_MyCenterHandler *handle;

@property (nonatomic, strong)  UICollectionView *fans_CollectionView;

/**粉丝集合*/
@property (nonatomic, strong) NSMutableArray       *array_FansModels;
/**需要被关注或取消关注的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel     *toFocusUserModel;
/**记录点击的index*/
@property (nonatomic, strong)  NSIndexPath  *indexPath;

@property (nonatomic, strong) NSMutableDictionary *dic_CellIdentifier;

@end

@implementation HL_MyFansVC

-(BYC_MyCenterHandler *)handle {
    
    if (!_handle) _handle = [BYC_MyCenterHandler new];
    return _handle;
}

-(NSMutableDictionary *)dic_CellIdentifier{
    if (!_dic_CellIdentifier) {
        _dic_CellIdentifier = [NSMutableDictionary dictionary];
    }
    return _dic_CellIdentifier;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝";
    
    self.view.backgroundColor = KUIColorBackground;
    _userModel = [BYC_AccountTool userAccount];
    //初始化Cell
    [self initCollectionView];
    //加载数据
    [self loadData];
//    [QNWSNotificationCenter addObserver:self selector:@selector(loadData) name:@"SaveOrRemove" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - 布局视图
- (void)initCollectionView {
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing      = 0.f;
    layout.itemSize = CGSizeMake(screenWidth , 50.f);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.fans_CollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight) collectionViewLayout:layout];
    self.fans_CollectionView.delegate                     = self;
    self.fans_CollectionView.dataSource                   = self;
    self.fans_CollectionView.emptyDataSetSource           = self;
    self.fans_CollectionView.emptyDataSetDelegate         = self;
    self.fans_CollectionView.showsVerticalScrollIndicator = YES;
    self.fans_CollectionView.backgroundColor = [UIColor clearColor];
    [self.fans_CollectionView registerNib:[UINib nibWithNibName:@"BYC_CenterFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"centerFocusCollectionViewCell"];
    
    [self.view addSubview:self.fans_CollectionView];
    
    __weak __typeof(self) weakSelf = self;
    
    // 上拉更新
    self.fans_CollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
}

-(void)setHandle:(BYC_MyCenterHandler *)handle{
    _handle = handle;
}

#pragma mark - 网络请求
- (void)loadData{
    //获取个人信息
    //loadType:   0--默认加载  1--作品  2--关注  3--粉丝
    //toUserId:   他人主页-----他人的UserId    个人主页 ----self.userInfoModel.userid
    //upType:     0--默认   1--下拉  2--上拉
    //userid     登陆用户Id   self.userInfoModel.userid
    //time：   关注时间
    NSDictionary *dic_params;
    if (self.fans_CollectionView.footer.isRefreshing) {
        BYC_AccountModel *fansModel = [self.array_FansModels lastObject];
        dic_params = @{@"loadType":@3,@"toUserId":[BYC_AccountTool userAccount].userid,@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"time":fansModel.attentiontime};
    }else{
        dic_params = @{@"loadType":@3,@"toUserId":[BYC_AccountTool userAccount].userid,@"upType":@0,@"userId":[BYC_AccountTool userAccount].userid};
    }
    //网络请求
    [BYC_HttpServers requestPersonalVCDataWithParameters:dic_params success:^(BYC_MyCenterHandler *handler) {
        self.handle = handler;
        if (self.fans_CollectionView.footer.isRefreshing) {
            // 结束刷新
            if (handler.handler_Fans.mArr_Models.count > 0) {
                NSMutableArray *arr_focusData = [NSMutableArray array];
                arr_focusData = [handler.handler_Fans.mArr_Models mutableCopy];
                [arr_focusData removeObjectAtIndex:0];
                if (arr_focusData.count > 0) {
                    for (int i = 0; i<arr_focusData.count; i++) {
                        
                        for (BYC_AccountModel *focusUserModel2 in self.array_FansModels) {
                            if ([((BYC_AccountModel *)arr_focusData[i]).userid isEqualToString:focusUserModel2.userid]){
                                [arr_focusData removeObjectAtIndex:i];
                            }
                        }
                    }
                    [self.fans_CollectionView.footer endRefreshing];
                }
                else{
                  [self.fans_CollectionView.footer endRefreshingWithNoMoreData];  
                }
                [self.array_FansModels addObjectsFromArray:arr_focusData];
            }
            else {
            self.array_FansModels = self.array_FansModels;
            [self.fans_CollectionView.footer endRefreshingWithNoMoreData];
            }
            
        }else {
            self.array_FansModels = [handler.handler_Fans.mArr_Models mutableCopy];
            [self.fans_CollectionView.footer endRefreshing];
        }
        [self.fans_CollectionView reloadData];
    } failure:^(NSError *error) {
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        if (self.fans_CollectionView.footer.isRefreshing) {
            [self.fans_CollectionView.footer endRefreshing];
        }
    }];
}
- (void)setupFocusState:(WhetherFocusForCell)status {
    
    self.toFocusUserModel.whetherFocusForCell = status;
    self.toFocusUserModel.attentionstate      = status;
    [self.fans_CollectionView reloadItemsAtIndexPaths:@[_indexPath]];
    
}


#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  self.array_FansModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *identifier = [self.dic_CellIdentifier objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"centerFocusCollectionViewCell", [NSString stringWithFormat:@"%@", indexPath]];
        [self.dic_CellIdentifier setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.fans_CollectionView registerNib:[UINib nibWithNibName:@"BYC_CenterFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    BYC_CenterFocusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    BYC_AccountModel *userInfoModel = self.array_FansModels[indexPath.row];
    cell.model = userInfoModel;
    cell.backgroundColor = KUIColorBackgroundModule1;
    __weak __typeof(self) weakSelf = self;
    cell.whetherFocusBlock = ^(BOOL whetherFocus,BYC_AccountModel *model ,UIButton *button,BOOL isLogin){//添加或取消关注
        
        button.enabled = NO;
        weakSelf.indexPath = indexPath;
        [BYC_MyCenterFocusRequestDataHandler whetherSelectFocusWithToUserID:model handler:weakSelf.handle completion:^(BOOL success, WhetherFocusForCell status) {
            button.enabled = YES;
            model.whetherFocusForCell = status;
        }];
    };
    return cell;
}
-(void)reloadDataWithSection:(NSIndexPath *)indexPath{
    
    [self.fans_CollectionView reloadItemsAtIndexPaths:@[indexPath]];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BYC_CenterFocusCollectionViewCell *item = (BYC_CenterFocusCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    HL_CenterViewController *myCenterVCFromFocus = [[HL_CenterViewController alloc] init];
    myCenterVCFromFocus.str_ToUserID = item.model.userid;
    self.indexPath = indexPath;
    __weak __typeof(self) weakSelf = self;
    myCenterVCFromFocus.searchUserListFocusStateBlock = ^(WhetherFocusForCell status){
        
        [weakSelf setupFocusState:status];
    };
    [self.navigationController pushViewController:myCenterVCFromFocus animated:YES];
}

-(NSMutableArray *)array_FansModels {
    
    if (_array_FansModels == nil) {
        
        _array_FansModels = [NSMutableArray array];
    }
    
    return _array_FansModels;
}

-(BYC_AccountModel *)toFocusUserModel {
    
    if (_toFocusUserModel == nil) {
        
        
        _toFocusUserModel = [[BYC_FocusAndFansModel alloc] init];
    }
    
    return _toFocusUserModel;
    
}

#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"img_kbzt_mygzdr"];
    return image;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
