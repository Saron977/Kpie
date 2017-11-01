 //
//  BYC_FocusViewController.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_FocusViewController.h"
#import "BYC_BaseNavigationController.h"
#import "HL_FocusArrModel.h"
#import "BYC_BackFocusListCellModel.h"
#import "BYC_ShareView.h"
#import "HL_CenterViewController.h"
#import "BYC_MainNavigationController.h"
#import "NSString+BYC_Tools.h"

#import "HL_FocusTableViewCell.h"
#import "HL_FocusTableViewHeader.h"
#import "BYC_HttpServers+FocusVC.h"
#import "ZFPlayer.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BYC_ControllerCustomView.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_HttpServers+HL_VideoPlayVC.h"
#import "HL_AddFocusViewController.h"

@interface BYC_FocusViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong)   UITableView               *tableView;
@property (nonatomic, strong)   HL_FocusTableViewHeader   *focusTableViewHeader;   /**<    转发模块*/
@property (nonatomic, strong)   NSMutableArray                   *focusListDataArr;       /**<    动态列表*/
@property (nonatomic, strong)   UIView                    *navTitleBgView;         /**<    自定义导航栏*/

@property (nonatomic, strong)   NSIndexPath                  *indexPath;

/** ZF播放器 */
@property (nonatomic, strong) ZFPlayerView          *playerView;

@end

@implementation BYC_FocusViewController

-(NSMutableArray *)focusListDataArr{
    
    if (_focusListDataArr == nil) {
        _focusListDataArr = [NSMutableArray array];
    }
    return _focusListDataArr;
}

-(instancetype)init{
    if (self = [super init]) {
        [self creatCustomNavBar];
        [self makeUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KUIColorFromRGB(0xf0f0f0);
   
    [self requestFocusListData];
    //替换账户或者上传新视频成功，则需要重新请求网络
    [QNWSNotificationCenter addObserver:self selector:@selector(kLoginSuccessed:) name:KSTR_KLoginSuccessed object:nil];
    //删除作品之后同时删除动态的通知方法
    [QNWSNotificationCenter addObserver:self selector:@selector(deletePhoneVideoNotification:) name:KNotification_DeletePhoneVideo object:nil];
    //上传视频成功之后刷新动态页面的数据通知
    [QNWSNotificationCenter addObserver:self selector:@selector(refreshFocusVCDataNotification) name:KNotification_RefreshFocusVCData object:nil];
    //网络不好时刷新数据
    [QNWSNotificationCenter addObserver:self selector:@selector(requestFocusListData) name:nil object:self];
    [QNWSNotificationCenter addObserver:self selector:@selector(refreshFavoritesStatus:) name:@"KNotification_isLikeVideo" object:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    ((BYC_BaseNavigationController *)self.navigationController).leftButton.hidden = YES;
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    ((BYC_BaseNavigationController *)self.navigationController).leftButton.hidden = NO;
    [self.playerView resetPlayer];
}

#pragma mark ----自定义导航栏
- (void)creatCustomNavBar{
    self.navTitleBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, KHeightNavigationBar)];
    self.navTitleBgView.backgroundColor = KUIColorBaseGreenNormal;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-50, 20, 100, 44)];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];//KUIColorFromRGB(0XFFFFFF);
    titleLab.text = @"动态";
//    titleLab.alpha = 0.7;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"dongtai_btn_tjpy_n"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"dongtai_btn_tjpy_h"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navTitleBgView addSubview:titleLab];
    [self.navTitleBgView addSubview:rightBtn];
    [self.view addSubview:self.navTitleBgView];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.insets = UIEdgeInsetsMake(0, 0, 12, 12);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(24);
    }];
}

-(void)rightButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    QNWSLog(@"----点击动态右上角按钮----");
    HL_AddFocusViewController *addFocusVC = [[HL_AddFocusViewController alloc]init];
    [KMainNavigationVC pushViewController:addFocusVC animated:YES];
}

