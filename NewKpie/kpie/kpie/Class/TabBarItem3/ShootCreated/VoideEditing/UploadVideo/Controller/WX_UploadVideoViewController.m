//
//  WX_UploadVideoViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//
#import "AFNetworking.h"
#import "WX_UploadVideoViewController.h"
#import "WX_GLocationViewController.h"
#import "WX_AddTopicViewController.h"
#import "WX_DraftBoxViewController.h"
#import "BYC_UMengShareTool.h"
#import "BYC_LoginAndRigesterView.h"
#import "BYC_MainTabBarController.h"
#import "BYC_AccountTool.h"
#import "WX_UploadModel.h"
#import "WX_GlocationModel.h"
#import "BYC_AliyunOSSUpload.h"
#import "NSString+BYC_HaseCode.h"
#import "WX_FMDBManager.h"
#import "WX_DBBoxModel.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "IQKeyboardManager.h"
#import "BYC_UserAgreementViewController.h"
#import "BYC_MainTabBarController.h"
#import "BYC_PropertyManager.h"
#import "WX_ToolClass.h"
#import "CoverFlowView.h"
#import "WX_AddUrlView.h"
#import "WX_UploadHandleModel.h"
#import "WX_UploadHandle.h"
#import "WX_ShareModel.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define INTERVAL_KEYBOARD 20
#define UPLOADVIEWONJECT @"UploadViewObject"

@interface WX_UploadVideoViewController ()<UITextFieldDelegate,UITextViewDelegate,CoverFlowDelegate,UrlTextDelegate> {
    
    /**oss*/
    
    NSString  *_videoPath;
    NSString  *_objectKey;
    NSString  *_imageKey;
    NSString  *_imagePath;
    
    
    BOOL                       _wasKeyboardManagerEnabled;
    
}
//@property(nonatomic, retain) UITextField                    *titleTField;
@property(nonatomic, retain) UITextView                     *textCTView;
@property(nonatomic, retain) UILabel                        *placeholderLabel;
@property(nonatomic, retain) UIView                         *imgBGView;
@property(nonatomic, retain) UILabel                        *gLocationLabel;
@property(nonatomic, retain) UIButton                       *teachBtn;          // 名师点评 接口
@property(nonatomic, retain) BYC_AccountModel               *accountModel;
@property(nonatomic, retain) WX_GlocationModel              *glocationModel;
@property(nonatomic, retain) WX_UploadModel                 *upModel;
@property(nonatomic, retain) NSTimer                        *successedTimer;
@property(nonatomic, retain) NSTimer                        *timeOutTimer;
@property(nonatomic, assign) NSInteger                      timeOutNum;

@property(nonatomic, retain) NSString                       *topicString;
@property(nonatomic, retain) NSMutableArray                 *topicArray;
@property(nonatomic, retain) NSString                       *titleString;

@property(nonatomic, retain) NSString                       *addressString;

@property(nonatomic, assign) BOOL                           isWeChat;
@property(nonatomic, assign) BOOL                           isQQ;

@property(nonatomic, retain) UIButton                       *weChatBtn;
@property(nonatomic, retain) UIButton                       *QQBtn;
@property(nonatomic, retain) UIButton                       *weChatMomentsBtn;
@property(nonatomic, retain) UIButton                       *sinaWeiboBtn;

@property(nonatomic, retain) WX_MediaInfoModel              *model;
@property(nonatomic, retain) WX_FMDBManager                 *manager;
@property(nonatomic, retain) NSString                       *DBmediaPath;
@property(nonatomic, retain) NSString                       *DBimgDataStr;
@property(nonatomic, assign) BOOL                           isFromDraftBox;
@property(nonatomic, assign) BOOL                           isApply;        // 名师点评权限   0_需要显示名师点评 1_不需要
@property(nonatomic, assign) BOOL                           isUserApply;  // 用户是否申请 名师点评
@property(nonatomic, assign) BOOL                           isShareFinish;  /// 分享完成

@property(nonatomic, assign) NSInteger                      btnNum;         /// 分享按钮个数

@property(nonatomic, retain) UIView                         *textBGView;    /// 背景

@property(nonatomic, assign) BOOL                           isUserFirst;    /// 用户第一次上传视频
@property(nonatomic, strong) UIView                         *promptView;    /// 用户第一次上传视频 提示相关协议框
@property(nonatomic, strong) UIView                         *promptBGview;  /// 用户第一次上传视频 提示相关协议框____背景
@property(nonatomic, assign) NSInteger                      needShareNum;   /// 需要分享次数
@property(nonatomic, assign) NSInteger                      isShareNum;     /// 实际分享次数

@property(nonatomic, assign) BOOL                           isWeChatShare;          /// 需要分享到微信
@property(nonatomic, assign) BOOL                           isWeChatMomentsShare;   /// 需要分享微信朋友圈
@property(nonatomic, assign) BOOL                           isQQShare;              /// 需要分享QQ
@property(nonatomic, assign) BOOL                           isSinaWeiBoShare;       /// 需要分享到微博

@property(nonatomic, strong) UIView                         *view_Function;         /**<   图层_按钮功能 */
@property(nonatomic, strong) UIImageView                    *imgView_Glocation;     /**<   图片_地理位置 */
@property(nonatomic, strong) UIView                         *view_AddTopic;         /**<   添加话题 */
@property(nonatomic, strong) UIView                         *view_glocation;        /**<   地理位置 */
@property(nonatomic, strong) UIView                         *view_teach;            /**<   名师点评 */
@property(nonatomic, strong) UIView                         *view_AddUrl;           /**<   添加网页跳转 */
@property(nonatomic, strong) NSMutableArray                 *array_Image;           /**<   数组_图片选取 */
@property(nonatomic, strong) CoverFlowView                  *view_CoverFlow;        /**<   图片选取 */
@property(nonatomic, strong) WX_AddUrlView                  *view_Url;              /**<   网址输入框 */



@end

@implementation WX_UploadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    self.needShareNum = 0;
    
    self.isShareNum = 0;
    
   }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addObserver:self forKeyPath:@"isShareFinish" options:NSKeyValueObservingOptionPrior context:@"isShareFinish"];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    /// 监听方法, 输入中文也可获得位数
    [QNWSNotificationCenter addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self printTopicAndGLocatiomInTextView];
    
    [self isApplyTeach];
    
    _wasKeyboardManagerEnabled = [IQKeyboardManager sharedManager].enableAutoToolbar;
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.topicString = nil;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    [self.successedTimer invalidate];
    
    [self.timeOutTimer invalidate];
    
    self.successedTimer = nil;
    
    self.timeOutTimer = nil;
    
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:_wasKeyboardManagerEnabled];
    
    [QNWSNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [QNWSNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self removeObserver:self forKeyPath:@"isShareFinish" context:@"isShareFinish"];
    
    [QNWSNotificationCenter removeObserver:self name:@"UITextViewTextDidChangeNotification" object:nil];

    
}

//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
//    if ([notification.object isEqualToString:UPLOADVIEWONJECT]) {
    
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = (self.textBGView.frame.origin.y+self.textBGView.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //将视图上移计算好的偏移
        if(offset > 0) {
         
            if (_view_Url && _view_Url.state_UrlView == ENUM_ViewDidLoad) {
                
                [_view_Url mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(-offset);
                    make.right.left.height.equalTo([UIApplication sharedApplication].keyWindow);
                }];
                
                /// 告诉self.view约束需要更新
                [self.view setNeedsUpdateConstraints];
                /// 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
                [self.view updateConstraintsIfNeeded];

            }
            
            [UIView animateWithDuration:duration animations:^{
                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
                if (_view_Url && _view_Url.state_UrlView == ENUM_ViewDidLoad)[_view_Url layoutIfNeeded];

            }];
            

        }
