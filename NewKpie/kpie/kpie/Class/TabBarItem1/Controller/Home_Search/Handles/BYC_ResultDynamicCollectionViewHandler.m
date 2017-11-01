//
//  BYC_ResultDynamicCollectionViewHandler.h
//  kpie
//  Created by 元朝 on 16/5/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ResultDynamicCollectionViewHandler.h"
#import "HL_FocusTableViewCell.h"
#import "HL_FocusTableViewHeader.h"

#import "NSString+BYC_Tools.h"
#import "HL_CenterViewController.h"
#import "UIView+BYC_GetViewController.h"
#import "WX_VoideDViewController.h"
#import "BYC_ShareView.h"
#import "BYC_SearchViewController.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import "BYC_HttpServers+FocusVC.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_HttpServers+HL_VideoPlayVC.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_ControllerCustomView.h"

#import "BYC_BaseVideoModel.h"
#import "HL_FocusArrModel.h"
#import "BYC_HttpServers+BYC_Search.h"

#define Identifier_Item @"ResultDynamicCollectionViewCell"
#define CellHeight 482

@interface BYC_ResultDynamicCollectionViewHandler ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

/**当前登录用户的个人信息*/
@property (nonatomic, strong)  BYC_AccountModel  *userModel;
/**第几页数据*/
@property (nonatomic, assign) int            page;
/**数据*/
@property (nonatomic, strong)  NSMutableArray<BYC_BaseVideoModel *> *array_Data;
/**回调*/
@property (nonatomic, strong)  ResultDynamicDataCountBlock  dataCountBlock;

@end

@implementation BYC_ResultDynamicCollectionViewHandler

- (instancetype)initResultDynamicCollectionViewHandle:(ResultDynamicDataCountBlock)dataCountBlock {
    
    self = [self init];
    if (self) {
        
        _dataCountBlock = dataCountBlock;
        [self initParameters];
        [self setupTableView];
    }
    
    return self;
}

-(NSMutableArray *)array_Data{
    if (!_array_Data) {
        _array_Data = [NSMutableArray array];
    }
    return _array_Data;
}

- (void)initParameters {
    _userModel = [BYC_AccountTool userAccount];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(screenWidth, 0.f, screenWidth,screenHeight-KHeightNavigationBar-37) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HL_FocusTableViewCell class] forCellReuseIdentifier:@"focusCell"];
    
    __weak __typeof(self) weakSelf = self;
    //上拉加载
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉加载
        BYC_BaseVideoModel *model = [weakSelf.array_Data lastObject];
        NSDictionary *dic_Parameters = @{@"time" :model.onmstime, @"videoId":model.videoid , @"upType": @2, @"userId":weakSelf.userModel.userid, @"keyWord": weakSelf.string_KeyWords};
        [weakSelf loadMoreData:dic_Parameters];
    }];
}

