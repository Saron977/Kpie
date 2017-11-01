//
//  WX_VoideDViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "AFNetworking.h"
#import "BYC_HomeViewControllerModel.h"
#import "WX_CommentsTableViewCell.h"
#import "BYC_CommonViewController.h"
#import "BYC_LoginAndRigesterView.h"
#import "WX_VoideDViewController.h"
#import "HL_CenterViewController.h"
#import "WX_CommentModel.h"
#import "BYC_UMengShareTool.h"
#import "BYC_AccountTool.h"
#import "WX_FMDBManager.h"
#import "WX_AVplayer.h"
#import "MBProgressHUD.h"
#import <TencentOpenAPI/QQApiInterface.h>

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
#import "ZFPlayer.h"
#import "VRplayerView.h"
#import "HL_VideodetailView.h"
#import "HL_RecommendView.h"
#import "HL_VideoDetailBottomView.h"
#import "BYC_MainNavigationController.h"
#import "WX_GeekViewController.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_HttpServers+FocusVC.h"
#import "BYC_HttpServers+HL_VideoPlayVC.h"
#import "BYC_HttpServers+HL_SaveOrRemoveFriend.h"

#import "HL_CommentViewHandles.h"

#define TableViewCellHeight  70   //语音评论cell的高度
#define KCOMMENTS_OF_PAGE 40     // 每一页的评论数
static NSString *url_ZFPlayer;
static NSString *url_VRPlayer;
@interface WX_VoideDViewController ()<UITextViewDelegate,UIAlertViewDelegate ,BYC_KeyboardToolBarDelegate,UIApplicationDelegate,UVPlayerDelegate,VRPlayerViewDelegate,ClickVideodetailBottomViewButtonDelegate>
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
@property(nonatomic, strong) BYC_BaseVideoModel                           *focusListModel;
@property(nonatomic, strong) WX_FMDBManager                               *manager;
@property(nonatomic, assign) BOOL                                         isEndToPlay;
@property(nonatomic, strong) UIView                                       *shareView;
@property(nonatomic, assign) CGFloat                                      keyboardHeight;               /**< 键盘高度 */

@property(nonatomic, strong) UIImageView                                  *backImgView;                 /**< 视频背景图片 */
@property(nonatomic, strong) NSMutableArray                               *dataArray;                   /**< 全部评论 */
@property(nonatomic, strong) NSMutableArray                               *userArray;                   /**< 用户评论 */
@property(nonatomic, strong) NSMutableArray                               *teacherArray;                /**< 名师评论 */

@property(nonatomic, strong) UILabel                                      *commentsLabel;
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
@property(nonatomic, strong) BYC_BaseVideoModel                            *leftLikeModel;                 /**< 喜欢界面,模型 */

@property(nonatomic, strong) HL_RecommendView                             *videoView;                     /**< 视频播放后显示界面 */

@property(nonatomic, strong) NSMutableArray                               *randomArray;                   /**< 相关视频数组 */
@property(nonatomic, assign) BOOL                                         isFavorite;                     /**< 记录是否赞过,播放完后界面会显示 */
@property(nonatomic, assign) BOOL                                         needToPlay;

@property(nonatomic, assign) NSInteger                                    reportNum;                      /**< 举报编号 */

@property(nonatomic, strong) BYC_KeyboardToolBar                          *myKeyboardToolBar;              /**< 输入框 */
@property(nonatomic, strong) BYC_KeyboardContent                          *faceScrollView;
@property(nonatomic, assign) BOOL                                         isNeedPlaceHoder;                 /**< 判断是否需要案文 */
@property(nonatomic, assign) BOOL                                         isShowEmojiView;                  /**< YES:显示Emoji NO:不显示Emoji */
@property(nonatomic, strong) WX_ScriptModel                               *scriptModel;                     /**<  剧本合拍模型 */
@property(nonatomic, strong) NSMutableArray                               *favorList_Array;                 /**<  设置喜欢,评论数组信息 */

/** VR视频播放器 */
@property (nonatomic, strong) VRplayerView                                 *VR_PlayerView;
/** ZF播放器 */
@property (nonatomic, strong) ZFPlayerView                                 *ZF_PlayerView;

@property (nonatomic, strong) id <UVPlayerDelegate> VRplayerDelagete;

@property (nonatomic, assign) BOOL isReadyToPlayVR;
@property (nonatomic, strong) id itemEndObserver;
@property (nonatomic, assign) NSInteger                                      self_Controlles;      /**<   判断当前控制器数, 只有一个是 WX_VoideDViewController,并且在didDissapper 中为null 就进行退出操作*/

@property (nonatomic, strong) HL_VideodetailView                        *tableheaderView;  /**<  表头*/
/** 底部评论视图 */
@property (nonatomic, strong) HL_VideoDetailBottomView                  *view_bottomComment;

@property (nonatomic, strong) UIAlertView *alter1;
@property (nonatomic, strong) UIAlertView *alter2;

@property (nonatomic, strong) HL_CommentViewHandles                    *commentViewHandlesView;
@property (nonatomic, assign) BOOL                                     isAddCommentViewHandlesView;