//    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
//    if ([notify.object isEqualToString:UPLOADVIEWONJECT]) {
    
        // 键盘动画时间
        double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        

    if (_view_Url && _view_Url.state_UrlView == ENUM_ViewDidLoad) {
        
        [_view_Url mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.bottom.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        /// 告诉self.view约束需要更新
        [self.view setNeedsUpdateConstraints];
        /// 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        [self.view updateConstraintsIfNeeded];
        
    }
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        if(_view_Url && _view_Url.state_UrlView == ENUM_ViewDidLoad) [_view_Url layoutIfNeeded];
    }];
    

//    }
}


-(void)printTopicAndGLocatiomInTextView
{
    self.topicArray = [[NSMutableArray alloc]init];
    
    if (self.topicString) {
        
        self.placeholderLabel.text = @"";
        self.textCTView.text = [self.textCTView.text stringByAppendingString:self.topicString];
    }else if (self.themeModel.isAddTheme) {
        
        self.placeholderLabel.text = @"";
        self.textCTView.text = self.themeModel.themeStr;
    }else if (!self.textCTView.text){
        if (_isUserFirst) {
            _placeholderLabel.text = @"添加描述和话题，让更多人看到你的精彩视频";
        }else{
            
            self.placeholderLabel.text = @"点击添加描述";
        }
    }
    
    if (self.addressString) {
        self.gLocationLabel.text = self.addressString;
    }

    if (self.scriptName) {
        self.titleString = self.scriptName;
    }
    
}


-(void)setFromDraftBoxModel:(WX_DBBoxModel *)model
{
    if (!self.model) {
        self.model = [[WX_MediaInfoModel alloc]init];
    }
    self.isFromDraftBox     = YES;
    self.DBimgDataStr       = model.imgDataStr;
    self.model.mediaPath    = model.mediaPath;
    self.model.mediaTitle   = model.mediaTitle;
    self.model.isVR         = model.media_Type;
    self.model.mediaID      = model.videoID;
    self.titleString        = model.title;
    if (model.contents.length) {
        self.topicString = model.contents;
    }
    if (model.location.length) {
        self.addressString = model.location;
    }
}


-(void)createUI
{
    
    _accountModel = [BYC_AccountTool userAccount];

    self.title = @"发布";
    
    /// 分享按钮个数, 微博总会显示
    self.btnNum = 1;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"存草稿" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickTheRigthButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.view.backgroundColor = KUIColorFromRGB(0xfcfcfc);
    // 图片
    self.imgBGView = [[UIView alloc]init];
    //                      WithFrame:CGRectMake( 0, KHeightNavigationBar, screenWidth, screenHeight*0.293)];
    self.imgBGView.backgroundColor = KUIColorFromRGB(0xf0f0f0);
    [self.view addSubview:self.imgBGView];
    
    [_imgBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(KHeightNavigationBar);
        make.height.mas_equalTo(screenHeight*0.293);
    }];
    
    // 创建视频封面
    [self createMediaCoverFlowView];
    
    /// 查看是否安装微信
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        self.isWeChat = NO;
        
    }else{
        self.btnNum = self.btnNum +2;
        self.isWeChat = YES;
    }
    /// 查看是否安装QQ
    if (![QQApiInterface isQQInstalled]) {
        self.isQQ = NO;
    }else{
        self.isQQ = YES;
        self.btnNum = self.btnNum +1;
    }
    
    // 记录
    self.textBGView = [[UIView alloc]init];
    self.textBGView.backgroundColor =  KUIColorFromRGB(0xfcfcfc);
    self.textBGView.layer.borderColor = KUIColorFromRGB(0xdedede).CGColor;
    self.textBGView.layer.borderWidth = 1.f;
    [self.view addSubview:self.textBGView];
    
    [_textBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(screenHeight*0.257);
        make.top.equalTo(_imgBGView.mas_bottom);
    }];
    
    /// 输入框
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor =  [UIColor clearColor];
    [self.textBGView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_textBGView);
        make.height.equalTo(_textBGView.mas_height).multipliedBy(0.793);
        make.top.equalTo(_textBGView);
    }];
    
    self.textCTView = [[UITextView alloc]init];
    self.textCTView.delegate = self;
    self.textCTView.textColor = KUIColorFromRGB(0x000000);
    self.textCTView.backgroundColor = [UIColor clearColor];
    self.textCTView.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:self.textCTView];
    
    [_textCTView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.top.equalTo(contentView);
    }];
    
    /// 提示文字
    CGSize size_PlaceHolder = [WX_ToolClass changeSizeWithString:@"添加描述和话题，让更多人看到你的精彩视频" FontOfSize:13 bold:ENUM_NormalSystem];
    
    self.placeholderLabel = [[UILabel alloc]init];
    self.placeholderLabel.enabled = NO;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.font = [UIFont systemFontOfSize:13];
    [self.placeholderLabel sizeToFit];
    [contentView addSubview:self.placeholderLabel];
    
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(0.038*screenWidth);
        make.top.mas_equalTo(@6);
        make.width.mas_equalTo(size_PlaceHolder.width+10);
        make.height.mas_equalTo(@20);
    }];
    
    /// 按钮
    _view_Function = [[UIView alloc]init];
    _view_Function.backgroundColor = [UIColor clearColor];
    [self.textBGView addSubview:_view_Function];
    
    [_view_Function mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_textBGView);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(_textBGView.mas_bottom);
    }];
    
    /// 设置按钮栏
    [self addFunctionToView:_view_Function WithTeachIsApply:NO];
    
    
    // 分享
    UIView *shareBGView = [[UIView alloc]init];
    shareBGView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shareBGView];
    
    [shareBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_textBGView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    UIImageView *leftImgView = [[UIImageView alloc]init];
    leftImgView.image = [UIImage imageNamed:@"image-zuobian"];
    leftImgView.backgroundColor = KUIColorFromRGB(0xdedede);
//    leftImgView.contentMode = UIViewContentModeScaleAspectFit;
    [shareBGView addSubview:leftImgView];
    
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(screenWidth*0.3);
        make.height.mas_equalTo(1);
        make.top.equalTo(shareBGView).offset(30);
    }];
    
    CGSize size_Share = [WX_ToolClass changeSizeWithString:@"同步分享至" FontOfSize:13 bold:ENUM_NormalSystem];
    UILabel *shareTitleLabel = [[UILabel alloc]init];
    shareTitleLabel.text = @"同步分享至";
    shareTitleLabel.textColor = KUIColorFromRGB(0x3c4f5e);
    shareTitleLabel.font = [UIFont systemFontOfSize:13];
    [shareTitleLabel sizeToFit];
    [shareBGView addSubview:shareTitleLabel];
    
    [shareTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftImgView);
        make.centerX.equalTo(shareBGView);
        make.width.mas_equalTo(size_Share.width+5);
        make.height.mas_equalTo(size_Share.height);
    }];
    
    UIImageView *rightImgView = [[UIImageView alloc]init];
    rightImgView.image = [UIImage imageNamed:@"image-youbian"];
    rightImgView.backgroundColor = KUIColorFromRGB(0xdedede);
