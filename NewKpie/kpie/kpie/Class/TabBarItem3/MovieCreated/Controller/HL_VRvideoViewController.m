//
//  HL_VRvideoViewController.m
//  kpie
//
//  Created by sunheli on 16/9/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_VRvideoViewController.h"

#import "AFNetworking.h"
#import "BYC_HomeViewControllerModel.h"
#import "WX_CommentsTableViewCell.h"
#import "BYC_CommonViewController.h"
#import "BYC_LoginAndRigesterView.h"
#import "BYC_MyCenterViewController.h"
#import "WX_CommentModel.h"
#import "BYC_UMengShareTool.h"
#import "BYC_AccountTool.h"
#import "WX_FMDBManager.h"
#import "WX_AVplayer.h"
#import "MBProgressHUD.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "DateFormatting.h"

#import "NSString+BYC_HaseCode.h"
#import "BYC_AliyunOSSUpload.h"
#import "EMAudioPlayerUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "WX_RandomVideoModel.h"
#import "IQKeyboardManager.h"
#import "BYC_ShareView.h"

#import "EMCDDeviceManager.h"
#import "BYC_KeyboardContent.h"
#import "BYC_KeyboardToolBar.h"
#import "BYC_DeleteEmojiStringName.h"
#import "WX_ShootingScriptViewController.h"
#import "WX_ScriptModel.h"
#import "BYC_MainNavigationController.h"

#import <UtoVRPlayer/UtoVRPlayer.h>
#import <ZFPlayer.h>
#import "VRplayerView.h"
#import "HL_VideodetailView.h"
#import "HL_RecommendView.h"
#import "BYC_FocusListModel.h"
#import "HL_VideoDetailBottomView.h"
#import "BYC_MainNavigationController.h"
#import "WX_JoinShootingViewController.h"
#import "WX_GeekViewController.h"
#import "HL_LikeModel.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_HttpServers+FocusVC.h"
#import "BYC_HttpServers+HL_VideoPlayVC.h"

#define TableViewCellHeight  70
#define KVOContent PopGestureRecognizer
//// 每一页的评论数
#define KCOMMENTS_OF_PAGE 40
static NSString *url_ZFPlayer;
static NSString *url_VRPlayer;

@interface HL_VRvideoViewController ()<UMSocialUIDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIAlertViewDelegate ,BYC_KeyboardToolBarDelegate,UIApplicationDelegate,UVPlayerDelegate,VRPlayerViewDelegate,ClickVideodetailBottomViewButtonDelegate>
{
    NSString                    *_voicePath;
    NSString                    *_objectKey;
    
    BOOL                       _wasKeyboardManagerEnabled;
}
@property(nonatomic,strong) CAGradientLayer *shareLayer;
@property (nonatomic) BOOL isChatGroup;
@property(nonatomic, strong) NSArray                                      *arrayModel;
@property(nonatomic, assign) NSInteger                                    num;
@property(nonatomic, strong) UIView                                       *playerBGView;
@property(nonatomic, copy)   NSString                                     *mediaID;
//@property(nonatomic, strong) BYC_HomeViewControllerModel                  *model;
@property(nonatomic, strong) BYC_FocusListModel                           *focusListModel;
@property(nonatomic, strong) WX_FMDBManager                               *manager;
@property(nonatomic, assign) BOOL                                         isEndToPlay;
@property(nonatomic, strong) UIView                                       *shareView;
@property(nonatomic, assign) CGFloat                                      keyboardHeight;               /**< 键盘高度 */

@property(nonatomic, strong) UIImageView                                  *backImgView;                 /**< 视频背景图片 */
@property(nonatomic, strong) NSMutableArray                               *dataArray;                   /**< 全部评论 */
@property(nonatomic, strong) NSMutableArray                               *userArray;                   /**< 用户评论 */
@property(nonatomic, strong) NSMutableArray                               *teacherArray;                /**< 名师评论 */

@property(nonatomic, strong) UILabel                                      *commentsLabel;
@property(nonatomic, strong) UITableView                                  *commentTableView;
@property(nonatomic, assign) NSInteger                                    textFont;                     /**< 字体大小 */

@property(nonatomic, copy)   NSString                                     *placeHolder;                   /**< 提示文字 */
@property(nonatomic, strong) UIView                                       *backView;                      /**< 上方变暗视图 */
@property(nonatomic, copy)   NSString                                     *commentsStr;                   /**< 需要上传的评论 */
@property(nonatomic, assign) NSInteger                                    toCommentIdNum;

@property(nonatomic, assign) BOOL                                         isVoice;                        /**< 发送语音 */
@property(nonatomic, assign) NSInteger                                    voiceLength;                    /**< 语音时长 */
@property(nonatomic, strong) NSData                                       *voiceData;                     /**< 语音文件 */

@property(nonatomic, assign) BOOL                                         isFromLeftMessage;              /**< 消息界面跳出  */
@property(nonatomic, assign) BOOL                                         isFormLeftLike;                 /**< 喜欢界面跳出 */

@property(nonatomic, assign) BOOL                                         isToComment;                    /**< 回复评论 */
@property(nonatomic, assign) NSInteger                                    keyboardHeigh;
@property(nonatomic, strong) BYC_LeftMassegeModel                         *leftMessageModel;              /**< 消息界面,模型 */
@property(nonatomic, strong) BYC_LeftLikeModel                            *leftLikeModel;                 /**< 喜欢界面,模型 */

@property(nonatomic, strong) HL_RecommendView                             *videoView;                     /**< 视频播放后显示界面 */

@property(nonatomic, strong) NSMutableArray                               *randomArray;                   /**< 相关视频数组 */
@property(nonatomic, assign) BOOL                                         isFavorite;                     /**< 记录是否赞过,播放完后界面会显示 */
@property(nonatomic, assign) CGFloat                                      playerBGViewHeight;             /**< 传给播放后的视图,防止界面高度错乱 */
@property(nonatomic, assign) BOOL                                         needToPlay;

@property(nonatomic, assign) BOOL                                         isSelfView;                     /**< KVO */

@property(nonatomic, strong) WX_CommentModel                              *deleteCommentModel;            /**< 需要删除的评论模型 */

@property(nonatomic, assign) NSInteger                                    reportNum;                      /**< 举报编号 */

@property(nonatomic, strong) BYC_KeyboardToolBar                          *myKeyboardToolBar;              /**< 输入框 */
@property(nonatomic, strong) BYC_KeyboardContent                          *faceScrollView;
@property(nonatomic, assign) BOOL                                         isHideKeyBoard;                   /**< 判断是否隐藏键盘 */
@property(nonatomic, assign) BOOL                                         isNeedPlaceHoder;                 /**< 判断是否需要案文 */
@property(nonatomic, assign) BOOL                                         isShowEmojiView;                  /**< YES:显示Emoji NO:不显示Emoji */
@property(nonatomic, strong) WX_ScriptModel                               *scriptModel;                     /**<  剧本合拍模型 */
@property(nonatomic, assign) BOOL                                         isDelete;                         /**<  是否删除  */
@property(nonatomic, strong) NSMutableArray                               *favorList_Array;                 /**<  设置喜欢,评论数组信息 */

/** VR视频播放器 */
@property (nonatomic, strong) VRplayerView                                 *VR_PlayerView;

@property (nonatomic, strong) id <UVPlayerDelegate> VRplayerDelagete;

@property (nonatomic, assign) BOOL isReadyToPlayVR;
@property (nonatomic, strong) id itemEndObserver;

@property (nonatomic, assign) BOOL                                         is_ReadyToPlay;                  /**<   记录是否第一次进入播放界面,是的话 在KVO里设置允许转屏 */
@property (nonatomic, assign) NSInteger                                      self_Controlles;      /**<   判断当前控制器数, 只有一个是 WX_VoideDViewController,并且在didDissapper 中为null 就进行退出操作*/

@property (nonatomic, strong) HL_VideodetailView                        *tableheaderView;  /**<  表头*/
/** 底部评论视图 */
@property (nonatomic, strong) HL_VideoDetailBottomView                  *view_bottomComment;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL                                      isZFPlaying;

@property (nonatomic, strong) UIScrollView                             *videoScrollView;

@property (nonatomic, strong) UIAlertView *alter1;
@property (nonatomic, strong) UIAlertView *alter2;

