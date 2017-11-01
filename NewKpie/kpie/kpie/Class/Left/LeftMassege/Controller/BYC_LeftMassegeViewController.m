//
//  BYC_LeftMassegeViewController.m
//  kpie
//
//  Created by 元朝 on 15/12/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LeftMassegeViewController.h"
#import "BYC_LeftMassegeVCCell.h"
#import "BYC_LeftNotificationCell.h"
#import "BYC_LeftMassegeModel.h"
#import "HL_CenterViewController.h"
#import "BYC_LeftNotificationModel.h"
#import "DateFormatting.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_LeftNotificationCell2.h"
#import "NSString+BYC_Tools.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_ControllerCustomView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_HttpServers+HL_MassageAndNoticeVC.h"
#import "BYC_JumpToVCHandler.h"
#import "BYC_HttpServers+HL_VideoPlayVC.h"
#import "WX_ShootingScriptViewController.h"
#import "BYC_HttpServers+WX_VideoPushRequest.h"


#define YC_NotPromptTextOfLeftNotification @"暂无通知"

#define BYC_LeftMassegeVCCellDefaultContentLabelSize CGSizeMake(screenWidth - 70, 12)//有回复的label的默认一行状态下的尺寸
#define BYC_LeftMassegeVCCellDefaultToContentLabelSize CGSizeMake(screenWidth - 70, 15)//有评论的label的默认一行状态下的尺寸
#define BYC_LeftMassegeVCCellDefaultSize CGSizeMake(screenWidth, 110)//有回复和评论的cell都是文字的默认状态下的尺寸
#define BYC_LeftMassegeVCCellCommentDefaultSize CGSizeMake(screenWidth, 137)//回复是音频默认状态下的尺寸
#define BYC_LeftMassegeVCCellReplyDefaultSize CGSizeMake(screenWidth, 120)//评论是音频默认状态下的尺寸
#define BYC_LeftMassegeVCCellCommentAndReplyDefaultSize CGSizeMake(screenWidth, 167)//回复和评论都是音频默认状态下的尺寸
#define BYC_LeftMassegeVCCellDefaultVideoHightSize CGSizeMake(screenWidth - 70, 45)//有回复和评论的cell的默认状态下的尺寸

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeMassege,         //消息请求
    RequestTypeNotification,     //通知请求
    RequestTypeMassegeRead,      //消息已读请求
    RequestTypeNotificationRead  //通知已读请求
};

@interface BYC_LeftMassegeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)  BYC_LeftMassegeModel *massegeReloadModel;
@property (nonatomic, strong)  BYC_LeftMassegeModel *notificationReloadModel;
@property (nonatomic, assign)  int massegeWhereType;
//@property (nonatomic, assign)  int notificationWhereType;

/**消息模型数组*/
@property (nonatomic, strong)  NSMutableArray  *massegeCellArrayModels;
/**通知模型数组*/
@property (nonatomic, strong)  NSMutableArray  *notificationCellArrayModels;
/**消息collection*/
@property (nonatomic, strong)  UICollectionView *massegeCollectionView;
/**通知collection*/
@property (nonatomic, strong)  UICollectionView *notificationCollectionView;
/**没有消息的遮罩*/
@property (nonatomic, strong)  UIView  *view_MaskMassege;
/**没有通知的遮罩*/
@property (nonatomic, strong)  UIView  *view_MaskNotification;


@property (nonatomic, strong)  UISegmentedControl *segmentedControl;
/**底部滑动视图*/
@property (nonatomic, strong)  UIScrollView  *scrollView;

/**第几页数据*/
@property (nonatomic, assign) __block int  pageNotification;
@end