@end
@implementation WX_VoideDViewController

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

-(HL_CommentViewHandles *)commentViewHandlesView{
    if (!_commentViewHandlesView) {
        _commentViewHandlesView = [[HL_CommentViewHandles alloc]initCommentViewHandles];
    }
    return _commentViewHandlesView;
}

- (void)dealloc
{
    NSLog(@"%@释放了",self.class);
//    [self.ZF_PlayerView resetPlayer];
    if (self.ZF_PlayerView) {
        [self.ZF_PlayerView cancelAutoFadeOutControlBar];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.isAddCommentViewHandlesView = NO;
    [self createUI];
    [self.view addSubview:self.view_bottomComment];
    if (_isVR) [self createVRPlayer];
    else [self createAVplayer];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self videoClicks];
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
    [QNWSNotificationCenter addObserver:self selector:@selector(getAllListUserCommentsWithDic) name:@"deletComment" object:nil];
    [self NewsFromLeftMessage];
    [self getAllListUserCommentsWithDic];
    
    if (_self_Controlles >= 1 && self.navigationController.viewControllers.count >= 1) {
        if (_isVR) {
            if (!self.isEndToPlay) self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;
            else [self playAgainVideo:nil];
            
            [self.playerBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.view);
            }];
            self.commentViewHandlesView.commentTableView.hidden = YES;
        }
        else{
            if (self.ZF_PlayerView.playDidEnd) [self playAgainVideo:nil];
            else [self.ZF_PlayerView play];
            [self.playerBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.view);
                make.height.equalTo(self.view.mas_height).multipliedBy(0.48);
            }];
            self.commentViewHandlesView.commentTableView.hidden = NO;
        }
    }
    if (_isVR) {
        KMainNavigationVC.isVR = YES;
        [self setNavigationRotateLandscape];
        if (self.VR_PlayerView) {
            [self.VR_PlayerView setNeedsLayout];
        }
    }
    else{
        KMainNavigationVC.isVR = NO;
        // 调用playerView的layoutSubviews方法
        if (self.ZF_PlayerView) { [self.ZF_PlayerView setNeedsLayout]; }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    QNWSLog(@"视图即将消息----self.navigationController.viewControllers === %@   _self_Controlles====%zi",self.navigationController.viewControllers,_self_Controlles);
    [self viewDismiss];
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
        [QNWSNotificationCenter removeObserver:self name:@"deletComment" object:nil];
}
    @catch (NSException *exception) {QNWSShowException(exception);}
    if (_isVR) {
        self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPuse;
    }
    else{
        [self.ZF_PlayerView pause];
    }
}
/** VR横屏 */
-(void)setNavigationRotateLandscape{
    if (self.VR_PlayerView) {
        self.VR_PlayerView.label_Top_Title.text = self.focusListModel.videotitle;
        [self.VR_PlayerView interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        [UIApplication sharedApplication].statusBarHidden = YES;
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
    if (self.arrayModel.count >= 1) {
        self.focusListModel = self.arrayModel[self.num];
    }
}

-(void)receiveFromLeftLikeWithModel:(BYC_BaseVideoModel *)model
{
    self.leftLikeModel = model;
    self.isFormLeftLike = YES;
    self.focusListModel      = [[BYC_BaseVideoModel alloc]init];
    self.focusListModel = model;
    
}
#pragma mark ------------- 接收消息界面跳转过来
-(void)receiveFromLeftMessageWithModel:(BYC_LeftMassegeModel *)model
{
    self.leftMessageModel = model;
    self.isFromLeftMessage = YES;
    self.focusListModel = [[BYC_BaseVideoModel alloc]init];
    self.focusListModel = self.leftMessageModel.video;
}
#pragma mark -------- 设置来自消息界面跳进 键盘
-(void)NewsFromLeftMessage{
    if (!self.myKeyboardToolBar) {
        [self initCustomKeyBoard];
    }
    if (self.isFromLeftMessage) {
        if (self.leftMessageModel.users.usertype != 10) {
            //弹键盘
            self.placeHolder = [NSString stringWithFormat:@"回复@%@:",self.leftMessageModel.users.nickname];
            self.myKeyboardToolBar.textView_Content.placeholder = self.placeHolder;
            [self.myKeyboardToolBar.textView_Content becomeFirstResponder];
            self.myKeyboardToolBar.hidden = NO;
            self.backView.hidden = NO;
        }
    }
}
#pragma mark ------------------------------------------- 接口区
#pragma mark ------------ 获取相关视频
-(void)getAllListUserCommentsWithDic{
    if (!_favorList_Array) {
        _favorList_Array = [[NSMutableArray alloc]init];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    QNWSDictionarySetObjectForKey(parameters, self.focusListModel.userid, @"toUserId")
    QNWSDictionarySetObjectForKey(parameters, @0, @"upType")
    QNWSDictionarySetObjectForKey(parameters, [BYC_AccountTool userAccount].userid == nil ? @"" : [BYC_AccountTool userAccount].userid, @"userId")
    QNWSDictionarySetObjectForKey(parameters, self.focusListModel.videoid, @"videoId")
    

    [BYC_HttpServers requestVideoPlayInfoWithWithParameters:parameters success:^(HL_VideoPlayPageModel *videoPlayPageModel) {
        //评论
        [self.commentViewHandlesView commentsFromNetWithComList_Array:[videoPlayPageModel.array_OrdCommentModels mutableCopy] TcList_Array:[videoPlayPageModel.array_TcCommentModels mutableCopy] andWithModel:self.focusListModel];
        
        self.userArray = [videoPlayPageModel.array_OrdCommentModels mutableCopy];
        self.teacherArray = [videoPlayPageModel.array_TcCommentModels mutableCopy];
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:self.userArray];
        [self.dataArray addObject:self.teacherArray];
        
        self.focusListModel.views     = videoPlayPageModel.VideoModel.views;
        self.focusListModel.favorites = videoPlayPageModel.VideoModel.favorites;
        self.focusListModel.comments  = videoPlayPageModel.VideoModel.comments;
        self.tableheaderView.focusListModel = self.focusListModel;
        self.view_bottomComment.focusListModel = self.focusListModel;
        
        if (videoPlayPageModel.VideoModel.isfavor) {
            self.view_bottomComment.button_like.selected = YES;
            if (self.videoView.endToFavoriteBtn) self.videoView.endToFavoriteBtn.selected = YES;
            self.isFavorite = YES;
        }
        else{
            self.view_bottomComment.button_like.selected = NO;
            if (self.videoView.endToFavoriteBtn) self.videoView.endToFavoriteBtn.selected = NO;
            self.isFavorite = NO;
        }
        if (videoPlayPageModel.array_RandVideoModels.count > 0)  [self getRandomVideoFromNetWithArray:videoPlayPageModel.array_RandVideoModels];
        //        通过键值对方式取值：
        //        scrList 所属剧本信息
//        NSArray *scrList_Array = responseObject[@"scrList"];
        //        state  关注状态
        //      1互相关注 2已关注 3被关注 4未关注
        if ([self.focusListModel.userid isEqualToString:[BYC_AccountTool userAccount].userid]) {
            self.tableheaderView.button_Focus.hidden = YES;
            self.tableheaderView.button_Focus.selected = YES;
        }
        else{
            if (videoPlayPageModel.AttentionState == 1 || videoPlayPageModel.AttentionState == 2 || videoPlayPageModel.AttentionState == 3) {
                self.tableheaderView.button_Focus.selected = YES;
                self.tableheaderView.button_Focus.hidden   = YES;
            }
            else {
                self.tableheaderView.button_Focus.selected = NO;
                self.tableheaderView.button_Focus.hidden   = NO;
            }

        }
        
        self.tableheaderView.likeArr = videoPlayPageModel.array_FavorUserModels;

//        [QNWSNotificationCenter postNotificationName:@"KNotification_isLikeVideo" object:nil];
    } failure:^(NSError *error) {
        
    }];
}

/**  播放完的推荐视频获取接口 */
-(void)getRandomVideoFromNetWithArray:(NSArray*)randList_Array{
    [self.randomArray removeAllObjects];
    for (WX_RandomVideoModel *randVideoModel in randList_Array) {
        [self.randomArray addObject:randVideoModel];
    }
}
#pragma mark --------- 添加关注接口
-(void)cilckFocus
{
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        NSArray *arr_params = @[[BYC_AccountTool userAccount].userid,self.focusListModel.userid];
        [BYC_HttpServers requestSaveFriendWithParameters:arr_params success:^(BOOL isSaveSuccess) {
            if (isSaveSuccess) {
                [UIView animateWithDuration:1.f animations:^{
                    self.tableheaderView.button_Focus.alpha = 0.f;
                } completion:^(BOOL finished) {
                    self.tableheaderView.button_Focus.hidden = YES;
                    if (self.focusListModel.isvr == 2) {
                        [self.tableheaderView.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(self.tableheaderView.mas_right).offset(-12);
                        }];
                    }
                }];
                [self getAllListUserCommentsWithDic];
            }
        } failure:^(NSError *error) {
        }];
    }];
    
}

