//
//  WX_JoinShootingViewController.m
//  kpie
//
//  Created by 王傲擎 on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_JoinShootingViewController.h"
#import "WX_ToolClass.h"
#import "DateFormatting.h"
//#import "BYC_MediaPlayer.h"
#import "WX_FMDBManager.h"
#import "HL_CenterViewController.h"
#import "BYC_LoginAndRigesterView.h"
#import "WX_EditingMediaViewController.h"
#import "WX_ProgressHUD.h"
#import "ASProgressPopUpView.h"
#import "WX_MediaInfoModel.h"
#import "WX_VoideDViewController.h"
#import "BYC_MainNavigationController.h"
#import "BYC_InStepCollectionViewCellModel.h"

#import "ZFPlayer.h"

@interface WX_JoinShootingViewController ()<NSURLConnectionDataDelegate,ASProgressPopUpViewDataSource>
{
    NSMutableData                   *_recData;              /**<    接收下载数据  */
    NSString                        *_filePath;             /**<    文件路径    */
    NSFileManager                   *_fileManager;
    NSFileHandle                    *_fileHandle;           /**<    文件操作句柄  */
    NSURLConnection                 *_downConnection;       /**<    下载链接对象  */
    WX_FMDBManager                  *_manager;
}
@property(nonatomic, strong) BYC_InStepCollectionViewCellModel      *model_Home;            /**<   全局model */
@property(nonatomic, strong) UIView                                 *all_View_Back;         /**<   视图背景 */
@property(nonatomic, strong) UIView                                 *top_View_MediaView;    /**<   播放器背景 */
@property(nonatomic, strong) UIView                                 *mid_View_Back;         /**<   中部视图背景 */
@property(nonatomic, strong) UIImageView                            *mid_ImgView_Head;      /**<   用户头像 */
@property(nonatomic, strong) UILabel                                *mid_Label_Title;       /**<   用户名 */
@property(nonatomic, strong) UILabel                                *mid_Label_Time;        /**<   发布时间 */
@property(nonatomic, strong) UIImageView                            *mid_ImgView_UseIcon;   /**<   使用次数图标 */
@property(nonatomic, strong) UILabel                                *mid_Label_UseTheNum;   /**<   使用次数 */
@property(nonatomic, strong) UIImageView                            *mid_ImgView_Cutting;   /**<   分割线 */
@property(nonatomic, strong) UIImageView                            *mid_ImgView_Recommend; /**<   简介图标 */
@property(nonatomic, strong) UILabel                                *mid_Label_Recommend;   /**<   简介 */
@property(nonatomic, strong) UIImageView                            *bottom_ImgView_Prompt; /**<   提示操作图片 */
@property(nonatomic, strong) UIView                                 *bottom_View_Back;      /**<   底部视图背景 */
@property(nonatomic, strong) UIButton                               *bottom_JoinButton;     /**<   底部合拍按钮 */
@property(nonatomic, assign) NSInteger                              integer_Report;         /**<   举报个数 */
@property(nonatomic, strong) ZFPlayerView                           *ZF_PlayerView;         /**<   播放器 */
@property(nonatomic, strong) NSMutableArray                         *array_Join;            /**<   合拍数组 */
@property(nonatomic, assign) NSInteger                              downNum;                /**<   下载个数 2个 0__1 */
@property(nonatomic, strong) ASProgressPopUpView                    *progress_Down;         /**<   下载进度条 */
@property(nonatomic, assign) CGFloat                                file_Size;              /**<   下载文件总大小 */
@property(nonatomic, assign) CGFloat                                down_Size;              /**<   已下载文件大小 */
@property(nonatomic, copy)   NSString                               *str_second;            /**<   时间秒数 */
@property(nonatomic, assign) BOOL                                   isMedia_exist;          /**<   需要下载的视频是否存在 */
@property(nonatomic, strong) NSMutableArray                         *array_Editing;         /**<   需要编辑的视频, 传入下一界面的数组 */


@end

@implementation WX_JoinShootingViewController
-(NSMutableArray *)array_Editing{
    if (!_array_Editing) {
        _array_Editing = [NSMutableArray array];
    }
    return _array_Editing;
}
#pragma mark ----- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self showPromptImgView];
    
    [self createProgress];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createPlayer];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self burningMediaPlayer];

}

