//
//  HL_CollectionViewVC.m
//  kpie
//
//  Created by sunheli on 16/9/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_CollectionViewVC.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_CenterCollectionViewCell.h"
#import "BYC_CenterFocusCollectionViewCell.h"
#import "HL_CenterViewController.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_MyCenterFocusRequestDataHandler.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import "BYC_HttpServers+BYC_MyCenterVC.h"



@interface HL_CollectionViewVC ()<UICollectionViewDelegate, UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource> {
    
    NSUInteger _page;
    NSString *_str_CollectionNibName;
    CGFloat _flo_CellHeight;
}

/**当前用户的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel          *model_CurrentUser;
@property (nonatomic, assign) WhetherFocusForCell        whenClickFocusStateResult;
@property (nonatomic, strong)  NSMutableArray *arr_Models;

/**第几页数据*/
@property (nonatomic, assign) int              data_Page;
/**没有更多:YES代表没有更多*/
@property (nonatomic, assign) BOOL isWhetherNoMore;

@property (nonatomic, strong) NSMutableDictionary * dic_CellIdentifier;

@end

@implementation HL_CollectionViewVC

-(NSMutableDictionary *)dic_CellIdentifier{
    if (!_dic_CellIdentifier) {
        _dic_CellIdentifier = [NSMutableDictionary dictionary];
    }
    return _dic_CellIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupCollection {
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing      = 0.f;
    layout.itemSize = CGSizeMake(screenWidth , _flo_CellHeight);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-KHeightNavigationBar) collectionViewLayout:layout];
    self.collectionView.delegate                     = self;
    self.collectionView.dataSource                   = self;
    self.collectionView.emptyDataSetDelegate         = self;
    self.collectionView.emptyDataSetSource           = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