#pragma mark ----------- 判断是否喜欢_收藏接口
-(void)favorite:(UIButton *)button
{
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){        
        button.selected = !button.selected;
        /// 服务器喜欢请求
        NSArray *array_isLikeParam;
        if (button.selected) {
            /// 添加为喜欢
            array_isLikeParam = @[[BYC_AccountTool userAccount].userid,self.focusListModel.videoid,@"0"];
            }else{// 取消喜欢
             array_isLikeParam = @[[BYC_AccountTool userAccount].userid,self.focusListModel.videoid,@"1"];
        }
        [BYC_HttpServers requestFocusVCSaveUserFavoritesWithParameters:array_isLikeParam andWithType:[array_isLikeParam[2] integerValue] success:^(BOOL isSuccess) {
            if (isSuccess) {
                [self getAllListUserCommentsWithDic];
                [QNWSNotificationCenter postNotificationName:@"KNotification_isLikeVideo" object:nil userInfo:@{@"isFavorite":[NSNumber numberWithBool:button.selected]}];
                QNWSLog(@"播放界面点赞 %zi",self.focusListModel.favorites);
            }
              
        } failure:^(NSError *error) {
            [self.view showAndHideHUDWithTitle:@"收藏失败" WithState:BYC_MBProgressHUDHideProgress];
            self.view_bottomComment.button_like.selected = NO;
            if (self.videoView.endToFavoriteBtn) self.videoView.endToFavoriteBtn.selected = NO;
            self.isFavorite = NO;
            self.focusListModel.isfavor    = NO;
            QNWSLog(@"收藏接口信息发送失败,error == %@",error);
        }];

    }];
}
#pragma mark ---------- 举报接口
-(void)reportTheVideoResponseObjectWithReportStr:(NSString *)reportStr{
    
    BYC_AccountModel *model = [BYC_AccountTool userAccount];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    QNWSDictionarySetObjectForKey(dic, reportStr, @"reportreason")
    QNWSDictionarySetObjectForKey(dic, self.focusListModel.videoid,@"reportvideoid")
    QNWSDictionarySetObjectForKey(dic, model.userid, @"userid")
    [BYC_HttpServers requestVideoPlayVCReportWithParameters:dic];
}