//    rightImgView.contentMode = UIViewContentModeScaleAspectFit;
    [shareBGView addSubview:rightImgView];
    
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(leftImgView);
        make.right.equalTo(shareBGView).offset(-20);
    }];
    
    NSInteger num = 1;
    /// 检测有安装微信
    if (self.isWeChat) {
        self.weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.weChatBtn setBackgroundImage:[UIImage imageNamed:@"icon-upwx-n"] forState:UIControlStateNormal];
        [self.weChatBtn setBackgroundImage:[UIImage imageNamed:@"icon-wx-n"] forState:UIControlStateSelected];
        self.weChatBtn.tag = 300;
        [self.weChatBtn addTarget:self action:@selector(shareTheMedia:) forControlEvents:UIControlEventTouchUpInside];
        [shareBGView addSubview:self.weChatBtn];
        [_weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((screenWidth-47*self.btnNum)/(self.btnNum+1));
            make.bottom.equalTo(shareTitleLabel).offset(80);
            make.width.height.mas_equalTo(47);
        }];
        num++;
        
        self.weChatMomentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.weChatMomentsBtn setBackgroundImage:[UIImage imageNamed:@"icon-uppyq-n"] forState:UIControlStateNormal];
        [self.weChatMomentsBtn setBackgroundImage:[UIImage imageNamed:@"icon-uppyq-h"] forState:UIControlStateSelected];
        self.weChatMomentsBtn.tag = 301;
        [self.weChatMomentsBtn addTarget:self action:@selector(shareTheMedia:) forControlEvents:UIControlEventTouchUpInside];
        [shareBGView addSubview:self.weChatMomentsBtn];
        [_weChatMomentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((screenWidth-47*self.btnNum)/(self.btnNum+1)*2+47);
            make.bottom.equalTo(shareTitleLabel).offset(80);
            make.width.height.mas_equalTo(47);
        }];
        num++;
    }
    
    self.sinaWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sinaWeiboBtn setBackgroundImage:[UIImage imageNamed:@"icon-fbwb-n"] forState:UIControlStateNormal];
    [self.sinaWeiboBtn setBackgroundImage:[UIImage imageNamed:@"icon-fbwb-h"] forState:UIControlStateSelected];
    self.sinaWeiboBtn.tag = 302;
    [self.sinaWeiboBtn addTarget:self action:@selector(shareTheMedia:) forControlEvents:UIControlEventTouchUpInside];
    [shareBGView addSubview:self.sinaWeiboBtn];
    [_sinaWeiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((screenWidth-47*self.btnNum)/(self.btnNum+1)*num+47*(num-1));
        make.bottom.equalTo(shareTitleLabel).offset(80);
        make.width.height.mas_equalTo(47);
    }];
    num++;
    
    /// 检测有安装qq
    if (self.isQQ) {
        self.QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.QQBtn setBackgroundImage:[UIImage imageNamed:@"icon-upqq-n"] forState:UIControlStateNormal];
        [self.QQBtn setBackgroundImage:[UIImage imageNamed:@"icon-qq-h"] forState:UIControlStateSelected];
        self.QQBtn.tag = 303;
        [self.QQBtn addTarget:self action:@selector(shareTheMedia:) forControlEvents:UIControlEventTouchUpInside];
        [shareBGView addSubview:self.QQBtn];
        [_QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((screenWidth-47*self.btnNum)/(self.btnNum+1)*num+47*(num-1));
            make.bottom.equalTo(shareTitleLabel).offset(80);
            make.width.height.mas_equalTo(47);
        }];
        num++;
    }
    
    // 发布
    UIView *publishView = [[UIView alloc]init];
    publishView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:publishView];
    [publishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@49);
    }];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:@"发布" forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn-scanbj-n"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"icon-anbjs-h"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [publishView addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(publishView);
    }];
    
    self.textCTView.returnKeyType = UIReturnKeyDone;
    
    if (self.model.isVR == 2) {
        if (self.isFromDraftBox) {
            self.placeholderLabel.text = @"";
        }else{
            self.textCTView.text = @"#合拍show#";
            self.placeholderLabel.text = @"";
        }
    }else{
        if (_isUserFirst) {
            _placeholderLabel.text = @"添加描述和话题，让更多人看到你的精彩视频";
        }else{
            
            self.placeholderLabel.text = @"点击添加描述";
        }
        
    }
//    /// 是否名师点评
//    if (self.isApply) {
//        _view_teach.hidden = NO;
//    }else{
//        _view_teach.hidden = YES;
//    }
    
    _view_teach.hidden = YES;
}

