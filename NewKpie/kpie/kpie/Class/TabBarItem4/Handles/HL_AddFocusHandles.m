//
//  HL_AddFocusHandles.m
//  kpie
//
//  Created by sunheli on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_AddFocusHandles.h"
#import "BYC_CenterFocusCollectionViewCell.h"
#import "HL_CenterViewController.h"
#import "BYC_AccountModel.h"
#import "BYC_LoginAndRigesterView.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_FocusListModel.h"
#import "HL_AddFocusModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BYC_ControllerCustomView.h"
#import "BYC_HttpServers+HL_SaveOrRemoveFriend.h"
#import "BYC_HttpServers+FocusVC.h"
#import "BYC_HttpServers+BYC_Search.h"
#import "BYC_MyCenterFocusRequestDataHandler.h"

#import "BYC_MyCenterHandler.h"


#define Identifier_Item @"CollectionViewCell"

@interface HL_AddFocusHandles ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIScrollViewDelegate>{
        
        BYC_MyCenterHandler *_handle;
}

@property (nonatomic, strong)  BYC_MyCenterHandler *handle;

/**需要被关注或者被取消*/
@property (nonatomic, strong)  BYC_AccountModel  *toFocusUserModel;

@property (nonatomic, strong) BYC_AccountModel *recommendUserModel;
/**是否是关注状态*/
@property (nonatomic, assign)  BOOL  isWhetherFocusState;

@property (nonatomic, strong) UIButton      *button_ChangeData;//换一批按钮

/**数据*/
@property (nonatomic, strong)  NSMutableArray<BYC_AccountModel *> *array_Data;

@property (nonatomic, assign) BOOL isClickChangeButton;

@property (nonatomic, strong) NSMutableDictionary *dic_CellIdentifier;


@end
static NSString *titleStr;
@implementation HL_AddFocusHandles

-(NSMutableArray *)array_Data{
    if (!_array_Data) {
        _array_Data = [NSMutableArray array];
    }
    return _array_Data;
}

-(NSMutableDictionary *)dic_CellIdentifier{
    if (!_dic_CellIdentifier) {
        _dic_CellIdentifier = [NSMutableDictionary dictionary];
    }
    return _dic_CellIdentifier;
}

-(instancetype)initAddFocusListCollectionViewHandle{
    if ([super init]) {

        [self initView];
        [self requestRecommendUser:nil];
         titleStr = @"你可能感兴趣的人";
    }
    return self;
}

-(BYC_MyCenterHandler *)handle {
    
    if (!_handle) _handle = [BYC_MyCenterHandler new];
    return _handle;
}

-(void)initView{
    _view_AddFocus = [[UIView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight-KHeightNavigationBar)];
    _view_AddFocus.backgroundColor = KUIColorBackground;
    _seachBar =[[HL_SearchBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    _seachBar.placeHolder = @"搜索昵称";
    _seachBar.delegate = self;
    _seachBar.canEditing = YES;
    [_view_AddFocus addSubview:_seachBar];
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing      = 0.f;
    layout.itemSize = CGSizeMake(screenWidth , 50.f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f,44, screenWidth,screenHeight - KHeightNavigationBar - 44/*搜索栏下面的高度*/)  collectionViewLayout:layout];
    [_view_AddFocus addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = NO;
    [_collectionView setScrollEnabled:NO];

    
//    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_CenterFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Identifier_Item];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [_view_AddFocus addSubview:self.button_ChangeData];
    __weak __typeof(self) weakSelf = self;
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        BYC_AccountModel *model = [weakSelf.array_Data lastObject];
        if (weakSelf.string_KeyWords.length > 0) {
            NSDictionary *dic_Parameters = @{@"time" : model.regdate, @"upType": @2, @"userId":model.userid, @"keyWord": weakSelf.string_KeyWords};
            [weakSelf reloadDataWithDic:dic_Parameters];
        }
        else{
            [weakSelf requestRecommendUser:model];
        }
        
    }];
    
}