#pragma mark --------- 判断是否已关注接口
/**  视频点击量 */
-(void)videoClicks{
    ///当前用户和登陆用户一致 不显示关注按钮
    if ([self.focusListModel.userid isEqualToString:[BYC_AccountTool userAccount].userid]) {
        if (!self.tableheaderView.button_Focus.hidden) {
            self.tableheaderView.button_Focus.hidden = YES;
            if (self.focusListModel.isvr == 2) {
                [self.tableheaderView.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.tableheaderView.mas_right).offset(-12);
                }];
            }
        }
    }else{
        //1互相关注 2已关注 3被关注 4未关注
        if (self.focusListModel.users.attentionstate == 1 || self.focusListModel.users.attentionstate == 2 || self.focusListModel.users.attentionstate == 3) {
            self.tableheaderView.button_Focus.selected = YES;
            self.tableheaderView.button_Focus.hidden = YES;
            if (self.focusListModel.isvr == 2) {
                [self.tableheaderView.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.tableheaderView.mas_right).offset(-12);
                }];
            }

        }
        else {
            self.tableheaderView.button_Focus.selected = NO;
            self.tableheaderView.button_Focus.hidden = NO;
            self.tableheaderView.button_Focus.alpha = 1.0;
            if (self.focusListModel.isvr == 2) {
                [self.tableheaderView.button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.tableheaderView.mas_right).offset(-46);
                }];
            }
        }
    }
    NSArray *arr = @[self.focusListModel.videoid];
    [BYC_HttpServers requestVideoPlayVCPlayedCountWithParameters:arr Success:^{
        [self getAllListUserCommentsWithDic];
    } failure:^{
    }];
}