/// 设置按钮栏
-(void)addFunctionToView:(UIView*)otherView WithTeachIsApply:(BOOL)isApply
{
    /// 添加话题
    NSString *str_Topic = @"话题";
    CGSize size_Topic = [WX_ToolClass changeSizeWithString:str_Topic FontOfSize:14 bold:ENUM_NormalSystem];
    if (self.isUserFirst && self.textCTView.text.length == 0) {
        self.placeholderLabel.text = @"添加描述和话题，让更多人看到你的精彩视频";
    }
    
    if (!_view_AddTopic) {
        
        _view_AddTopic = [[UIView alloc]init];
        _view_AddTopic.backgroundColor = KUIColorFromRGB(0xe2e5e8);
        _view_AddTopic.layer.masksToBounds  = YES;
        _view_AddTopic.layer.cornerRadius = 10.f;
        _view_AddTopic.userInteractionEnabled = YES;
        [otherView addSubview:_view_AddTopic];
        
        [_view_AddTopic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@10);
            make.height.mas_equalTo(size_Topic.height+5);
            make.centerY.equalTo(otherView);
            make.width.mas_equalTo(size_Topic.width*2);
        }];
        
        UIImageView *topicImgView = [[UIImageView alloc]init];
        topicImgView.image = [UIImage imageNamed:@"icon-tjht-n"];
        topicImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_view_AddTopic addSubview:topicImgView];
        
        [topicImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size_Topic.height).multipliedBy(0.7);
            make.height.mas_equalTo(size_Topic.height).multipliedBy(0.8);
            make.centerY.equalTo(_view_AddTopic);
            make.left.equalTo(_view_AddTopic.mas_left).offset(3);
        }];
        
        UILabel *topicLabel = [[UILabel alloc]init];
        topicLabel.text = @"话题";
        topicLabel.backgroundColor = [UIColor clearColor];
        topicLabel.textColor = KUIColorFromRGB(0x3c4f5e);
        topicLabel.font = [UIFont systemFontOfSize:14];
        [topicLabel sizeToFit];
        topicLabel.tag = 100;
        topicLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapTop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheLabel:)];
        [topicLabel addGestureRecognizer:tapTop];
        [_view_AddTopic addSubview:topicLabel];
        
        [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topicImgView.mas_right).offset(2);
            make.centerY.equalTo(_view_AddTopic);
            make.width.mas_equalTo(size_Topic.width);
            make.height.mas_equalTo(size_Topic.height);
        }];
    }
    
    
    // 添加网址
    NSString *str_Url = @"链接";
    CGSize size_Url = [WX_ToolClass changeSizeWithString:str_Url FontOfSize:14 bold:ENUM_NormalSystem];
    if (!_view_AddUrl) {
        _view_AddUrl = [[UIView alloc]init];
        _view_AddUrl = [[UIView alloc]init];
        _view_AddUrl.backgroundColor = KUIColorFromRGB(0xe2e5e8);
        _view_AddUrl.layer.masksToBounds  = YES;
        _view_AddUrl.layer.cornerRadius = 10.f;
        _view_AddUrl.userInteractionEnabled = YES;
        [otherView addSubview:_view_AddUrl];
        
        [_view_AddUrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view_AddTopic.mas_right).offset(10);
            make.height.centerY.equalTo(_view_AddTopic);
            make.width.mas_equalTo(size_Topic.width*2);
        }];
        
        UIImageView *urlImgView = [[UIImageView alloc]init];
        urlImgView.image = [UIImage imageNamed:@"icon_fubu_lianjie"];
        urlImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_view_AddUrl addSubview:urlImgView];
        
        [urlImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size_Url.height).multipliedBy(0.7);
            make.height.mas_equalTo(size_Url.height).multipliedBy(0.8);
            make.centerY.equalTo(_view_AddUrl);
            make.left.equalTo(_view_AddUrl.mas_left).offset(3);
        }];
        
        UILabel *urlLabel = [[UILabel alloc]init];
        urlLabel.text = str_Url;
        urlLabel.backgroundColor = [UIColor clearColor];
        urlLabel.textColor = KUIColorFromRGB(0x3c4f5e);
        urlLabel.font = [UIFont systemFontOfSize:14];
        [urlLabel sizeToFit];
        urlLabel.tag = 300;
        urlLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapTop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheLabel:)];
        [urlLabel addGestureRecognizer:tapTop];
        [_view_AddUrl addSubview:urlLabel];
        
        [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(urlImgView.mas_right).offset(2);
            make.centerY.equalTo(_view_AddUrl);
            make.width.mas_equalTo(size_Url.width+5);
            make.height.mas_equalTo(size_Url.height);
        }];

    }
    
    if (isApply) {
        /// 有名师
        /// 名师点评
        if (!_view_teach) {
            
            _view_teach = [[UIView alloc]init];
            _view_teach.backgroundColor = KUIColorFromRGB(0xe2e5e8);
            _view_teach.layer.masksToBounds  = YES;
            _view_teach.layer.cornerRadius = 10.f;
            _view_teach.userInteractionEnabled = YES;
            [otherView addSubview:_view_teach];
            
            [_view_teach mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_view_AddUrl.mas_right).offset(10);
                make.centerY.equalTo(_view_AddUrl);
                make.width.mas_equalTo(85);
                make.height.equalTo(_view_AddUrl);
            }];
            
            self.teachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.teachBtn setImage:[UIImage imageNamed:@"img-msdp-h"] forState:UIControlStateSelected];
            [self.teachBtn setImage:[UIImage imageNamed:@"img-msdp-h"] forState:UIControlStateHighlighted];
            [self.teachBtn setImage:[UIImage imageNamed:@"img-msdp-n"] forState:UIControlStateNormal];
            [self.teachBtn setTitle:@"名师点评" forState:UIControlStateNormal];
            [self.teachBtn setTitleColor:KUIColorFromRGB(0x3c4f5e) forState:UIControlStateNormal];
            [self.teachBtn setTitleColor:KUIColorFromRGB(0xff6666) forState:UIControlStateHighlighted];
            [self.teachBtn setTitleColor:KUIColorFromRGB(0xff6666) forState:UIControlStateSelected];
            [self.teachBtn addTarget:self action:@selector(applyTeacher:) forControlEvents:UIControlEventTouchUpInside];
            self.teachBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_view_teach addSubview:self.teachBtn];
            
            [_teachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_view_teach);
                make.centerY.equalTo(_view_teach);
                make.width.mas_equalTo(@80);
                make.height.mas_equalTo(size_Topic.height);
            }];
            
        }else{
            [_view_teach mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_view_AddUrl.mas_right).offset(10);
                make.centerY.equalTo(_view_AddUrl);
                make.width.mas_equalTo(85);
                make.height.equalTo(_view_AddUrl);
            }];
        }
        
        if (!_view_glocation) {
            /// 地理位置
            NSString *str_location = @"位置";
            CGSize size_Location = [WX_ToolClass changeSizeWithString:str_location FontOfSize:14 bold:ENUM_NormalSystem];
            
            _view_glocation = [[UIView alloc]init];
            _view_glocation.backgroundColor = KUIColorFromRGB(0xe2e5e8);
            _view_glocation.layer.masksToBounds  = YES;
            _view_glocation.layer.cornerRadius = 10.f;
            _view_glocation.userInteractionEnabled = YES;
            [otherView addSubview:_view_glocation];
            
            _imgView_Glocation = [[UIImageView alloc]init];
            _imgView_Glocation.image = [UIImage imageNamed:@"icon-dt-n"];
            _imgView_Glocation.contentMode =  UIViewContentModeScaleAspectFit;
            [_view_glocation addSubview:_imgView_Glocation];
            
            self.gLocationLabel = [[UILabel alloc]init];
            self.gLocationLabel.text = str_location;
            self.gLocationLabel.backgroundColor = [UIColor clearColor];
            self.gLocationLabel.textColor = KUIColorFromRGB(0x3c4f5e);
            self.gLocationLabel.font = [UIFont systemFontOfSize:14];
            self.gLocationLabel.tag = 200;
            self.gLocationLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGL = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheLabel:)];
            [self.gLocationLabel addGestureRecognizer:tapGL];
            [otherView addSubview:self.gLocationLabel];
            
            if (self.addressString.length>0) {
                /// 有位置信息,显示位置信息
                self.gLocationLabel.text = self.addressString;
                CGSize size_Location = [WX_ToolClass changeSizeWithString:self.addressString FontOfSize:14 bold:ENUM_NormalSystem];
                
                [_view_glocation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_teach.mas_right).offset(10);
                    make.centerY.height.equalTo(_view_teach);
                    make.width.mas_equalTo(size_Location.width + size_Location.height*0.8+15);
                    make.height.mas_equalTo(size_Location.height +5);
                }];
                
                [_imgView_Glocation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_glocation).offset(3);
                    make.width.mas_equalTo(size_Location.height).multipliedBy(0.8);
                    make.height.mas_equalTo(size_Location.height);
                    make.centerY.equalTo(_view_glocation);
                }];
                
                [_gLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_imgView_Glocation.mas_right).offset(2);
                    make.height.mas_equalTo(size_Location.height);
                    make.width.mas_equalTo(size_Location.width+5);
                    make.centerY.equalTo(_view_glocation);
                }];
                
            }else{
                  /// 没有位置信息

                
                [_view_glocation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_teach.mas_right).offset(10);
                    make.centerY.height.equalTo(_view_teach);
                    make.width.mas_equalTo(size_Location.width*2);
                    make.height.mas_equalTo(size_Location.height +5);
                }];
                
     
                
                [_imgView_Glocation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_glocation).offset(3);
                    make.width.mas_equalTo(size_Location.height).multipliedBy(0.8);
                    make.height.mas_equalTo(size_Location.height);
                    make.centerY.equalTo(_view_glocation);
                }];
                

                
                [_gLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_imgView_Glocation.mas_right).offset(2);
                    make.height.mas_equalTo(size_Location.height);
                    make.width.mas_equalTo(size_Location.width+5);
                    make.centerY.equalTo(_view_glocation);
                }];
            }

        }else{
            
            if (self.addressString.length>0) {
                /// 有位置信息,显示位置信息
                self.gLocationLabel.text = self.addressString;
                CGSize size_Location = [WX_ToolClass changeSizeWithString:self.addressString FontOfSize:14 bold:ENUM_NormalSystem];
                
                [_view_glocation mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_teach.mas_right).offset(10);
                    make.centerY.height.equalTo(_view_teach);
                    make.width.mas_equalTo(size_Location.width + size_Location.height*0.8+15);
                    make.height.mas_equalTo(size_Location.height +5);
                }];
                
                [_imgView_Glocation mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_glocation).offset(3);
                    make.width.mas_equalTo(size_Location.height).multipliedBy(0.8);
                    make.height.mas_equalTo(size_Location.height);
                    make.centerY.equalTo(_view_glocation);
                }];
                
                [_gLocationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_imgView_Glocation.mas_right).offset(2);
                    make.height.mas_equalTo(size_Location.height);
                    make.width.mas_equalTo(size_Location.width+5);
                    make.centerY.equalTo(_view_glocation);
                }];
                
            }else{
                   /// 没有位置信息,显示位置
                NSString *str_location = @"位置";
                CGSize size_Location = [WX_ToolClass changeSizeWithString:str_location FontOfSize:14 bold:ENUM_NormalSystem];
                
                [_view_glocation mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_teach.mas_right).offset(10);
                    make.centerY.height.equalTo(_view_teach);
                    make.width.mas_equalTo(size_Location.width*2);
                    make.height.mas_equalTo(size_Location.height +5);
                }];
            }
        }
    }else{
        /// 没有名师
        if (_view_teach) {
            [_view_teach removeFromSuperview];
            
        }
        if (!_view_glocation) {
            
            /// 地理位置
            NSString *str_location = @"位置";
            CGSize size_Location = [WX_ToolClass changeSizeWithString:str_location FontOfSize:14 bold:ENUM_NormalSystem];
            
            _view_glocation = [[UIView alloc]init];
            _view_glocation.backgroundColor = KUIColorFromRGB(0xe2e5e8);
            _view_glocation.layer.masksToBounds  = YES;
            _view_glocation.layer.cornerRadius = 10.f;
            _view_glocation.userInteractionEnabled = YES;
            [otherView addSubview:_view_glocation];
            
            _imgView_Glocation = [[UIImageView alloc]init];
            _imgView_Glocation.image = [UIImage imageNamed:@"icon-dt-n"];
            _imgView_Glocation.contentMode =  UIViewContentModeScaleAspectFit;
            [_view_glocation addSubview:_imgView_Glocation];
            
            self.gLocationLabel = [[UILabel alloc]init];
            self.gLocationLabel.text = str_location;
            self.gLocationLabel.backgroundColor = [UIColor clearColor];
            self.gLocationLabel.textColor = KUIColorFromRGB(0x3c4f5e);
            self.gLocationLabel.font = [UIFont systemFontOfSize:14];
            self.gLocationLabel.tag = 200;
            self.gLocationLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGL = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheLabel:)];
            [self.gLocationLabel addGestureRecognizer:tapGL];
            [otherView addSubview:self.gLocationLabel];
            
            if (self.addressString.length>0) {
                /// 有位置信息,显示位置信息
                self.gLocationLabel.text = self.addressString;
                CGSize size_Location = [WX_ToolClass changeSizeWithString:self.addressString FontOfSize:14 bold:ENUM_NormalSystem];
                
                [_view_glocation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_AddUrl.mas_right).offset(10);
                    make.centerY.height.equalTo(_view_AddUrl);
                    make.width.mas_equalTo(size_Location.width + size_Location.height*0.8+15);
                    make.height.mas_equalTo(size_Location.height +5);
                }];
                
                [_imgView_Glocation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_glocation).offset(3);
                    make.width.mas_equalTo(size_Location.height).multipliedBy(0.8);
                    make.height.mas_equalTo(size_Location.height);
                    make.centerY.equalTo(_view_glocation);
                }];
                
                [_gLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_imgView_Glocation.mas_right).offset(2);
                    make.height.mas_equalTo(size_Location.height);
                    make.width.mas_equalTo(size_Location.width+5);
                    make.centerY.equalTo(_view_glocation);
                }];
            }else{
                
                [_view_glocation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_AddUrl.mas_right).offset(10);
                    make.centerY.height.equalTo(_view_AddUrl);
                    make.width.mas_equalTo(size_Location.width*2);
                    make.height.mas_equalTo(size_Location.height +5);
                }];
                
                
                [_imgView_Glocation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_glocation).offset(3);
                    make.width.mas_equalTo(size_Location.height).multipliedBy(0.8);
                    make.height.mas_equalTo(size_Location.height);
                    make.centerY.equalTo(_view_glocation);
                }];
                
 
                
                [_gLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_imgView_Glocation.mas_right).offset(2);
                    make.height.mas_equalTo(size_Location.height);
                    make.width.mas_equalTo(size_Location.width+5);
                    make.centerY.equalTo(_view_glocation);
                }];
                
            }
        }else{
            if (self.addressString.length>0) {
                /// 有位置信息,显示位置信息
                self.gLocationLabel.text = self.addressString;
                CGSize size_Location = [WX_ToolClass changeSizeWithString:self.addressString FontOfSize:14 bold:ENUM_NormalSystem];
                
                [_view_glocation mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_AddUrl.mas_right).offset(10);
                    make.centerY.height.equalTo(_view_AddUrl);
                    make.width.mas_equalTo(size_Location.width + size_Location.height*0.8+15);
                    make.height.mas_equalTo(size_Location.height +5);
                }];
                
                [_imgView_Glocation mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_glocation).offset(3);
                    make.width.mas_equalTo(size_Location.height).multipliedBy(0.8);
                    make.height.mas_equalTo(size_Location.height);
                    make.centerY.equalTo(_view_glocation);
                }];
                
                [_gLocationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_imgView_Glocation.mas_right).offset(2);
                    make.height.mas_equalTo(size_Location.height);
                    make.width.mas_equalTo(size_Location.width+5);
                    make.centerY.equalTo(_view_glocation);
                }];
            }else{
                /// 地理位置
                NSString *str_location = @"位置";
                CGSize size_Location = [WX_ToolClass changeSizeWithString:str_location FontOfSize:14 bold:ENUM_NormalSystem];

                [_view_glocation mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_AddUrl.mas_right).offset(10);
                    make.centerY.height.equalTo(_view_AddUrl);
                    make.width.mas_equalTo(size_Location.width*2);
                    make.height.mas_equalTo(size_Location.height +5);
                }];
                
                
                [_imgView_Glocation mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_glocation).offset(3);
                    make.width.mas_equalTo(size_Location.height).multipliedBy(0.8);
                    make.height.mas_equalTo(size_Location.height);
                    make.centerY.equalTo(_view_glocation);
                }];
                
                [_gLocationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_imgView_Glocation.mas_right).offset(2);
                    make.height.mas_equalTo(size_Location.height);
                    make.width.mas_equalTo(size_Location.width+5);
                    make.centerY.equalTo(_view_glocation);
                }];
                
            }
        }

    }
}

