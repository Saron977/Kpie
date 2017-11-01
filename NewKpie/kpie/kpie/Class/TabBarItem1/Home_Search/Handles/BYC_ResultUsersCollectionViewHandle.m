//
//  BYC_ResultUsersCollectionViewHandle.h
//  kpie
//
//  Created by 元朝 on 16/5/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#define Identifier_Item @"CollectionViewCell"

#import "BYC_ResultUsersCollectionViewHandle.h"
#import "BYC_CenterFocusCollectionViewCell.h"
#import "BYC_MyCenterViewController.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_SearchAccountModel.h"
#import "BYC_LoginAndRigesterView.h"
#import "UICollectionView+BYC_PlaceHolder.h"

@interface BYC_ResultUsersCollectionViewHandle ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**当前登录用户的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel  *userModel;
/**需要被关注或者被取消*/
@property (nonatomic, strong)  BYC_AccountModel  *toFocusUserModel;
/**是否是关注状态*/
@property (nonatomic, assign)  BOOL  isWhetherFocusState;
/**记录点击的index*/
@property (nonatomic, strong)  NSIndexPath  *indexPath;
/**数据*/
@property (nonatomic, strong)  NSArray<BYC_AccountModel *> *array_Data;
/**第几页数据*/
@property (nonatomic, assign) int            page;
/**回调*/
@property (nonatomic, strong)  ResultUsersDataCountBlock  dataCountBlock;

@end

@implementation BYC_ResultUsersCollectionViewHandle

- (instancetype)initResultUsersCollectionViewHandle:(ResultUsersDataCountBlock)dataCountBlock {
    
    self = [self init];
    if (self) {
        
        _dataCountBlock = dataCountBlock;
        [self initParameters];
        [self setupCollectionView];
    }
    
    return self;
}

- (void)initParameters {

    self.array_Data = [NSArray array];
    _userModel = [BYC_AccountTool userAccount];
}


- (void)setupCollectionView {
    
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing      = 0.f;
    layout.itemSize = CGSizeMake(screenWidth , 50.f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, screenWidth,screenHeight - KHeightNavigationBar - 37/*搜索栏下面的用户动态切换栏的高度*/)  collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_CenterFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Identifier_Item];

    __weak __typeof(self) weakSelf = self;
    // 上拉更新
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        NSDictionary *dic_Parameters = @{@"page":[NSNumber numberWithInt:weakSelf.page++],@"rows":@"20",@"user.userid":weakSelf.userModel.userid ? weakSelf.userModel.userid : @"",@"condition": weakSelf.string_KeyWords};
        [weakSelf reloadDataWithDic:dic_Parameters];
        
    }];
}

//下拉加载更多数据
- (void)reloadDataWithDic:(NSDictionary *)parameters {

    [BYC_HttpServers Get:KQNWS_GetMatchUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *rows = responseObject[@"rows"];
        if (_dataCountBlock) _dataCountBlock([responseObject[@"total"] intValue]);
        if (rows.count == 0) {//无数据
            
            if ([_collectionView.footer isRefreshing]) [self.collectionView.footer endRefreshingWithNoMoreData];//刷新状态下无数据
        }else {//有数据
            
            NSArray *arr_models = [BYC_SearchAccountModel initWithArray:rows];
            if ([_collectionView.footer isRefreshing]) {//刷新状态下有数据
                
                NSMutableArray *marr = [NSMutableArray array];
                marr = [self.array_Data mutableCopy];
                [marr addObjectsFromArray:arr_models];
                self.array_Data = [marr copy];
                [self.collectionView.footer endRefreshing];
            }else self.array_Data = arr_models;
        }
        [_collectionView byc_reloadData:@"没有搜索到相关用户"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIView alloc] showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
         if ([_collectionView.footer isRefreshing])[self.collectionView.footer endRefreshing];
    }];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.array_Data.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BYC_CenterFocusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier_Item forIndexPath:indexPath];
    cell.model = self.array_Data[indexPath.row];
    
    cell.backgroundColor = KUIColorBackgroundModule1;
    __weak __typeof(self) weakSelf = self;
    cell.whetherFocusBlock = ^(BOOL whetherFocus,BYC_AccountModel *model , UIButton *button ){//添加或取消关注
        button.enabled = NO;
        
        //记录选择的下标
        weakSelf.indexPath = indexPath;
        [weakSelf whetherSelectFocus:whetherFocus toUserID:model completion:^(BOOL success) {
            button.enabled = YES;
        }];
    };
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //未登录跳转去登录
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        return;
    }
    
    self.indexPath = indexPath;
    BYC_CenterFocusCollectionViewCell *item = (BYC_CenterFocusCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    BYC_MyCenterViewController *myCenterVCFromFans = [[BYC_MyCenterViewController alloc] init];
    myCenterVCFromFans.userID = item.model.userid;
    self.toFocusUserModel  = item.model;
    __weak __typeof(self) weakSelf = self;
    myCenterVCFromFans.searchUserListFocusStateBlock = ^(int state){

        [weakSelf setupToFocusUserModelFocusState:state];
    };
    [_collectionView.getBGViewController.navigationController pushViewController:myCenterVCFromFans animated:YES];
    
}