@end
static CGFloat height_tableViewHeader;
@implementation HL_VRvideoViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)teacherArray{
    if (!_teacherArray) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
}
-(NSMutableArray *)userArray{
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
-(NSMutableArray *)randomArray{
    if (!_randomArray) {
        _randomArray = [NSMutableArray array];
    }
    return _randomArray;
}

- (void)dealloc
{
    NSLog(@"%@释放了",self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createUI];
    [self createAVplayer];
    [self NewsFromLeftMessage];
    if (self.focusListModel.scriptID && self.focusListModel.scriptID.length) {
        
        [self scriptModelOnNetWithScriptID:self.focusListModel.scriptID];
    }
    [self.view addSubview:self.view_bottomComment];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *selfVC_Class = [NSString stringWithFormat:@"%@",self.class];
    _self_Controlles = 0;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        QNWSLog(@"vc.class == %@",vc.class);
        QNWSLog(@"self.class == %@",self.class);
        NSString *VC_Class = [NSString stringWithFormat:@"%@",vc.class];
        
        if ([VC_Class isEqualToString:selfVC_Class]) {
            _self_Controlles++;
        }
    }
    QNWSLog(@"视图即将呈现_____self.navigationController.viewControllers == %@   _self_Controlles====%zi",self.navigationController.viewControllers,_self_Controlles);
    
    self.is_ReadyToPlay = YES;
    self.isSelfView = YES;
    _wasKeyboardManagerEnabled = [IQKeyboardManager sharedManager].enableAutoToolbar;
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    //使用NSNotificationCenter 鍵盤出現時
    [QNWSNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [QNWSNotificationCenter addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(videoPaseOfVoice) name:@"voicePase" object:nil];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(videoPlayOfVoice) name:@"voicePlay" object:nil];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(stopAllAnimation) name:@"stopAnimation" object:nil];
    /// 点击评论后回复
    [QNWSNotificationCenter addObserver:self selector:@selector(notificationComments:) name:@"notiComments" object:nil];
    
    [self NewsFromLeftMessage];
    [self getAllListUserCommentsWithDic:nil];
    
    if (_self_Controlles >= 1 && self.navigationController.viewControllers.count >= 1) {
      
            if (!self.VR_PlayerView.playItem) {[self createAVplayer];}
    }
        KMainNavigationVC.isVR = YES;
        [self setNavigationRotateLandscape];
        if (self.VR_PlayerView) {
            [self.VR_PlayerView setNeedsLayout];
        }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isSelfView = YES;
    [self videoClicks];
    self.videoScrollView.delegate = self;
    if (_self_Controlles >= 1) {
        // 生命周期关系, 写在didappear 中
            KMainNavigationVC.isVR = YES;
            self.commentTableView.hidden = YES;
            self.myKeyboardToolBar.hidden = YES;
            [self setNavigationRotateLandscape];
            [self.playerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.view);
            }];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    QNWSLog(@"视图即将消息----self.navigationController.viewControllers === %@   _self_Controlles====%zi",self.navigationController.viewControllers,_self_Controlles);
    [self viewDismiss];
    self.isSelfView = NO;
    self.is_ReadyToPlay = NO;
    self.videoScrollView.delegate = nil;
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:_wasKeyboardManagerEnabled];
    // 移除监听者
    @try {
        [QNWSNotificationCenter removeObserver:self name:@"stopAnimation" object:nil];
        [QNWSNotificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        
        [QNWSNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        [QNWSNotificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [QNWSNotificationCenter removeObserver:self name:@"notiComments" object:nil];
        
        [QNWSNotificationCenter removeObserver:self name:@"voicePlay" object:nil];
        
        [QNWSNotificationCenter removeObserver:self name:@"voicePase" object:nil];
        
        [QNWSNotificationCenter removeObserver:self name:@"videoPause" object:nil];
    }
    @catch (NSException *exception) {QNWSShowException(exception);}
        [self.VR_PlayerView releaseVRPlayer];
}
/** VR横屏 */
-(void)setNavigationRotateLandscape{
    if (self.VR_PlayerView) {
        self.VR_PlayerView.label_Top_Title.text = self.focusListModel.videoTitle;
        [self.VR_PlayerView interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

#pragma mark ------------ 接受主界面的数据
-(void)receiveTheModelWith:(NSArray *)arrayModel WithNum:(NSInteger)num WithType:(NSInteger)type{
    if (type == 0) {
        if (num == -1) {
            self.num = arrayModel.count -1;
        }else if(num == arrayModel.count){
            self.num = 0;
        }else{
            self.num = num;
        }
    }else if (type == 1){
        self.num = num;
    }
    self.arrayModel = arrayModel;
}

-(void)receiveFromLeftLikeWithModel:(BYC_LeftLikeModel *)model
{
    self.leftLikeModel = model;
    self.isFormLeftLike = YES;
    self.focusListModel      = [[BYC_FocusListModel alloc]init];
    self.focusListModel.userID           = model.userID;
    self.focusListModel.videoID          = model.videoID;
    self.focusListModel.videoTitle       = model.videoTitle;
    self.focusListModel.videoMP4         = model.videoMP4;
    self.focusListModel.views            = model.views;
    self.focusListModel.pictureJPG       = model.pictureJPG;
    self.focusListModel.videoDescription = model.videoDescription;
    self.focusListModel.onOffTime        = model.collectionTime;
    self.focusListModel.nickName         = model.nickName;
    self.focusListModel.headPortrait     = model.headPortrait;
    self.focusListModel.sex              = model.sex;
    self.focusListModel.comments         = [(NSNumber*)model.comments integerValue];
    self.focusListModel.favorites        = [(NSNumber *)model.favorites integerValue];
    self.focusListModel.isLike           = model.isLike;
    self.focusListModel.isVR             = model.isVR;
    
}
#pragma mark ------------- 接收消息界面跳转过来
-(void)receiveFromLeftMessageWithModel:(BYC_LeftMassegeModel *)model
{
    self.leftMessageModel = model;
    self.isFromLeftMessage = YES;
    self.focusListModel = [[BYC_FocusListModel alloc]init];
    self.focusListModel.videoID          = model.videoID;
    self.focusListModel.videoTitle       = model.videoTitle;
    self.focusListModel.videoMP4         = model.videoMP4;
    self.focusListModel.views            = model.views;
    self.focusListModel.pictureJPG       = model.pictureJPG;
    self.focusListModel.videoDescription = model.myDescription;
    self.focusListModel.onOffTime        = model.postDateTime;
    self.focusListModel.nickName         = model.vNickName;
    self.focusListModel.headPortrait     = model.vHeadPortrait;
    self.focusListModel.sex              = model.vSex;
    self.focusListModel.isVR             = model.isVR;
    self.focusListModel.userID           = model.vUserID;
}
/// 获取剧本信息
-(void)scriptModelOnNetWithScriptID:(NSString *)scriptID
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:scriptID forKey:@"id"];
    [BYC_HttpServers requestVideoPlayVCscriptModelOnNetWithParameters:dic success:^(id responseObject) {
        self.scriptModel = [WX_ScriptModel initModelWithDic:responseObject];
    } failure:^(NSError *error) {
        QNWSLog(@"剧本信息获取错误, error == %@",error);
    }];
}

#pragma mark -------- 设置来自消息界面跳进 键盘
-(void)NewsFromLeftMessage{
    if (!self.myKeyboardToolBar) {
        [self initCustomKeyBoard];
    }
    if (self.isFromLeftMessage) {
        if (self.leftMessageModel.userType != 10 && self.leftMessageModel.toUserType != 10) {
            //弹键盘
            self.placeHolder = [NSString stringWithFormat:@"回复@%@:",self.leftMessageModel.toNickName];
            self.myKeyboardToolBar.textView_Content.placeholder = self.placeHolder;
            [self.myKeyboardToolBar.textView_Content becomeFirstResponder];
            self.myKeyboardToolBar.hidden = NO;
            self.backView.hidden = NO;
        }
    }
}
#pragma mark ------------------------------------------- 接口区
#pragma mark ------------ 获取相关视频
-(void)getAllListUserCommentsWithDic:(NSMutableDictionary*)dic{
    if (!_favorList_Array) {
        _favorList_Array = [[NSMutableArray alloc]init];
    }
    BYC_AccountModel *userModel = [BYC_AccountTool userAccount];
    if (!dic) {
        dic = [[NSMutableDictionary alloc]init];
        [dic setValue:nil forKey:@"postdatetime"];
        [dic setValue:nil forKey:@"whereType"];
        [dic setValue:nil forKey:@"commentId"];
        [dic setValue:nil forKey:@"scriptId"];
    }
    
    if (userModel.userid && userModel.userid.length) [dic setValue:userModel.userid forKey:@"userId"];
    else [dic setValue:nil forKey:@"userId"];
    
    [dic setValue:self.focusListModel.videoID forKey:@"videoId"];
    [dic setValue:self.focusListModel.userID forKey:@"touserId"];
    [BYC_HttpServers requestVideoPlayInfoWithWithParameters:dic success:^(id responseObject, NSMutableArray *comListArr, NSMutableArray *tcListArr, NSMutableArray *favorList2Arr, NSMutableArray *randListArr, NSMutableArray *likeArrModel) {
        //评论
        [self commentsFromNetWithComList_Array:comListArr TcList_Array:tcListArr Dic:dic];
        _favorList_Array = favorList2Arr;
        NSArray *array = _favorList_Array.firstObject;
        self.focusListModel.views     = [(NSNumber *)array[0] integerValue];
        self.focusListModel.favorites = [(NSNumber *)array[1] integerValue];
        self.focusListModel.comments  = [(NSNumber *)array[2] integerValue];
        self.tableheaderView.focusListModel = self.focusListModel;
        self.view_bottomComment.focusListModel = self.focusListModel;
        if ([(NSNumber *)array[3] integerValue]) {
            self.view_bottomComment.button_like.selected = YES;
            if (self.videoView.endToFavoriteBtn) self.videoView.endToFavoriteBtn.selected = YES;
            else self.isFavorite = YES;
        }
        if (randListArr.count > 0)  [self getRandomVideoFromNetWithArray:randListArr];
        //        通过键值对方式取值：
        //        scrList 所属剧本信息
        NSArray *scrList_Array = responseObject[@"scrList"];
        QNWSLog(@"scrList_Array == %@",scrList_Array);
        //        state  关注状态
        //        3 互相关注 0已关注 2未关注
        NSString *state_Str = responseObject[@"state"];
        QNWSLog(@"state_Str == %@",state_Str);
        if ([state_Str isEqualToString:@"0"] || [state_Str isEqualToString:@"3"]) self.tableheaderView.button_Focus.selected = YES;
        else self.tableheaderView.button_Focus.selected = NO;
        
        self.tableheaderView.likeArr = likeArrModel;
        
    } failure:^(NSError *error) {
        
    }];
}

/**  播放完的推荐视频获取接口 */
-(void)getRandomVideoFromNetWithArray:(NSArray*)randList_Array{
    [self.randomArray removeAllObjects];
    for (NSArray * array in randList_Array) {
        WX_RandomVideoModel *randVideoModel = [WX_RandomVideoModel initModelWithArray:array];
        [self.randomArray addObject:randVideoModel];
    }
}

#pragma mark ------------ 获取评论
// 评论获取接口
-(void)commentsFromNetWithComList_Array:(NSMutableArray*)comList_Array TcList_Array:(NSMutableArray*)tcList_Array Dic:(NSMutableDictionary*)dic{
    [self.dataArray removeAllObjects];
    [self.teacherArray removeAllObjects];
    [self.userArray removeAllObjects];
    if (comList_Array.count == 0 && tcList_Array.count == 0) {
        self.focusListModel.comments = 0;
        self.view_bottomComment.focusListModel = self.focusListModel;
    }else if(self.isDelete){//删除
        
        if (self.focusListModel.comments > comList_Array.count){
            NSInteger page = self.focusListModel.comments / KCOMMENTS_OF_PAGE;
            BOOL isReload = YES;
            
            for (int i = 0; i < page; i++) {
                dispatch_queue_t serialQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
                dispatch_async(serialQueue, ^{
                    
                    WX_CommentModel *commentModel = [WX_CommentModel initModelWithArray:[comList_Array lastObject]];
                    QNWSLog(@"评论不足, 需要继续加载");
                    QNWSLog(@"第 %zi 次评论内容 %zi",i,comList_Array.count+tcList_Array.count);
                    
                    [dic setValue:commentModel.postDateTime forKey:@"postdatetime"];
                    [dic setValue:@"1" forKey:@"whereType"];
                    [dic setValue:commentModel.commentID forKey:@"commentId"];
                    [BYC_HttpServers Get:KQNWS_GetAllListUserComments parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSArray *comRows_Array = responseObject[@"comList"];
                        [comList_Array addObjectsFromArray:comRows_Array];
                        
                        if (i + 1 == page) {[self showCommentsWithComRowArray:comList_Array TcRowsArray:tcList_Array];}
                        QNWSLog(@"第 %zi 次评论内容 %zi",i,comRows_Array.count);
                        self.view_bottomComment.focusListModel.comments = comList_Array.count;
                        ;
                        self.view_bottomComment.focusListModel = self.focusListModel;
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        QNWSLog(@"第 %zi 次评论接口数据获取失败,error == %@",i,error);
                        
                    }];
                });
                
                isReload = NO;
            }
            if (isReload) {
                
                [self showCommentsWithComRowArray:comList_Array TcRowsArray:tcList_Array];
                self.view_bottomComment.focusListModel.comments = comList_Array.count;
                ;
                self.view_bottomComment.focusListModel = self.focusListModel;
                self.isDelete = NO;
            }
        }else{
            
            [self showCommentsWithComRowArray:comList_Array TcRowsArray:tcList_Array];
            self.view_bottomComment.focusListModel.comments = comList_Array.count;
            ;
            self.view_bottomComment.focusListModel = self.focusListModel;
            
            self.isDelete = NO;
            
        }
        
    }else if (self.focusListModel.comments > comList_Array.count){
        NSInteger page = self.focusListModel.comments / KCOMMENTS_OF_PAGE;
        for (int i = 0; i < page; i++) {
            
            dispatch_queue_t serialQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
            dispatch_async(serialQueue, ^{
                
                WX_CommentModel *commentModel = [WX_CommentModel initModelWithArray:[comList_Array lastObject]];
                QNWSLog(@"评论不足, 需要继续加载");
                QNWSLog(@"第 %zi 次评论内容 %zi",i,comList_Array.count);
                
                [dic setValue:commentModel.postDateTime forKey:@"postdatetime"];
                [dic setValue:@"1" forKey:@"whereType"];
                [dic setValue:commentModel.commentID forKey:@"commentId"];
                
                [BYC_HttpServers Get:KQNWS_GetAllListUserComments parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSArray *comRows_Array = responseObject[@"comList"];
                    [comList_Array addObjectsFromArray:comRows_Array];
                    
                    if (i + 1 == page) {
                        [self showCommentsWithComRowArray:comList_Array TcRowsArray:tcList_Array];
                        
                    }
                    QNWSLog(@"第 %zi 次评论内容 %zi",i,comRows_Array.count);
                    self.view_bottomComment.focusListModel.comments = comList_Array.count;
                    ;
                    self.view_bottomComment.focusListModel = self.focusListModel;
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    QNWSLog(@"第 %zi 次评论接口数据获取失败,error == %@",i,error);
                }];
            });
            
        }
    }else{
        
        [self showCommentsWithComRowArray:comList_Array TcRowsArray:tcList_Array];
        self.view_bottomComment.focusListModel.comments = comList_Array.count;
        ;
        self.view_bottomComment.focusListModel = self.focusListModel;
    }
    [self.commentTableView reloadData];
    
}

-(void)showCommentsWithComRowArray:(NSMutableArray *)comRowsArray TcRowsArray:(NSArray *)tcRowsArray
{
    NSInteger comments = 0;
    
    for (NSArray *array in comRowsArray) {
        WX_CommentModel *model = [WX_CommentModel initModelWithArray:array];
        [self.userArray addObject:model];
        comments++;
    }
    
    for (NSArray *array in tcRowsArray) {
        WX_CommentModel *model = [WX_CommentModel initModelWithArray:array];
        [self.teacherArray addObject:model];
        comments++;
    }
    
    [self.dataArray removeAllObjects];
#pragma mark -------------- 名师点评 测试数据
    if (self.teacherArray.count >0) {
        self.teacherArray = [self sortArrayWithArray:self.teacherArray];
        [self.dataArray addObject:self.teacherArray];
    }
    
    if (self.userArray.count >0) {
        self.userArray = [self sortArrayWithArray:self.userArray];
        [self.dataArray addObject:self.userArray];
    }
    
    if (self.dataArray.count > 0) {
        /// 根据cell 自适应tableview高度
        CGFloat tableViewHight = height_tableViewHeader;
        for (WX_CommentModel *commentModel in self.teacherArray) {
            if (!commentModel.voiceType) {
                tableViewHight = tableViewHight + [WX_CommentsTableViewCell cellHeightWithString:commentModel];
            }else{
                tableViewHight += 70;
            }
        }
        for (WX_CommentModel *commentModel in self.userArray) {
            if (!commentModel.voiceType) {
                tableViewHight = tableViewHight + [WX_CommentsTableViewCell cellHeightWithString:commentModel];
            }else{
                tableViewHight  += 70;
            }
        }
        QNWSLog(@"tableViewHight == %f",tableViewHight);
        
        self.commentTableView.frame = CGRectMake(0, 0, screenWidth, tableViewHight+40);
        self.videoScrollView.contentSize = CGSizeMake(0,tableViewHight+50);
    }
    [self.commentTableView reloadData];
}
#pragma mark -------- 删除评论接口
-(void)deleteComment:(NSMutableDictionary *)dic{
    
    [BYC_HttpServers requestVideoPlayVCDeletCommentsWithParameters:dic success:^(id responseObject) {
        [self getAllListUserCommentsWithDic:nil];
    } failure:^(NSError *error) {
        
    }];
    self.deleteCommentModel = nil;
}

#pragma mark --------- 添加关注接口
-(void)cilckFocus
{
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        
        return;
    }else {
        /// 关注
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        BYC_AccountModel *model = [BYC_AccountTool userAccount];
        
        [dic setValue:self.focusListModel.userID forKey:@"touserid"];
        [dic setValue:model.userid forKey:@"user.userid"];
        
        [dic setValue:model.userid forKey:@"userid"];
        [dic setValue:model.token forKey:@"token"];
        [BYC_HttpServers requestVideoPlayVCFocusWithParameters:dic Success:^(NSInteger isfocusSuccess) {
            if (isfocusSuccess == 0) {
                self.tableheaderView.button_Focus.selected = YES;
                [UIView animateWithDuration:1.f animations:^{
                    self.tableheaderView.button_Focus.alpha = 0.f;
                } completion:^(BOOL finished) {
                    self.tableheaderView.button_Focus.hidden = YES;
                    if (self.focusListModel.isVR == 2) {
                        [self.tableheaderView.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(self.tableheaderView.mas_right).offset(-12);
                        }];
                    }
                }];
                //                model.focus      += 1;
                //                [BYC_AccountTool saveAccount:model];
            }
            else if (isfocusSuccess == 6) self.tableheaderView.button_Focus.selected = NO;
            else self.tableheaderView.button_Focus.selected = NO;
        } failure:^(NSError *error) {
            self.tableheaderView.button_Focus.selected = NO;
        }];
    }
}