/**
 *   创建视频封面
 */
-(void)createMediaCoverFlowView
{
    [_view_CoverFlow removeFromSuperview];
    _view_CoverFlow = nil;
    _array_Image = [[NSMutableArray alloc]init];
    [_array_Image removeAllObjects];
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"Media"];
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",self.model.mediaTitle]];
    self.DBmediaPath = filePath;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    [WX_ToolClass splitVideo:url photosCount:10 completedBlock:^(NSMutableArray *array_Cover) {
        if (array_Cover && array_Cover.count>0) {
            // 返回封面信息
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _view_CoverFlow = [CoverFlowView coverFlowViewWithFrame: CGRectMake(0, KHeightNavigationBar+20, screenWidth, screenHeight*0.293*0.6) andImages:array_Cover sideImageCount:6 sideImageScale:0.35 middleImageScale:0.25];
                _view_CoverFlow.delegate = self;
                [self.imgBGView addSubview:_view_CoverFlow];
                
                [_view_CoverFlow mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.left.bottom.equalTo(_imgBGView);
                    make.top.equalTo(_imgBGView).offset(20);
                }];
                _array_Image = [array_Cover copy];
                self.model.imageDataStr =  [[WX_ToolClass achieveDataWithImage:_array_Image[3]] base64EncodedStringWithOptions:0];
                self.DBimgDataStr = self.model.imageDataStr;
            });
        }else{
            
            [_view_CoverFlow removeFromSuperview];
            _view_CoverFlow = nil;
            
            // 视频封面信息获取出错
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *array_Thumb = [[NSMutableArray alloc]init];
                AVAsset *asset = [AVAsset assetWithURL:url];
                Float64 duration = asset.duration.value/asset.duration.timescale;
 
                
                for (int i = 0; i < 10; i++) {
                    UIImage *image = [WX_ToolClass thumbnailImageForVideo:url atTime:CMTimeMakeWithSeconds(duration/10*i, 30)];
                    if(image){
                        [array_Thumb addObject: image];
                    }
                    
                }
//                while (array_Thumb.count<10) {
//                    for (UIImage *image in array_Thumb) {
//                        [array_Thumb addObject:image];
//                    }
//                }
                _view_CoverFlow = [CoverFlowView coverFlowViewWithFrame: CGRectMake(0, KHeightNavigationBar+20, screenWidth, screenHeight*0.293*0.6) andImages:array_Thumb sideImageCount:1 sideImageScale:0.35 middleImageScale:0.25];
                _view_CoverFlow.delegate = self;
                [self.imgBGView addSubview:_view_CoverFlow];
                
                [_view_CoverFlow mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.left.bottom.equalTo(_imgBGView);
                    make.top.equalTo(_imgBGView).offset(20);
                }];
                _array_Image = [array_Thumb copy];
                self.model.imageDataStr =  [[WX_ToolClass achieveDataWithImage:_array_Image[0]] base64EncodedStringWithOptions:0];
                self.DBimgDataStr = self.model.imageDataStr;
            });



        }
    }];
    
}