#pragma mark ----------获取动态列表数据
-(void)requestFocusListData{
    __weak __typeof(self) weakSelf = self;
    if (![BYC_AccountTool userAccount].userid) {return;}
    NSDictionary *params =  @{@"upType":@0,@"userId":[BYC_AccountTool userAccount].userid};
    [BYC_HttpServers requestFocusVCFocusListWithParameters:params success:^(HL_FocusArrModel *focusModels) {
        weakSelf.focusListDataArr = [focusModels.arr_FocusList mutableCopy];
        [weakSelf.tableView.footer endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
    }];
}

#pragma mark  ------下拉刷新
-(void)loadNewData:(id)params{
    __weak __typeof(self) weakSelf = self;
    [self.tableView.footer endRefreshing];
    [BYC_HttpServers requestFocusVCFocusListWithParameters:params success:^(HL_FocusArrModel *focusModels) {
        if (focusModels.arr_FocusList.count > 0) {
            NSMutableArray *arr_videoData = [NSMutableArray array];
            arr_videoData = [focusModels.arr_FocusList mutableCopy];
            for (int i = 0; i<arr_videoData.count; i++) {
                
                for (BYC_BaseVideoModel *videoModel2 in weakSelf.focusListDataArr) {
                    if ([((BYC_BaseVideoModel *)arr_videoData[i]).videoid isEqualToString:videoModel2.videoid]){
                        [arr_videoData removeObjectAtIndex:i];
                    }
                }
            }
                [weakSelf.focusListDataArr addObjectsFromArray:arr_videoData];
        }
        else{
            weakSelf.focusListDataArr = weakSelf.focusListDataArr;
        }
        [weakSelf.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark -------上拉加载
-(void)loadMoreData:(id)params{
    __weak __typeof(self) weakSelf = self;
    [BYC_HttpServers requestFocusVCFocusListWithParameters:params success:^(HL_FocusArrModel *focusModels) {
        if (focusModels.arr_FocusList.count == 0){
        [self.tableView.footer endRefreshingWithNoMoreData];
        }
        else {
            NSMutableArray *arr_videoData = [NSMutableArray array];
            arr_videoData = [focusModels.arr_FocusList mutableCopy];
            for (int i = 0; i<arr_videoData.count; i++) {
                
                for (BYC_BaseVideoModel *videoModel2 in weakSelf.focusListDataArr) {
                    if ([((BYC_BaseVideoModel *)arr_videoData[i]).videoid isEqualToString:videoModel2.videoid]){
                        [arr_videoData removeObjectAtIndex:i];
                    }
                }
            }
            [weakSelf.focusListDataArr addObjectsFromArray:arr_videoData];
            [weakSelf.tableView.footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}
#pragma mark ---------点赞/取消点赞
-(void)requestOfSaveFavorites:(NSArray *)params andWithType:(NSInteger)type andWithIindextPath:(NSIndexPath *)indexPath andWithCell:(HL_FocusTableViewCell *)focusCell{
    focusCell.button_like.enabled = NO;
    [BYC_HttpServers requestFocusVCSaveUserFavoritesWithParameters:params andWithType:type success:^(BOOL isSuccess) {
        NSInteger likes = [focusCell.button_like.titleLabel.text integerValue] >= 0 ? [focusCell.button_like.titleLabel.text integerValue] : 0;
        BYC_BaseVideoModel *model = self.focusListDataArr[indexPath.section];
        if (type == 0) {//点赞
            [focusCell.button_like setImage:[UIImage imageNamed:@"dongtai_btn_zan_h"] forState:UIControlStateNormal];
            focusCell.button_like.selected = YES;
            likes += 1;
             model.isfavor = YES;
            model.favorites = likes;
            focusCell.button_like.enabled = YES;
        }
        else if (type == 1){//取消点赞
            [focusCell.button_like setImage:[UIImage imageNamed:@"dongtai_btn_zan_n"] forState:UIControlStateNormal];
            focusCell.button_like.selected = NO;
            likes -= 1;
            model.favorites = likes >= 0 ? likes : 0;
             model.isfavor = NO;
            focusCell.button_like.enabled = YES;
        }
        [self.focusListDataArr replaceObjectAtIndex:indexPath.section withObject:model];
        [focusCell.button_like setTitle:[NSString stringWithFormat:@"%ld",(long)likes] forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ---- 手动改变是否点赞状态
-(void)refreshFavoritesStatus:(NSNotification*)not
{
    if (self.focusListDataArr.count > 0) {
        BYC_BaseVideoModel *model = self.focusListDataArr[self.indexPath.section];
        model.isfavor = [not.userInfo[@"isFavorite"] boolValue];
        [self.focusListDataArr replaceObjectAtIndex:self.indexPath.section withObject:model];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        QNWSLog(@"活动界面点赞 %@ 收藏数 %zi 是否收藏 %zi",model.videotitle,model.favorites,model.isfavor);
    }
}
- (void)refreshFocusVCDataNotification {
    
    [self.focusListDataArr removeAllObjects];//移除所有
    if (self.focusListDataArr.count == 0) [self requestFocusListData];
}

- (void)kLoginSuccessed:(NSNotification *)notification {
    
    [self.focusListDataArr removeAllObjects];//移除所有
    BYC_AccountModel *userModel = notification.object;
    
    if (userModel) [self requestFocusListData];
    
}

- (void)deletePhoneVideoNotification:(NSNotification *)notification {
    
    for (BYC_BaseVideoModel *model in self.focusListDataArr) {
        
        if ([model.videoid isEqualToString:notification.object]) {
            
            [self.focusListDataArr removeObject:model];
            [self.tableView reloadData];
            return;
        }
    }
}


-(void)makeUI{
    self.focusListDataArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth,screenHeight-KHeightNavigationBar) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KUIColorFromRGB(0xFFFFFF);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HL_FocusTableViewCell class] forCellReuseIdentifier:@"focusCell"];
    [self.view addSubview:self.tableView];

    __weak __typeof(self) weakSelf = self;
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.focusListDataArr.count == 0) {
            [self requestFocusListData];
            return ;
        }
            BYC_BaseVideoModel *model = (BYC_BaseVideoModel *)[weakSelf.focusListDataArr firstObject];
                    NSDictionary *dic = @{@"time":model.onmstime,@"upType":@1,@"userId":[BYC_AccountTool userAccount].userid,@"videoId":model.videoid};
            [weakSelf loadNewData:dic];
    }];
    //上拉加载
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        BYC_BaseVideoModel *model = (BYC_BaseVideoModel *)[weakSelf.focusListDataArr lastObject];
        NSDictionary *dic = @{@"time":model.onmstime,@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"videoId":model.videoid};
        [weakSelf loadMoreData:dic];
    }];
}

#pragma mark - tableView的DataSource 和 Delegate方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.focusListDataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HL_FocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusCell" forIndexPath:indexPath];
    cell.model = self.focusListDataArr[indexPath.section];
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(cell) weakCell = cell;
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        cell.selectButton = ^(HL_FocusTableViewCellSelected selectButton ,BYC_BaseVideoModel *model){
            self.indexPath = indexPath;
            [weakSelf clickButtonAction:selectButton model:model andWithIndexPath:indexPath WithCell:weakCell];
        };
        
    });
    
    cell.clickHeaderButtonBlock = ^(BYC_BaseVideoModel *model){
        HL_CenterViewController *myCenterVC = [[HL_CenterViewController alloc] init];
        myCenterVC.str_ToUserID = model.userid;
        [weakSelf.navigationController pushViewController:myCenterVC animated:YES];
};

#pragma mark  ------点击播放按钮
    __block NSIndexPath *weakIndexPath = indexPath;
    __block BYC_BaseVideoModel * model = self.focusListDataArr[indexPath.section];
    
    cell.clickPlayButtonBlock = ^(UIButton *btn){
        if (model.isvr == 1) {
            self.indexPath = indexPath;
            [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
        }
        else{
            weakSelf.playerView = [ZFPlayerView sharedPlayerView];
            NSURL *videoURL = [NSURL URLWithString:model.videomp4];
            
            // 设置player相关参数(需要设置imageView的tag值，此处设置的为1001)
            [weakSelf.playerView setVideoURL:videoURL
                               withTableView:weakSelf.tableView
                                 AtIndexPath:weakIndexPath
                            withImageViewTag:1001];
            [weakSelf.playerView addPlayerToCellImageView:weakCell.imageV_videoImage];
            
            // 下载功能
            weakSelf.playerView.hasDownload   = NO;
            //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
            weakSelf.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
            // 自动播放
            [weakSelf.playerView autoPlayTheVideo];
            [weakSelf videoClicks:model andWithIndexPath:indexPath];
        }
        
    };
    self.playerView.getVideoViewsBlock = ^{
        [weakSelf videoClicks:model andWithIndexPath:indexPath];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HL_FocusTableViewCell returnCellHeightOfFocus:self.focusListDataArr[indexPath.section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footerView.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    return footerView;
}

- (void)clickButtonAction:(HL_FocusTableViewCellSelected)selectButton model:(BYC_BaseVideoModel *)model andWithIndexPath:(NSIndexPath *)indexPath WithCell:(HL_FocusTableViewCell *)focusCell{
    
    switch (selectButton) {
        case HL_FocusTableViewCellSelectedShoot:{//合拍
            [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
            
        }
            break;
        case HL_FocusTableViewCellSelectedLike:{
            
            if (model.isfavor) {//取消点赞
                NSArray *array_UnLikeParam = @[[BYC_AccountTool userAccount].userid,model.videoid,@"1"];
                [self requestOfSaveFavorites:array_UnLikeParam andWithType:1 andWithIindextPath:indexPath andWithCell:focusCell];
            }else {//点赞
                NSArray *array_LikeParam = @[[BYC_AccountTool userAccount].userid,model.videoid,@"0"];
                [self requestOfSaveFavorites:array_LikeParam andWithType:0 andWithIindextPath:indexPath andWithCell:focusCell];
            }}
            break;
        case HL_FocusTableViewCellSelectedComment:{
#pragma mark -------评论
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:YES andFromType:ENU_FromOtherVideo];            }
            break;
        case HL_FocusTableViewCellSelectedForward:{
#pragma mark -------转发/分享
            [[BYC_ShareView alloc] showWithDelegateVC:self shareContentOrMedia:BYC_ShareTypeMedia shareWithDic:@{const_ShareResourceID:model.videoid,const_ShareUserID:model.userid,const_ShareResourceTitle:model.videotitle,const_ShareResourceImage:model.picturejpg}];
        }
            break;
        default:
            break;
    }
}

/***  视频点击量 */
-(void)videoClicks:(BYC_BaseVideoModel *)focusModel andWithIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = @[focusModel.videoid];
    [BYC_HttpServers requestVideoPlayVCPlayedCountWithParameters:arr Success:^{
        BYC_BaseVideoModel *model = self.focusListDataArr[indexPath.section];
        model.views += 1;
        [self.focusListDataArr replaceObjectAtIndex:indexPath.section withObject:model];
        [self.tableView reloadData];
    } failure:^{}];
}

#pragma mark ------空数据提示
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    BYC_ControllerCustomView *emptyView = [[BYC_ControllerCustomView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight - KHeightNavigationBar - KHeightTabBar) andNotificationObject:self];
    emptyView.imageUrl = @"img_kbzt_smdmy";
    return emptyView;
}

-(void)dealloc{
    [QNWSNotificationCenter removeObserver:self];
}


@end