@implementation BYC_LeftMassegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"消息",@"通知",nil];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(0,7,159,30);
    // 设置默认选择项索引
    if (_isFrmeRemoteNotification) {
        
        _segmentedControl.selectedSegmentIndex = 1;
    }else {
    
        _segmentedControl.selectedSegmentIndex = 0;
    }
    _segmentedControl.tintColor = KUIColorBackgroundModule2;
     [_segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
    
    QNWSLog(@"nav == %@ self.navigationItem == %@ ",self.navigationController,self.navigationItem);
    
    //初始化Cell
    [self makeUI];
    self.pageNotification = 0;
    //加载通知数据
    [self loadData:nil RequestType:RequestTypeNotification];

    //加载消息数据
    [self loadData:nil RequestType:RequestTypeMassege];

}

-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
}

#pragma mark - 布局视图
-(void)makeUI
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64)];
    _scrollView.contentSize = CGSizeMake(screenWidth * 2 , 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    if (_isFrmeRemoteNotification) {
        
        _scrollView.contentOffset = CGPointMake(screenWidth, 0);
    }else {
    
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    //设置布局
    UICollectionViewFlowLayout *layoutMassege = [[UICollectionViewFlowLayout alloc] init];
    layoutMassege.minimumInteritemSpacing = .5f;
    layoutMassege.minimumLineSpacing = 0.f;
    [layoutMassege setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //创建UICollectionView
    _massegeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, screenWidth,_scrollView.kheight)  collectionViewLayout:layoutMassege];
    _massegeCollectionView.dataSource = self;
    _massegeCollectionView.delegate = self;
    _massegeCollectionView.emptyDataSetSource = self;
    _massegeCollectionView.emptyDataSetDelegate = self;
    _massegeCollectionView.backgroundColor = KUIColorFromRGB(0xFFFFFF);
    _massegeCollectionView.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:_massegeCollectionView];
    
    [_massegeCollectionView registerNib:[UINib nibWithNibName:@"BYC_LeftMassegeVCCell" bundle:nil] forCellWithReuseIdentifier:@"leftMassegeVCCell"];

    
    __weak __typeof(self) weakSelf = self;
    self.massegeCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.massegeWhereType = 1;
        weakSelf.massegeReloadModel = (BYC_LeftMassegeModel *)[weakSelf.massegeCellArrayModels firstObject];
        [weakSelf loadData:weakSelf.massegeReloadModel RequestType:RequestTypeMassege];
    }];
    
    self.massegeCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.massegeWhereType = 2;
        weakSelf.massegeReloadModel = (BYC_LeftMassegeModel *)[weakSelf.massegeCellArrayModels lastObject];
        [weakSelf loadData:weakSelf.massegeReloadModel RequestType:RequestTypeMassege];
    }];
    
    //设置布局
    UICollectionViewFlowLayout *layoutNotification = [[UICollectionViewFlowLayout alloc] init];
    layoutNotification.minimumInteritemSpacing = .5f;
    layoutNotification.minimumLineSpacing = 0.f;
    [layoutNotification setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //创建UICollectionView
    _notificationCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth,_scrollView.kheight)  collectionViewLayout:layoutNotification];
    _notificationCollectionView.dataSource = self;
    _notificationCollectionView.delegate = self;
    _notificationCollectionView.backgroundColor = [UIColor clearColor];
    _notificationCollectionView.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:_notificationCollectionView];
    
    [_notificationCollectionView registerNib:[UINib nibWithNibName:@"BYC_LeftNotificationCell" bundle:nil] forCellWithReuseIdentifier:@"leftNotificationCell"];
    [_notificationCollectionView registerNib:[UINib nibWithNibName:@"BYC_LeftNotificationCell2" bundle:nil] forCellWithReuseIdentifier:@"leftNotificationCell2"];
    
    self.notificationCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNotification = 2;
        weakSelf.notificationReloadModel = [weakSelf.notificationCellArrayModels lastObject];
        [weakSelf loadData: weakSelf.notificationReloadModel RequestType:RequestTypeNotification];
    }];
}