#pragma mark ----------- 判断是否喜欢_收藏接口
-(void)favorite:(UIButton *)button
{
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        return ;
    }else {
        button.selected = !button.selected;
        /// 服务器喜欢请求
        if (button.selected) {
            /// 添加为喜欢
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            BYC_AccountModel *model = [BYC_AccountTool userAccount];
            
            [dic setValue:model.userid forKey:@"userFavorites.userid"];
            [dic setValue:self.focusListModel.videoID forKey:@"userFavorites.videoid"];
            
            [dic setValue:model.userid forKey:@"userid"];
            [dic setValue:model.token forKey:@"token"];
            
            [BYC_HttpServers requestFocusVCSaveUserFavoritesWithParameters:dic success:^(BYC_BackFocusListCellModel *likeModel, NSMutableArray *likeArrModel) {
                self.focusListModel.views     = likeModel.views;
                self.focusListModel.favorites = likeModel.favorites;
                self.focusListModel.comments  = likeModel.comments;
                self.focusListModel.isLike    = YES;
                self.view_bottomComment.button_like.selected = YES;
                self.tableheaderView.focusListModel = self.focusListModel;
                self.view_bottomComment.focusListModel = self.focusListModel;
                if (self.videoView.endToFavoriteBtn) {
                    self.videoView.endToFavoriteBtn.selected = YES;
                }else{
                    self.isFavorite = YES;
                }
                self.view_bottomComment.button_like.selected = YES;
                self.tableheaderView.likeArr = likeArrModel;
                
            } failure:^(NSError *error) {
                [self.view showAndHideHUDWithTitle:@"收藏失败" WithState:BYC_MBProgressHUDHideProgress];
                self.view_bottomComment.button_like.selected = NO;
                if (self.videoView.endToFavoriteBtn) {
                    
                    self.videoView.endToFavoriteBtn.selected = NO;
                }else{
                    self.isFavorite = NO;
                }
                QNWSLog(@"收藏接口信息发送失败,error == %@",error);
            }];
        }else{// 取消喜欢
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            BYC_AccountModel *model = [BYC_AccountTool userAccount];
            
            [dic setValue:model.userid forKey:@"userFavorites.userid"];
            [dic setValue:self.focusListModel.videoID forKey:@"userFavorites.videoid"];
            
            [dic setValue:model.userid forKey:@"userid"];
            [dic setValue:model.token forKey:@"token"];
            [BYC_HttpServers requestFocusVCRemoveUserFavoritesWithParameters:dic success:^(BYC_BackFocusListCellModel *unLikeModel, NSMutableArray *unLikeArrModel) {
                self.focusListModel.views     = unLikeModel.views;
                self.focusListModel.favorites = unLikeModel.favorites;
                self.focusListModel.comments  = unLikeModel.comments;
                self.focusListModel.isLike    = NO;
                self.view_bottomComment.button_like.selected = NO;
                self.tableheaderView.focusListModel = self.focusListModel;
                self.view_bottomComment.focusListModel = self.focusListModel;
                if (self.videoView.endToFavoriteBtn) {
                    self.videoView.endToFavoriteBtn.selected = NO;
                }else{
                    self.isFavorite = NO;
                }
                self.view_bottomComment.button_like.selected = NO;
                self.tableheaderView.likeArr = unLikeArrModel;
                
            } failure:^(NSError *error) {
                self.view_bottomComment.button_like.selected = YES;
                if (self.videoView.endToFavoriteBtn) {
                    
                    self.videoView.endToFavoriteBtn.selected = YES;
                }else{
                    self.isFavorite = YES;
                }
                [self.view showAndHideHUDWithTitle:@"收藏失败" WithState:BYC_MBProgressHUDHideProgress];
                QNWSLog(@"取消收藏接口信息发送失败,error == %@",error);
            }];
        }
    }
}
#pragma mark ---------- 举报接口
-(void)reportTheVideoResponseObjectWithReportStr:(NSString *)reportStr{
    
    BYC_AccountModel *model = [BYC_AccountTool userAccount];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.focusListModel.userID forKey:@"userReports.userid"];
    [dic setValue:reportStr forKey:@"userReports.reportreason"];
    [dic setValue:self.focusListModel.videoID forKey:@"userReports.reportvideoid"];
    [dic setValue:model.userid forKey:@"userid"];
    [dic setValue:model.token forKey:@"token"];
    [BYC_HttpServers requestVideoPlayVCReportWithParameters:dic];
}