-(void)setHandle:(BYC_MyCenterHandler *)handle{
    _handle = handle;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.array_Data.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [self.dic_CellIdentifier objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", Identifier_Item, [NSString stringWithFormat:@"%@", indexPath]];
        [self.dic_CellIdentifier setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
       [_collectionView registerNib:[UINib nibWithNibName:@"BYC_CenterFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }

    BYC_CenterFocusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    BYC_AccountModel *cellModel = self.array_Data[indexPath.row];
    cellModel.flag_Btn = indexPath.row;
    cell.model = cellModel;
    cell.backgroundColor = KUIColorBackgroundModule1;
    __weak __typeof(self) weakSelf = self;
        cell.whetherFocusBlock = ^(BOOL whetherFocus,BYC_AccountModel *model , UIButton *button ,BOOL isLogin){//添加或取消关注
                    button.enabled = NO;
                    weakSelf.indexPath = indexPath;
            [BYC_MyCenterFocusRequestDataHandler whetherSelectFocusWithToUserID:model handler:weakSelf.handle completion:^(BOOL success, WhetherFocusForCell status) {
                            button.enabled = YES;
                model.whetherFocusForCell = status;
            }];
        };
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //未登录跳转去登录
    
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        self.indexPath = indexPath;
        BYC_CenterFocusCollectionViewCell *item = (BYC_CenterFocusCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        HL_CenterViewController *myCenterVCFromFans = [[HL_CenterViewController alloc] init];
        myCenterVCFromFans.str_ToUserID = item.model.userid;
        self.toFocusUserModel  = item.model;
        __weak __typeof(self) weakSelf = self;
        myCenterVCFromFans.searchUserListFocusStateBlock = ^(WhetherFocusForCell status){
            [weakSelf setupFocusState:status];
        };
        [_collectionView.getBGViewController.navigationController pushViewController:myCenterVCFromFans animated:YES];
        
    }];
    return;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ( [kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        //段头复用
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        //  解决cell 重用问题
        for (UIView *view in head.subviews) {
            if (view) {
                [view removeFromSuperview];
            }
        }
        
        head.backgroundColor = KUIColorBackground;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, screenWidth, 30)];
        titleLabel.text = titleStr;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        titleLabel.textColor = KUIColorWordsBlack2;
        [head addSubview:titleLabel];
        reusableView = head;
    }
    return reusableView;
    
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={screenWidth,30};
    return size;
}

- (void)setupFocusState:(WhetherFocusForCell)status {
    
    self.toFocusUserModel.whetherFocusForCell = status;
    self.toFocusUserModel.attentionstate = status;
    _isWhetherFocusState = !_isWhetherFocusState;
    [_collectionView reloadItemsAtIndexPaths:@[_indexPath]];
    
}

-(void)setString_KeyWords:(NSString *)string_KeyWords {
    
    
    if (_string_KeyWords != string_KeyWords && string_KeyWords.length > 0) {
        
        [_collectionView reloadData];
    }
    _string_KeyWords = string_KeyWords;
    NSDictionary *dic_Parameters = @{@"time" : @"", @"upType": @0, @"userId":[BYC_AccountTool userAccount].userid, @"keyWord": _string_KeyWords};
    if(string_KeyWords.length > 0)[self reloadDataWithDic:dic_Parameters];
}



- (void)reloadDataWithDic:(NSDictionary *)parameters {
    [BYC_HttpServers requestSearchUserHandelListDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, BYC_MyCenterHandler *handler, NSInteger total) {
        
        self.handle = handler;
        if (handler.handler_Focus.mArr_Models.count == 0) {//无数据
            if ([_collectionView.footer isRefreshing]) [self.collectionView.footer endRefreshingWithNoMoreData];//刷新状态下无数据
        }else {//有数据
            
            if ([_collectionView.footer isRefreshing]) {//刷新状态下有数据
                // 结束刷新
                if (handler.handler_Focus.mArr_Models.count > 0) {
                    NSMutableArray *arr_focusData = [NSMutableArray array];
                    arr_focusData = [handler.handler_Focus.mArr_Models mutableCopy];
                        for (int i = 0; i<arr_focusData.count; i++) {
                            
                            for (BYC_AccountModel *focusUserModel2 in self.array_Data) {
                                if ([((BYC_AccountModel *)arr_focusData[i]).userid isEqualToString:focusUserModel2.userid]){
                                    [arr_focusData removeObjectAtIndex:i];
                                }
                            }
                        }
                        [self.collectionView.footer endRefreshing];
                    [self.array_Data addObjectsFromArray:arr_focusData];
                }
                else {
                    self.array_Data = self.array_Data;
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                }

            }else self.array_Data = [handler.handler_Focus.mArr_Models mutableCopy];
        }
            [_collectionView reloadData];
        titleStr = @"搜索结果如下";
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIView alloc] showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        if ([_collectionView.footer isRefreshing])[self.collectionView.footer endRefreshing];
    }];
}

