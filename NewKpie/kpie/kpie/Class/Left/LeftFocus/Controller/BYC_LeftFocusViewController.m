//
//  BYC_LeftFocusViewController.m
//  kpie
//
//  Created by 元朝 on 15/12/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LeftFocusViewController.h"
#import "BYC_CenterFocusCollectionViewCell.h"
#import "BYC_AccountTool.h"
#import "HL_CenterViewController.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_ControllerCustomView.h"
#import "BYC_HttpServers+HL_PersonalVC.h"
#import "BYC_HttpServers+HL_SaveOrRemoveFriend.h"
#import "BYC_MyCenterFocusRequestDataHandler.h"
#import "BYC_MyCenterHandler.h"

#define YC_NotPromptTextLeftFocus  @"您还没有关注任何人，看见喜欢的就别错过，赶紧关注！"
@interface BYC_LeftFocusViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource> {

    /**当前登录用户的个人信息*/
    BYC_AccountModel *_userModel;
    BYC_MyCenterHandler *_handle;
}

@property (nonatomic, strong) BYC_MyCenterHandler  *handle;
@property (nonatomic, strong)  UICollectionView    *focus_CollectionView;
/**关注第几页数据*/
@property (nonatomic, assign) int              pageFocus;
/**关注集合*/
@property (nonatomic, strong) NSMutableArray<BYC_AccountModel *>       *array_FocusModels;
/**需要被关注或取消关注的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel           *toFocusUserModel;

/**记录点击的index*/
@property (nonatomic, strong)  NSIndexPath  *indexPath;

@property (nonatomic, strong) NSMutableDictionary *dic_CellIdentifier;

@end

@implementation BYC_LeftFocusViewController
-(instancetype)init{
    if (self = [super init]) {
        [self initCollectionView];
    }
    return self;
}

-(NSMutableDictionary *)dic_CellIdentifier{
    if (!_dic_CellIdentifier) {
        _dic_CellIdentifier = [NSMutableDictionary dictionary];
    }
    return _dic_CellIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关注列表";
    
    self.view.backgroundColor = KUIColorBackground;
    _userModel = [BYC_AccountTool userAccount];
    //加载数据
    [self loadData];
//    [QNWSNotificationCenter addObserver:self selector:@selector(loadData) name:@"SaveOrRemove" object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.focus_CollectionView reloadData];
}

-(BYC_MyCenterHandler *)handle {
    
    if (!_handle) _handle = [BYC_MyCenterHandler new];
    return _handle;
}
#pragma mark - 布局视图
- (void)initCollectionView {
    
        //设置布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = .5f;
        layout.minimumLineSpacing      = 0.f;
        layout.itemSize = CGSizeMake(screenWidth , 50.f);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _focus_CollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,screenWidth, screenHeight-64) collectionViewLayout:layout];
        _focus_CollectionView.delegate                     = self;
        _focus_CollectionView.dataSource                   = self;
        _focus_CollectionView.emptyDataSetDelegate = self;
        _focus_CollectionView.emptyDataSetSource = self;
        _focus_CollectionView.showsVerticalScrollIndicator = YES;
        _focus_CollectionView.backgroundColor = [UIColor clearColor];
//        [_focus_CollectionView registerNib:[UINib nibWithNibName:@"BYC_CenterFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"centerFocusCollectionViewCell"];
    
        [self.view addSubview:_focus_CollectionView];
        
        __weak __typeof(self) weakSelf = self;

        // 上拉更新
        _focus_CollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
}
-(void)setHandle:(BYC_MyCenterHandler *)handle{
    _handle = handle;
}