#pragma mark --------- 评论排序
// 数组倒置
-(NSMutableArray *)sortArrayWithArray:(NSMutableArray *)sortArray;
{
    NSArray *commentArray = [self sortCommentsWithArray:sortArray];
    [sortArray removeAllObjects];
    if (commentArray.count >0) {
        for (NSArray *array in commentArray) {
            for (int i = 0; i < array.count; i++) {
                WX_CommentModel *model = array[i];
                [sortArray addObject:model];
            }
        }
        return sortArray;
    }
    return nil;
}

-(NSArray *)sortCommentsWithArray:(NSMutableArray *)sourceArray
{
    /// 按时间排序
    /// -------- 最新评论置顶
    NSMutableArray *DateArray = [[NSMutableArray alloc]init];
    NSMutableArray *array = [NSMutableArray arrayWithArray:sourceArray];
    
    for (int i = 0; i < array.count; i ++) {
        WX_CommentModel *model = array[i];
        NSString *dataStr = model.postDateTime;
        dataStr = [dataStr substringToIndex:10];
        NSMutableArray *tempArray = [@[] mutableCopy];
        
        [tempArray addObject:model];
        for (int j = i+1; j < array.count; j ++) {
            WX_CommentModel *otherModel = array[j];
            NSString *otherData = otherModel.postDateTime;
            otherData = [otherData substringToIndex:10];
            
            if([dataStr isEqualToString:otherData]){
                [tempArray addObject:otherModel];
                [array removeObjectAtIndex:j];
                j= j-1;
            }
        }
        NSMutableArray *sorDateArray = [[NSMutableArray alloc]init];
        for (int k = (int)tempArray.count-1; k >= 0; k--) {
            [sorDateArray addObject:tempArray[k]];
        }
        
        [DateArray addObject:sorDateArray];
    }
    
#pragma mark ------------------ 时间排序
    // 比较一组数据中第一个,然后把着一组数据放进数组中
    NSMutableArray *compareArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< DateArray.count; i++) {
        NSArray *array = DateArray[i];
        WX_CommentModel *model = array[0];
        NSString *dataStr = model.postDateTime;
        dataStr = [dataStr substringToIndex:10];
        
        NSArray *dataStrArray = [dataStr componentsSeparatedByString:@"-"];
        dataStr = @"";
        
        for (NSString *str in dataStrArray) {
            dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
            dataStr = [dataStr substringFromIndex:1];
        }
        [compareArray addObject:dataStr];
        
    }
    
    NSMutableArray *dateArrayCopy = [DateArray copy];
    [DateArray removeAllObjects];
    for (int i = 0 ; i < dateArrayCopy.count;i++) {
        NSMutableArray *array = dateArrayCopy[i];
        NSMutableArray *dayArray = [[NSMutableArray alloc]init];
        for (int j = 0; j < array.count;j++) {
            WX_CommentModel *model = array[j];
            NSString *dateStr = [model.postDateTime substringFromIndex:11];
            NSArray *dateArray = [dateStr componentsSeparatedByString:@":"];
            dateStr = @"";
            for (NSString *str2 in dateArray) {
                dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%@",str2]];
            }
            [dayArray addObject:dateStr];
        }
        
        for (int k = 0; k <dayArray.count; k++) {
            CGFloat num1 = [dayArray[k] floatValue];
            
            for (int l = 0; l <dayArray.count; l++) {
                CGFloat num2 = [dayArray[l] floatValue];
                if (num1 < num2) {
                    id obj = dayArray[k];
                    dayArray[k] = dayArray[l];
                    dayArray[l] = obj;
                    
                    id obj2 = array[k];
                    array[k] = array[l];
                    array[l] = obj2;
                }
            }
        }
        NSArray *dayArrayCopy = [dayArray copy];
        [dayArray removeAllObjects];
        NSArray *arrayCopy = [array copy];
        [array removeAllObjects];
        for (int l = (int)dayArrayCopy.count-1; l >= 0; l--) {
            [dayArray addObject:dayArrayCopy[l]];
            [array addObject:arrayCopy[l]];
        }
        [DateArray addObject:array];
    }
    return DateArray;
}

#pragma mark --------- 判断是否已关注接口
/**  视频点击量 */
-(void)videoClicks{
    BYC_AccountModel *model = [BYC_AccountTool userAccount];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:model.userid forKey:@"userid"];
    [dic setValue:model.token forKey:@"token"];
    
    [dic setValue:model.userid forKey:@"user.userid"];
    [dic setValue:self.focusListModel.userID forKey:@"touserid"];
    ///当前用户和登陆用户一致 不显示关注按钮
    if ([[dic valueForKey:@"userid"] isEqualToString:[dic valueForKey:@"touserid"]]) {
        if (!self.tableheaderView.button_Focus.hidden) {
            self.tableheaderView.button_Focus.hidden = YES;
            if (self.focusListModel.isVR == 2) {
                [self.tableheaderView.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.tableheaderView.mas_right).offset(-12);
                }];
            }
        }
    }else{
        
        [BYC_HttpServers requestVideoPLayVCisFocusWithParameters:dic Success:^(BOOL isFocus) {
            if (isFocus) {
                self.tableheaderView.button_Focus.selected = YES;
                self.tableheaderView.button_Focus.hidden = YES;
                if (self.focusListModel.isVR == 2) {
                    [self.tableheaderView.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.tableheaderView.mas_right).offset(-12);
                    }];
                }
            }
            else{
                self.tableheaderView.button_Focus.selected = NO;
                self.tableheaderView.button_Focus.hidden = NO;
                self.tableheaderView.button_Focus.alpha = 1.0;
                if (self.focusListModel.isVR == 2) {
                    [self.tableheaderView.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.tableheaderView.mas_right).offset(-46);
                    }];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    NSMutableDictionary *viewsDic = [[NSMutableDictionary alloc]init];
    [viewsDic setValue:self.focusListModel.videoID forKey:@"video.videoid"];
    [BYC_HttpServers requestVideoPlayVCPlayedCountWithParameters:viewsDic Success:^{
        [self getAllListUserCommentsWithDic:nil];
    } failure:^{
    }];
}

#pragma mark  ----------- 上传评论
/// 上传评论
-(void)SaveUserCommentsFromNet{
    BYC_AccountModel *accountModel = [BYC_AccountTool userAccount];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.commentsStr forKey:@"userComments.content"];
    [dic setValue:accountModel.userid forKey:@"userComments.userid"];
    [dic setValue:self.focusListModel.videoID forKey:@"userComments.videoid"];
    if (self.isToComment) {
        WX_CommentModel *model = self.userArray[self.toCommentIdNum];
        [dic setValue:model.commentID forKey:@"userComments.tocommentid"];
        QNWSLog(@"model.commentID == %@",model.commentID);
    }else if (self.isFromLeftMessage ){
        [dic setValue:self.leftMessageModel.commentID forKey:@"userComments.tocommentid"];
    }else{
        [dic setValue:nil forKey:@"userComments.tocommentid"];
    }
    
    [dic setValue:[NSString stringWithFormat:@"%d",self.isVoice]forKey:@"userComments.isvoice"];
    [dic setValue:[NSString stringWithFormat:@"%zi",self.voiceLength] forKey:@"userComments.seconds"];
    [dic setValue:[NSString stringWithFormat:@"%zi",accountModel.usertype] forKey:@"usertype"];
    [dic setValue:accountModel.userid forKey:@"userid"];
    [dic setValue:accountModel.token forKey:@"token"];
    
    QNWSLog(@"self.toCommentIdNum == %zi",self.toCommentIdNum);
    
    if (self.isVoice) {//声音评论
        self.isVoice = NO;
        _objectKey = [NSString createFileName:@"voice.amr" andType:ENUM_ResourceTypeVoices];
        
#ifdef DEBUG
        NSString *stringIP = [QNWS_Main_HostIP copy];
        
        if ([stringIP isEqualToString:KQNWS_KPIE_MAIN_URL] || [stringIP isEqualToString:@"http://112.74.88.81/api/"]) {
            ///正式服务器__ 阿里云上传正式路径
            _voicePath = [NSString stringWithFormat:@"%@%@",KQNWS_VIDEOFilePath,_objectKey];
        }else{
            ///本地服务器__ 阿里云上传测试路径
            _voicePath = [NSString stringWithFormat:@"%@%@",KQNWS_OSSTestFilePath,_objectKey];
            
        }
#else
        /// release 模式下, 固定阿里云上传路径
        _voicePath = [NSString stringWithFormat:@"%@%@",KQNWS_VIDEOFilePath,_objectKey];
#endif
        
        [dic setValue:_voicePath forKey:@"userComments.content"];
        
        [BYC_AliyunOSSUpload uploadWithObjectKey:_objectKey Data:self.voiceData andType:resourceTypeVideo completion:^(BOOL finished) {
            if (finished) {
                QNWSLog(@"音频文件上传成功");
                [BYC_HttpServers requestVideoPlayVCUploadCommentWithParameters:dic Success:^(BYC_BackFocusListCellModel *backFocusListModel, NSInteger isUploadSuccess) {
                    if (isUploadSuccess == 0) {
                        self.focusListModel.views     = backFocusListModel.views;
                        self.focusListModel.favorites = backFocusListModel.favorites;
                        self.focusListModel.comments  = backFocusListModel.comments;
                        
                        self.tableheaderView.focusListModel = self.focusListModel;
                        self.view_bottomComment.focusListModel = self.focusListModel;
                        [self getAllListUserCommentsWithDic:nil];
                        if (self.needToPlay) {[self setMediaPlayerPlayStatus];}
                    }
                    else{
                        if (self.needToPlay) {[self setMediaPlayerPlayStatus];}
                    }
                    self.backView.hidden = YES;
                    
                    [self.myKeyboardToolBar endEditing:YES];
                    [self.myKeyboardToolBar.textView_Content resignFirstResponder];
                } failure:^(NSError *error) {
                    if (self.needToPlay) {[self setMediaPlayerPlayStatus];}
                }];
            }
        }];
        if (!self.backView.userInteractionEnabled) {
            self.backView.userInteractionEnabled = YES;
        }
    }else{//文本评论
        [BYC_HttpServers requestVideoPlayVCUploadCommentWithParameters:dic Success:^(BYC_BackFocusListCellModel *backFocusListModel, NSInteger isUploadSuccess) {
            if (isUploadSuccess == 0) {
                self.focusListModel.views     = backFocusListModel.views;
                self.focusListModel.favorites = backFocusListModel.favorites;
                self.focusListModel.comments  = backFocusListModel.comments;
                
                self.tableheaderView.focusListModel = self.focusListModel;
                self.view_bottomComment.focusListModel = self.focusListModel;
                [self.myKeyboardToolBar.textView_Content resignFirstResponder];
                [self getAllListUserCommentsWithDic:nil];
            }
            self.backView.hidden = YES;
            
            self.placeHolder = @"  在此处输入...";
            self.myKeyboardToolBar.textView_Content.placeholder = @"  在此处输入...";
            [self.myKeyboardToolBar endEditing:YES];
            _myKeyboardToolBar.textView_Content.text = @"";
            CGFloat height = 50;//键盘输入条的原来高度
            _myKeyboardToolBar.frame = CGRectMake(_myKeyboardToolBar.left, _myKeyboardToolBar.bottom - height, _myKeyboardToolBar.kwidth, height);
            [self HiddenTheKeyBoard];
            QNWSLog(@"发送完成清除数据完毕");
        } failure:^(NSError *error) {
        }];
    }
}