-(void)clickTheMovie:(UIButton *)button
{
    
    NSURL *url;
    
    if ([[self.model.mediaPath substringToIndex:1] isEqualToString:@"a"]) {
        //   相册
        
        //        QNWSLog(@"mediaPath == %@",self.model.mediaPath);
        url = [NSURL URLWithString:self.model.mediaPath];
        //        NSData *data = [NSData dataWithContentsOfURL:url];
        //        QNWSLog(@"data == %@",data);
        //        QNWSLog(@"url == %@",url);
    }else{
        
        // 沙盒
        NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *filePath = [docDir stringByAppendingPathComponent:@"Media"];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",self.model.mediaTitle]];
        self.DBmediaPath = filePath;
        url = [NSURL fileURLWithPath:filePath];
        QNWSLog(@"filePath == %@",filePath);
        QNWSLog(@"url == %@",url);
        
    }
    
    // 播放器测试 路径
    MPMoviePlayerViewController *playViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    MPMoviePlayerController *player = [playViewController moviePlayer];
    player.scalingMode = MPMovieScalingModeAspectFit;
    player.controlStyle = MPMovieControlStyleFullscreen;
    [player play];
    [self.navigationController presentViewController:playViewController animated:YES completion:nil];
    
}

#pragma mark ------------ 是否申请名师点评
-(void)applyTeacher:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.isUserApply = YES;
    }else{
        self.isUserApply = NO;
    }
}

#pragma mark ------------- 检测是否可以名师评论
/// 检测是否可以 请求名师评论
-(void)isApplyTeach
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_accountModel.userid forKey:@"userid"];
//    [dic setValue:_accountModel.token forKey:@"token"];
    [BYC_HttpServers Get:[NSString stringWithFormat:@"%@/%@",KQNWS_IsApplyVideo,dic[@"userid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QNWSLog(@"responseObject == %@",responseObject);
        BOOL success = [responseObject[@"success"] boolValue];
        if (success) {
            
//            /// 0 未申请_显示按钮
//            /// 1 已申请_隐藏按钮
//            if ([[NSString stringWithFormat:@"%zi",[responseObject[@"data"][@"isApply"] boolValue]] isEqualToString:@"0"]) {
//                self.isApply = YES;
//            }else if ([[NSString stringWithFormat:@"%zi",[responseObject[@"data"][@"isApply"] boolValue]] isEqualToString:@"1"]){
//                self.isApply = NO;
//            }
            if ([[NSString stringWithFormat:@"%zi",[responseObject[@"data"][@"sum"] integerValue]] isEqualToString:@"0"]) {
                self.isUserFirst = YES;
            }else{
                self.isUserFirst = NO;
            }
            
        }
        [self addFunctionToView:_view_Function WithTeachIsApply:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSLog(@"名师点评接口请求数据错误 error == %@",error);
    }];
}

#pragma mark ---------- 返回按钮
-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
    [_view_CoverFlow removeFromSuperview];
    _view_CoverFlow = nil;
}

-(void)shareTheMedia:(UIButton *)button
{
    button.selected = !button.selected;
    NSArray *array = @[@"微信",@"朋友圈",@"新浪微博",@"QQ"];
    if (button.selected) {
        
        [self.view showAndHideHUDWithTitle:[NSString stringWithFormat:@"看拍发布成功后,\n将会跳转至%@分享",array[button.tag-300]] WithState:BYC_MBProgressHUDHideProgress];
    }

    
}

-(void)tapTheLabel:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 100) {
        QNWSLog(@"添加话题");
        WX_AddTopicViewController *addTopVC = [[WX_AddTopicViewController alloc]init];
        addTopVC.block = ^(WX_AddTopicModel *model){
            self.topicString = model.themeName;
        };
        
        [self.navigationController pushViewController:addTopVC animated:YES];
        
    }else if (tap.view.tag == 200){
        QNWSLog(@"显示地理位置");
        WX_GLocationViewController *GLocationCG = [[WX_GLocationViewController alloc]init];
        GLocationCG.block = ^(WX_GlocationModel *model){
            self.addressString = model.address;
            self.glocationModel = model;
        };
        [self.navigationController pushViewController:GLocationCG animated:YES];
    }else if (tap.view.tag == 300){
        _view_Url = [[WX_AddUrlView alloc]init];
        [_view_Url createUrlViewWithView:_view_Url Frame:CGRectMake(self.view.center.x-150, self.view.center.y-102.5, 300, 205) Placeholder:@"输入或者粘贴网址"];
        _view_Url.delegate = self;
        QNWSLog(@"添加网址");
        
    }
}

-(void)setMediaWithModel:(WX_MediaInfoModel *)model
{
    if (!self.model) {
        self.model = [[WX_MediaInfoModel alloc]init];
    }
    self.model = model;
    
    if (self.model.isVR == 2) {
        self.textCTView.text = @"#合拍show#";
        self.placeholderLabel.text = @"";
    }
}

-(void)textValueChange:(UITextField *)textField
{
    QNWSLog(@"textField.text == %@",textField.text);
    
}
// 回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
        [self.textCTView resignFirstResponder];
    
}

// 获取图片封面
-(void)coverFlowCurrentRenderingImageIndex:(NSInteger)imageIndex
{
    UIImage *image = _array_Image[imageIndex];
    NSData *data_Image = [WX_ToolClass achieveDataWithImage:image];
    self.DBimgDataStr = [data_Image base64EncodedStringWithOptions:0];
    self.model.imageDataStr = self.DBimgDataStr;
}

// 上传
-(void)done
{

    if (self.textCTView.text.length > 200) {
        [self.view showAndHideHUDWithTitle:@"描述不能输入过多哦" WithState:BYC_MBProgressHUDHideProgress];
    }else{
        
        _titleString = [NSString stringWithFormat:@"%@的短片",self.accountModel.nickname];
        NSURL *url;
        NSData *data;
        NSString *filePath;
        // 沙盒
        NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        filePath = [docDir stringByAppendingPathComponent:@"Media"];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",self.model.mediaTitle]];
        url = [NSURL fileURLWithPath:filePath];
        data = [NSData dataWithContentsOfFile:filePath];
        QNWSLog(@"filePath == %@",filePath);
        
        
        self.upModel = [[WX_UploadModel alloc]init];
        self.upModel.mediaPath = filePath;
        self.upModel.imgData = [[NSData alloc]initWithBase64EncodedString:self.model.imageDataStr options:0];
        self.upModel.mediaData = data;
        self.upModel.userID = self.accountModel.userid;
        self.upModel.mediaTitle = _titleString;
        self.upModel.mediaContents = self.textCTView.text;
        self.upModel.longitude = self.glocationModel.longitude;
        self.upModel.latitude = self.glocationModel.latitude;
        
        
        //添加网络判断
        //监察网络状态
        //开始监测
        [[AFNetworkReachabilityManager sharedManager]startMonitoring];
        
        //一旦网络状态发生改变,就会立刻走这个回调
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            if ([AFStringFromNetworkReachabilityStatus(status) isEqualToString:@"Not Reachable"]) {
                QNWSLog(@"无网络");
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请核查您的网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }else{
                if (self.isUserFirst) {
                    // 用户第一次上传视频
                    
                    [self initPromptView];
                    
                }else{
                    // 否则

                    WX_UploadHandle *uploadHandle = [WX_UploadHandle sharedWX_UploadHandle];
                    if (uploadHandle.isUploading) {
                        // 还在上传中
                        // 存在草稿箱
                        [self writeToDraftBox];
                    }else{
                        // 上传完成
                        // 执行上传操作
                        [self mediaUpload];
                        
                    }
                }
            }
        }];
    }
}



