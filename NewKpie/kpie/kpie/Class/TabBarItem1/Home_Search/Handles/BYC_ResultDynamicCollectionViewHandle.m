//
//  BYC_ResultDynamicCollectionViewHandle.h
//  kpie
//  Created by 元朝 on 16/5/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ResultDynamicCollectionViewHandle.h"
#import "HL_FocusTableViewCell.h"
#import "HL_FocusTableViewHeader.h"

#import "NSString+BYC_Tools.h"
#import "BYC_MyCenterViewController.h"
#import "UIView+BYC_GetViewController.h"
#import "WX_VoideDViewController.h"
#import "BYC_ShareView.h"
#import "BYC_SearchViewController.h"
#import "UICollectionView+BYC_PlaceHolder.h"


#define Identifier_Item @"ResultDynamicCollectionViewCell"
#define CellHeight 482

@interface BYC_ResultDynamicCollectionViewHandle ()<UITableViewDelegate, UITableViewDataSource>

/**当前登录用户的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel  *userModel;
/**第几页数据*/
@property (nonatomic, assign) int            page;
/**数据*/
@property (nonatomic, strong)  NSArray<BYC_FocusListModel *> *array_Data;
/**回调*/
@property (nonatomic, strong)  ResultDynamicDataCountBlock  dataCountBlock;

@end

@implementation BYC_ResultDynamicCollectionViewHandle

- (instancetype)initResultDynamicCollectionViewHandle:(ResultDynamicDataCountBlock)dataCountBlock {
    
    self = [self init];
    if (self) {
        
        _dataCountBlock = dataCountBlock;
        [self initParameters];
        [self setupTableView];
    }
    
    return self;
}

- (void)initParameters {
    
    self.array_Data = [NSArray array];
    _userModel = [BYC_AccountTool userAccount];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(screenWidth, 0.f, screenWidth,screenHeight-KHeightNavigationBar-37) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HL_FocusTableViewCell class] forCellReuseIdentifier:@"focusCell"];
    
    __weak __typeof(self) weakSelf = self;
    //上拉加载
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉加载
        NSDictionary *dic_Parameters = @{@"page":[NSNumber numberWithInt:weakSelf.page++],@"rows":@"20",@"userid":weakSelf.userModel.userid ? weakSelf.userModel.userid : @"",@"keyWord": weakSelf.string_KeyWords};
        [weakSelf loadMoreData:dic_Parameters];
    }];
}

//上拉加载更多数据
- (void)loadMoreData:(NSDictionary *)parameters {
    
    [BYC_HttpServers Get:KQNWS_GetMatchVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *rows = responseObject[@"videoRows"];
        if (_dataCountBlock) _dataCountBlock([responseObject[@"videoTotal"] intValue]);
        if (rows.count == 0) {//无数据
            
            if ([_tableView.footer isRefreshing]) [_tableView.footer endRefreshingWithNoMoreData];//刷新状态下无数据
        }else {//有数据
            
            NSArray *arr_models = [BYC_FocusListModel initWithArray:rows];
            if ([_tableView.footer isRefreshing]) {//刷新状态下有数据
                
                NSMutableArray *marr = [NSMutableArray array];
                marr = [self.array_Data mutableCopy];
                [marr addObjectsFromArray:arr_models];
                self.array_Data = [marr copy];
                [_tableView.footer endRefreshing];
            }else self.array_Data = arr_models;
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIView alloc] showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        if ([_tableView.footer isRefreshing])[_tableView.footer endRefreshing];
    }];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
return self.array_Data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HL_FocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusCell"];
    cell.model = self.array_Data[indexPath.section];
    __weak __typeof(self) weakSelf = self;
    //初始化信号
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        cell.selectButton = ^(HL_FocusTableViewCellSelected selectButton ,BYC_FocusListModel *model){
            
            __block BYC_BackFocusListCellModel *backModel = nil;
            //点赞
            if (selectButton == HL_FocusTableViewCellSelectedLike) {
                
                [weakSelf clickButtonAction:selectButton model:model completion:^(BYC_BackFocusListCellModel *model) {
                    backModel = model;
                    dispatch_semaphore_signal(sema);
                }];
                //等待信号
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                return backModel;
            }else {
                
                [weakSelf clickButtonAction:selectButton model:model completion:nil];
                return backModel;
            }
        };
        
    });
    
    cell.clickHeaderButtonBlock = ^(BYC_FocusListModel *model){
        
        BYC_MyCenterViewController *myCenterVC = [[BYC_MyCenterViewController alloc] init];
        myCenterVC.userID = model.userID;
        [weakSelf.tableView.getBGViewController.navigationController pushViewController:myCenterVC animated:YES];
        
    };
//    if (indexPath.section%2 == 0) {
//        cell.button_Focus.hidden = NO;
//        cell.backgroundColor = KUIColorFromRGB(0xf0f0f0);
//        [cell.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(cell.mas_right).offset(-46);
//        }];
//    }
//    else{
        cell.button_Focus.hidden = YES;
        cell.backgroundColor = KUIColorFromRGB(0xFCFCFC);
        [cell.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.mas_right).offset(-12);
        }];