#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - 网络请求
//选择是否关注:userID 被关注或取消对象的UserID
- (void)whetherSelectFocus:(BOOL)whetherSelectFocus toUserID:(BYC_AccountModel *)model completion:(void(^)(BOOL success))completion {
    
    self.toFocusUserModel  = model;
    _isWhetherFocusState = whetherSelectFocus;
    
    [BYC_HttpServers Get:_isWhetherFocusState ? KQNWS_RemoveFriendsUserUrl : KQNWS_SaveFriendsUserUrl parametersWithToken:@{@"user.userid":[BYC_AccountTool userAccount].userid,@"touserid":self.toFocusUserModel.userid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleResponseObject:(NSDictionary *)responseObject];
        
        if (completion) completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error.code == -1100)
            [[UIView alloc] showAndHideHUDWithDetailsTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress completion:nil];
        else
            [[UIView alloc] showAndHideHUDWithTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress];
        
        if (completion) completion(YES);
    }];
}

- (void)handleResponseObject:(NSDictionary *)responseObject {

    if ([_userModel.userid isEqualToString:_toFocusUserModel.userid])return;//~~~~!20160223 新需求，自己不能关注自己。
    
    NSDictionary *dic = responseObject;
    if ([dic[@"result"] intValue] == 6 || [dic[@"result"] intValue] == 4) {//6是被需要关注的人拉黑了。所以关注失败，4未知
        
        [[UIView alloc] showAndHideHUDWithTitle:@"抱歉，无法关注" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }

    if ([dic[@"result"] intValue] == 0) {
        
        [self setupToFocusUserModelFocusState:[dic[@"rows"][1] intValue]];
    
        [[UIView alloc] showAndHideHUDWithTitle:!_isWhetherFocusState ? @"取消关注成功":@"添加关注成功" WithState:BYC_MBProgressHUDHideProgress];
        
    } else {
        
        [[UIView alloc] showAndHideHUDWithTitle:_isWhetherFocusState ? @"抱歉，取消关注失败":@"抱歉，无法关注" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }
}

//设置此人与我的关注状态
- (void)setupToFocusUserModelFocusState:(int)state {

    switch (state) {
        case 0://已关注
            self.toFocusUserModel.whetherFocusForCell = WhetherFocusForCellYES;
            break;
        case 2://未关注
            self.toFocusUserModel.whetherFocusForCell = WhetherFocusForCellNO;
            break;
        case 3://互相关注
            self.toFocusUserModel.whetherFocusForCell = WhetherFocusForCellHXFocus;
            break;
            
        default:
            break;
    }
    _isWhetherFocusState = !_isWhetherFocusState;
    [_collectionView reloadItemsAtIndexPaths:@[_indexPath]];
}

-(void)setString_KeyWords:(NSString *)string_KeyWords {


    if (_string_KeyWords != string_KeyWords) {
        
        _array_Data = @[];
        [_collectionView reloadData];
    }
    
    int cou = 20;
    _page = 1;
    _string_KeyWords = string_KeyWords;
    _userModel = [BYC_AccountTool userAccount];
    NSString *str_count =  [NSString stringWithFormat:@"%d",_isLoginReloadData ? (int)self.array_Data.count : cou];
    NSDictionary *dic_Parameters = @{@"page":[NSNumber numberWithInt:_page++],@"rows": str_count,@"user.userid":self.userModel.userid ? self.userModel.userid : @"",@"condition": _string_KeyWords};
    [self reloadDataWithDic:dic_Parameters];
}

@end
