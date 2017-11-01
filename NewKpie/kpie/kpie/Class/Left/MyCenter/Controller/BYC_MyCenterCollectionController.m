//
//  BYC_MyCenterCollectionController.m
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MyCenterCollectionController.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_CenterCollectionViewCell.h"
#import "BYC_CenterFocusCollectionViewCell.h"
#import "HL_CenterViewController.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_MyCenterFocusRequestDataHandler.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UICollectionView+BYC_PlaceHolder.h"

@interface BYC_MyCenterCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource> {

    NSUInteger _index;
    NSString *_str_CollectionNibName;
    CGFloat _flo_CellHeight;
}

/**当前用户的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel          *model_CurrentUser;
@property (nonatomic, assign) WhetherFocusForCell        whenClickFocusStateResult;
@property (nonatomic, strong)  NSMutableArray *arr_Models;

/**第几页数据*/
@property (nonatomic, assign) int              page;
/**没有更多:YES代表没有更多*/
@property (nonatomic, assign) BOOL isWhetherNoMore;
@end

@implementation BYC_MyCenterCollectionController



-(void)setArr_CellData:(NSArray *)arr_CellData {
    
    _arr_CellData = arr_CellData;
    _index = [_arr_CellData[0] unsignedIntValue];
    _str_CollectionNibName = _arr_CellData[1];
    _flo_CellHeight = [_arr_CellData[2] floatValue];
    [self setupCollection];

}

-(void)setArr_Models:(NSMutableArray *)arr_Models {

    _arr_Models = arr_Models;
    _page = 1;
//    [self.collectionView byc_reloadData:_index == 0 ? @"暂无作品" : _index == 1 ? @"没有关注任何人" : @"没有任何粉丝"];
    [self.collectionView reloadData];
    [self registerKVO];
}

-(void)setHandle:(BYC_MyCenterHandler *)handle {

    _handle = handle;
    switch (_index) {
        case 0:
            self.arr_Models = [_handle.handler_Works.mArr_Models mutableCopy];
            break;
        case 1:
            self.arr_Models = [_handle.handler_Focus.mArr_Models mutableCopy];
            break;
        case 2:
            self.arr_Models = [_handle.handler_Fans.mArr_Models mutableCopy];
            break;
            
        default:
            break;
    }
    
    if (_isWhetherNoMore == YES && _arr_Models.count < 20) [self.collectionView.footer endRefreshingWithNoMoreData];
    else [self.collectionView.footer resetNoMoreData];

}

- (void)registerKVO {
    
    switch (_index) {
        case 0:
        {
            
            [_handle.handler_Works rac_observeKeyPath:@"mArr_Models" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                self.arr_Models = value;
            }];
        }
            break;
        case 1:
        {
            [_handle.handler_Focus rac_observeKeyPath:@"mArr_Models" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                self.arr_Models = value;
            }];
        }
            break;
        case 2:
        {
            [_handle.handler_Fans rac_observeKeyPath:@"mArr_Models" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                self.arr_Models = value;
            }];
        }
            break;
            
        default:
            break;
    }

}

- (void)setupCollection {
        //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing      = 0.f;
    layout.itemSize = CGSizeMake(screenWidth , _flo_CellHeight);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView  = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(flo_DefaultOffSetY, 0,  0,  0);
    self.collectionView.delegate                     = self;
    self.collectionView.dataSource                   = self;
    self.collectionView.emptyDataSetDelegate         = self;
    self.collectionView.emptyDataSetSource           = self;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:_str_CollectionNibName bundle:nil] forCellWithReuseIdentifier:_str_CollectionNibName];
    
    [self.view addSubview:self.collectionView];
    
    QNWSWeakSelf(self);
    // 上拉更新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself loadData];
    }];
}