#pragma mark - 网络请求
- (void)loadData:(BYC_LeftMassegeModel *)model RequestType:(RequestType)requestType{

    //精选数据
    NSDictionary *dic;
    if (requestType == RequestTypeMassege) {
    
        if (model) {
            
            dic = @{@"upType": @(self.massegeWhereType),@"userId":[BYC_AccountTool userAccount].userid,@"commentId":model.commentid,@"postdatetime":model.postdatetime};
        }else {
            
            dic = @{@"upType":@0,@"userId":[BYC_AccountTool userAccount].userid};
        }
    }else {//通知
        dic = @{@"userId":[BYC_AccountTool userAccount].userid,@"upType":@(self.pageNotification),@"createDate":model == nil ? @"" : model.createdate,@"userType":[NSNumber numberWithInteger:[BYC_AccountTool userAccount].usertype]};
    }
    
    [self requestDataWithRequestType:requestType parameters:dic];
}

- (void)requestDataWithRequestType:(RequestType)RequestType parameters:(id)parameters{
    
    switch (RequestType) {
        case RequestTypeMassege:
        {
            [BYC_HttpServers requestMassageDataWithParameters:parameters success:^(NSMutableArray<BYC_LeftMassegeModel *> *arr_massageModel) {
                if (self.massegeCollectionView.footer.isRefreshing) {
                    if (arr_massageModel.count >0 ) {
                        [_massegeCellArrayModels addObjectsFromArray:arr_massageModel];
                        // 结束刷新
                        [self.massegeCollectionView.footer endRefreshing];
                    }
                    else{
                        [self.massegeCollectionView.footer endRefreshingWithNoMoreData];
                    }
                }
                else if (self.massegeCollectionView.header.isRefreshing){
                    if (arr_massageModel.count > 0) {
                        [_massegeCellArrayModels addObjectsFromArray:arr_massageModel];
                    }
                    else {
                        _massegeCellArrayModels = self.massegeCellArrayModels;
                        
                    }
                    [self.massegeCollectionView.header endRefreshing];
                }
                else{
                   _massegeCellArrayModels = arr_massageModel;
                    [self.massegeCollectionView.footer endRefreshing];
                }
                
                [_massegeCollectionView reloadData];
                
                //清空红点标记
                [self requestDataWithRequestType:RequestTypeMassegeRead parameters:@[[BYC_AccountTool userAccount].userid]];
            } failure:^(NSError *error) {
                if (self.massegeCollectionView.header.isRefreshing) {
                    [self.massegeCollectionView.header endRefreshing];
                }
                if (self.massegeCollectionView.footer.isRefreshing) {
                    [self.massegeCollectionView.footer endRefreshing];
                }
                
            }];
        }
            break;
        case RequestTypeNotification:
        {
            [BYC_HttpServers requestNotificationDataWithParameters:parameters success:^(NSMutableArray<BYC_LeftNotificationModel *> *arr_massageModel) {
                if (self.notificationCollectionView.footer.isRefreshing) {
                    if (arr_massageModel.count >0 ) {
                        [_notificationCellArrayModels addObjectsFromArray:arr_massageModel];
                        // 结束刷新
                        [self.notificationCollectionView.footer endRefreshing];
                    }
                    else{
                        [self.notificationCollectionView.footer endRefreshingWithNoMoreData];
                    }
                }
                else if (self.notificationCollectionView.header.isRefreshing){
                    if (arr_massageModel.count > 0) {
                        [_notificationCellArrayModels addObjectsFromArray:arr_massageModel];
                    }
                    else {
                    _notificationCellArrayModels = arr_massageModel;
                    
                    }
                    [self.notificationCollectionView.header endRefreshing];
                }
                else {
                    _notificationCellArrayModels = arr_massageModel;
                    [self.notificationCollectionView.footer endRefreshing];
                }
                [_notificationCollectionView reloadData];
                [self requestDataWithRequestType:RequestTypeNotificationRead parameters:@[KSTR_KDeviceToken]];
            } failure:^(NSError *error) {
                if (self.notificationCollectionView.footer.isRefreshing) {
                    // 变为没有更多数据的状态
                    [self.notificationCollectionView.footer endRefreshingWithNoMoreData];
                }
                if (self.notificationCollectionView.header.isRefreshing) {
                    [self.notificationCollectionView.header endRefreshing];
                }
                
            }];
        }
            break;
        case RequestTypeMassegeRead:
        {
        [BYC_HttpServers requestMassageReadDataWithParameters:parameters success:nil failure:nil];
        }
            break;
        case RequestTypeNotificationRead:
        {
            [BYC_HttpServers requestNotificationReadDataWithParameters:parameters success:nil failure:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - collection的DataSource 和 Delegate方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return collectionView == _massegeCollectionView ? _massegeCellArrayModels.count : _notificationCellArrayModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    __weak __typeof(self) weakSelf = self;
    if (collectionView == _massegeCollectionView) {//消息
        
        BYC_LeftMassegeVCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"leftMassegeVCCell" forIndexPath:indexPath];
        cell.model = _massegeCellArrayModels[indexPath.row];
        cell.clickButtonBlock = ^(ClickButtonBlockType clickButtonBlockFlag ,BYC_LeftMassegeModel *model){
            
            if (clickButtonBlockFlag == ClickButtonBlockReply) {
                
                // 评论- 到视频详情界面
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.video.isvr andisComment:YES andFromType:ENU_FromLeftMessageVideo];
            }
            if (clickButtonBlockFlag == ClickButtonBlockHeader) {
                
                // 评论- 到个人中心
                HL_CenterViewController *myCenterVC = [[HL_CenterViewController alloc] init];
                myCenterVC.str_ToUserID = model.users.userid;
                [weakSelf.navigationController pushViewController:myCenterVC animated:YES];
            }
            if (clickButtonBlockFlag == ClickButtonBlockLook) {
                
                // 评论- 到视频详情界面
                [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.video.isvr andisComment:YES andFromType:ENU_FromLeftMessageVideo];
            }
        };
        return cell;
    }else {//通知
        
        BYC_LeftNotificationModel *model = _notificationCellArrayModels[indexPath.row];
        
//        if (model.type == 1 || model.type == 3) {//视频
//           BYC_LeftNotificationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"leftNotificationCell" forIndexPath:indexPath];
//         cell.model = model;
//            cell.clickLeftNotificationCellButtonBlock = ^(ClickLeftNotificationCellButtonBlockType clickButtonBlockFlag ,BYC_LeftNotificationModel *model){
//                
//                if (clickButtonBlockFlag == ClickLeftNotificationCellButtonBlockReply) {
//                    // 评论- 到视频详情界面
//                    [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.video.isvr andisComment:YES andFromType:ENU_FromLeftMessageVideo];
//                }
//                if (clickButtonBlockFlag == ClickLeftNotificationCellButtonBlockHeader) {
//                    
//                    // 评论- 到个人中心
//                    HL_CenterViewController *myCenterVC = [[HL_CenterViewController alloc] init];
//                    myCenterVC.str_ToUserID = model.video.users.userid;
//                    [weakSelf.navigationController pushViewController:myCenterVC animated:YES];
//                }
//            };
//            return cell;
//        }else {//非名师点评的内容
            BYC_LeftNotificationCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"leftNotificationCell2" forIndexPath:indexPath];
            cell.model = model;
//            cell.clickHeaderAction = ^(){
//                // 评论- 到个人中心
//                HL_CenterViewController *myCenterVC = [[HL_CenterViewController alloc] init];
//                myCenterVC.str_ToUserID = model.users.userid;
//                [weakSelf.navigationController pushViewController:myCenterVC animated:YES];
//            };
            return cell;
//        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (collectionView == _massegeCollectionView) {
        
//        QNWSLog(@"消息");
            return [self reloadItemSize:_massegeCellArrayModels[indexPath.row]];
    }else {
        
        BYC_LeftMassegeModel *notifModel = _notificationCellArrayModels[indexPath.row];
        if (notifModel.type == 1 || notifModel.type == 3) {
           return CGSizeMake(screenWidth, 231);
        }
        else{
          return CGSizeMake(screenWidth, [self returnCellHeightOfFocus:notifModel]+160);
        }
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (collectionView == _massegeCollectionView) {
        
//        QNWSLog(@"消息");

    }else {
//        model.type
//        ENUM_GoType_Video   =   1,      /*<    跳转类型_视频 **/
//        ENUM_GoType_Column  =   2,      /*<    跳转类型_栏目 **/
//        ENUM_GoType_Script  =   3,      /*<    跳转类型_剧本合拍 **/
//        ENUM_GoType_InStep  =   4,      /*<    跳转类型_视频合拍 **/
//        ENUM_GoType_WebView =   5,      /*<    跳转类型_网址 **/

        
     BYC_LeftNotificationModel *model = _notificationCellArrayModels[indexPath.row];
        switch (model.type) {
            case 1://视频
            {
                [self WX_GoToVideoPageWithVideoID:model.videoid ENUM_VideoType:ENUM_VideoType_NormalVideo];
            }
                break;
            case 2://栏目
            {
                [BYC_JumpToVCHandler jumpToColumnWithColumnId:model.videoid];
            }
                break;
            case 3://剧本合拍
            {
                [self WX_GoToVideoPageWithVideoID:model.videoid ENUM_VideoType:ENUM_VideoType_Scripte];
            }
                break;
            case 4://视频合拍
            {
                [self WX_GoToVideoPageWithVideoID:model.videoid ENUM_VideoType:ENUM_VideoType_JoinShooting];
            }
                break;
            case 5://网址
            {
                [BYC_JumpToVCHandler jumpToWebWithUrl:model.videoid];
            }
                break;
            default:
                break;
        }
    }
    
}
/// 跳转到视频__视频播放/剧本合拍
- (void)WX_GoToVideoPageWithVideoID:(NSString*)videoID ENUM_VideoType:(ENUM_VideoType)videoType
{
    [BYC_HttpServers WX_RequestVideoPushWithVideoID:@[videoID] ENUM_PushType:videoType == ENUM_VideoType_Scripte ? ENUM_VideoPushType_Script:ENUM_VideoPushType_Video success:^(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *video_Model) {
        
        [HL_JumpToVideoPlayVC jumpToVCWithModel:video_Model[0]
                                   andVideoTepy:videoType andisComment:videoType == ENUM_VideoType_JoinShooting ?NO:YES
                                    andFromType:ENU_FromOtherVideo];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)getScriptDetail:(NSArray *)arr_parameters{
    [BYC_HttpServers requestVideoPlayVCscriptModelOnNetWithParameters:arr_parameters success:^(WX_ScriptModel *scriptModel) {
        WX_ShootingScriptViewController *scriptVC = [[WX_ShootingScriptViewController alloc]init];
        scriptVC.videoD_ScriptModel = scriptModel;
        [self.navigationController pushViewController:scriptVC animated:YES];
    } failure:^(NSError *error) {        
    }];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (_scrollView == scrollView) {
        
        _segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x / screenWidth;
    }
    
}

#pragma mark - UISegmentedControlDelegate
-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 1:
            [_scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
            break;
        default:
            break;
    }
}

-(CGFloat)returnCellHeightOfFocus:(BYC_LeftMassegeModel *)model{
    if (model.content.length > 0) {
        CGRect descripRect = [model.content boundingRectWithSize:CGSizeMake(screenWidth-34,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}context:nil];
        return descripRect.size.height;
    }
    else return 10;
}


//计算cell尺寸 size
- (CGSize)reloadItemSize:(BYC_LeftMassegeModel *)model {

    NSString *contentString;
    NSString *toContentString;
    CGFloat toContentSizeHeight;
    CGFloat contentSizeHeight;
    CGSize defaultSize;
    
    if (!model.isvoice) {//评论和回复都不是语音
        
        if (model.content.length > 0) {
            
            NSRange rangeToContent = [model.content rangeOfString:@":"]; //现获取要截取的字符串位置
            NSString *resultToContent;
            if (rangeToContent.length > 0) {
                
                resultToContent = [model.content substringFromIndex:rangeToContent.location + 1]; //截取字符串
            }else {
            
                resultToContent = model.content;
            }
            toContentString = resultToContent;
            contentString = [NSString stringWithFormat:@"%@: %@",@"回复了你的评论",model.content];
        }else {
            
            toContentString = model.content;
            contentString = @"评论了你的视频";
        }

        toContentSizeHeight = [toContentString sizeWithfont:15 boundingRectWithSize:CGSizeMake(BYC_LeftMassegeVCCellDefaultToContentLabelSize.width, MAXFLOAT)].height;
        contentSizeHeight = [contentString sizeWithfont:12 boundingRectWithSize:CGSizeMake(BYC_LeftMassegeVCCellDefaultContentLabelSize.width, MAXFLOAT)].height;
        defaultSize = CGSizeMake(screenWidth, BYC_LeftMassegeVCCellDefaultSize.height + (toContentSizeHeight - BYC_LeftMassegeVCCellDefaultToContentLabelSize.height + contentSizeHeight - BYC_LeftMassegeVCCellDefaultContentLabelSize.height));
    }else {//必有其中一个有语音
    
        if (model.content.length > 0) {//有回复
        
            if (model.isvoice) {//评论是语音
                
                model.label_CommentContentHeight = 0;
//                if (model.isvoice) {//回复也是语音
                    defaultSize = BYC_LeftMassegeVCCellReplyDefaultSize;
                
                    model.label_CommentToContentHeight = 25;
//                }
//                else {//回复是文本
//                    defaultSize = BYC_LeftMassegeVCCellReplyDefaultSize;
//                    NSRange rangeToContent = [model.content rangeOfString:@":"]; //现获取要截取的字符串位置
//                    NSString *resultToContent = [model.content substringFromIndex:rangeToContent.location + 1]; //截取字符串
//                    toContentString = resultToContent;
//                    toContentSizeHeight = [toContentString sizeWithfont:15 boundingRectWithSize:CGSizeMake(BYC_LeftMassegeVCCellDefaultToContentLabelSize.width, MAXFLOAT)].height;
//                    defaultSize.height = defaultSize.height + toContentSizeHeight - BYC_LeftMassegeVCCellDefaultToContentLabelSize.height;
//                    model.label_CommentToContentHeight = toContentSizeHeight - 15;
//                }
            }
//            else {//评论是文本，回复是语音
//                defaultSize = BYC_LeftMassegeVCCellCommentDefaultSize;
//                toContentSizeHeight = BYC_LeftMassegeVCCellDefaultVideoHightSize.height;
//                contentString = [NSString stringWithFormat:@"%@: %@",@"回复了你的评论",model.content];
//                contentSizeHeight = [contentString sizeWithfont:12 boundingRectWithSize:CGSizeMake(BYC_LeftMassegeVCCellDefaultContentLabelSize.width, MAXFLOAT)].height;
//                defaultSize.height = defaultSize.height + contentSizeHeight - BYC_LeftMassegeVCCellDefaultContentLabelSize.height;
//                model.label_CommentContentHeight = contentSizeHeight - 12;
//                model.label_CommentToContentHeight = 45;
//            }
        }
//        else {//无回复
//            defaultSize = BYC_LeftMassegeVCCellCommentDefaultSize;
//            toContentSizeHeight = BYC_LeftMassegeVCCellDefaultVideoHightSize.height;
//            contentString = @"评论了你的视频";
//            contentSizeHeight = [contentString sizeWithfont:12 boundingRectWithSize:CGSizeMake(BYC_LeftMassegeVCCellDefaultContentLabelSize.width, MAXFLOAT)].height;
//            defaultSize.height = defaultSize.height + contentSizeHeight - BYC_LeftMassegeVCCellDefaultContentLabelSize.height;
//            model.label_CommentContentHeight = contentSizeHeight - 12;
//            model.label_CommentToContentHeight = 45;
//        }
    }
    
   return  defaultSize;
}
#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"img_kbzt_meiyouxiaox"];
    return image;
}


-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -50;
}

@end