//上拉加载更多数据
- (void)loadMoreData:(NSDictionary *)parameters {
    
    [BYC_HttpServers requestSearchVideoListDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *arrModels, NSInteger total) {

        if (_dataCountBlock) _dataCountBlock(total);
        if (arrModels.count == 0) {//无数据
            
            if ([_tableView.footer isRefreshing]) [_tableView.footer endRefreshingWithNoMoreData];//刷新状态下无数据
        }else {//有数据
            
            if ([_tableView.footer isRefreshing]) {//刷新状态下有数据
                
                [self.array_Data addObjectsFromArray:arrModels];

                [_tableView.footer endRefreshing];
            }else self.array_Data = [arrModels mutableCopy];
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    __weak __typeof(cell) weakCell = cell;
    //初始化信号
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        cell.selectButton = ^(HL_FocusTableViewCellSelected selectButton ,BYC_BaseVideoModel *model){
            [weakSelf clickButtonAction:selectButton model:model andWithIindextPath:indexPath andWithCell:weakCell];
        };
        
    });
    
    cell.clickHeaderButtonBlock = ^(BYC_BaseVideoModel *model){
        
        HL_CenterViewController *myCenterVC = [[HL_CenterViewController alloc] init];
        myCenterVC.str_ToUserID = model.userid;
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
    __block BYC_BaseVideoModel * model = self.array_Data[indexPath.section];
    
    cell.clickPlayButtonBlock = ^(UIButton *btn){
        if (model.isvr == 1) {
            WX_VoideDViewController *videoVC = [[WX_VoideDViewController alloc]init];
            videoVC.isVR = YES;
            [videoVC receiveTheModelWith:self.array_Data WithNum:indexPath.section WithType:1];
            [weakSelf.tableView.getBGViewController.navigationController pushViewController:videoVC animated:YES];
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
            [weakSelf videoClicks:model];
        }
    };
    self.playerView.getVideoViewsBlock = ^{
        [weakSelf videoClicks:model];
    };
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HL_FocusTableViewCell returnCellHeightOfFocus:self.array_Data[indexPath.section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section%2 == 0) {
//        BYC_BaseVideoModel *model = self.array_Data[section];
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

- (void)clickButtonAction:(HL_FocusTableViewCellSelected)selectButton model:(BYC_BaseVideoModel *)model andWithIindextPath:(NSIndexPath *)indexPath andWithCell:(HL_FocusTableViewCell *)cell{
    
    switch (selectButton) {
        case HL_FocusTableViewCellSelectedShoot:{//合拍
            [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
        }
            break;
        case HL_FocusTableViewCellSelectedLike://点赞
        {
            if (model.isfavor) {//取消点赞
                NSArray *array_UnLikeParam = @[[BYC_AccountTool userAccount].userid,model.videoid,@"1"];
                [self requestOfSaveFavorites:array_UnLikeParam andWithType:1 andWithIindextPath:indexPath andWithCell:cell];
            }else {//点赞
                NSArray *array_LikeParam = @[[BYC_AccountTool userAccount].userid,model.videoid,@"0"];
                [self requestOfSaveFavorites:array_LikeParam andWithType:0 andWithIindextPath:indexPath andWithCell:cell];
            }
        }
            
            break;
        case HL_FocusTableViewCellSelectedComment:{
            
            [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:YES andFromType:ENU_FromOtherVideo];
        }
            
            break;
        case HL_FocusTableViewCellSelectedForward:{
            
            [[BYC_ShareView alloc] showWithDelegateVC:(BYC_SearchViewController *)_tableView.getBGViewController shareContentOrMedia:BYC_ShareTypeMedia shareWithDic:@{const_ShareResourceID:model.videoid,const_ShareUserID:model.userid,const_ShareResourceTitle:model.videotitle,const_ShareResourceImage:model.picturejpg}];
        }
            
            break;
        default:
            break;
    }
}

-(void)setString_KeyWords:(NSString *)string_KeyWords {
    
    if (_string_KeyWords != string_KeyWords) {
        
        _array_Data = nil;
        [_tableView reloadData];
    }

    _string_KeyWords = string_KeyWords;
    _userModel = [BYC_AccountTool userAccount];
    NSDictionary *dic_Parameters = @{@"time" : @"", @"videoId":@"", @"upType": @0,  @"keyWord": _string_KeyWords, @"userId":self.userModel.userid};
    [self loadMoreData:dic_Parameters];
}

#pragma mark ---------点赞/取消点赞
-(void)requestOfSaveFavorites:(id)params andWithType:(NSInteger)type andWithIindextPath:(NSIndexPath *)indexPath andWithCell:(HL_FocusTableViewCell *)cell{
    [BYC_HttpServers requestFocusVCSaveUserFavoritesWithParameters:params andWithType:type success:^(BOOL isSuccess) {
        NSInteger likes = [cell.button_like.titleLabel.text integerValue] >= 0 ? [cell.button_like.titleLabel.text integerValue] : 0;
        BYC_BaseVideoModel *model = self.array_Data[indexPath.section];
        if (type == 0) {//点赞
            [cell.button_like setImage:[UIImage imageNamed:@"dongtai_btn_zan_h"] forState:UIControlStateNormal];
            cell.button_like.selected = YES;
            model.isfavor = YES;
            likes += 1;
            model.favorites = likes;
        }
        else if (type == 1){//取消点赞
            [cell.button_like setImage:[UIImage imageNamed:@"dongtai_btn_zan_n"] forState:UIControlStateNormal];
            cell.button_like.selected = NO;
            model.isfavor = NO;
            likes -= 1;
            model.favorites = likes;
        }
        [self.array_Data replaceObjectAtIndex:indexPath.section withObject:model];
        [cell.button_like setTitle:[NSString stringWithFormat:@"%ld",(long)likes] forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

/***  视频点击量 */
-(void)videoClicks:(BYC_BaseVideoModel *)focusModel{
    NSArray *arr = @[focusModel.videoid];
    [BYC_HttpServers requestVideoPlayVCPlayedCountWithParameters:arr Success:^{
//        NSDictionary *dic_Parameters = @{@"time" : @"", @"videoId":@"", @"upType": @0, @"userId":self.userModel.userid, @"keyWord": _string_KeyWords};
//        [self loadMoreData:dic_Parameters];
    } failure:^{
    }];
}

#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"img_kbzt_wssdxgnr"];
    return image;
}


@end