- (void)dealloc
{
    NSLog(@"%@释放了",self.class);
    [self.ZF_PlayerView cancelAutoFadeOutControlBar];
}

#pragma mark ------ 接口

#pragma mark ---------- 举报接口
/// 举报接口
-(void)reportTheVideoResponseObjectWithReportStr:(NSString *)reportStr
{
    
    BYC_AccountModel *model = [BYC_AccountTool userAccount];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_model_Home.userid forKey:@"userReports.userid"];
    [dic setValue:reportStr forKey:@"userReports.reportreason"];
    [dic setValue:_model_Home.videoid forKey:@"userReports.reportvideoid"];
    
    [dic setValue:model.userid forKey:@"userid"];
    [dic setValue:model.token forKey:@"token"];
    
    [BYC_HttpServers Post:KQNWS_SaveUserReport parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QNWSLog(@"responseObject == %@",responseObject);
        if ([responseObject[@"result"] isEqualToString:@"0"]) {
            [self.view showAndHideHUDWithTitle:@"举报成功" WithState:BYC_MBProgressHUDHideProgress];
        }else {
            [self.view showAndHideHUDWithTitle:@"举报失败" WithState:BYC_MBProgressHUDHideProgress];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view showAndHideHUDWithTitle:@"举报失败" WithState:BYC_MBProgressHUDHideProgress];
        QNWSLog(@"举报失败,error == %@",error);
    }];
    
}
#pragma mark ------ 绘制界面,创建播放器
/// 创建界面
-(void)createUI
{
    /// 视图背景
    _all_View_Back = [[UIView alloc]init];
    _all_View_Back.backgroundColor = KUIColorFromRGB(0xf0f0f0);
    [self.view addSubview:_all_View_Back];
    
    [_all_View_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    /// 播放器背景
    _top_View_MediaView = [[UIView alloc]init];
    _top_View_MediaView.backgroundColor = [UIColor blackColor];
    [_all_View_Back addSubview:_top_View_MediaView];
    
    [_top_View_MediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_all_View_Back);
        make.left.right.equalTo(_all_View_Back);
        make.height.equalTo(_all_View_Back.mas_height).multipliedBy(0.48);
    }];
    
    /// 中部视图背景
    _mid_View_Back = [[UIView alloc]init];
    _mid_View_Back.backgroundColor = [UIColor clearColor];
    [_all_View_Back addSubview:_mid_View_Back];
    
    [_mid_View_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_all_View_Back);
        make.top.equalTo(_top_View_MediaView.mas_bottom);
        make.height.equalTo(_all_View_Back.mas_height).multipliedBy(0.35);
    }];
    
    /// 用户头像
    _mid_ImgView_Head = [[UIImageView alloc]init];
    [_mid_ImgView_Head sd_setImageWithURL:[NSURL URLWithString:_model_Home.users.headportrait]];
    _mid_ImgView_Head.layer.masksToBounds = YES;
    _mid_ImgView_Head.layer.cornerRadius = 17;
    _mid_ImgView_Head.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_head = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHead:)];
    [_mid_ImgView_Head addGestureRecognizer:tap_head];
    [_mid_View_Back addSubview:_mid_ImgView_Head];
    
    [_mid_ImgView_Head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@10);
        make.top.equalTo(_top_View_MediaView.mas_bottom).offset(15);
        make.width.height.mas_equalTo(@34);
    }];
    
    /// 用户名
    _mid_Label_Title = [[UILabel alloc]init];
    _mid_Label_Title.text = _model_Home.users.nickname;
    _mid_Label_Title.font = [UIFont systemFontOfSize:14];
    _mid_Label_Title.textColor = KUIColorFromRGB(0x3c4f5e);
    [_mid_View_Back addSubview:_mid_Label_Title];
    
    CGSize size_Title = [WX_ToolClass changeSizeWithString:_model_Home.users.nickname FontOfSize:14 bold:ENUM_NormalSystem];
    CGFloat width_Title = size_Title.width +10;
    [_mid_Label_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_ImgView_Head.mas_right).offset(10);
        make.top.equalTo(_mid_ImgView_Head.mas_top);
        make.width.mas_equalTo(width_Title);
        make.height.mas_equalTo(size_Title.height);
    }];
    
    
    /// 发布时间
    NSString *str_Time = [WX_ToolClass getDateWithFormatter:_model_Home.uploadtime];
    CGSize size_Time = [WX_ToolClass changeSizeWithString:str_Time FontOfSize:12 bold:ENUM_NormalSystem];
    CGFloat width_time = size_Time.width +10;
    
    _mid_Label_Time = [[UILabel alloc]init];
    _mid_Label_Time.font = [UIFont systemFontOfSize:12];
    _mid_Label_Time.text = str_Time;
    _mid_Label_Time.textColor = KUIColorFromRGB(0x3c4f5e);
    _mid_Label_Time.enabled = NO;
    [_mid_View_Back addSubview:_mid_Label_Time];
    
    [_mid_Label_Time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_Label_Title.mas_left);
        make.top.equalTo(_mid_Label_Title.mas_bottom).offset(4);
        make.width.mas_equalTo(width_time);
        make.height.mas_equalTo(size_Time.height);
    }];
    
    /// 使用次数图标
    _mid_ImgView_UseIcon = [[UIImageView alloc]init];
    _mid_ImgView_UseIcon.image = [UIImage imageNamed:@"hepaishow_icon_zhizuo"];
    [_mid_View_Back addSubview:_mid_ImgView_UseIcon];
    
    [_mid_ImgView_UseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_Label_Time.mas_right).offset(5);
        make.top.equalTo(_mid_Label_Time.mas_top);
        make.width.height.mas_equalTo(@14);
    }];
    
    /// 使用次数
    NSString *str_UserNum = [NSString stringWithFormat:@"%zi 次制作",_model_Home.templets];
    CGSize size_UserNum =[WX_ToolClass changeSizeWithString:str_UserNum FontOfSize:12 bold:ENUM_NormalSystem];
    CGFloat float_Width = size_UserNum.width+10;
    _mid_Label_UseTheNum = [[UILabel alloc]init];
    _mid_Label_UseTheNum.text = str_UserNum;
    _mid_Label_UseTheNum.font = [UIFont systemFontOfSize:12];
    _mid_Label_UseTheNum.textColor = KUIColorFromRGB(0x3c4f5e);
    _mid_Label_UseTheNum.enabled = NO;
    [_mid_View_Back addSubview:_mid_Label_UseTheNum];
    
    [_mid_Label_UseTheNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_ImgView_UseIcon.mas_right).offset(5);
        make.top.equalTo(_mid_Label_Time.mas_top);
        make.height.mas_equalTo(size_UserNum.height);
        make.width.mas_equalTo(float_Width);
    }];
    
    /// 分割线
    _mid_ImgView_Cutting = [[UIImageView alloc]init];
    _mid_ImgView_Cutting.backgroundColor = KUIColorFromRGB(0xdedede);
    [_mid_View_Back addSubview:_mid_ImgView_Cutting];
    
    [_mid_ImgView_Cutting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mid_ImgView_Head.mas_bottom).offset(10);
        make.left.equalTo(_mid_ImgView_Head.mas_left);
        make.right.equalTo(_mid_View_Back);
        make.height.mas_equalTo(0.5);
    }];
    
    /// 简介图标
    _mid_ImgView_Recommend = [[UIImageView alloc]init];
    _mid_ImgView_Recommend.image = [UIImage imageNamed:@"icon_bfy_jjspfh"];
    [_mid_View_Back addSubview:_mid_ImgView_Recommend];
    
    [_mid_ImgView_Recommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_ImgView_Head.mas_left);
        make.top.equalTo(_mid_ImgView_Cutting.mas_bottom).offset(10);
        make.width.height.mas_equalTo(@20);
    }];
    
    /// 简介
    NSString *str_Recommend = _model_Home.videotitle;
    CGSize size_Recommend = [WX_ToolClass changeSizeWithString:str_Recommend FontOfSize:13 bold:ENUM_NormalSystem];
    CGFloat width_Recommend = size_Recommend.width +10;
    _mid_Label_Recommend = [[UILabel alloc]init];
    _mid_Label_Recommend.text = str_Recommend;
    _mid_Label_Recommend.font = [UIFont systemFontOfSize:13];
    _mid_Label_Recommend.textColor = KUIColorFromRGB(0x3c4f5e);
    _mid_Label_Recommend.enabled = NO;
    [_mid_View_Back addSubview:_mid_Label_Recommend];
    
    [_mid_Label_Recommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_ImgView_Recommend.mas_right).offset(10);
        make.centerY.equalTo(_mid_ImgView_Recommend.mas_centerY);
        make.width.mas_equalTo(width_Recommend);
        make.height.mas_equalTo(size_Recommend.height);
    }];
    
    
    
    /// 底部视图背景
    _bottom_View_Back = [[UIView alloc]init];
    _bottom_View_Back.backgroundColor = [UIColor clearColor];
    [_all_View_Back addSubview:_bottom_View_Back];
    
    CGFloat float_top = screenHeight - 47;
    [_bottom_View_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_all_View_Back);