#pragma mark  ----------- 上传评论
/// 上传评论
-(void)SaveUserCommentsFromNet{
    BYC_AccountModel *accountModel = [BYC_AccountTool userAccount];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.commentsStr forKey:@"content"];
    [dic setValue:accountModel.userid forKey:@"userid"];
    [dic setValue:self.focusListModel.videoid forKey:@"videoid"];
    if (self.isToComment) {
        WX_CommentModel *model = self.userArray[self.toCommentIdNum];
        [dic setValue:model.commentid forKey:@"tocommentid"];
        QNWSLog(@"model.commentID == %@",model.commentid);
    }else if (self.isFromLeftMessage ){
        [dic setValue:self.leftMessageModel.commentid forKey:@"tocommentid"];
    }else{
        [dic setValue:nil forKey:@"tocommentid"];
    }
    
    if (self.isVoice) {//声音评论
        self.isVoice = NO;
        _objectKey = [NSString createFileName:@"voice.amr" andType:ENUM_ResourceTypeVoices];
        
//#ifdef DEBUG
//        NSString *stringIP = [QNWS_Main_HostIP copy];
//        
//        if ([stringIP isEqualToString:KQNWS_KPIE_MAIN_URL] || [stringIP isEqualToString:@"http://112.74.88.81/api/"]) {
//            ///正式服务器__ 阿里云上传正式路径
//            _voicePath = [NSString stringWithFormat:@"%@%@",KQNWS_VIDEOFilePath,_objectKey];
//        }else{
//            ///本地服务器__ 阿里云上传测试路径
//            _voicePath = [NSString stringWithFormat:@"%@%@",KQNWS_OSSTestFilePath,_objectKey];
//            
//        }
//#else
        /// release 模式下, 固定阿里云上传路径
        _voicePath = [NSString stringWithFormat:@"%@%@",KQNWS_VIDEOFilePath,_objectKey];
//#endif
        
        [dic setValue:_voicePath forKey:@"content"];
        [dic setValue:@"true" forKey:@"isvoice"];
        [dic setValue:[NSString stringWithFormat:@"%zi",_voiceLength] forKey:@"seconds"];
        [BYC_AliyunOSSUpload uploadWithObjectKey:_objectKey Data:self.voiceData andType:resourceTypeVideo completion:^(BOOL finished) {
            if (finished) {
                QNWSLog(@"音频文件上传成功");
                [BYC_HttpServers requestVideoPlayVCUploadCommentWithParameters:dic Success:^(BOOL isUploadSuccess) {
                    if (isUploadSuccess == YES) {
                        [self getAllListUserCommentsWithDic];
                        if (self.needToPlay) {[self setMediaPlayerPlayStatus];}
                    }
                    else{
                        [self getAllListUserCommentsWithDic];
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
        [dic setValue:@"false" forKey:@"isvoice"];
        [BYC_HttpServers requestVideoPlayVCUploadCommentWithParameters:dic Success:^(BOOL isUploadSuccess) {
            if (isUploadSuccess == YES) {
                [self.myKeyboardToolBar.textView_Content resignFirstResponder];
                [self getAllListUserCommentsWithDic];
            }
            self.backView.hidden = YES;            
            self.placeHolder = @"  在此处输入...";
            self.myKeyboardToolBar.textView_Content.placeholder = self.placeHolder;
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
            self.videoView.endToFavoriteBtn.selected = YES;}
        self.isFavorite = YES;
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
-(void)createUI{
    self.tableheaderView = [[HL_VideodetailView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, [HL_VideodetailView returnHeightOfFocusHeaderView:self.focusListModel])];
    self.commentViewHandlesView.height_tableViewHeader = [HL_VideodetailView returnHeightOfFocusHeaderView:self.focusListModel];
    self.tableheaderView.focusListModel = self.focusListModel;
    self.view_bottomComment.focusListModel = self.focusListModel;
    QNWSWeakSelf(self);
    self.tableheaderView.selectButton = ^(BYC_FocusCollectionViewCellSelected selectButton ,BYC_BaseVideoModel *model){
        __block BYC_BackFocusListCellModel *backModel = nil;
        [weakself clickButtonAction:selectButton model:model];
        return backModel;
    };
    self.tableheaderView.clickHeaderButtonBlock = ^(BYC_BaseVideoModel *model){

        [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
            
            HL_CenterViewController *myCenterVC = [[HL_CenterViewController alloc] init];
            myCenterVC.str_ToUserID = model.userid;
            [weakself.navigationController pushViewController:myCenterVC animated:YES];
        }];
};
    // 播放器画布
    if (!self.playerBGView) {
        self.playerBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*0.48)];
        self.playerBGView.backgroundColor = [UIColor clearColor];
        [self.backImgView sd_setImageWithURL:[NSURL URLWithString:self.focusListModel.picturejpg] placeholderImage:nil];
        [self.playerBGView addSubview:self.backImgView];
        [self.view addSubview:self.playerBGView];
        self.playerBGView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    if (_isVR) {
        [self.playerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(self.view);
        }];
    }
    else{
        [self.playerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.equalTo(self.view.mas_height).multipliedBy(0.48);
        }];
    }
    self.commentViewHandlesView.commentTableView.tableHeaderView = self.tableheaderView;
    [self judgeFavoriteBtnSelectSate];
    if (!self.isAddCommentViewHandlesView) {
        [self.view addSubview:self.commentViewHandlesView.videoScrollView];
        [self.commentViewHandlesView.videoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerBGView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        }];
        self.isAddCommentViewHandlesView = YES;
    }
    [self initCustomKeyBoard];
}
- (void)clickButtonAction:(BYC_FocusCollectionViewCellSelected)selectButton model:(BYC_BaseVideoModel *)model{
    switch (selectButton) {
        case BYC_FocusCollectionViewCellSelectedShoot:{//合拍
            NSArray *arr_parameters = @[model.scriptid];
            [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
                [self getScriptDetail:arr_parameters];
            }];
        }
            break;
        case BYC_FocusCollectionViewCellSelectedFocus:{//关注
            [self cilckFocus];
        }
            break;
        default:
            break;
    }
}
#pragma mark -----获取剧本信息
-(void)getScriptDetail:(NSArray *)arr_parameters{
    [BYC_HttpServers requestVideoPlayVCscriptModelOnNetWithParameters:arr_parameters success:^(WX_ScriptModel *scriptModel) {
        WX_ShootingScriptViewController *scriptVC = [[WX_ShootingScriptViewController alloc]init];
        scriptVC.videoD_ScriptModel = scriptModel;
        [self.navigationController pushViewController:scriptVC animated:YES];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ------ 默认状态的底部View
-(HL_VideoDetailBottomView *)view_bottomComment{
    if (!_view_bottomComment) {
        _view_bottomComment = [[HL_VideoDetailBottomView alloc]initWithFrame:CGRectMake(0, screenHeight-50, screenWidth, 50)];
        _view_bottomComment.buttonDelegate = self;
        [self.view addSubview:self.view_bottomComment];
    }
    return _view_bottomComment;
}
#pragma mark -------默认状态的底部button的点击事件
-(void)clickBottomButton:(UIButton *)sender{
    
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
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
    }];
}

#pragma mark ----------------- 创建播放器
// 创建AV播放器
-(void)createAVplayer{
    if (self.VR_PlayerView) {
        [self.VR_PlayerView removeFromSuperview];
        self.VR_PlayerView.hidden = YES;
    }
    self.ZF_PlayerView = [[ZFPlayerView alloc]init];
    [self.playerBGView addSubview:self.ZF_PlayerView];
    self.ZF_PlayerView.hidden = NO;
    [self.playerBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.48);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.ZF_PlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.playerBGView);
    }];
    // 设置播放前的占位图（需要在设置视频URL之前设置）
    self.ZF_PlayerView.placeholderImageName = @"img_shipingmorentu_n";
    //设置视频的URL
    if (!self.focusListModel.videomp4.length) {
        NSString *urlString;
        // 加载网络视频
        if (self.isFromLeftMessage) {
            BYC_LeftMassegeModel *model = self.leftMessageModel;
            self.mediaID = model.videoid;
            urlString = model.video.videomp4;
            
            //实例化item.包含播放时间等信息
        }else if (self.isFormLeftLike){
            BYC_BaseVideoModel *model = self.leftLikeModel;
            self.mediaID = model.videoid;
            urlString = model.videomp4;
        }else{
            BYC_HomeViewControllerModel *model = self.arrayModel[self.num];
            self.mediaID = model.videoid;
            urlString = model.videomp4;
        }
        url_ZFPlayer = urlString;
    }else{url_ZFPlayer = self.focusListModel.videomp4;}
    [self setVideoPlayItem:url_ZFPlayer];
}
//创建VR播放器
-(void)createVRPlayer{
    if (self.ZF_PlayerView) {
        [self.ZF_PlayerView removeFromSuperview];
        self.ZF_PlayerView.hidden = YES;
    }
    if (!self.VR_PlayerView) {
        self.VR_PlayerView = [[VRplayerView alloc]init];
        self.VR_PlayerView.VRdelagete = self;
        self.VR_PlayerView.VR_Player.delegate = self;
        if (!self.focusListModel.videomp4.length) {
            NSString *urlString;
            // 加载网络视频
            if (self.isFromLeftMessage) {
                BYC_LeftMassegeModel *model = self.leftMessageModel;
                self.mediaID = model.videoid;
                urlString = model.video.videomp4;
                
                //实例化item.包含播放时间等信息
            }else if (self.isFormLeftLike){
                BYC_BaseVideoModel *model = self.leftLikeModel;
                self.mediaID = model.videoid;
                urlString = model.videomp4;
            }else{
                BYC_HomeViewControllerModel *model = self.arrayModel[self.num];
                self.mediaID = model.videoid;
                urlString = model.videomp4;
            }
            //实例化item.包含播放时间等信息
            urlString= [NSString stringWithFormat:@"%@",urlString];
            urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
            url_VRPlayer = encodedString;
        }else{
            
            NSString *vrUrlStr= [NSString stringWithFormat:@"%@",self.focusListModel.videomp4];
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
        self.VR_PlayerView.hidden = NO;
        [self.VR_PlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.playerBGView);
        }];
    }
}