- (void)loadData{
    //获取个人信息
    //loadType:   0--默认加载  1--作品  2--关注  3--粉丝
    //toUserId:   他人主页-----他人的UserId    个人主页 ----self.userInfoModel.userid
    //upType:     0--默认   1--下拉  2--上拉
    //userid     登陆用户Id   self.userInfoModel.userid
    //time：   关注时间
    NSDictionary *dic_params;
    if (self.focus_CollectionView.footer.isRefreshing) {
      BYC_AccountModel *focusModel = [self.array_FocusModels lastObject];
        dic_params = @{@"loadType":@2,@"toUserId":[BYC_AccountTool userAccount].userid,@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"time":focusModel.attentiontime};
    }
    else{
        dic_params = @{@"loadType":@2,@"toUserId":[BYC_AccountTool userAccount].userid,@"upType":@0,@"userId":[BYC_AccountTool userAccount].userid};
    }
    //网络请求
    QNWSWeakSelf(self);
    [BYC_HttpServers requestPersonalVCDataWithParameters:dic_params success:^(BYC_MyCenterHandler *handler) {
        self.handle = handler;
        if (self.focus_CollectionView.footer.isRefreshing) {
        
            if (handler.handler_Focus.mArr_Models.count >0) {
                
                NSMutableArray *arr_focusData = [NSMutableArray array];
                arr_focusData = [handler.handler_Focus.mArr_Models mutableCopy];
                [arr_focusData removeObjectAtIndex:0];
                if (arr_focusData.count > 0) {
                    for (int i = 0; i<arr_focusData.count; i++) {
                        
                        for (BYC_AccountModel *focusUserModel2 in weakself.array_FocusModels) {
                            if ([((BYC_AccountModel *)arr_focusData[i]).userid isEqualToString:focusUserModel2.userid]){
                                [arr_focusData removeObjectAtIndex:i];
                            }
                        }
                    }
                    [weakself.focus_CollectionView.footer endRefreshing];
                }
                else{
                  [weakself.focus_CollectionView.footer endRefreshingWithNoMoreData];
                }
                [weakself.array_FocusModels addObjectsFromArray:arr_focusData];
            }
            
            else [weakself.focus_CollectionView.footer endRefreshingWithNoMoreData];
            
        }else {
            [weakself.array_FocusModels removeAllObjects];
            [weakself.focus_CollectionView.footer endRefreshing];
            weakself.array_FocusModels = [handler.handler_Focus.mArr_Models mutableCopy];
        }
        [_focus_CollectionView reloadData];
    } failure:^(NSError *error) {
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        if (self.focus_CollectionView.footer.isRefreshing) {
            [self.focus_CollectionView.footer endRefreshing];
        }
    }];
}

#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  self.array_FocusModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.dic_CellIdentifier objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"centerFocusCollectionViewCell", [NSString stringWithFormat:@"%@", indexPath]];
        [self.dic_CellIdentifier setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.focus_CollectionView registerNib:[UINib nibWithNibName:@"BYC_CenterFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }
        BYC_CenterFocusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
        cell.model = self.array_FocusModels[indexPath.row];
        cell.backgroundColor = KUIColorBackgroundModule1;

        __weak __typeof(self) weakSelf = self;
        cell.whetherFocusBlock = ^(BOOL whetherFocus,BYC_AccountModel *model , UIButton *button ,BOOL isLogin){//添加或取消关注
            button.enabled = NO;
            [BYC_MyCenterFocusRequestDataHandler whetherSelectFocusWithToUserID:model handler:weakSelf.handle completion:^(BOOL success, WhetherFocusForCell status) {
                button.enabled = YES;
                model.whetherFocusForCell = status;
            }];

        };
        return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BYC_CenterFocusCollectionViewCell *item = (BYC_CenterFocusCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    HL_CenterViewController *myCenterVCFromFocus = [[HL_CenterViewController alloc] init];
    myCenterVCFromFocus.str_ToUserID = item.model.userid;
    self.toFocusUserModel  = item.model;
    self.indexPath = indexPath;
    __weak __typeof(self) weakSelf = self;
    myCenterVCFromFocus.searchUserListFocusStateBlock = ^(WhetherFocusForCell status){
    
        [weakSelf setupFocusState:status];
    };

    [self.navigationController pushViewController:myCenterVCFromFocus animated:YES];
}
- (void)setupFocusState:(WhetherFocusForCell)status {
    
//    self.toFocusUserModel.whetherFocusForCell = status;
    
}

-(NSMutableArray *)array_FocusModels {
    
    if (_array_FocusModels == nil) {
        
        _array_FocusModels = [[NSMutableArray alloc] init];
    }
    
    return _array_FocusModels;
}

-(BYC_AccountModel *)toFocusUserModel {
    
    if (_toFocusUserModel == nil) {
        
        
        _toFocusUserModel = [[BYC_AccountModel alloc] init];
    }
    
    return _toFocusUserModel;
    
}

#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"img_kbzt_mygzdr"];
    return image;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return -50;
}


@end