//        make.bottom.equalTo(_all_View_Back.mas_bottom);
        make.top.equalTo(_all_View_Back.mas_top).offset(float_top);
        make.height.mas_equalTo(@47);
    }];
    
    /// 底部合拍按钮
    _bottom_JoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottom_JoinButton setBackgroundImage:[UIImage imageNamed:@"hepaishow_mbyl_btn_wlhp_n"] forState:UIControlStateNormal];
    [_bottom_JoinButton setBackgroundImage:[UIImage imageNamed:@"hepaishow_mbyl_btn_wlhp_h"] forState:UIControlStateHighlighted];
    [_bottom_JoinButton addTarget:self action:@selector(joinShooting:) forControlEvents:UIControlEventTouchUpInside];
    [_bottom_View_Back addSubview:_bottom_JoinButton];
    
    [_bottom_JoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(_bottom_View_Back);
    }];
    
    /// 提示操作图片
    _bottom_ImgView_Prompt = [[UIImageView alloc]init];
    _bottom_ImgView_Prompt.image = [UIImage imageNamed:@"hepaishow_mbyl_pop_tihp"];
    _bottom_ImgView_Prompt.alpha = 0.f;
    [_bottom_View_Back addSubview:_bottom_ImgView_Prompt];
    
    [_bottom_ImgView_Prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottom_JoinButton.mas_top).offset(-10);
        make.centerX.equalTo(_bottom_View_Back.mas_centerX);
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@58);
    }];
    
    
}