-(void)setVideoPlayItem:(NSString *)url_ZFPlayer{
    if (*KNetwork_Type == ENUM_NETWORK_TYPE_NONE){
        [self.view showAndHideHUDWithTitle:@"无网络连接" WithState:BYC_MBProgressHUDHideProgress];
        self.ZF_PlayerView.controlView.lockBtn.hidden = YES;
        self.ZF_PlayerView.button_CenterPlay.hidden = YES;
        self.ZF_PlayerView.controlView.videoSlider.enabled = NO;
    }
    else{
        if (QNWSUserDefaultsObjectForKey(KSTR_KNetwork_IsWiFi)) {
            if (*KNetwork_Type == ENUM_NETWORK_TYPE_WiFi) {
                self.ZF_PlayerView.videoURL = [NSURL URLWithString:url_ZFPlayer];
            }else{
                if (!self.alter1) {
                    self.alter1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前为非Wi-fi网络，继续播放需要关闭“仅Wi-Fi联网”功能。是否关闭 ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定关闭", nil];
                    self.alter1.tag = 400;
                    [self.alter1 show];
                }
            }
        }
        else{
            if (*KNetwork_Type == ENUM_NETWORK_TYPE_WiFi) {
                self.ZF_PlayerView.videoURL = [NSURL URLWithString:url_ZFPlayer];
            }
            else{
                if (!self.alter2) {
                    if (*KNetwork_Type == ENUM_NETWORK_TYPE_Mobile) {
                        self.alter2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"“仅Wi-Fi联网”功能已关闭，当前为非Wi-Fi网络，是否继续播放 ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
                        self.alter2.tag = 500;
                        [self.alter2 show];
                    }
                }
            }
        }
    }
    self.ZF_PlayerView.lable_title = self.focusListModel.videotitle;
    // 分辨率字典（key:分辨率名称，value：分辨率url)
//    NSMutableDictionary *dic = @{}.mutableCopy;
//    [dic setValue:@"" forKey:@""];
    // 赋值分辨率字典
//    self.ZF_PlayerView.resolutionDic = dic;
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.ZF_PlayerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    // 打开断点下载功能（默认没有这个功能）
    self.ZF_PlayerView.hasDownload = NO;
    // 是否自动播放，默认不自动播放
    [self.ZF_PlayerView autoPlayTheVideo];
    QNWSWeakSelf(self);
    self.ZF_PlayerView.playToendBlock = ^(BOOL isPlayToend){
        if (isPlayToend) {[weakself playToEnd];}
    };
    self.ZF_PlayerView.goBackBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    self.ZF_PlayerView.reportBlock = ^{
        [weakself mediaPlayReportTheVideo];
    };
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
            if (_isVR) KMainNavigationVC.isVR = YES;
            else KMainNavigationVC.isVR = NO;
            [super updateViewConstraints];
            self.commentViewHandlesView.commentTableView.hidden = NO;
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
            if (_isVR) KMainNavigationVC.isVR = YES;
            else KMainNavigationVC.isVR = NO;
            [super updateViewConstraints];
            self.commentViewHandlesView.commentTableView.hidden = YES;
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
            if (_isVR) KMainNavigationVC.isVR = YES;
            else KMainNavigationVC.isVR = NO;
            [super updateViewConstraints];
            self.commentViewHandlesView.commentTableView.hidden = YES;
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
#pragma mark ------------ 初始化自定义键盘
-(void)initCustomKeyBoard{
    self.myKeyboardToolBar = [self myKeyboardToolBar];
    self.backView = [self backView];     // 点击收起键盘
    
}
-(BYC_KeyboardToolBar *)myKeyboardToolBar{
    if (!_myKeyboardToolBar) {
        _myKeyboardToolBar = [[BYC_KeyboardToolBar alloc] initWithFrame:CGRectZero];
        _myKeyboardToolBar.bottom = screenHeight;
        _myKeyboardToolBar.delegate_KeyboardToolBar = self;
        _myKeyboardToolBar.backgroundColor = KUIColorBackgroundModule1;
        [self.view addSubview:_myKeyboardToolBar];
    }
    return _myKeyboardToolBar;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = KUIColorFromRGBA(0x00000, 0.3);
        _backView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HiddenTheKeyBoard)];
        [_backView addGestureRecognizer:tap];
        _backView.hidden = YES;
        [self.view addSubview:self.backView];
        [self.view bringSubviewToFront:self.backView];
    }
    return _backView;
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
        [BYC_LoginAndRigesterView shareLoginAndRigesterViewSuccess:nil failure:nil];
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
    for (UIWindow *window in [windows reverseObjectEnumerator]){//逆序效率更高，因为键盘总在上方
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView){return keyboardView;}
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
//录音失败
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
        if (_isVR) {
            if (!_isEndToPlay) {self.needToPlay = YES;}
        }
        else{
            if (!self.ZF_PlayerView.playDidEnd) {self.needToPlay = YES;}
        }
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
    if (_isVR) self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPuse;
    else [self.ZF_PlayerView pause];
}
/** 播放状态 */
-(void)setMediaPlayerPlayStatus{
    if (_isVR) {
        if (!self.isEndToPlay) {self.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;}
    }
    else {
        if (!self.ZF_PlayerView.playDidEnd) {
            if (self.ZF_PlayerView.state == ZFPlayerStatePause) { [self.ZF_PlayerView pause];}
            else if (self.ZF_PlayerView.state == ZFPlayerStatePlaying){ [self.ZF_PlayerView play];}
        }
    }
}