//    }
#pragma mark  ------点击播放按钮
    __block NSIndexPath *weakIndexPath = indexPath;
    __block HL_FocusTableViewCell *weakCell     = cell;
    __block BYC_FocusListModel * model = self.array_Data[indexPath.section];
    
    cell.clickPlayButtonBlock = ^(UIButton *btn){
        if (model.isVR == 1) {
            WX_VoideDViewController *videoVC = [[WX_VoideDViewController alloc]init];
            videoVC.isVR = YES;
            [videoVC receiveTheModelWith:self.array_Data WithNum:indexPath.section WithType:1];
            [weakSelf.tableView.getBGViewController.navigationController pushViewController:videoVC animated:YES];
        }
        else if(model.isVR == 0){
            weakSelf.playerView = [ZFPlayerView sharedPlayerView];
            NSURL *videoURL = [NSURL URLWithString:model.videoMP4];
            
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
        }else{
            //合拍
            
        }
        
    };
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HL_FocusTableViewCell returnCellHeightOfFocus:self.array_Data[indexPath.section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section%2 == 0) {
//        BYC_FocusListModel *model = self.array_Data[section];
//        return [HL_FocusTableViewHeader returnHeightOfFocusHeaderView:model];
//    }
//    else{
        return 0.1;
//    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    if (section%2 == 0) {
//        HL_FocusTableViewHeader *headerView = [[HL_FocusTableViewHeader alloc]initWithFrame:CGRectMake(0, 0, screenWidth, [HL_FocusTableViewHeader returnHeightOfFocusHeaderView:self.array_Data[section]])];
//        headerView.model = self.array_Data[section];
//        return headerView;
//    }
//    else{
        return nil;
//    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footerView.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    return footerView;
}

- (BOOL)clickButtonAction:(HL_FocusTableViewCellSelected)selectButton model:(BYC_FocusListModel *)model completion:(void(^)(BYC_BackFocusListCellModel *model))completion{
    
    switch (selectButton) {
        case HL_FocusTableViewCellSelectedLike:
        {
            
            NSString *url;
            NSDictionary *dic = @{@"token":[BYC_AccountTool userAccount].token,@"userid":[BYC_AccountTool userAccount].userid,@"userFavorites.userid":[BYC_AccountTool userAccount].userid , @"userFavorites.videoid" : model.videoID};
            if (model.isLike) url = KQNWS_RemoveUserFavorites;
            else url = KQNWS_SaveUserFavorites;
            
            [BYC_HttpServers Get:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSArray *resultArray = responseObject[@"rows"][0];
                
                BYC_BackFocusListCellModel *model = [[BYC_BackFocusListCellModel alloc] init];
                
                model.isOK      = ![responseObject[@"result"] integerValue];
                model.views     = [resultArray[0] integerValue];
                model.favorites = [resultArray[1] integerValue];
                model.comments  = [resultArray[2] integerValue];
                
                if (completion) completion(model);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [[UIView alloc] showAndHideHUDWithTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress];
                if (completion) completion(nil);
            }];
            
        }
            
            break;
        case HL_FocusTableViewCellSelectedComment:
        {
            
            WX_VoideDViewController *voideVC = [[WX_VoideDViewController alloc]init];
            voideVC.hidesBottomBarWhenPushed = YES;
            [voideVC receiveTheModelWith:@[model] WithNum:0 WithType:1];
            [_tableView.getBGViewController.navigationController pushViewController:voideVC animated:YES];
        }
            
            break;
        case HL_FocusTableViewCellSelectedForward:
        {
            
            [[BYC_ShareView alloc] showWithDelegateVC:(BYC_SearchViewController *)_tableView.getBGViewController shareContentOrMedia:BYC_ShareTypeMedia shareWithDic:@{@"mediaID":model.videoID,@"videoUserID":model.userID,@"mediaTitle":model.videoTitle,@"pictureJPG":model.pictureJPG}];
        }
            
            break;
        default:
            break;
    }
    
    return YES;
}

-(void)setString_KeyWords:(NSString *)string_KeyWords {
    
    if (_string_KeyWords != string_KeyWords) {
        
        _array_Data = @[];
        [_tableView reloadData];
    }
    
    int cou = 20;
    _page = 1;
    _string_KeyWords = string_KeyWords;
    _userModel = [BYC_AccountTool userAccount];
    NSString *str_count =  [NSString stringWithFormat:@"%d",_isLoginReloadData ? (int)self.array_Data.count : cou];
    NSDictionary *dic_Parameters = @{@"page":[NSNumber numberWithInt:_page++],@"rows":str_count,@"userid":self.userModel.userid ? self.userModel.userid : @"",@"keyWord": _string_KeyWords};
    [self loadMoreData:dic_Parameters];
}

@end