/// 创建播放器
-(void)createPlayer
{
    
    _ZF_PlayerView = [[ZFPlayerView alloc]init];
    [_top_View_MediaView addSubview:self.ZF_PlayerView];

    [self.ZF_PlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(_top_View_MediaView);
        make.top.equalTo(_top_View_MediaView).offset(20);
    }];
    // 设置播放前的占位图（需要在设置视频URL之前设置）
    self.ZF_PlayerView.placeholderImageName = @"loading_bgView1";
    self.ZF_PlayerView.videoURL = [NSURL URLWithString:_model_Home.videomp4];
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.ZF_PlayerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    // 打开断点下载功能（默认没有这个功能）
    self.ZF_PlayerView.hasDownload = NO;
    // 是否自动播放，默认不自动播放
    [self.ZF_PlayerView autoPlayTheVideo];
    QNWSWeakSelf(self);
    
    self.ZF_PlayerView.goBackBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    self.ZF_PlayerView.reportBlock = ^{
        [weakself mediaPlayReportTheVideo];
    };

}

#pragma mark ------- 转屏
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            NSLog(@"中");
            [_top_View_MediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_all_View_Back);
                make.left.right.equalTo(_all_View_Back);
                make.height.equalTo(_all_View_Back.mas_height).multipliedBy(0.48);
            }];
            KMainNavigationVC.isVR = NO;
            [super updateViewConstraints];
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"左");
            [BYC_LoginAndRigesterView removeAppearView];
            [_top_View_MediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.view);
            }];
            KMainNavigationVC.isVR = NO;
            
            [super updateViewConstraints];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"右");
            [BYC_LoginAndRigesterView removeAppearView];
            [_top_View_MediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.view);
            }];
            
            KMainNavigationVC.isVR = NO;
            [super updateViewConstraints];
            
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

#pragma mark ------ 代理方法
/// 播放器
-(void)mediaPlayViewPop
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)mediaPlayReportTheVideo
{
    [self reportTheVideo];
}

/// 举报视频
-(void)reportTheVideo
{
    QNWSLog(@"点击,举报该视频");
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"举报" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"涉及色情或政治内容",@"其他原因",@"取消", nil];
        alert.tag = 100;
        
        [alert show];
    }];
    
}