#pragma mark ----------- 其他
-(void)judgeFavoriteBtnSelectSate{
    NSArray *array = _favorList_Array.firstObject;
    
    NSInteger countNum = [(NSNumber *)array[0] integerValue];
    self.tableheaderView.lable_playedCount.text = [NSString stringWithFormat:@"%zi",countNum];
    NSInteger favoriteNum = [(NSNumber *)array[1] integerValue];
    self.view_bottomComment.lable_likeCount.text = [NSString stringWithFormat:@"%zi",favoriteNum];
    NSInteger commentsNum = [(NSNumber *)array[2] integerValue];
    self.commentsLabel.text = [NSString stringWithFormat:@"%zi",commentsNum];
    if ([(NSNumber *)array[3] integerValue]) {
        self.view_bottomComment.button_like.selected = YES;
        if (self.videoView.endToFavoriteBtn) {
            self.videoView.endToFavoriteBtn.selected = YES;
            
        }else{
            self.isFavorite = YES;
        }
    }
    
}

-(void)viewDismiss{
    self.isFromLeftMessage = NO;
    self.isFormLeftLike = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    /// 调用键盘播放接口 暂时保留
    if ([[EMCDDeviceManager sharedInstance] isPlaying]) {
        [[EMCDDeviceManager sharedInstance] stopPlaying];
        QNWSLog(@"还在播放");
    }
    NSNotification *notification = [NSNotification notificationWithName:@"hiddenTheButton" object:nil userInfo:@{@"2":@"2"}];
    [QNWSNotificationCenter postNotification:notification];
}
#pragma mark ------------------------------------------- UI设置
-(void)createUI
{
    self.isSelfView = YES;
    if (!self.isFromLeftMessage && !self.isFormLeftLike) {
        if (self.arrayModel.count >= 1) {
            self.focusListModel = self.arrayModel[self.num];
        }
    }
    
    self.tableheaderView = [[HL_VideodetailView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, [HL_VideodetailView returnHeightOfFocusHeaderView:self.focusListModel])];
    height_tableViewHeader = [HL_VideodetailView returnHeightOfFocusHeaderView:self.focusListModel];
    self.tableheaderView.focusListModel = self.focusListModel;
    self.view_bottomComment.focusListModel = self.focusListModel;
    QNWSWeakSelf(self);
    self.tableheaderView.selectButton = ^(BYC_FocusCollectionViewCellSelected selectButton ,BYC_FocusListModel *model){
        __block BYC_BackFocusListCellModel *backModel = nil;
        [weakself clickButtonAction:selectButton model:model];
        return backModel;
    };
    self.tableheaderView.clickHeaderButtonBlock = ^(BYC_FocusListModel *model){
        
        if (![BYC_AccountTool userAccount]) {
            [BYC_LoginAndRigesterView shareLoginAndRigesterView];
            return;
        }
        else{
            BYC_MyCenterViewController *myCenterVC = [[BYC_MyCenterViewController alloc] init];
            myCenterVC.userID = model.userID;
            [weakself.navigationController pushViewController:myCenterVC animated:YES];
        }
    };
    // 播放器画布
    self.playerBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*0.48)];
    self.playerBGViewHeight = self.playerBGView.frame.size.height;
    self.playerBGView.backgroundColor = [UIColor clearColor];
    [self.backImgView sd_setImageWithURL:[NSURL URLWithString:self.focusListModel.pictureJPG] placeholderImage:nil];
    [self.playerBGView addSubview:self.backImgView];
    [self.view addSubview:self.playerBGView];
    self.playerBGView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.view);
    }];
        if(!self.videoScrollView){
        self.videoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20+screenHeight*0.48, screenWidth, screenHeight -20-screenHeight*0.48 -self.myKeyboardToolBar.kheight)];
        self.videoScrollView.backgroundColor = KUIColorFromRGB(0xFFFFFF);
        self.videoScrollView.delegate = self;
        self.videoScrollView.scrollsToTop = YES;
        
        [self.view addSubview:self.videoScrollView];
        
        [self.videoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerBGView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
            
        }];
    }
    
    [self createCommentsTableView];
}
- (void)clickButtonAction:(BYC_FocusCollectionViewCellSelected)selectButton model:(BYC_FocusListModel *)model{
    
    switch (selectButton) {
        case BYC_FocusCollectionViewCellSelectedShoot:{
            //合拍
            WX_JoinShootingViewController *shootVC = [[WX_JoinShootingViewController alloc]init];
            [shootVC receiveModelWith:model];
            [self.navigationController pushViewController:shootVC animated:YES];
            
        }
            break;
        case BYC_FocusCollectionViewCellSelectedFocus:{
            //关注
            [self cilckFocus];
        }
            break;
        default:
            break;
    }
}
#pragma mark --------------- 创建tableView__评论区
-(void)createCommentsTableView{
    self.commentTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,0, screenWidth, screenHeight -20-screenHeight*0.48 -self.myKeyboardToolBar.kheight - 15) style:UITableViewStyleGrouped];
    self.commentTableView.backgroundColor = KUIColorFromRGB(0xFCFCFC);
