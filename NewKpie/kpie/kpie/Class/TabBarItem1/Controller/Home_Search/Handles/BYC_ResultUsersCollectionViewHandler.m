//
//  BYC_ResultUsersCollectionViewHandler.h
//  kpie
//
//  Created by 元朝 on 16/5/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#define Identifier_Item @"CollectionViewCell"

#import "BYC_ResultUsersCollectionViewHandler.h"
#import "BYC_CenterFocusCollectionViewCell.h"
#import "HL_CenterViewController.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_SearchAccountModel.h"
#import "BYC_LoginAndRigesterView.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_ControllerCustomView.h"
#import "BYC_HttpServers+BYC_Search.h"
#import "BYC_MyCenterFocusRequestDataHandler.h"

@interface BYC_ResultUsersCollectionViewHandler ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

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

/***/
@property (nonatomic, strong)  BYC_MyCenterHandler  *handle;
@end

@implementation BYC_ResultUsersCollectionViewHandler

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
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_CenterFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Identifier_Item];

    __weak __typeof(self) weakSelf = self;
    // 上拉更新
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        BYC_AccountModel *model = [weakSelf.array_Data lastObject];
        NSDictionary *dic_Parameters = @{@"time" : model.regdate, @"upType": @2, @"userId":model.userid, @"keyWord": weakSelf.string_KeyWords};
        [weakSelf reloadDataWithDic:dic_Parameters];
        
    }];
}

-(BYC_MyCenterHandler *)handle {
    
    if (!_handle) _handle = [BYC_MyCenterHandler new];
    return _handle;
}

//下拉加载更多数据
- (void)reloadDataWithDic:(NSDictionary *)parameters {
  
    [BYC_HttpServers requestSearchUserListDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, NSArray<BYC_AccountModel *> *arrModels, NSInteger total) {
        
        if (_dataCountBlock) _dataCountBlock(total);
        if (arrModels.count == 0) {//无数据
            
            if ([_collectionView.footer isRefreshing]) [self.collectionView.footer endRefreshingWithNoMoreData];//刷新状态下无数据
        }else {//有数据
            
            if ([_collectionView.footer isRefreshing]) {//刷新状态下有数据
                
                NSMutableArray *marr = [NSMutableArray array];
                marr = [self.array_Data mutableCopy];
                [marr addObjectsFromArray:arrModels];
                self.array_Data = [marr copy];
                [self.collectionView.footer endRefreshing];
            }else self.array_Data = arrModels;
            [_collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

- (void)setupFocusState:(WhetherFocusForCell)status {

    self.toFocusUserModel.whetherFocusForCell = status;
    _isWhetherFocusState = !_isWhetherFocusState;
    [_collectionView reloadItemsAtIndexPaths:@[_indexPath]];
    
}

-(void)setString_KeyWords:(NSString *)string_KeyWords {


    if (_string_KeyWords != string_KeyWords) {
        
        _array_Data = @[];
        [_collectionView reloadData];
    }

    _string_KeyWords = string_KeyWords;
    _userModel = [BYC_AccountTool userAccount];
    NSDictionary *dic_Parameters = @{@"time" : @"", @"upType": @0, @"keyWord": _string_KeyWords, @"userId":self.userModel.userid};
    [self reloadDataWithDic:dic_Parameters];
}

#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"img_kbzt_wssdxgnr"];
    return image;
}

@end