-(void)reportTheVideoAlterView
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"确定举报该视频 ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    alter.tag = 200;
    [alter show];
    
}


/// 提示框
#pragma mark ------------- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            _integer_Report = 1;
            [self reportTheVideoAlterView];
        }else if (buttonIndex == 1){
            _integer_Report = 2;
            [self reportTheVideoAlterView];
        }else if (buttonIndex == 2){
            /// 取消
            return;
        }
        
    }
    if (alertView.tag == 200) {
        if (buttonIndex == 0) {
            return;
        }else if(buttonIndex == 1){
            NSString *reportStr = (_integer_Report == 1) ? @"涉及色情或政治内容" : @"其他原因";
            [self reportTheVideoResponseObjectWithReportStr:reportStr];
        }
    }
}

/// 进度条
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *str;
    if (progress < 0.2) {
        str = @"开始下载";
    } else if (progress >= 1.0) {
        str = @"下载完成";
    }
    return str;
}

#pragma amrk ------ 手势,按钮事件
/// 进入合拍界面
-(void)joinShooting:(UIButton*)btn
{    

    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        if(_isMedia_exist){
            /// 如果之前已经下载, 直接把数组传入, 推出下一页
            
            WX_EditingMediaViewController *editVC = [[WX_EditingMediaViewController alloc]init];
            
            [editVC receiveEditingMediaWithArray:self.array_Editing];
            
            [self.navigationController pushViewController:editVC animated:YES];
        }else{
            
            _bottom_JoinButton.enabled = NO;
            /// 下载,完成后退出下一页
            [self createDownLoadWithScriptNum:0];
            
        }
    }];
    
}

/// 点击头像进入页面
-(void)tapToHead:(UITapGestureRecognizer*)tap
{
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        HL_CenterViewController *centerVC = [[HL_CenterViewController alloc]init];
        centerVC.str_ToUserID = _model_Home.userid;
        [self.navigationController pushViewController:centerVC animated:YES];
    }];
}
#pragma mark ------ 其他

/// 是否展示提示图片
-(void)showPromptImgView
{

    BOOL is_Show = [WX_FMDBManager selectWithTable:KSTR_TABLE_JoinShooting];
    if (is_Show) {
        ///存在 不显示图片
        _bottom_ImgView_Prompt.alpha = 0.f;
        ///读取数据库信息查询视频是否存在
        [self readInfoFromFMDB];
        
    }else{

        /// 创建数据库
        NSArray *array_CreateTabel = [NSArray arrayWithObjects:@"mediaTitle",@"mediaPath",@"mediaID",@"mediaUrl",@"imageDataStr",@"timelength",@"isVR",@"mediaParameter", nil];
        BOOL is_Create = [WX_FMDBManager createTable:KSTR_TABLE_JoinShooting WithArray:array_CreateTabel];
        if (is_Create) {
            QNWSLog(@"合拍表创建成功");
        }else{
            QNWSLog(@"合拍表创建失败");
        }
        
        /// 不存在 展示图片
        _bottom_ImgView_Prompt.alpha = 1.f;
        
        [UIView animateWithDuration:2.0f animations:^{
            
            _bottom_ImgView_Prompt.layer.transform = CATransform3DMakeScale(.3f, .3f, 1.f);
            [UIView animateWithDuration:1.95f animations:^{
                _bottom_ImgView_Prompt.layer.transform = CATransform3DIdentity;
            }];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:2.0f animations:^{
                
                _bottom_ImgView_Prompt.layer.transform = CATransform3DMakeScale(.3f, .3f, 1.f);
                [UIView animateWithDuration:1.95f animations:^{
                    _bottom_ImgView_Prompt.layer.transform = CATransform3DIdentity;
                }];
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.55f animations:^{
                    _bottom_ImgView_Prompt.alpha = 0.f;
                }];
            }];
        }];
    }
}