#pragma mark - SearchBarDelegate
-(void)searchBar:(HL_SearchBar *)searchBar didSearch:(NSString *)text{
    [searchBar endEditing:YES];
    //根据关键字搜索用户
    [self setString_KeyWords:text];
}

-(void)searchBar:(HL_SearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.collectionView.footer endRefreshing];
    [self.array_Data removeAllObjects];
    if (searchText.length == 0) {
       //显示推荐用户
        self.string_KeyWords = searchText;
        [self.array_Data removeAllObjects];
        [self requestRecommendUser:nil];
    }
    
}

-(void)requestRecommendUser:(BYC_AccountModel *)userModel{
    
    _seachBar.text = nil;
    NSDictionary *dic_Parameters;
    if (userModel == nil) {
        dic_Parameters = @{@"upType":@0,@"userId":[BYC_AccountTool userAccount].userid,@"videos":@0};
    }
    else{
           dic_Parameters = @{@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"videos":@(userModel.userInfo.videos)};
    }
    [BYC_HttpServers requestAddFriendVCDataWithParameters:dic_Parameters success:^(BYC_MyCenterHandler *handler) {
        
        self.handle = handler;
        if ([self.collectionView.footer isRefreshing]) {
                if (handler.handler_Focus.mArr_Models.count > 0) {
                    NSMutableArray *arr_focusData = [NSMutableArray array];
                    arr_focusData = [handler.handler_Focus.mArr_Models mutableCopy];
                    for (int i = 0; i<arr_focusData.count; i++) {
                        
                        for (BYC_AccountModel *focusUserModel2 in self.array_Data) {
                            if ([((BYC_AccountModel *)arr_focusData[i]).userid isEqualToString:focusUserModel2.userid]){
                                [arr_focusData removeObjectAtIndex:i];
                            }
                        }
                    }
                    [self.collectionView.footer endRefreshing];
                    [self.array_Data addObjectsFromArray:arr_focusData];
                }
                else {
                    self.array_Data = self.array_Data;
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                }
        }
        else{
            [self.array_Data addObjectsFromArray:handler.handler_Focus.mArr_Models];
        }
        titleStr = @"你可能感兴趣的人";
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        [[UIView alloc] showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        if ([_collectionView.footer isRefreshing])[self.collectionView.footer endRefreshing];
    }];
}

#pragma mark ------空数据提示
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    titleStr = @"没有搜索到相关用户";
    BYC_ControllerCustomView *emptyView = [[BYC_ControllerCustomView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andNotificationObject:self];
    emptyView.imageUrl = @"img_kbzt_wssdxgnr";
    return emptyView;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.collectionView.contentOffset.y <= 0) {
        self.collectionView.contentOffset = CGPointMake(0, 0);
        return;
    }
}

@end