#pragma mark ---------- 提示框
-(void)initPromptView
{
    if (!self.promptBGview) {
        
        self.promptBGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.promptBGview.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
        [self.view addSubview:self.promptBGview];
        
        self.promptView = [[UIView alloc]initWithFrame:CGRectMake( screenWidth*(1-0.75) /2, (1- 0.35)*screenHeight /2, 0.75 *screenWidth, 0.35 *screenHeight)];
        self.promptView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        self.promptView.layer.cornerRadius = 15;
        self.promptView.layer.masksToBounds = YES;
        [self.promptBGview addSubview:self.promptView];
        
        NSString *titleStr = @"提示";
        CGSize titleSize = [titleStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.promptView.frame.size.width -titleSize.width)/2, titleSize.height, titleSize.width, titleSize.height)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = titleStr;
        
        [self.promptView addSubview:titleLabel];
        
        UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height*2, self.promptBGview.frame.size.width, 0.5)];
        titleImgView.backgroundColor = KUIColorFromRGBA(0x2d343c, 0.5);
        [self.promptView addSubview:titleImgView];
        
        NSString *proStr = @"请仔细阅读《用户协议》，如果\n同意，您的作品才可发布";
        CGSize proSize = [proStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        UILabel *proLabel = [[UILabel alloc]init];
        if (proSize.width > self.promptView.frame.size.width -20) {
            /// 两行显示
            CGFloat num = proSize.width / (self.promptView.frame.size.width -20);
            
            proLabel.frame = CGRectMake(10, titleImgView.frame.origin.y+titleSize.height, self.promptView.frame.size.width -20, proSize.height *(num+1));
        }else{
            /// 单行显示
            proLabel.frame = CGRectMake(10, titleImgView.frame.origin.y+titleSize.height, self.promptView.frame.size.width -20, proSize.height);
        }
        
        /// 文字颜色多段
        proLabel.numberOfLines = 0;
        proLabel.text = proStr;
        
        NSMutableAttributedString *attriPromptStr = [[NSMutableAttributedString alloc]initWithString:proStr];
        [attriPromptStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x087bff) range:NSMakeRange(5, 6)];
        proLabel.font = [UIFont systemFontOfSize:14];
        proLabel.attributedText = attriPromptStr;
        
        proLabel.textAlignment = NSTextAlignmentCenter;
        proLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSeeUserProtocol)];
        [proLabel addGestureRecognizer:tap];
        [self.promptView addSubview:proLabel];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, (1 -0.25)*self.promptView.frame.size.height, self.promptView.frame.size.width/2, 0.25*self.promptView.frame.size.height);
        [cancelBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:KUIColorFromRGB(0x087bff) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(promptBtn:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.tag = 1;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.promptView addSubview:cancelBtn];
        
        UIImageView *proImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, cancelBtn.frame.origin.y, self.promptBGview.frame.size.width, 0.5)];
        proImgView.backgroundColor = KUIColorFromRGBA(0x2d343c, 0.5);;
        [self.promptView addSubview:proImgView];
        
        UIImageView *btnImgView = [[UIImageView alloc]initWithFrame:CGRectMake(cancelBtn.frame.size.width, cancelBtn.frame.origin.y, 0.5, cancelBtn.frame.size.height)];
        btnImgView.backgroundColor = KUIColorFromRGBA(0x2d343c, 0.5);;
        [self.promptView addSubview:btnImgView];
        
        UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        continueBtn.frame = CGRectMake(cancelBtn.frame.size.width+cancelBtn.frame.origin.x, (1 -0.25)*self.promptView.frame.size.height, self.promptView.frame.size.width/2, 0.25*self.promptView.frame.size.height);
        [continueBtn setTitle:@"同意" forState:UIControlStateNormal];
        [continueBtn setTitleColor:KUIColorFromRGB(0x087bff) forState:UIControlStateNormal];
        [continueBtn addTarget:self action:@selector(promptBtn:) forControlEvents:UIControlEventTouchUpInside];
        continueBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        //        continueBtn.titleLabel.textColor = [UIColor colorWithRed:0 green:86 blue:255 alpha:1.0];
        continueBtn.tag = 2;
        [self.promptView addSubview:continueBtn];
        
    }else{
        self.promptBGview.hidden = NO;
    }
    
    
}

#pragma mark ----------- 点击去看用户协议
-(void)tapToSeeUserProtocol
{
    BYC_UserAgreementViewController *userVC = [[BYC_UserAgreementViewController alloc]init];
    [self.navigationController pushViewController:userVC animated:YES];
}

-(void)promptBtn:(UIButton *)button
{
    if (button.tag == 1) {
        self.promptBGview.hidden = YES;
        return;
    }
    if (button.tag == 2) {
        self.promptBGview.hidden = YES;
        [self mediaUpload];
    }
}
///      视频上传
///      先传视频 再传截图 最后文件信息
-(void)mediaUpload
{
    QNWSLog(@"是否为合拍栏目视频 %zi",self.model.isVR);
    
//    [self.view showHUDWithTitle:@"正在上传" WithState:BYC_MBProgressHUDShowTurnplateProgress];
    
    _objectKey = [NSString createFileName:@"userHeaderImage.mp4" andType:ENUM_ResourceTypeVideos];
    _imageKey = [NSString createFileName:@"KPie.png" andType:ENUM_ResourceTypeVideos];
    
    /// 调试模式下, 区分服务器类型, 阿里云上传路径
//#ifdef DEBUG
//    NSString *stringIP = [QNWS_Main_HostIP copy];
//
//    if ([stringIP isEqualToString:KQNWS_KPIE_MAIN_URL] || [stringIP isEqualToString:@"http://112.74.88.81/api/"]) {
//        ///正式服务器__ 阿里云上传正式路径
//        _videoPath = [NSString stringWithFormat:@"%@%@",KQNWS_VIDEOFilePath,_objectKey];
//        _imagePath = [NSString stringWithFormat:@"%@%@",KQNWS_OSSFilePath,_imageKey];
//    }else{
//        ///本地服务器__ 阿里云上传测试路径
//        _videoPath = [NSString stringWithFormat:@"%@%@",KQNWS_OSSTestFilePath,_objectKey];
//        _imagePath = [NSString stringWithFormat:@"%@%@",KQNWS_OSSTestFilePath,_imageKey];
//        
//    }
//#else
    
    
    /// release 模式下, 固定阿里云上传路径
    _videoPath = [NSString stringWithFormat:@"%@%@",KQNWS_VIDEOFilePath,_objectKey];
    _imagePath = [NSString stringWithFormat:@"%@%@",KQNWS_OSSFilePath,_imageKey];
//#endif
    
    WX_UploadHandleModel *model_UploadHandle = [[WX_UploadHandleModel alloc]init];
    model_UploadHandle.key_Video            = _objectKey;
    model_UploadHandle.key_Image            = _imageKey;
    model_UploadHandle.data_Video           = self.upModel.mediaData;
    model_UploadHandle.data_Image           = self.upModel.imgData;
    model_UploadHandle.path_Video           = _videoPath;
    model_UploadHandle.path_Image           = _imagePath;
    model_UploadHandle.title_Video          = nil;
    model_UploadHandle.userID_Video         = self.accountModel.userid;
    model_UploadHandle.strID_Video          = self.scriptStrid.length>0? self.scriptStrid : nil;
    model_UploadHandle.gpsX_Video           = self.glocationModel.longitude;
    model_UploadHandle.gpsY_Video           = self.glocationModel.latitude;
    model_UploadHandle.themeid_Video        = nil;
    model_UploadHandle.description_video    = self.textCTView.text;
    model_UploadHandle.token_User           = self.accountModel.token;
    model_UploadHandle.userID_User          = self.accountModel.userid;
    model_UploadHandle.teachApply           = [NSString stringWithFormat:@"%zi",self.isUserApply];
    model_UploadHandle.videoId_VideoType    = self.model.isVR;
    model_UploadHandle.videoID_Activity     = model_UploadHandle.videoId_VideoType == 2?self.model.mediaID:nil;
    
    model_UploadHandle.loaction             = self.addressString.length>0?self.addressString:nil;
    model_UploadHandle.str_ImageData        = self.model.imageDataStr;
    
    model_UploadHandle.isFromDraftBox       = _isFromDraftBox;
    model_UploadHandle.title_DraftBox       = self.model.mediaTitle;
    
    [WX_UploadHandle uploadVideoWithModel:model_UploadHandle];
    
    [self checkShare];
    
    [self popToMainViewController];
    
    [_view_CoverFlow removeFromSuperview];
    _view_CoverFlow = nil;
   
}