-(void)readInfoFromFMDB
{
    [self.array_Editing removeAllObjects];
    
    _manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    FMResultSet *dataResult = [_manager.dataBase executeQuery:@"select * from JoinShooting"];
    NSMutableArray *array_Result = [[NSMutableArray alloc]init];

    if (dataResult != nil) {
        while ([dataResult next]) {
            WX_MediaInfoModel *model_Media  =   [[WX_MediaInfoModel alloc]init];
            model_Media.mediaTitle          =   [dataResult stringForColumn:@"mediaTitle"];
            model_Media.mediaPath           =   [dataResult stringForColumn:@"mediaPath"];
            model_Media.mediaID             =   [dataResult stringForColumn:@"mediaID"];
            model_Media.mediaUrl            =   [dataResult stringForColumn:@"mediaUrl"];
            model_Media.imageDataStr        =   [dataResult stringForColumn:@"imageDataStr"];
            model_Media.DurationStr         =   [dataResult stringForColumn:@"timelength"];
            model_Media.isVR                =   [dataResult intForColumn:@"isVR"];
            model_Media.media_Parameter     =   [dataResult stringForColumn:@"mediaParameter"];
            [array_Result addObject:model_Media];
        }
    }
    
    /// 判断是否存在此视频
    for (WX_MediaInfoModel *model_media in array_Result) {
        if ([model_media.mediaID isEqualToString:_model_Home.videoid]) {
            [self.array_Editing addObject:model_media];
            _isMedia_exist = YES;
        }
    }

}

/// 销毁播放器
-(void)burningMediaPlayer
{
//    [_mediaPlayer stopPlayer];
//    
//    _mediaPlayer = nil;
//    
//    self.suppport_Orientation = ENUM_unNeed_UnSupportOrientation;
    
    [self.ZF_PlayerView pause];

}


#pragma mark ------ 对外接口
/// 获取界面模型
-(void)receiveModelWith:(BYC_InStepCollectionViewCellModel *)model
{
    _model_Home = model;
    
    /// 存储合拍模型数组
    if (!_array_Join) {       
        
        _array_Join = [[NSMutableArray alloc]init];
        
        WX_MediaInfoModel *model_Media = [[WX_MediaInfoModel alloc]init];
        model_Media.mediaTitle          =   _model_Home.videotitle;
        model_Media.mediaID             =   _model_Home.videoid;
        model_Media.mediaUrl            =   _model_Home.videomp4;
        model_Media.pictureJPGUrl       =   _model_Home.picturejpg;
        model_Media.isVR                =   _model_Home.isvr;
        model_Media.media_Parameter     =   _model_Home.soundmp3;
        [_array_Join addObject:model_Media];
    }
}

/// 创建下载进度条
-(void)createProgress
{
    _progress_Down = [[ASProgressPopUpView alloc]init];
    _progress_Down.dataSource = self;
    _progress_Down.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
    _progress_Down.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    [_progress_Down showPopUpViewAnimated:YES];
    [_bottom_View_Back addSubview:_progress_Down];
    
    [_progress_Down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottom_JoinButton);
        make.bottom.equalTo(_bottom_JoinButton.mas_top);
        make.height.mas_equalTo(@2);
    }];
    
    _progress_Down.hidden = YES;
}

#pragma mark ------ 下载合拍视频
// 现从第一个合拍视频开始下载
// 等待第一个合拍视频下载完成后, 再下载第二个剧本
// 以此类推
-(void)createDownLoadWithScriptNum:(NSInteger)scriptNum
{
    _progress_Down.hidden = NO;
    
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    _filePath = [path stringByAppendingPathComponent:KSTR_TABLE_JoinShooting];
    _fileManager = [NSFileManager defaultManager];
    [_fileManager createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    WX_MediaInfoModel *model_Media = _array_Join[scriptNum];
    
    _filePath = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model_Media.mediaTitle]];
    QNWSLog(@"filePath==%@",_filePath);
    model_Media.mediaPath = _filePath;
    
    [self downTheScriptWithUrlStr:model_Media.mediaUrl];
    
    /// 封面图片转化为字符串
    NSData *data_Img = [NSData dataWithContentsOfURL:[NSURL URLWithString:model_Media.pictureJPGUrl]];
    
    model_Media.imageDataStr = [data_Img base64EncodedStringWithOptions:0];
    
}