//    [self.collectionView registerNib:[UINib nibWithNibName:_str_CollectionNibName bundle:nil] forCellWithReuseIdentifier:_str_CollectionNibName];
    
    [self.view addSubview:self.collectionView];
    
    QNWSWeakSelf(self);
    // 上拉更新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself loadData];
    }];
}
-(void)setArr_Models:(NSMutableArray *)arr_Models {
    
    _arr_Models = arr_Models;
    _data_Page = 1;
    [self.collectionView reloadData];
    [self registerKVO];
}
- (void)registerKVO {
    
    switch (_page) {
        case 0:{
            
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


-(void)setArr_CellData:(NSArray *)arr_CellData{
    _arr_CellData = arr_CellData;
    _page                    = [_arr_CellData[0] unsignedIntValue];
    _str_CollectionNibName   = _arr_CellData[1];
    _flo_CellHeight          = [_arr_CellData[2] floatValue];
    [self setupCollection];
}

-(void)setHandle:(BYC_MyCenterHandler *)handle {
    _handle = handle;
    switch (_page) {
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

- (void)loadData {
    
    NSDictionary *dic;
    switch (_page) {
        case 0:{
            BYC_BaseVideoModel *worksModel = [self.arr_Models lastObject];
            dic = @{@"loadType":@1,@"toUserId":_handle.model_CurrentUser.userid,@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"time":worksModel.onmstime,@"videoId":worksModel.videoid};
        }
            break;
        case 1:{
            BYC_AccountModel *focusModel = [self.arr_Models lastObject];
            dic = @{@"loadType":@2,@"toUserId":_handle.model_CurrentUser.userid,@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"time":focusModel.attentiontime};
        }
            break;
        case 2:{
            BYC_AccountModel *fansModel = [self.arr_Models lastObject];
            dic = @{@"loadType":@3,@"toUserId":_handle.model_CurrentUser.userid,@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"time":fansModel.attentiontime};

        }
            break;
        default:
            break;
    }
    
    //网络请求
    [self requestDataWithParameters:dic];
}

- (void)requestDataWithParameters:(id)parameters{
        //获取个人信息
        //loadType:   0--默认加载  1--作品  2--关注  3--粉丝
        //toUserId:   他人主页-----他人的UserId    个人主页 ----self.userInfoModel.userid
        //upType:     0--默认   1--下拉  2--上拉
        //userid     登陆用户Id   self.userInfoModel.userid
    [BYC_HttpServers requestMyCenterDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, BYC_MyCenterHandler *handler) {
        switch (_page) {
            case 0:
            {
                if (handler.handler_Works.mArr_Models.count >0) {
                    NSMutableArray *arr_videoData = [NSMutableArray array];
                    arr_videoData = [handler.handler_Works.mArr_Models mutableCopy];
                    for (int i = 0; i<arr_videoData.count; i++) {
                        
                        for (BYC_BaseVideoModel *videoModel2 in self.arr_Models) {
                            if ([((BYC_BaseVideoModel *)arr_videoData[i]).videoid isEqualToString:videoModel2.videoid]){
                                [arr_videoData removeObjectAtIndex:i];
                            }
                        }
                    }
                        [self.arr_Models addObjectsFromArray:arr_videoData];
                        [self.collectionView.footer endRefreshing];
                }
                else{
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                }
            }
                break;
            case 1:
            {
                if (handler.handler_Focus.mArr_Models.count >0) {
                    NSMutableArray *arr_videoData = [NSMutableArray array];
                    arr_videoData = [handler.handler_Focus.mArr_Models mutableCopy];
                    [arr_videoData removeObjectAtIndex:0];
                    if (arr_videoData.count > 0) {
                        for (int i = 0; i<arr_videoData.count; i++) {
                            
                            for (BYC_AccountModel *videoModel2 in self.arr_Models) {
                                if ([((BYC_AccountModel *)arr_videoData[i]).userid isEqualToString:videoModel2.userid]){
                                    [arr_videoData removeObjectAtIndex:i];
                                }
                            }
                        }
                        [self.arr_Models addObjectsFromArray:arr_videoData];
                        [self.collectionView.footer endRefreshing];
                    }
                    else [self.collectionView.footer endRefreshingWithNoMoreData];
                    
                }
                else{
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                }
            }
                
                break;
            case 2:
            {
                if (handler.handler_Fans.mArr_Models.count >0) {
                    NSMutableArray *arr_videoData = [NSMutableArray array];
                    arr_videoData = [handler.handler_Fans.mArr_Models mutableCopy];
                    [arr_videoData removeObjectAtIndex:0];
                    if (arr_videoData.count > 0) {
                        for (int i = 0; i<arr_videoData.count; i++) {
                            
                            for (BYC_AccountModel *videoModel2 in self.arr_Models) {
                                if ([((BYC_AccountModel *)arr_videoData[i]).userid isEqualToString:videoModel2.userid]){
                                    [arr_videoData removeObjectAtIndex:i];
                                }
                            }
                        }
                        [self.arr_Models addObjectsFromArray:arr_videoData];
                        [self.collectionView.footer endRefreshing];
                        
                    }
                    else [self.collectionView.footer endRefreshingWithNoMoreData]; 
                }
                else{
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                }
            }
                break;
            default:
                break;
        }
        
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        if (self.collectionView.footer.isRefreshing) {
            [self.collectionView.footer endRefreshing];
        }
    }];
}

#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  _arr_Models.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.dic_CellIdentifier objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", _str_CollectionNibName, [NSString stringWithFormat:@"%@", indexPath]];
        [self.dic_CellIdentifier setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [_collectionView registerNib:[UINib nibWithNibName:_str_CollectionNibName bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = KUIColorBackgroundModule1;
    if (_page == 0) {
        
        ((BYC_CenterCollectionViewCell *)cell).model = _arr_Models[indexPath.row];
    }else {
        ((BYC_CenterFocusCollectionViewCell *)cell).model = _arr_Models[indexPath.row];
        __weak __typeof(self) weakSelf = self;
        ((BYC_CenterFocusCollectionViewCell *)cell).whetherFocusBlock = ^(BOOL whetherFocus,BYC_AccountModel *model , UIButton *button, BOOL isLogin){//添加或取消关注
            button.enabled = NO;
            [BYC_MyCenterFocusRequestDataHandler whetherSelectFocusWithToUserID:model handler:weakSelf.handle completion:^(BOOL success, WhetherFocusForCell status) {
                button.enabled = YES;
                model.whetherFocusForCell = status;
                if (_page == 2 && [[BYC_AccountTool userAccount].userid isEqualToString:weakSelf.handle.model_CurrentUser.userid]) {
                    [QNWSNotificationCenter postNotificationName:@"SaveOrRemove" object:nil];
                }
            }];
        };
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_page == 0) {
        
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

#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:_page == 0 ? @"img_kbzt_smdmy" : _page == 1 ? @"img_kbzt_mygzdr" : @"img_kbzt_mygzdr"];
    return image;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return 100;
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