-(void)checkShare
{
    self.needShareNum = 0;
    
    if (self.weChatBtn.selected) {
        self.needShareNum++;
        self.isWeChatShare = YES;
    }else{
        self.isWeChatShare = NO;
    }
    if (self.weChatMomentsBtn.selected) {
        self.needShareNum++;
        self.isWeChatMomentsShare = YES;
        
    }else{
        self.isWeChatMomentsShare = NO;
    }
    if (self.sinaWeiboBtn.selected) {
        self.needShareNum++;
        self.isSinaWeiBoShare = YES;
        
    }else{
        self.isSinaWeiBoShare = NO;
    }
    if (self.QQBtn.selected) {
        self.needShareNum++;
        self.isQQShare = YES;
        
    }else{
        self.isQQShare = NO;
    }
    WX_ShareModel *model_Share      = [[WX_ShareModel alloc]init];
    model_Share.share_VideoID       = self.upModel.upVideoID;
    model_Share.share_UserID        = [BYC_AccountTool userAccount].userid;
    model_Share.share_VideoTitle    = self.upModel.mediaTitle ;
    model_Share.share_ImageDataStr  = self.DBimgDataStr;
    
    if(_needShareNum>0)[WX_UploadHandle WX_ShareVideoWithModel:model_Share NeedShareCounts:_needShareNum ShareQQ:_isQQShare ShareWeChat:_isWeChatShare ShareWeChatMonents:_isWeChatMomentsShare ShareWeiBo:_isSinaWeiBoShare];
}

-(void)clickTheRigthButton
{
    QNWSLog(@"视频存入草稿箱,进入下一步");
    
    [self.view showAndHideHUDWithTitle:@"导入成功" WithState:BYC_MBProgressHUDHideProgress];
    
    [self writeToDraftBox];
    
}

/**
 *  写入数据库保存
 */
-(void)writeToDraftBox
{
    WX_DBBoxModel*model_DBBox = [[WX_DBBoxModel alloc]init];
    model_DBBox.title = _titleString;
    model_DBBox.mediaTitle = self.model.mediaTitle;
    model_DBBox.contents = self.textCTView.text;
    model_DBBox.location = self.addressString;
    model_DBBox.imgDataStr = self.DBimgDataStr;
    model_DBBox.media_Type = self.model.isVR;
    model_DBBox.videoID = self.model.mediaID;
    
    [WX_UploadHandle writeToDraftBoxModel:model_DBBox Compeleted:^(ENUM_WriteToDBoxType type) {
        switch (type) {
                /**
                 *  存储成功
                 */
            case ENUM_WriteSuccess:
            {
                [self.view showHUDWithTitle:@"已存入草稿箱" WithState:BYC_MBProgressHUDHideProgress];
                [self popToMainViewController];
            }
                break;
                /**
                 *  更新成功
                 */
            case ENUM_UpdataSuccess:
            {
                [self.view showAndHideHUDWithTitle:@"视频信息更新成功" WithState:BYC_MBProgressHUDHideProgress];
                [self popToMainViewController];
            }
                break;
                /**
                 *  文件已存在
                 */
            case ENUM_AlreadyExisted:
            {
                [self.view showAndHideHUDWithTitle:@"已导入该文件" WithState:BYC_MBProgressHUDHideProgress];
            }
                
                break;
            default:
                break;
        }
    }];
}
/// 返回主界面
-(void)popToMainViewController
{
    for (UIViewController *controllers in self.navigationController.viewControllers) {
        if ([controllers isKindOfClass:[BYC_MainTabBarController class]])
        {
            [self.navigationController popToViewController:controllers animated:YES];
            [_view_CoverFlow removeFromSuperview];
            _view_CoverFlow = nil;
        }
    }
}
#pragma mark --------------- KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isShareFinish"] && [[NSString stringWithFormat:@"%@",context] isEqualToString:@"isShareFinish"]) {
        
//        [self uploadSucceed];
    }
}

#pragma mark ---------------  UrlTextDelegate
-(void)UrlText:(NSString *)text
{
    _textCTView.text = [NSString stringWithFormat:@"%@%@",_textCTView.text,text];

    if (_textCTView.text.length == 0) {
        if (self.model.isVR == 2) {
            
            self.placeholderLabel.text = @"";
        }else{
            if (_isUserFirst) {
                _placeholderLabel.text = @"添加描述和话题，让更多人看到你的精彩视频";
            }
            self.placeholderLabel.text = @"点击添加描述";
        }
    }else{
        self.placeholderLabel.text = @"";
    }
}

#pragma mark --------------- UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --------------  UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        if (self.model.isVR == 2) {
            
            self.placeholderLabel.text = @"";
        }else{
            if (_isUserFirst) {
                _placeholderLabel.text = @"添加描述和话题，让更多人看到你的精彩视频";
            }
            self.placeholderLabel.text = @"点击添加描述";
        }
    }else{
            self.placeholderLabel.text = @"";

    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.textCTView resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - 监听

-(void)textViewEditChanged:(NSNotification *)obj
{
    
    UITextView *textView = (UITextView *)obj.object;
    
    /// 判断当前输入法是否是中文
    bool isChinese;
    
    /// iOS7.0之后使用
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }else{
        isChinese = true;
    }
    
    NSString *str_TextFiled = textView.text;
    
    if (self.model.isVR == 2 && textView.text.length < 8) {
        textView.text = @"#合拍show#";
    }
    /// 中文输入法下
    if (isChinese) {
        UITextRange *selectedRange = [textView markedTextRange];
        /// 获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        /// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            QNWSLog(@"输入的是汉字");
        }else{
            QNWSLog(@"输入的英文还没有转化为汉字的状态");
            QNWSLog(@"str_TextFiled == %@",str_TextFiled);
            QNWSLog(@"str_TextFiled.length == %zi",str_TextFiled.length);
        }
    }else{
    }
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