#pragma mark ----------- tableView 添加长按点击手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(moreSelect:)];
    longPress.minimumPressDuration = 1.0f;
    [self.commentTableView addGestureRecognizer:longPress];
    
    /// 判断登录状态
    [self judgeFavoriteBtnSelectSate];
    [self.videoScrollView addSubview:self.commentTableView];
    self.commentTableView.scrollEnabled = NO;
    self.commentTableView.tableHeaderView = self.tableheaderView;
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    [self.commentTableView registerClass:[WX_CommentsTableViewCell class] forCellReuseIdentifier:@"CommentsTableViewCell"];
    
}
#pragma mark ------ 默认状态的底部View
-(HL_VideoDetailBottomView *)view_bottomComment{
    if (!_view_bottomComment) {
        _view_bottomComment = [[HL_VideoDetailBottomView alloc]initWithFrame:CGRectMake(0, screenHeight-50, screenWidth, 50)];
        _view_bottomComment.buttonDelegate = self;
    }
    return _view_bottomComment;
}
#pragma mark -------默认状态的底部button的点击事件
-(void)clickBottomButton:(UIButton *)sender{
    
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        return;
    }
    else {
        switch (sender.tag) {
            case 1100:
                [self comment:sender];
                self.view_bottomComment.hidden = YES;
                self.myKeyboardToolBar.hidden = NO;
                break;
            case 1101:
                [self comment:sender];
                self.view_bottomComment.hidden = YES;
                self.myKeyboardToolBar.hidden = NO;
                break;
            case 1102:
                [self favorite:sender];
                break;
            case 1103:
                [self share];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark ------   参与剧本
-(void)joinTheScript:(UIButton*)btn
{
    WX_ShootingScriptViewController *shootScriptVC = [[WX_ShootingScriptViewController alloc]init];
    
    shootScriptVC.videoD_ScriptModel = self.scriptModel;
    
    QNWSLog(@"剧本名 %@",shootScriptVC.videoD_ScriptModel.scriptname);
    
    [self.navigationController pushViewController:shootScriptVC animated:YES];
}

#pragma mark ----------------- 创建播放器
// 创建播放器
-(void)createAVplayer{
        self.VR_PlayerView = [[VRplayerView alloc]init];
        self.VR_PlayerView.VRdelagete = self;
        self.VR_PlayerView.VR_Player.delegate = self;
        if (!self.focusListModel.videoMP4.length) {
            NSString *urlString;
            // 加载网络视频
            if (self.isFromLeftMessage) {
                BYC_LeftMassegeModel *model = self.leftMessageModel;
                self.mediaID = model.videoID;
                urlString = model.videoMP4;
                
                //实例化item.包含播放时间等信息
            }else if (self.isFormLeftLike){
                BYC_LeftLikeModel *model = self.leftLikeModel;
                self.mediaID = model.videoID;
                urlString = model.videoMP4;
            }else{
                BYC_HomeViewControllerModel *model = self.arrayModel[self.num];
                self.mediaID = model.videoID;
                urlString = model.videoMP4;
            }
            //实例化item.包含播放时间等信息
            urlString= [NSString stringWithFormat:@"%@",urlString];
            urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
            url_VRPlayer = encodedString;
        }else{
            
            NSString *vrUrlStr= [NSString stringWithFormat:@"%@",self.focusListModel.videoMP4];
            vrUrlStr = [vrUrlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)vrUrlStr, NULL, NULL,  kCFStringEncodingUTF8 ));
            url_VRPlayer = encodedString;
        }
        self.VR_PlayerView.playItem = [[UVPlayerItem alloc]initWithPath:url_VRPlayer type:UVPlayerItemTypeOnline];
        if (_self_Controlles >= 1 ) {
            [self.playerBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.view);
            }];
        }
        [self.playerBGView addSubview:self.VR_PlayerView];
        [self.VR_PlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.playerBGView);
        }];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            NSLog(@"中");
            [self.playerBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(20);
                make.height.equalTo(self.view.mas_height).multipliedBy(0.48);
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
            }];
            KMainNavigationVC.isVR = YES;
            [super updateViewConstraints];
            self.commentTableView.hidden = NO;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"左");
            [BYC_LoginAndRigesterView removeAppearView];
            self.backView.hidden = YES;
            [self hideFaceView];
            [self.myKeyboardToolBar.textView_Content resignFirstResponder];
            [self.playerBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.view);
            }];
           KMainNavigationVC.isVR = YES;
            [super updateViewConstraints];
            self.commentTableView.hidden = YES;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"右");
            [BYC_LoginAndRigesterView removeAppearView];
            self.backView.hidden = YES;
            [self hideFaceView];
            [self.myKeyboardToolBar.textView_Content resignFirstResponder];
            [self.playerBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            KMainNavigationVC.isVR = YES;
            [super updateViewConstraints];
            self.commentTableView.hidden = YES;
        }
            break;
        default:
            break;
    }
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark ---------------- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = self.dataArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WX_CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsTableViewCell"];
    if (self.dataArray.count >0) {
        NSArray *array = self.dataArray[indexPath.section];
        WX_CommentModel *model = array[indexPath.row];
        if (self.teacherArray.count > 0 && indexPath.section == 0) {
            [cell setCellWithModel:model UserType:10];
            
        }else{
            [cell setCellWithModel:model UserType:0];
        }
    }
    cell.userArray = self.userArray;
    cell.teachArray = self.teacherArray;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WX_CommentModel *model;
    if (self.dataArray.count > 0) {
        model = self.dataArray[indexPath.section][indexPath.row];
        if (!model.voiceType)return [WX_CommentsTableViewCell cellHeightWithString:model];  //文字
        else return TableViewCellHeight;  //语音
    }
    else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]init];
    sectionView.backgroundColor = KUIColorBackgroundModule1;
    if (self.teacherArray.count > 0) {
        /// 有名师的状态下
        [self initSectionViewWithType:0 WithView:sectionView];
    }else{
        /// 没有名师
        [self initSectionViewWithType:1 WithView:sectionView];
    }
    return sectionView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.videoScrollView.contentOffset.y <= 0) {
        self.videoScrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
}
#pragma mark ------------ 名师, 用户 评论区
// 0 ----名师, 1-----用户 评论
-(void)initSectionViewWithType:(NSInteger)type WithView:(UIView*)sectionView
{
    UIImageView *image_view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_img_pinglunbiaoqian"]];
    [sectionView addSubview:image_view];
    [image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionView.mas_centerY);
        make.left.equalTo(sectionView.mas_left).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *lable_title = [[UILabel alloc]init];
    lable_title.enabled = NO;
    lable_title.font = [UIFont systemFontOfSize:13];
    lable_title.textColor = KUIColorWordsBlack1;
    [sectionView addSubview:lable_title];
    [lable_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionView.mas_centerY);
        make.left.equalTo(image_view.mas_right).offset(4);
    }];
    
    if (type == 0) {
        lable_title.text = @"名师点评";
        
    }else if (type == 1){
        lable_title.text = @"最新评论";
        
    }
    [lable_title sizeToFit];
}

#pragma mark ------------ 初始化自定义键盘
-(void)initCustomKeyBoard{
    // 语音键盘
    if (!_myKeyboardToolBar) {
        _myKeyboardToolBar = [[BYC_KeyboardToolBar alloc] initWithFrame:CGRectZero];
        self.myKeyboardToolBar.bottom = screenHeight;
        _myKeyboardToolBar.delegate_KeyboardToolBar = self;
        _myKeyboardToolBar.backgroundColor = KUIColorBackgroundModule1;
        [self.view addSubview:_myKeyboardToolBar];
    }
    
    // 点击收起键盘
    if (!self.backView) {
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = KUIColorFromRGBA(0x00000, 0.3);
        self.backView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HiddenTheKeyBoard)];
        [self.backView addGestureRecognizer:tap];
        self.backView.hidden = YES;
        [self.view addSubview:self.backView];
        [self.view bringSubviewToFront:self.backView];
    }
}
//显示表情
- (void)showFaceView {
    if (_faceScrollView == nil) {
        __weak __typeof(self) weakSelf = self;
        _faceScrollView = [[BYC_KeyboardContent alloc] initWithBlock:^(BOOL isWhetherDeleteEmoji, NSString *stringEmojiName) {
            if (!isWhetherDeleteEmoji) {//展示表情
                NSString *text = weakSelf.myKeyboardToolBar.textView_Content.text;
                NSString *appendText = [text stringByAppendingString:stringEmojiName];
                weakSelf.myKeyboardToolBar.textView_Content.text = appendText;
                [weakSelf.myKeyboardToolBar.textView_Content textDidChange];
                
            }else {//删除表情或者文字
                weakSelf.myKeyboardToolBar.textView_Content.text = [BYC_DeleteEmojiStringName deleteEmojiStringAction:weakSelf.myKeyboardToolBar.textView_Content.text];
                [weakSelf.myKeyboardToolBar.textView_Content textDidChange];
            }
        }];
        [self.view addSubview:_faceScrollView];
    }
    
    _faceScrollView.alpha = 1;
    _isShowEmojiView = YES;
    [_myKeyboardToolBar.textView_Content resignFirstResponder];
    _faceScrollView.top = screenHeight - _faceScrollView.kheight;
    _myKeyboardToolBar.bottom = _faceScrollView.top;
    self.backView.hidden = NO;
    self.myKeyboardToolBar.isSmile = YES;
    self.myKeyboardToolBar.hidden = NO;
    self.view_bottomComment.hidden = YES;
    self.backView.frame = CGRectMake(0, 0, screenWidth, _myKeyboardToolBar.frame.origin.y);
}

- (void)hideFaceView {
    
    _isShowEmojiView = NO;
    CGFloat delay = 0.35f;
    [UIView animateWithDuration:delay animations:^{
        _faceScrollView.alpha = 0;
    }];
    if (self.myKeyboardToolBar.textView_Content.text.length == 0) {
        self.myKeyboardToolBar.hidden = YES;
        self.view_bottomComment.hidden = NO;
    }
    else{
        self.myKeyboardToolBar.hidden = NO;
        self.view_bottomComment.hidden = YES;
    }
}

- (void)downFaceView {
    
    [UIView animateWithDuration:.35f animations:^{
        
        _faceScrollView.top = screenHeight;
        _myKeyboardToolBar.bottom = _faceScrollView.top;
        if (_myKeyboardToolBar.isVoice) self.backView.hidden = YES;
        else self.backView.frame = CGRectMake(0, 0, screenWidth, _myKeyboardToolBar.frame.origin.y);
        _myKeyboardToolBar.button_Emoji.selected = NO;
    }];
}