-(void)downTheScriptWithUrlStr:(NSString*)urlStr
{
    
    _recData = [NSMutableData new];
    
    QNWSLog(@"urlStr == %@",urlStr);
    //创建可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    //NSFileManager:文件管理类.管理文件的创建,删除,是否存在
    //NSFileHandle:文件操作类.文件的读,写.文件指针的移动
    _fileManager = [NSFileManager defaultManager];
    
    //判断文件是否存在
    if([_fileManager fileExistsAtPath:_filePath]){
        //存在.接着前面的部分往后追加(断点续传)
        
        //获取文件操作句柄
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_filePath];
        
        //将句柄移动到文件末尾
        [_fileHandle seekToEndOfFile];
        
        //获取到已下载文件的长度
        long long fileLength = _fileHandle.offsetInFile;
        
        //设置range头域
        [request addValue:[NSString stringWithFormat:@"bytes=%lld-",fileLength] forHTTPHeaderField:@"Range"];
        
        //发起请求
        _downConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
    }else{
        //不存在.从零开始下载
        
        //创建这个文件
        [_fileManager createFileAtPath:_filePath contents:nil attributes:nil];
        
        //获取文件操作句柄
        //fileHandleForUpdatingAtPath  读和写
        //fileHandleForReadingAtPath   只读
        //fileHandleForWritingAtPath   只写
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_filePath];
        
        //发起网络请求
        _downConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
}

#pragma mark -NSURLConnectionDataDelegate
//接收到了响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    QNWSLog(@"下载文件总大小 ==%lld",response.expectedContentLength);
    _file_Size = response.expectedContentLength;
    
    //总长度是2048
    //文件不存在 expectedContentLength   2048
    //文件存在,长度是1024   expectedContentLength  1024
    _recData.length = 0;
    
    
}
//接收到了数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //数据拼接
    [_recData appendData:data];
    
    QNWSLog(@"下载了 %f",_recData.length/_file_Size);
    
    [_progress_Down setProgress:_recData.length/_file_Size animated:YES];
}

#pragma mark ------------ NSURLConnectionDataDelegate
//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_downNum < _array_Join.count) {
        
        //写入沙盒
        [_fileHandle writeData:_recData];
        
        WX_MediaInfoModel *model_Media = _array_Join[_downNum];
        
        NSInteger seconds = _ZF_PlayerView.playerItem.duration.value/_ZF_PlayerView.playerItem.duration.timescale;
        
        _str_second = [WX_ToolClass TimeformatFromSeconds:seconds];
        model_Media.DurationStr = _str_second;
        
        /// 存入数据库
        _manager = [WX_FMDBManager sharedWX_FMDBManager];
        if (![_manager.dataBase executeUpdate:@"insert into JoinShooting(mediaTitle ,mediaPath ,mediaID ,mediaUrl ,imageDataStr ,timelength ,isVR, mediaParameter) values(?,?,?,?,?,?,?,?)",model_Media.mediaTitle,model_Media.mediaPath,model_Media.mediaID,model_Media.mediaUrl,model_Media.imageDataStr,model_Media.DurationStr,[NSString stringWithFormat:@"%zi",model_Media.isVR],model_Media.media_Parameter]){
            QNWSLog(@"视频拍摄数据库信息----- 插入失败");
        }else{
            QNWSLog(@"写入信息成功");
            [self.array_Editing addObject:model_Media];
        }
        
        
        if (_downNum < _array_Join.count -1) {
            
            [self createDownLoadWithScriptNum:_downNum+1];
        }else{
            /// 下载成功 进行跳转
            [WX_ProgressHUD showSuccess:@"下载成功"];
            
            WX_EditingMediaViewController *editVC = [[WX_EditingMediaViewController alloc]init];
            
            [editVC receiveEditingMediaWithArray:self.array_Editing];
            
            [self.navigationController pushViewController:editVC animated:YES];
            
            _isMedia_exist = YES;
            
            [self dismissTheHUD];
            
        }
        
        _downNum++;
    }else{
        
        [self downFailedShow];
        
    }
    
}
//下载失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    QNWSLog(@"下载失败,error=%@",error);

    [self downFailedShow];
    
}

/// 下载失败, 展示提示
-(void)downFailedShow
{
    [WX_ProgressHUD show:@"下载失败"];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
}

/// 隐藏提示
-(void)dismissTheHUD
{
    _progress_Down.hidden = YES;
    
    [_progress_Down setProgress:0.f];
    
    _bottom_JoinButton.enabled = YES;
    
    [WX_ProgressHUD dismiss];
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