#pragma mark -------  举报
-(void)mediaPlayReportTheVideo{
    [self reportTheVideo];
}
#pragma mark -------- 播放语音时,暂停播放视频
-(void)videoPaseOfVoice{
    [self setMediaPlayerPuaeStatus];
}
//语音播放结束
-(void)videoPlayOfVoice{
    [self setMediaPlayerPlayStatus];
}

#pragma mark --------- 暂停所有语音动画
-(void)stopAllAnimation{
    for (int i = 0; i < self.dataArray.count; i++){
        NSArray *array = self.dataArray[i];
        for (int j = 0; j < array.count; j++) {
            WX_CommentsTableViewCell *cell = [self.commentViewHandlesView.commentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
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
    if (_isVR) {
        [self setNavigationRotateLandscape];
        [self.VR_PlayerView.VR_Player replayLast];
    }
    else{
        [self.ZF_PlayerView repeatPlay:rePlayBtn];
        self.ZF_PlayerView.state = ZFPlayerStatePlaying;
    }
}

#pragma mark ---------- 点击手势,进入推荐视频
-(void)toSeeRecommendedVideo:(UITapGestureRecognizer *)tap{
    WX_RandomVideoModel *model;
    if (tap.view.tag == 401) model = [self.randomArray firstObject];// 左侧推荐视频
    else if (tap.view.tag == 402) model = [self.randomArray lastObject];// 右侧推荐视频
    [self receiveTheModelWith:@[model] WithNum:0 WithType:1];
    if (model.isvr == 0) {
        [self.playerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(self.view.mas_height).multipliedBy(0.48);
        }];
        KMainNavigationVC.isVR = NO;
        self.isVR = NO;
        if (!self.ZF_PlayerView) [self createAVplayer];
        else {
            if (self.VR_PlayerView) {
                if (!self.VR_PlayerView.hidden) {
                    [self.VR_PlayerView removeFromSuperview];
                    self.VR_PlayerView.hidden = YES;
                }
                if (self.ZF_PlayerView.hidden) {
                    [self.playerBGView addSubview:self.ZF_PlayerView];
                    self.ZF_PlayerView.hidden = NO;
                }
            }
            [self.ZF_PlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.right.equalTo(self.playerBGView);
            }];
            [self.ZF_PlayerView.player replaceCurrentItemWithPlayerItem:nil];
            [self.ZF_PlayerView.playerLayer removeFromSuperlayer];
            [self.ZF_PlayerView.controlView resetControlView];
            [self setVideoPlayItem:model.videomp4];
        }
    }
    else if(model.isvr == 1){
        KMainNavigationVC.isVR = YES;
        self.isVR = YES;
        [self.playerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
        if (!self.VR_PlayerView) [self createVRPlayer];
        else {
            if (self.ZF_PlayerView) {
                if (!self.ZF_PlayerView.hidden) {
                    [self.ZF_PlayerView removeFromSuperview];
                    self.ZF_PlayerView.hidden = YES;
                }
                if (self.VR_PlayerView.hidden) {
                    [self.playerBGView addSubview:self.VR_PlayerView];
                    self.VR_PlayerView.hidden = NO;
                }
            }
            [self.VR_PlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.playerBGView);
            }];
            self.VR_PlayerView.playItem = [[UVPlayerItem alloc]initWithPath:model.videomp4 type:UVPlayerItemTypeOnline];
        }
        self.commentViewHandlesView.commentTableView.hidden = YES;
        self.myKeyboardToolBar.hidden = YES;
        [self setNavigationRotateLandscape];
    }
    else{
        self.isVR = NO;
        [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
    }
    [self createUI];
    self.commentViewHandlesView.commentTableView.tableHeaderView = self.tableheaderView;
    [self getAllListUserCommentsWithDic];
    [self initPaseViewWithHidden:YES];
}
#pragma mark ---------- 播放结束,显示界面
- (void)playToEnd{
    [self initPaseViewWithHidden:NO];
}

#pragma mark -------- 分享
-(void)share{
    //未登录跳转去登陆
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        [[BYC_ShareView alloc] showWithDelegateVC:self shareContentOrMedia:BYC_ShareTypeMedia shareWithDic:@{const_ShareResourceID:self.focusListModel.videoid,const_ShareUserID:self.focusListModel.userid,const_ShareResourceTitle:self.focusListModel.videotitle,const_ShareResourceImage:self.focusListModel.picturejpg}];
    }];
}
#pragma mark ---------- 评论
-(void)comment:(UIButton *)button
{
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){        
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
    }];
    
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
    self.placeHolder = [NSString stringWithFormat:@"回复 @%@:",model.users.nickname];
    self.myKeyboardToolBar.textView_Content.placeholder = self.placeHolder;
    [self.myKeyboardToolBar.textView_Content becomeFirstResponder];
    QNWSLog(@"点击了 该回复啦");
}