#pragma mark ------- 隐藏键盘
// 点击背景隐藏
-(void)HiddenTheKeyBoard{
    [UIView animateWithDuration:.35f animations:^{
        self.myKeyboardToolBar.bottom = screenHeight;
    }];
    
    if (self.myKeyboardToolBar.bottom == screenHeight) {
        /// 键盘消失
        [self.myKeyboardToolBar endEditing:YES];
        self.backView.hidden = YES;
        if (!_myKeyboardToolBar.textView_Content.isFirstResponder) {
            if (self.myKeyboardToolBar.isSmile)
                [self downFaceView];
            self.myKeyboardToolBar.isSmile = NO;
            
        }
    }
    if (self.myKeyboardToolBar.textView_Content.text.length == 0) {
        self.myKeyboardToolBar.hidden = YES;
        self.view_bottomComment.hidden = NO;
    }
    else{
        self.myKeyboardToolBar.hidden = NO;
        self.view_bottomComment.hidden = YES;
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    self.myKeyboardToolBar.hidden = NO;
    self.view_bottomComment.hidden = YES;
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    self.backView.hidden = YES;
    if(self.myKeyboardToolBar.textView_Content.text.length == 0){
        self.myKeyboardToolBar.hidden = YES;
        self.view_bottomComment.hidden = NO;
    }
    else{
        self.myKeyboardToolBar.hidden = NO;
        self.view_bottomComment.hidden = YES;
    }
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    //未登录跳转去登陆
    if (![BYC_AccountTool userAccount]) {
        
        [self HiddenTheKeyBoard];
        
        self.backView.hidden = YES;
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        
        return;
    }else{
        NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect frame = [value CGRectValue];
        
        if (!_isShowEmojiView){
            
            self.backView.userInteractionEnabled = YES;
            
            self.backView.hidden = NO;
            
            _myKeyboardToolBar.bottom = frame.origin.y;
            
            self.backView.frame = CGRectMake(0, 0, screenWidth, frame.origin.y -_myKeyboardToolBar.frame.size.height);
            
            [self.view bringSubviewToFront:self.backView];
        }
    }
}
#pragma mark ------- 键盘代理方法
- (UIView *)findKeyboard{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view{
    for (UIView *subView in [view subviews]){
        
        if (strstr(object_getClassName(subView), "UIKeyboard"))return subView;
        else {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)return tempView;
        }
    }
    return nil;
}

#pragma mark - BYC_KeyboardToolBarDelegate
-(void)clickActionWithStatus:(KeyboardStatus)status {
    switch (status) {
        case KeyboardStatusText:{
            
            _myKeyboardToolBar.textView_Content.placeholder = self.placeHolder;
            self.myKeyboardToolBar.hidden = NO;
            self.view_bottomComment.hidden = YES;
            [self hideFaceView];
        }
            break;
        case KeyboardStatusVoice:{
            [QNWSNotificationCenter addObserver:self selector:@selector(keyboardNotification:) name:@"videoPause" object:nil];
            if (!_myKeyboardToolBar.textView_Content.isFirstResponder) {
                
                if (self.myKeyboardToolBar.isSmile)
                    [self downFaceView];
            }
            _myKeyboardToolBar.textView_Content.placeholder = @"";
            self.myKeyboardToolBar.hidden = NO;
            self.view_bottomComment.hidden = YES;
            [self.view endEditing:YES];
        }
            break;
        case KeyboardStatusEmoji:{
            _myKeyboardToolBar.textView_Content.placeholder = self.placeHolder;
            [self showFaceView];
        }
            break;
        case KeyboardStatusSendMsg:{
            if (!_myKeyboardToolBar.textView_Content.isFirstResponder && _myKeyboardToolBar.bottom != screenHeight) {
                
                [self downFaceView];
            }else {
                
                [self.view endEditing:YES];
            }
            self.myKeyboardToolBar.hidden = YES;
            self.view_bottomComment.hidden = NO;
            QNWSLog(@"发送成功 ===  %@",_myKeyboardToolBar.textView_Content.text);
            if (self.isNeedPlaceHoder) {
                self.commentsStr = [self.placeHolder stringByAppendingString:_myKeyboardToolBar.textView_Content.text];
            }else{
                self.commentsStr = _myKeyboardToolBar.textView_Content.text;
            }
            [self SaveUserCommentsFromNet];
        }
            break;
        case KeyboardStatusSpeak:
            break;
            
        default:
            break;
    }
}

-(void)sendVoiceData:(NSData *)voiceData withVoiceDuration:(CGFloat)duration {
    self.myKeyboardToolBar.hidden = YES;
    self.view_bottomComment.hidden = NO;
    self.isVoice = YES;
    self.voiceLength = duration;
    self.voiceData = voiceData;
    [self SaveUserCommentsFromNet];
    self.backView.hidden = YES;
    self.view.userInteractionEnabled = YES;
}

-(void)recordVoiceDataFail{
    self.myKeyboardToolBar.hidden = YES;
    self.view_bottomComment.hidden = NO;
    self.backView.hidden = YES;
    self.isVoice = YES;
    self.view.userInteractionEnabled = YES;
    [self setMediaPlayerPlayStatus];
    
}

// 通知语音键盘
-(void)keyboardNotification:(NSNotification *)notification{
    
    if ([[NSString stringWithFormat:@"%@",notification.object] isEqualToString:KSTR_KVoiceWillStart]) {
        QNWSLog(@"开始录音 \n 如果播放需要暂停");
        if (!_isEndToPlay) {self.needToPlay = YES;}
        
        [self setMediaPlayerPuaeStatus];
        self.view.userInteractionEnabled = NO;
        self.backView.userInteractionEnabled = NO;
        self.backView.frame = CGRectMake(0, 0, screenWidth, screenHeight-50);
        self.backView.hidden = NO;
        [self.view bringSubviewToFront:self.backView];
    }
}

/** 暂停状态 */
-(void)setMediaPlayerPuaeStatus{
    
    self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPuse;
}
/** 播放状态 */
-(void)setMediaPlayerPlayStatus{
    if (!self.isEndToPlay) {
            self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;
        }
}
#pragma mark -------  举报
-(void)mediaPlayReportTheVideo{
    [self reportTheVideo];
}
#pragma mark --------------------------------------------- 其他操作
#pragma mark -------- 播放语音时,暂停播放视频
-(void)videoPaseOfVoice{
    [self setMediaPlayerPuaeStatus];
}
//语音播放结束
-(void)videoPlayOfVoice{
    [self setMediaPlayerPlayStatus];
}

#pragma mark --------- 暂停所有语音动画
// 暂停所有语音动画
-(void)stopAllAnimation{
    for (int i = 0; i < self.dataArray.count; i++){
        NSArray *array = self.dataArray[i];
        for (int j = 0; j < array.count; j++) {
            WX_CommentsTableViewCell *cell = [self.commentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            [cell stopVoiceAnimation];
        }
    }
}

#pragma mark -------- 创建暂停后的视图
-(void)initPaseViewWithHidden:(BOOL)hidden{
    QNWSLog(@"%@",self.randomArray);
    if (screenWidth == 320) self.textFont = 13;
    else self.textFont = 14;
    //// 有数据才可以显示
    if (self.randomArray.count > 0) {
        // 创建视图
        if (!self.videoView) {
            
            self.videoView = [[HL_RecommendView alloc]initWithFrame:CGRectMake(0, 44, screenWidth, screenHeight*0.48-44)];
            self.videoView.hidden = NO;
            [self.playerBGView addSubview:self.videoView];
            
            [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@44);
                make.left.equalTo(self.playerBGView.mas_left);
                make.right.equalTo(self.playerBGView.mas_right);
                make.bottom.equalTo(self.playerBGView.mas_bottom);
            }];
            [self.videoView.endToFavoriteBtn addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.videoView.endToPlayBtn addTarget:self action:@selector(playAgainVideo:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark ----------- 相关视频 推荐, 只有两个 不需要collectionView
            UITapGestureRecognizer *leftseeRecommendVideoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSeeRecommendedVideo:)];
            [self.videoView.leftRecommendedVideo addGestureRecognizer:leftseeRecommendVideoTap];
            
            UITapGestureRecognizer *rightseeRecommendVideoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSeeRecommendedVideo:)];
            [self.videoView.rightRecommendedVideo addGestureRecognizer:rightseeRecommendVideoTap];
        }
        [self.videoView initRecommendedVideoViewWithWithVideoArr:self.randomArray];
        
        if (hidden) {
            [self.playerBGView sendSubviewToBack:self.videoView];
            self.videoView.hidden = YES;
        }else{
            [self.playerBGView bringSubviewToFront:self.videoView];
            self.videoView.hidden = NO;
        }
    }
    if (self.isFavorite) self.videoView.endToFavoriteBtn.selected = YES;
    else self.videoView.endToFavoriteBtn.selected = NO;
}

#pragma mark -------- 点击重播按钮
/// 点击重播按钮
-(void)playAgainVideo:(UIButton *)rePlayBtn{
    [self videoClicks];
    [self initPaseViewWithHidden:YES];
        [self setNavigationRotateLandscape];
        [self.VR_PlayerView.VR_Player replayLast];
}

#pragma mark ---------- 点击手势,进入推荐视频
-(void)toSeeRecommendedVideo:(UITapGestureRecognizer *)tap{
        KMainNavigationVC.isVR = YES;
        [self.VR_PlayerView releaseVRPlayer];
    if (tap.view.tag == 401) {
        // 左侧推荐视频
        WX_RandomVideoModel *model = [self.randomArray firstObject];
        [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isVR andisComment:NO andFromType:ENU_FromOtherVideo andFromVideoVCType:ENUM_FromOtherViewController];
    }else if (tap.view.tag == 402){
        // 右侧推荐视频
        WX_RandomVideoModel *model = [self.randomArray lastObject];
        [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isVR andisComment:NO andFromType:ENU_FromOtherVideo andFromVideoVCType:ENUM_FromOtherViewController];
    }
}
#pragma mark ---------- 播放结束,显示界面
- (void)playToEnd{
    [self initPaseViewWithHidden:NO];
}

#pragma mark -------- 分享
-(void)share{
    //未登录跳转去登陆
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        return;
    }else {
        [[BYC_ShareView alloc] showWithDelegateVC:self shareContentOrMedia:BYC_ShareTypeMedia shareWithDic:@{const_ShareResourceID:self.focusListModel.videoID,const_ShareUserID:self.focusListModel.userID,const_ShareResourceTitle:self.focusListModel.videoTitle,const_ShareResourceImage:self.focusListModel.pictureJPG}];
    }
}
#pragma mark ---------- 评论
-(void)comment:(UIButton *)button
{
    if (![BYC_AccountTool userAccount]) {
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        return;
    }else {
        /// 评论
        self.placeHolder = nil;
        self.isVoice = NO;
        self.voiceLength = 0;
        self.voiceData = nil;
        self.myKeyboardToolBar.hidden = NO;
        self.isNeedPlaceHoder = NO;
        self.placeHolder = @"  在此处输入...";
        self.myKeyboardToolBar.textView_Content.placeholder = self.placeHolder;
        [self.myKeyboardToolBar.textView_Content becomeFirstResponder];
    }
}

#pragma mark ----------- 点击评论后回复
-(void)notificationComments:(NSNotification *)notification{
    QNWSLog(@"点击了第%zi 行",[[notification object] integerValue]);
    NSInteger num = [[notification object] integerValue];
    WX_CommentModel *model = self.userArray[num];
    
    self.myKeyboardToolBar.hidden = NO;
    self.isToComment = YES;
    self.isVoice = NO;
    self.voiceLength = 0;
    self.voiceData = nil;
    self.toCommentIdNum = num;
    self.isNeedPlaceHoder = YES;
    QNWSLog(@"self.toCommentIdNum == %zi",self.toCommentIdNum);
    self.placeHolder = [NSString stringWithFormat:@"回复@%@:",model.nickName];
    self.myKeyboardToolBar.textView_Content.placeholder = self.placeHolder;
    [self.myKeyboardToolBar.textView_Content becomeFirstResponder];
    QNWSLog(@"点击了 该回复啦");
}

#pragma mark ----------- 头像点击进入
-(void)tapHead{
    QNWSLog(@"点击头像");
    QNWSLog(@"model.userID == %@",self.focusListModel.userID);
    if (![BYC_AccountTool userAccount]) {
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
    }else{
        BYC_MyCenterViewController *centerVC = [[BYC_MyCenterViewController alloc]init];
        centerVC.userID = self.focusListModel.userID;
            [self.VR_PlayerView releaseVRPlayer];
        [self.navigationController pushViewController:centerVC animated:YES];
    }
}