- (void)loadData {
    
    NSDictionary *dic;
    switch (_index) {
        case 0:
            dic = @{@"page":[NSNumber numberWithInt:++_page],@"rows":@"20",@"video.userid": _handle.model_CurrentUser.userid};
            break;
        case 1:
            dic = @{@"page":[NSNumber numberWithInt:++_page],@"rows":@"20",@"userid":_handle.model_User.userid ? _handle.model_User.userid : @"", @"touserid":  _handle.model_CurrentUser.userid};
            break;
        case 2:
            dic = @{@"page":[NSNumber numberWithInt:++_page],@"rows":@"20",@"userid":_handle.model_User.userid ? _handle.model_User.userid : @"", @"touserid":  _handle.model_CurrentUser.userid};
            break;
        default:
            break;
    }
    
    //网络请求
    [self requestDataWithUrl:_index == 0 ? KQNWS_GetMineVideoUrl : _index == 1 ? KQNWS_GetFocusUserUrl : KQNWS_GetFansUserUrl parameters:dic];
}

- (void)requestDataWithUrl:(NSString *)url parameters:(id)parameters{
    
    [BYC_HttpServers Get:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.collectionView.footer.isRefreshing) [self.collectionView.footer endRefreshing];
        
        NSArray *bodyRows = responseObject[@"rows"];
        if (bodyRows.count > 0) {
            
            NSArray *arr_Temp;
            if (_index == 0) arr_Temp = [BYC_HomeViewControllerModel initModelsWithArray:bodyRows];
            else  arr_Temp = [BYC_FocusAndFansModel initModelsWithArray:bodyRows];
            // 结束刷新
            [self.arr_Models addObjectsFromArray:arr_Temp];
            [self.collectionView reloadData];
        }else {
            
            [self.collectionView.footer endRefreshingWithNoMoreData];
            _isWhetherNoMore = YES;
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
            if (self.collectionView.footer.isRefreshing) [self.collectionView.footer endRefreshing];
    }];
}

#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  _arr_Models.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_str_CollectionNibName forIndexPath:indexPath];
    cell.backgroundColor = KUIColorBackgroundModule1;
    
    if (_index == 0) {
        
        ((BYC_CenterCollectionViewCell *)cell).model = (BYC_HomeViewControllerModel *)_arr_Models[indexPath.row];
    }else {

        ((BYC_CenterFocusCollectionViewCell *)cell).model = (BYC_FocusAndFansModel *)_arr_Models[indexPath.row];
        __weak __typeof(self) weakSelf = self;
        ((BYC_CenterFocusCollectionViewCell *)cell).whetherFocusBlock = ^(BOOL whetherFocus,BYC_AccountModel *model , UIButton *button, BOOL isLogin){//添加或取消关注
            button.enabled = NO;
            
            [BYC_MyCenterFocusRequestDataHandler whetherSelectFocusWithToUserID:model handler:weakSelf.handle completion:^(BOOL success, WhetherFocusForCell status) {
                button.enabled = YES;
            }];
        };
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (_index == 0) {
        
        // 通知中心
        NSNotification *notification = [NSNotification notificationWithName:@"hiddenTheButton" object:nil userInfo:@{@"1":@"1"}];
        [QNWSNotificationCenter postNotification:notification];
        
        
        BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)_arr_Models[indexPath.row];
        [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
    }else {
    
        
        BYC_CenterFocusCollectionViewCell *item = (BYC_CenterFocusCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if ([item.model.userid isEqualToString:_handle.model_CurrentUser.userid]) {
            
            [self.view showAndHideHUDWithTitle:@"不能继续点击当前用户主页" WithState:BYC_MBProgressHUDHideProgress];
            return;
        }
        HL_CenterViewController *myCenterVCFromFocus = [[HL_CenterViewController alloc] init];
        myCenterVCFromFocus.str_ToUserID = item.model.userid;
        [self.navigationController pushViewController:myCenterVCFromFocus animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.collectionView)
        [self.delegate customCenterCollectionViewController:self scrollViewIsScrolling:scrollView];
}

#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:_index == 0 ? @"img_kbzt_smdmy" : _index == 1 ? @"img_kbzt_mygzdr" : @"img_kbzt_mygzdr"];
    return image;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return 100;
}

@end