#pragma mark ---------- 举报视频
-(void)reportTheVideo{
    QNWSLog(@"点击,举报该视频");
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"举报" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"涉及色情或政治内容",@"其他原因",@"取消", nil];
        alert.tag = 100;
        
        [alert show];
    }];
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
    if (alertView.tag == 400) {
        if (buttonIndex == 0) {
            QNWSUserDefaultsSetObjectForKey(@"wifi", KSTR_KNetwork_IsWiFi);
        }else if (buttonIndex == 1){
            [self closeOnlyWifi];
            QNWSUserDefaultsSetObjectForKey(nil, KSTR_KNetwork_IsWiFi);
        }
    }
    if (alertView.tag == 500) {
        if (buttonIndex == 0) {
            self.ZF_PlayerView.controlView.lockBtn.hidden = YES;
            self.ZF_PlayerView.button_CenterPlay.hidden = YES;
            self.ZF_PlayerView.controlView.videoSlider.enabled = NO;
        }else if (buttonIndex == 1){
            self.ZF_PlayerView.videoURL = [NSURL URLWithString:url_ZFPlayer];
            [self.ZF_PlayerView autoPlayTheVideo];
        }
    }
}
-(void)closeOnlyWifi{
    if (*KNetwork_Type == ENUM_NETWORK_TYPE_Mobile) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否在Wi-Fi网络再播放 ？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Wi-Fi时播放",@"继续播放", nil];
        alter.tag = 500;
        [alter show];
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
    self.isEndToPlay = NO;
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
        if (*KNetwork_Type == ENUM_NETWORK_TYPE_NONE) {[weakself player:player playItemFailed:self.VR_PlayerView.playItem error:nil];}
        else{if (rate !=0 && bufferFull){weakself.VR_PlayerView.controlPlayerStatus = ENUM_PlayerStatusPlay;}}
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