#pragma mark ---------- 长按删除评论
-(void)moreSelect:(UILongPressGestureRecognizer *)gesture
{
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        return;
        
    }else{
        if (gesture.state == UIGestureRecognizerStateBegan) {
            CGPoint point = [gesture locationInView:self.commentTableView];
            NSIndexPath *indexPath = [self.commentTableView indexPathForRowAtPoint:point];
            if (indexPath == nil) {
                return;
            }
            BYC_AccountModel *accountModel = [BYC_AccountTool userAccount];
            self.deleteCommentModel  = self.dataArray[indexPath.section][indexPath.row];
            // 视频拥有者 ||  评论发表者
            if ([accountModel.userid isEqualToString:self.focusListModel.userID] || [accountModel.userid isEqualToString:self.deleteCommentModel.userID]) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您想要删除评论 ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
                alter.tag = 300;
                [alter show];
                
            }else{
                self.deleteCommentModel = nil;
                return;
            }
        }
    }
}
#pragma mark ---------- 举报视频
-(void)reportTheVideo{
    QNWSLog(@"点击,举报该视频");
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterView];
        return;
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"举报" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"涉及色情或政治内容",@"其他原因",@"取消", nil];
        alert.tag = 100;
        [alert show];
    }
}

-(void)reportTheVideoAlterView{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"确定举报该视频 ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    alter.tag = 200;
    [alter show];
}
#pragma mark ------------- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            self.reportNum = 1;
            [self reportTheVideoAlterView];
        }else if (buttonIndex == 1){
            self.reportNum = 2;
            [self reportTheVideoAlterView];
        }else if (buttonIndex == 2){// 取消
            return;
        }
    }
    if (alertView.tag == 200) {
        if (buttonIndex == 0) {
            return;
        }else if(buttonIndex == 1){
            NSString *reportStr = (self.reportNum == 1) ? @"涉及色情或政治内容" : @"其他原因";
            [self reportTheVideoResponseObjectWithReportStr:reportStr];
        }
    }
    if (alertView.tag == 300) {
        
        if (buttonIndex == 0) {
            
            /// 取消删除操作
            self.deleteCommentModel = nil;
            self.isDelete = NO;
            return;
        }else if (buttonIndex == 1){
            
            /// 确认删除操作
            self.isDelete = YES;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            BYC_AccountModel *accountModel = [BYC_AccountTool userAccount];
            [dic setValue:accountModel.userid forKey:@"userid"];
            [dic setValue:accountModel.token forKey:@"token"];
            
            [dic setValue:self.deleteCommentModel.commentID forKey:@"userComments.commentid"];
            [dic setValue:[NSString stringWithFormat:@"%d",self.deleteCommentModel.voiceType] forKey:@"userComments.isvoice"];
            [dic setValue:self.deleteCommentModel.content forKey:@"userComments.content"];
            [self deleteComment:dic];
        }
    }
}

#pragma mark ----- VRViewdelegate
#pragma mark -----左上角返回按钮
-(void)backToPrePage{
    [KMainNavigationVC popViewControllerAnimated:YES];
}

#pragma  mark -------播放控件
-(void)buttonPlayOrPauseDelegate:(UIButton *)sender{
    if (sender.selected) self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;
    else self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPuse;
}

#pragma  mark -------螺旋按钮
-(void)gyroscope:(UIButton *)sender{
    if (sender.selected) self.VR_PlayerView.VR_Player.gyroscopeEnabled = YES;
    else self.VR_PlayerView.VR_Player.gyroscopeEnabled = NO;
}

#pragma  mark -------双屏按钮
-(void)duralScreen:(UIButton *)sender{
    if (sender.selected) {
        self.VR_PlayerView.VR_Player.duralScreenEnabled = YES;
        self.VR_PlayerView.VR_Player.gyroscopeEnabled = YES;
        self.VR_PlayerView.button_Gyroscope.selected = YES;
    }
    else{
        self.VR_PlayerView.VR_Player.duralScreenEnabled = NO;
        self.VR_PlayerView.VR_Player.gyroscopeEnabled = NO;
        self.VR_PlayerView.button_Gyroscope.selected = NO;
    }
}

#pragma mark --- 开始滑动
-(void)sliderDidStart:(UISlider *)sender{
    self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPuse;
}

#pragma mark --- 滑动到某个位置
-(void)sliderToTime:(NSTimeInterval)time{
    self.VR_PlayerView.tap.enabled = NO;
    [self.VR_PlayerView.VR_Player seekToProgress:time/CMTimeGetSeconds(self.VR_PlayerView.VR_Player.duration)];
    self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPuse;
}

#pragma mark --- 滑动结束
-(void)sliderDidEnd:(UISlider *)slider{
    self.VR_PlayerView.tap.enabled = YES;
    self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    
    if (time > duration) self.VR_PlayerView.label_CurrentTime.text = [self formatSeconds:duration];
    else if (time < 0) {
        
        if (duration > 3600) self.VR_PlayerView.label_CurrentTime.text = @"00:00:00";
        else self.VR_PlayerView.label_CurrentTime.text = @"00:00";
    }
    else self.VR_PlayerView.label_CurrentTime.text = [self formatSeconds:time];
    self.VR_PlayerView.label_AllTime.text = [NSString stringWithFormat:@" / %@",[self formatSeconds:duration]];
    self.VR_PlayerView.slider_ProgressBar.minimumValue = 0.0f;
    self.VR_PlayerView.slider_ProgressBar.maximumValue = duration;
    NSLog(@"视频总长----%f秒",duration);
    self.VR_PlayerView.slider_ProgressBar.value = time;
    self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;
    [self.VR_PlayerView.VR_Player seekToProgress:time/duration];
}

- (NSString *)formatSeconds:(NSUInteger)value {
    
    NSString *str = nil;
    if (value < 3600) return str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(value/60.f)),lround(floor(value/1.f))%60];
    else return str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(value/3600.f)),lround(floor(((NSUInteger)value)%3600)/60.f),lround(floor(value/1.f))%60];
}

-(void)sliderTap:(UITapGestureRecognizer *)tap{
    self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPuse;
    UISlider *slider = (UISlider *)tap.view;
    CGPoint point = [tap locationInView:slider];
    CGFloat length = slider.frame.size.width;
    // 视频跳转的value
    CGFloat tapValue = point.x / length;
    // 视频总时间长度
    CGFloat total           = CMTimeGetSeconds(self.VR_PlayerView.VR_Player.duration);
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(total * tapValue);
    [self setCurrentTime:dragedSeconds duration:total];
    
}
#pragma mark ---- UVPlayeraDelegate
#pragma  mark -------  将要开始播放一个视频。
-(void)player:(UVPlayer*)player willBeginPlayItem:(UVPlayerItem*)item{
    self.VR_PlayerView.button_Play.selected = NO;
    self.isReadyToPlayVR = YES;
}

#pragma  mark -------视频播放开始。当前播放任务顺利开始
-(void)player:(UVPlayer*)player didBeginPlayItem:(UVPlayerItem*)item{
    self.VR_PlayerView.button_Play.selected = YES;
    self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;
}
/** VR播放结束 */
-(void)playerFinished:(UVPlayer *)player{
    self.isEndToPlay = YES;
    if (self.VR_PlayerView) {[self.VR_PlayerView interfaceOrientation:UIInterfaceOrientationPortrait];}
    [self playToEnd];
}
#pragma  mark -------播放视频失败。当前播放任务失败
-(void)player:(UVPlayer*)player playItemFailed:(UVPlayerItem*)item error:(NSError*)error{
    self.VR_PlayerView.button_Play.selected = NO;
    if (self.VR_PlayerView) {[self.VR_PlayerView interfaceOrientation:UIInterfaceOrientationPortrait];}
    UIImageView *BGimageView = [[UIImageView alloc]init];
    BGimageView.image = [UIImage imageNamed:@"img_shipingmorentu_n"];
    UILabel *horizontalLabel = [[UILabel alloc]init];
    horizontalLabel.text =@"视频加载失败";
    horizontalLabel.textColor       = [UIColor whiteColor];
    horizontalLabel.textAlignment   = NSTextAlignmentCenter;
    horizontalLabel.font            = [UIFont systemFontOfSize:15.0];
    horizontalLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:ZFPlayerSrcName(@"ZFPlayer_management_mask")]];
    [BGimageView addSubview:horizontalLabel];
    [player.playerView addSubview:BGimageView];
    [BGimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.playerBGView);
    }];
    [horizontalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(BGimageView);
    }];
}
#pragma  mark -------播放器状态变化
-(void)player:(UVPlayer*)player playingStatusDidChanged:(NSDictionary*)dict{
    if ([dict[@"avalibaleItem"] boolValue]) {
        float rate = [dict[@"rate"] floatValue];
        BOOL bufferFull = [dict[@"bufferFull"] boolValue];
        QNWSWeakSelf(self);
        if (*KNetwork_Type == ENUM_NETWORK_TYPE_NONE) {
            [weakself player:player playItemFailed:self.VR_PlayerView.playItem error:nil];
        }
        else{
            if (rate !=0 && bufferFull){
                weakself.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;
            }
        }
    }
}
#pragma  mark -------缓冲进度
-(void)player:(UVPlayer *)player didCache:(Float64)startSeconds duration:(Float64)duration{
    float total = startSeconds+duration;
    self.VR_PlayerView.progressView.progress = total/CMTimeGetSeconds(player.duration);
}

#pragma  mark ------- 播放进度更新。
-(void)player:(UVPlayer*)player playingTimeDidChanged:(Float64)newTime{
    self.VR_PlayerView.label_CurrentTime.text = [self formatSeconds:newTime];
    self.VR_PlayerView.slider_ProgressBar.value = newTime;
}

#pragma  mark -------获取到总时长
-(void)player:(UVPlayer*)player didGetDuration:(Float64)duration{
    self.VR_PlayerView.label_AllTime.text = [NSString stringWithFormat:@" / %@",[self formatSeconds:duration]];
    self.VR_PlayerView.slider_ProgressBar.maximumValue = duration;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
