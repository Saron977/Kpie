//
//  WX_MovieCViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_MovieCViewController.h"
#import "WX_ShootCViewController.h"
#import "WX_FMDBManager.h"
#import "ffmpegutils.h"
#import "WX_ShootModel.h"
#import "CTAssetsPickerController.h"
#import "WX_ProgressHUD.h"
#import "WX_ToolClass.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BYC_MainNavigationController.h"
#import "WX_Authority.h"






typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface WX_MovieCViewController ()<AVCaptureFileOutputRecordingDelegate,UIAlertViewDelegate>//视频文件输出代理
@property(nonatomic, retain) UIProgressView                         *playerPgress;
@property(nonatomic, assign) float                                   pgressValue;
@property(nonatomic, retain) NSTimer                                *pgressTimer;
@property(nonatomic, retain) NSTimer                                *shootTimer;
@property(nonatomic, retain) NSArray                                *normalArray;
@property(nonatomic, retain) NSArray                                *selectArray;
@property(nonatomic, strong) UIImageView                           *flogImgView;
@property(nonatomic, assign)  int                                   flag;
@property(nonatomic, retain) NSString                               *mediaFileParh;
@property(nonatomic, retain) NSString                               *path;
@property(nonatomic, retain) NSString                               *outPath;
@property(nonatomic, retain) UIButton                               *shootButton;
@property(nonatomic, retain) NSMutableArray                         *shootVideoArray;
@property(nonatomic, assign) BOOL                                   isReturn;
@property(nonatomic, assign) BOOL                                   isPopToRoot;
@property(nonatomic, retain) UIView                                 *coverView;     /**< 屏幕遮蔽,禁用所有按钮 */

@property(nonatomic, assign) CGFloat                                num;
@property(nonatomic, strong) NSString                               *mediaDuration;

@property(nonatomic, assign) BOOL                                   isTransition;

@property(nonatomic, retain) UIButton                               *finishButton;
@property(nonatomic, retain) UIButton                               *flashButton;
@property(nonatomic, strong) UIButton                               *button_ImportVideo;   /**< 相册 */
@property(nonatomic, assign) BOOL                                   isFlashClick;
@property(nonatomic, assign) BOOL                                   isCameraClick;
@property(nonatomic, assign) NSInteger                              camerCount;
//@property(nonatomic, assign) CGImageRef                             thumbnailImageRef;

@property (nonatomic, strong) NSFileManager                          *fileManager;
@property (nonatomic, strong) NSString                               *dateString;
@property (nonatomic, strong) NSString                               *mediaPath;
@property (nonatomic, strong) NSURL                                  *fileUrl;

@property (strong, nonatomic) AVCaptureDevice                       *device;
@property (strong, nonatomic) AVCaptureConnection                   *captureConnection;
@property (assign, nonatomic) AVCaptureDevicePosition               currentPosition;
@property (assign, nonatomic) AVCaptureDevicePosition               toChangePosition;
@property (strong, nonatomic) AVCaptureSession                       *captureSession;/**<  负责输入和输出设置之间的数据传递 */
@property (strong, nonatomic) AVCaptureDeviceInput                   *captureDeviceInput;/**<  负责从AVCaptureDevice获得输入数据 */
@property (strong, nonatomic) AVCaptureMovieFileOutput               *captureMovieFileOutput;/**<  视频输出流 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer             *captureVideoPreviewLayer;/**< 相机拍摄预览图层 */
@property (assign, nonatomic) BOOL                                   enableRotation;/**< 是否允许旋转（注意在视频录制过程中禁止屏幕旋转）*/
@property (assign, nonatomic) CGRect                                 *lastBounds;/**< 旋转的前大小 */
@property (assign, nonatomic) UIBackgroundTaskIdentifier             backgroundTaskIdentifier;/**< 后台任务标识 */
//@property (retain, nonatomic) IBOutlet UIView                       *backView;
@property (weak, nonatomic) IBOutlet UIButton                        *takeButton;/**< 拍照按钮 */
//@property (weak, nonatomic) IBOutlet UIImageView                    *focusCursor; /**< 聚焦光标 */
@property (strong, nonatomic) UIImageView                            *focusCursor;  /**< 聚焦光标 */
@property (strong, nonatomic) UIView                                 *backView;

@property(nonatomic, strong) WX_FMDBManager                          *manager;

@property(nonatomic, strong)CAGradientLayer                          *gradLayer; /**< 设置渐变色带 */
@property(nonatomic, strong)CALayer                                  *mask; /**<  蒙版, 遮盖色带 */
@property(nonatomic, strong)UIImageView                              *promptImgView; /**< 渐变色带前置白色闪烁提示图 */
@property(nonatomic, strong)UILabel                                  *shootTimeLabel; /**<  拍摄时长 */

@property(nonatomic, copy) NSString                                  *script_Replace_ImgData;   /**<   剧本合拍_图片_data */
@property(nonatomic, copy) NSString                                  *script_Replace_Duration;  /**<   剧本合拍_时长 */

@property (nonatomic, strong) UIButton                              *button_FlashLight;     /**<   闪光灯 */
@property (nonatomic, strong) UIButton                              *button_FrontOrRear_Cameras;    /**<   前后摄像头切换 */
@end

@implementation WX_MovieCViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.isFlashClick = 1;
    
    self.isCameraClick = 1;
    
    [self createTimer];
    
    [self clearTheCacheFile];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorFromRGB(0x000000)];
    


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.captureSession startRunning];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self createUI];
    
    // 权限判断
    // 相机权限
    [WX_Authority WX_AuthorityVideoDetection:^(BOOL authority) {
        // 麦克风权限
        if (authority) {
            
            [WX_Authority WX_AuthorityAudioDetection:^(BOOL authorited) {
                if(authorited){
                    [self createCamera];
                    [self.captureSession startRunning];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self createFMDB];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [KMainNavigationVC.navigationBar setBarTintColor:KUIColorBaseGreenNormal];
    
    self.isFromShootVC = NO;
    
    //关闭定时器
    [self.shootTimer invalidate];
    self.shootTimer = nil;
    
    [self.pgressTimer invalidate];
    self.pgressTimer = nil;
    
    [self.fileManager removeItemAtPath:self.mediaPath error:nil];
}

-(void)createTimer
{
    // 通过计时器 完成循环调用
    self.pgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(progressWithPlayer:) userInfo:nil repeats:YES];
}

-(void)createUI
{
    self.flag = 1;
    self.camerCount = 0;
    
    self.shootVideoArray = [[NSMutableArray alloc]init];
    
    
#if 0
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickTheRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
#endif

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [backBtn setImage:[UIImage imageNamed:@"btn_tongyong_guanbi_n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"btn_tongyong_guanbi_h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    
    // 播放器 画布
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight*0.5)];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.5);
        make.top.offset(KHeightNavigationBar);
    }];
    
#pragma mark ------ 设置摄像头
//    // 模拟
//    UIView *playerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backView.frame.size.height*0.1, screenWidth, self.backView.frame.size.height*0.7)];
//    playerView.backgroundColor = [UIColor clearColor];
//    [self.backView addSubview:playerView];
    
   
    // 设置进度条
    self.playerPgress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, self.backView.bottom, screenWidth, 2)];
    self.playerPgress.progressViewStyle = UIProgressViewStyleBar;
    self.playerPgress.trackTintColor = [UIColor clearColor];
    self.playerPgress.progressTintColor = [UIColor clearColor]; // 改变进度条颜色
    [self.view addSubview:self.playerPgress];
    
    self.flogImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.playerPgress.frame.size.width/KFLOAT_KVideoShoot*3, 0, 2, KFLOAT_KVideoShootProgressHight)];
    self.flogImgView.backgroundColor = [UIColor greenColor];
    [self.playerPgress addSubview:self.flogImgView];
    
    UIImageView *progressImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.playerPgress.frame.size.width, KFLOAT_KVideoShootProgressHight)];
    [self.playerPgress addSubview:progressImgView];
    
    if (self.gradLayer == nil) {
        self.gradLayer = [CAGradientLayer layer];
        self.gradLayer.frame = progressImgView.bounds;//尺寸要与view的layer一致
    }
    self.gradLayer.startPoint = CGPointMake(0, 0.5);
    self.gradLayer.endPoint = CGPointMake(1, 0.5);
    
    self.gradLayer.colors = [NSArray arrayWithObjects:(id)[UIColor redColor].CGColor,(id)[UIColor yellowColor].CGColor,(id)[UIColor greenColor].CGColor, nil];
    self.gradLayer.locations = @[@(0.1f),@(0.2f),@(1.0f)];
    
    self.mask = [CALayer layer];
    [self.mask setFrame:CGRectMake(self.gradLayer.frame.origin.x, self.gradLayer.frame.origin.y,0, KFLOAT_KVideoShootProgressHight)];
    self.mask.borderWidth = KFLOAT_KVideoShootProgressHight;
    [self.gradLayer setMask:self.mask];

    [progressImgView.layer insertSublayer:self.gradLayer atIndex:0];

    self.promptImgView = [[UIImageView alloc]initWithFrame:CGRectMake(progressImgView.frame.origin.x, 0, 5, KFLOAT_KVideoShootProgressHight)];
    self.promptImgView.backgroundColor = [UIColor whiteColor];
    [self.playerPgress addSubview:self.promptImgView];
    
    [self.promptImgView.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
    
    
    
    // button.tag === 100 ~ 104
    // 闪光灯  镜头反转按钮
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(0, self.playerPgress.bottom, screenWidth, screenHeight*0.07)];
    smallView.backgroundColor = KUIColorFromRGB(0x292929);
    [self.view addSubview:smallView];
    
    [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_backView.mas_bottom).offset(KFLOAT_KVideoShootProgressHight);
        make.height.equalTo(self.view).multipliedBy(0.07);
    }];
    
    self.normalArray = @[@"btn_zipai_shanguangdengguan_n",@"btn_zipai_qianzhi_n",@"btn_zipai_cexiao_n",@"btn_zipai_wancheng_n",@"btn_zipai_paishemoren_n"];
    self.selectArray = @[@"btn_zipai_shanguangdengguan_h",@"btn_zipai_qianzhi_n",@"btn_zipai_cexiao_h",@"btn_zipai_wancheng_h",@"btn_zipai_anxiapaise_h"];
    
    /// 闪光灯
    _button_FlashLight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_FlashLight setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalArray[0]]] forState:UIControlStateNormal];
    [_button_FlashLight setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectArray[0]]] forState:UIControlStateHighlighted];
    _button_FlashLight.tag = 100;
    [_button_FlashLight addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button_FlashLight];
    
    [_button_FlashLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.top.equalTo(smallView.mas_bottom).offset(12);
        make.height.width.mas_equalTo(24);
    }];
    
    /// 前后摄像头
    _button_FrontOrRear_Cameras = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_FrontOrRear_Cameras setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalArray[1]]] forState:UIControlStateNormal];
    [_button_FrontOrRear_Cameras setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectArray[1]]] forState:UIControlStateHighlighted];
    _button_FrontOrRear_Cameras.tag = 101;
    [_button_FrontOrRear_Cameras addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button_FrontOrRear_Cameras];
    
    [_button_FrontOrRear_Cameras mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-35);
        make.centerY.equalTo(_button_FlashLight.mas_centerY);
        make.height.width.mas_equalTo(24);
    }];
    
    // 时长
    CGSize size_ShootLabel = [WX_ToolClass changeSizeWithString:@"60.60 s" FontOfSize:16 bold:ENUM_NormalSystem];
    CGFloat float_Width_ShootLabel = size_ShootLabel.width+10;
    self.shootTimeLabel = [[UILabel alloc]init];
    self.shootTimeLabel.center = CGPointMake(smallView.kwidth/2, smallView.kheight/2);
    self.shootTimeLabel.text = @"0.0 s";
    self.shootTimeLabel.textColor = KUIColorFromRGB(0x767676);
    self.shootTimeLabel.font = [UIFont systemFontOfSize:16];
    self.shootTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.shootTimeLabel];
    
    [_shootTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(smallView.mas_centerX);
        make.centerY.equalTo(_button_FlashLight.mas_centerY);
        make.width.mas_equalTo(float_Width_ShootLabel);
        make.height.mas_equalTo(size_ShootLabel.height);
    }];
    
    
    // 底部按钮
    
    // &&  拍摄按钮 
    self.shootButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shootButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalArray.lastObject]] forState:UIControlStateNormal];
    [self.shootButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectArray.lastObject]] forState:UIControlStateSelected];
    self.shootButton.tag = 103;
    [self.shootButton addTarget:self action:@selector(tapShoot:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPressBtn = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressShoot:)];
    longPressBtn.minimumPressDuration = 0.8f;
    [self.shootButton addGestureRecognizer:longPressBtn];
    [self.view addSubview:self.shootButton];
    
    [_shootButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-27);
        make.width.height.mas_equalTo(@100);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    // 返回
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.flashButton.frame = CGRectMake(screenWidth/2*0.2, (screenHeight-smallView.frame.origin.y-smallView.frame.size.height)*0.45+smallView.frame.origin.y+smallView.frame.size.height, (screenHeight-smallView.frame.origin.y-smallView.frame.size.height)*0.26, (screenHeight-smallView.frame.origin.y-smallView.frame.size.height)*0.26);
    [self.flashButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalArray[2]]] forState:UIControlStateNormal];
    [self.flashButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectArray[2]]] forState:UIControlStateHighlighted];
    self.flashButton.tag = 102;
    self.flashButton.hidden = YES;
    [self.flashButton addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    [_flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(34.5);
        make.width.height.mas_equalTo(@62);
        make.centerY.equalTo(_shootButton.mas_centerY);
    }];
    

    // 导入视频
    // 从剧本合拍跳转进来的不需要此功能
    if (!self.isFromScriptVC) {
        self.button_ImportVideo = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button_ImportVideo setBackgroundImage:[UIImage imageNamed:@"icon_drsp_n"] forState:UIControlStateNormal];
        [self.button_ImportVideo setBackgroundImage:[UIImage imageNamed:@"icon_drsp_h"] forState:UIControlStateHighlighted];
        [self.button_ImportVideo addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
        self.button_ImportVideo.tag = 105;
        [self.view addSubview:self.button_ImportVideo];
        
        [_button_ImportVideo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_flashButton);
        }];
        
    }
    
    // &&  完成
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalArray[3]]] forState:UIControlStateNormal];
    [self.finishButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectArray[3]]] forState:UIControlStateHighlighted];
    self.finishButton.tag = 104;
    self.finishButton.hidden = YES;
    [self.finishButton addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.finishButton];
    
    [_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-34.5);
        make.width.height.mas_equalTo(@62);
        make.centerY.equalTo(_shootButton.mas_centerY);
    }];
    
    
  
}

#pragma mark === 永久闪烁的动画 ======

-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    
    animation.autoreverses = YES;
    
    animation.duration = time;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    return animation;
    
}



#pragma mark -------- 给拍摄按钮 添加动画


-(void)dismiss:(id)sender
{
    if (self.shootButton.selected) {
        
        [self tapShoot:self.shootButton];
    }
    
    self.themeModel.isAddTheme = NO;
    
    self.themeModel.themeStr = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    for (UIViewController *controllers in self.navigationController.viewControllers) {
//        QNWSLog(@"controllers == %@",controllers);
//        if ([controllers isKindOfClass:[BYC_MainTabBarController class]])
//        {
//            [self.navigationController popToViewController:controllers animated:YES];
//        }
//    }

}

-(void)createCamera
{
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset640x480;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    self.currentPosition = [captureDevice position];
    self.toChangePosition=AVCaptureDevicePositionBack;
    if (!captureDevice) {
        QNWSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        QNWSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        QNWSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer=self.backView.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    //[layer addSublayer:_captureVideoPreviewLayer];
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    _enableRotation=YES;
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];

}



-(void)createFMDB
{
    self.manager = [WX_FMDBManager sharedWX_FMDBManager];
    if (![self.manager.dataBase executeUpdate:@"create table if not exists KPieMedia(id integer primary key autoincrement,title text,duration text,createdDate text,imageData text,mediaPath text,albumPath text)"]) {
        QNWSLog(@"数据库---KPieMedia表创建失败");
    }
}

// 进度条 计时器
-(void)progressWithPlayer:(id)sender
{
    
    if (self.playerPgress.progress >=1) {
        // 进度条完成, 计时器停止
        
//        [self.pgressTimer invalidate];
        
        [self.captureMovieFileOutput stopRecording];//停止录制
    }
    if (self.playerPgress.progress > 0.000) {
        self.flashButton.hidden = NO;
    }
    
    if (self.num >= 3.0000) {
        self.flogImgView.hidden = YES;
        self.finishButton.hidden = NO;
    }else{
        self.flogImgView.hidden = NO;
        self.finishButton.hidden = YES;
    }
    
//    QNWSLog(@"KVideoShoot/KVideoShoot/10 == %f",KVideoShoot/KVideoShoot/10);
//    if (self.playerPgress.progress >= KVideoShoot/(KVideoShoot+0.5)/10) {
//        self.flogImgView.hidden = YES;
//        self.finishButton.hidden = NO;
//    }else{
//        self.flogImgView.hidden = NO;
//        self.finishButton.hidden = YES;
//    }
    
    
#if 0
    if (self.pgressValue >= 1) {
        // 进度条完成, 计时器停止
        
        [self.pgressTimer invalidate];
        
        [self.captureMovieFileOutput stopRecording];//停止录制

    }
#endif
    
    
    
}

-(void)clickTheRightButton
{
    QNWSLog(@"新增拍摄完成,进行下一步");
}



//
//
//
//

// 闪光灯 镜头反转
-(void)clickTheButton:(UIButton *)button
{
#pragma mark ------ 闪光灯
    // 闪光灯
    if (button.tag == 100) {
        
//        if (self.currentPosition == AVCaptureDevicePositionFront) {
//            [self flashLightType:NO];
//        }
        
        if (!self.isFlashClick && self.toChangePosition == AVCaptureDevicePositionBack) {
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalArray[button.tag-100]]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_zipai_shanguangdengguan_h"] forState:UIControlStateHighlighted];
            // 闪光灯关闭
            [self flashLightType:NO];
            self.isFlashClick = !self.isFlashClick;
            
        }else if(self.isFlashClick && self.toChangePosition == AVCaptureDevicePositionBack){
            [button setBackgroundImage:[UIImage imageNamed:@"btn_zipai_shanguangdengkai_h"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_zipai_shanguangdengguan_h"] forState:UIControlStateHighlighted];
            // 闪光灯开启
            [self flashLightType:YES];
            self.isFlashClick = !self.isFlashClick;

        }else if(self.isFlashClick && self.toChangePosition == AVCaptureDevicePositionFront){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请使用后置摄像头后,开启闪光灯" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        QNWSLog(@"FlashClick == %d",self.isFlashClick);
    }
    
#pragma mark ------- 前后镜头
    // 镜头
    if (button.tag == 101) {
        
        if (self.shootButton.selected) {
            [self tapShoot:self.shootButton];
        }
        /// 切换前后镜头
        AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
        self.currentPosition=[currentDevice position];
        [self removeNotificationFromCaptureDevice:currentDevice];
        AVCaptureDevice *toChangeDevice;
        self.toChangePosition=AVCaptureDevicePositionFront;
        [self flashLightType:NO];
        if (self.currentPosition==AVCaptureDevicePositionUnspecified|| self.currentPosition==AVCaptureDevicePositionFront) {
            self.toChangePosition=AVCaptureDevicePositionBack;
            
        }
        toChangeDevice=[self getCameraDeviceWithPosition:self.toChangePosition];
        [self addNotificationToCaptureDevice:toChangeDevice];
        //获得要调整的设备输入对象
        AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
        
        //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
        [self.captureSession beginConfiguration];
        //移除原有输入对象
        [self.captureSession removeInput:self.captureDeviceInput];
        //添加新的输入对象
        if ([self.captureSession canAddInput:toChangeDeviceInput]) {
            [self.captureSession addInput:toChangeDeviceInput];
            self.captureDeviceInput=toChangeDeviceInput;
        }
        //提交会话配置
        [self.captureSession commitConfiguration];
        
        if (self.isCameraClick) {

            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectArray[button.tag-100]]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalArray[button.tag-100]]] forState:UIControlStateHighlighted];
            // 反向镜头开启 -- 正面镜头
            QNWSLog(@"反向镜头开启 -- 正面镜头");
            self.flag = 2;
        }else{
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalArray[button.tag-100]]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectArray[button.tag-100]]] forState:UIControlStateHighlighted];
            // 反向镜头关闭 -- 背面镜头
            QNWSLog(@"反向镜头关闭 -- 背面镜头");
            self.flag = 1;
        }
        self.isCameraClick = !self.isCameraClick;
    }
    
#pragma mark --------- 删除按钮
    // 视频 返回按钮
    if (button.tag == 102) {
        // 在数据库中删除
        
        /// 点击手势状态下 按删除按钮
        if (self.shootButton.selected) {
            [self tapShoot:self.shootButton];
        }
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您想要撤销本段视频" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        alter.tag = 200;
        [alter show];
        

        QNWSLog(@"返回上一段拍摄的视频");
    }
 
#pragma mark -------- 视频拍摄
    // 视频 拍摄
    if (button.tag == 103) {
        
         [self.captureMovieFileOutput stopRecording];//停止录制
        
        if (self.num <= KFLOAT_KVideoShoot) {
            self.shootTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(shoot:) userInfo:nil repeats:YES];
            //根据设备输出获得连接
            self.captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            //根据连接取得设备输出的数据
            if (![self.captureMovieFileOutput isRecording]) {
                self.enableRotation=NO;
                //如果支持多任务则则开始多任务
                if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                    self.backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                }
                //预览图层和视频方向保持一致
                self.captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
                
                NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                self.path = [docArray objectAtIndex:0];
                self.mediaPath = [self.path stringByAppendingPathComponent:@"Cache"];
                self.fileManager = [NSFileManager defaultManager];
                [self.fileManager createDirectoryAtPath:self.mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
                
                //获取当前时间，日期
                NSDate *currentDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
                self.dateString = [dateFormatter stringFromDate:currentDate];
                
                // 存入沙盒
                NSString *outputFielPath=[self.mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.dateString]];
                QNWSLog(@"save path is :%@",outputFielPath);
                self.fileUrl=[NSURL fileURLWithPath:outputFielPath];
                QNWSLog(@"fileUrl:%@",self.fileUrl);
                [self.captureMovieFileOutput startRecordingToOutputFileURL:self.fileUrl recordingDelegate:self];
                
                self.mediaFileParh = outputFielPath;
                
            }
            
            WX_ShootModel *shootModel = [[WX_ShootModel alloc]init];
            shootModel.videoDuration = self.num;
            shootModel.videoTitle = self.dateString;
            shootModel.outputFielPath = self.mediaFileParh;
            [self.shootVideoArray addObject:shootModel];
            
            
            
            QNWSLog(@"self.num == %f",self.num);

        }else{
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"视频录制完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
        }
    }
#pragma mark ------- 拍摄完成
    // 视频 完成
    if (button.tag == 104) {
        
        [self.captureMovieFileOutput stopRecording];
        
        if (self.shootButton.selected) {
            [self shootFinish:self.shootButton];
        }
        
        self.isReturn = YES;
        self.shootTimer = nil;
        self.playerPgress.progress = 0.0;
        self.num = 0;
       
        [self transcodingTheMediaWithFFMpegAndInsertDBWithType:1];

    }
    
#pragma mark ------ 点击进入视频导入
    if (button.tag == 105) {
        WX_ShootCViewController *shootVC = [[WX_ShootCViewController alloc]init];
        [self.navigationController pushViewController:shootVC animated:YES];
    }
}

#pragma mark ----------- 点击手势___点击拍摄
-(void)tapShoot:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self clickTheButton:self.shootButton];
    }else if (!button.selected){
        [self shootFinish:self.shootButton];
    }
}
#pragma mark ----------- 长按手势___长按拍摄
-(void)longPressShoot:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.shootButton.selected = YES;
        [self clickTheButton:self.shootButton];
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.shootButton.selected = NO;
        [self shootFinish:self.shootButton];
    }
}
#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    QNWSLog(@"开始录制...");
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    QNWSLog(@"视频录制完成.");

#if 0
    //视频录入完成之后在后台将视频存储到相簿
    self.enableRotation=YES;
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier=self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            QNWSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        }
        QNWSLog(@"outputUrl:%@",outputFileURL);
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
        QNWSLog(@"成功保存视频到相簿.");
    }];
#endif
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 210) {
        
    ///     删除标记
    //      依次遍历self.view中的所有子视图
        for(id tmpView in [self.playerPgress subviews])
        {
            //找到要删除的子视图的对象
            if([tmpView isKindOfClass:[UIImageView class]])
            {
                UIImageView *imgView = (UIImageView *)tmpView;
                
                for (int i = 0; i < self.shootVideoArray.count; i++) {
                    if (imgView.tag == i+1) {                                           //判断是否满足自己要删除的子视图的条件
                        [imgView removeFromSuperview];                                  //删除子视图
                    }
                }
                
            }
        }
        
        [self.shootTimer invalidate];
        
        [self.shootVideoArray removeAllObjects];
        
        if (buttonIndex == 0) {
            self.isReturn = NO;
            self.isPopToRoot = YES;
            self.shootTimer = nil;
            self.playerPgress.progress = 0.0;
            self.num = 0;
            [self transcodingTheMediaWithFFMpegAndInsertDBWithType:1];
            
            
        }
        if (buttonIndex == 1) {
            self.isReturn = NO;
            self.isPopToRoot = NO;
            self.shootTimer = nil;
            self.playerPgress.progress = 0.0;
            self.num = 0;
            self.finishButton.hidden = YES;
            self.flashButton.hidden = YES;
            [self transcodingTheMediaWithFFMpegAndInsertDBWithType:1];
            return;
        }
        if (buttonIndex == 2) {
            self.isReturn = YES;
            self.isPopToRoot = NO;
            self.shootTimer = nil;
            self.playerPgress.progress = 0.0;
            [self transcodingTheMediaWithFFMpegAndInsertDBWithType:1];

            
        }

    }else if (alertView.tag == 200){
        
#pragma mark ------------- 删除操作
        
        if (buttonIndex == 0) {
            
            WX_ShootModel * shootModel = [self.shootVideoArray lastObject];
            
            NSString *delPath=[self.mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",shootModel.videoTitle]];
            BOOL blHave= [self.fileManager fileExistsAtPath:delPath];
            
            
            if (!blHave) {
                QNWSLog(@"no  have");
                
            }else {
                QNWSLog(@" have");
                BOOL blDele= [self.fileManager removeItemAtPath:delPath error:nil];
                if (blDele) {
                    QNWSLog(@"dele success");
                   
                }else {
                    QNWSLog(@"dele fail");
                }
            }
           
            self.shootTimer = nil;
            self.playerPgress.progress = 0.0;
            self.num = 0;
            self.flashButton.hidden = YES;
            self.finishButton.hidden = YES;
            
            //依次遍历self.view中的所有子视图
            for(id tmpView in [self.playerPgress subviews])
            {
                //找到要删除的子视图的对象
                if([tmpView isKindOfClass:[UIImageView class]])
                {
                    UIImageView *imgView = (UIImageView *)tmpView;
                    
                    if (imgView.tag == self.shootVideoArray.count) {                //判断是否满足自己要删除的子视图的条件
                        [imgView removeFromSuperview];          //删除子视图
                        break;                                  //跳出for循环，因为子视图已经找到，无须往下遍历
                    }
                }
            }

            self.playerPgress.progress = shootModel.videoDuration/KFLOAT_KVideoShoot;
            self.num = shootModel.videoDuration;
            NSString *durationStr = [NSString stringWithFormat:@"%.1f",self.num];
            NSArray *durationArray = [durationStr componentsSeparatedByString:@"."];
            self.mediaDuration = [NSString stringWithFormat:@"%@",durationArray[0]];
            [self.shootVideoArray removeObject: [self.shootVideoArray lastObject]];
            WX_ShootModel *nextModel = [self.shootVideoArray lastObject];
            self.mediaFileParh = nextModel.outputFielPath;
            self.mask.frame = CGRectMake(0, 0, self.playerPgress.progress*self.playerPgress.frame.size.width, KFLOAT_KVideoShootProgressHight);
            self.promptImgView.frame = CGRectMake(self.mask.frame.size.width, 0, 5, KFLOAT_KVideoShootProgressHight);
            QNWSLog(@"mediaDuration == %@",self.mediaDuration);
           
             self.shootTimeLabel.text = [NSString stringWithFormat:@"%.1f s",self.num];
            
            if (self.num >= 3.50000) {
                self.flashButton.hidden = NO;
                self.finishButton.hidden = NO;
            }else{
                self.flashButton.hidden = YES;
                self.finishButton.hidden = YES;
            }
            
            [self albumBtnShowOrHidden];

        }
        if (buttonIndex == 1) {
            return;
        }

    }
    
    
}

//
-(void)delayMethod
{
    QNWSLog(@"延迟一秒");
}
/// type  ==    1      异步执行
/// type  ==    2      同步执行
-(void)transcodingTheMediaWithFFMpegAndInsertDBWithType:(NSInteger)type
{
    self.shootButton.selected = NO;

    ///KVO
    self.isTransition = NO;
    
    [self.captureMovieFileOutput stopRecording];
    
  
    [NSThread sleepForTimeInterval:0.35f];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [WX_ProgressHUD show:@"正在转码"];
        
        
        [self StateEnableOrUnableWithChoose:YES];
    });
    
    
    NSString *dataStr = self.dateString;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSString *createDate = [dateFormatter stringFromDate:currentDate];
    
    NSString *duration;
    
    
    duration = [self.mediaDuration integerValue]%60 < 10? [NSString stringWithFormat:@"0%zi:0%zi",[self.mediaDuration integerValue]/60,[self.mediaDuration integerValue]%60] : [NSString stringWithFormat:@"0%zi:%zi",[self.mediaDuration integerValue]/60,[self.mediaDuration integerValue]%60];

    if (type == 1) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *ffPath = [docArray objectAtIndex:0];
            
            NSString *ffmpegPath = [ffPath stringByAppendingPathComponent:@"Media"];
            NSFileManager *ffFilemanager = [NSFileManager defaultManager];
            [ffFilemanager createDirectoryAtPath:ffmpegPath withIntermediateDirectories:YES attributes:nil error:nil];
            self.outPath = [ffmpegPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.dateString]];
            NSURL *outUrl = [NSURL fileURLWithPath:self.outPath];
            QNWSLog(@"outPath == %@",self.outPath);
            QNWSLog(@"self.mediaFileParh == %@",self.mediaFileParh);
            

#pragma mark --- ffmpeg
#if KSimulatorRun
            /// 视频拼接
            NSString *logPath = [self.mediaPath stringByAppendingPathComponent:@"log.txt"];
            NSString *concatFilePath = [self.mediaPath stringByAppendingString:@"/concat.txt"];
            QNWSLog(@"concatFilePath=%@", concatFilePath);
//            NSString *outPath = [self.mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.dateString]];
            NSString *outPath = [self.mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",createDate]];
            QNWSLog(@"outPath=%@",outPath);
            NSArray *filesArray = [self.fileManager subpathsAtPath:self.mediaPath];

            
            ffmpegutils *ffmpeg = [ffmpegutils new];
            ffmpeg.isDebug=YES;
            
            char *clog = (char*)alloca(1024);
            strcpy(clog, [logPath cStringUsingEncoding:NSUTF8StringEncoding]);
            
            ffmpeg.logPath=clog;
            int ret = 1;

            if (filesArray.count > 1) {
                
                NSMutableData *fileArray = [[NSMutableData alloc]init];
                
                for (NSString *Str in filesArray) {
                    NSString *  strPath = [self.mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",Str]];
                    [fileArray appendData:[@"file " dataUsingEncoding:NSUTF8StringEncoding]];
                    [fileArray appendData:[strPath dataUsingEncoding:NSUTF8StringEncoding] ];
                    [fileArray appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
                [fileArray writeToFile:concatFilePath atomically:YES];
                
                
                if ([[NSFileManager alloc] fileExistsAtPath:concatFilePath]) {
                    /// ret == 0  为转换成功
                    ret = [ffmpeg concatVideo:concatFilePath OutTo:outPath];
                    QNWSLog(@"ret = %d", ret);
                } else {
                    QNWSLog(@"拼接格式文件未找到");
                    
                }
            }else if(filesArray.count == 0){
                

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [WX_ProgressHUD show:@"文件拼接有误,请重试"];
                    
                    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(popToRoot) userInfo:nil repeats:NO];
                    
                    
                    
                });
                return ;
                
                
            }
            
            
            /// 视频转码
            if (!ret) {
                /// 视频转码
                int result = [ffmpeg rotationVideo:outPath AndCrop:self.outPath WithFlag:-1];
                if (!result) {
                    QNWSLog(@"视频成功");
                }
            }else{
                /// 视频转码
                int result = [ffmpeg rotationVideo:self.mediaFileParh AndCrop:self.outPath WithFlag:-1];
                if (!result) {
                    QNWSLog(@"视频成功");
                }
            }
            
            // 获取视频对象
            NSURL *playerPath = outUrl;
            NSString *encodeImgStr = [[WX_ToolClass achieveDataWithImage:[WX_ToolClass thumbnailImageForVideo:playerPath atTime:CMTimeMake(0, 10)]] base64EncodedStringWithOptions:0];
            self.script_Replace_ImgData = encodeImgStr;
            self.script_Replace_Duration = duration;
//            QNWSLog(@"duration == %@",duration);
            NSString *albumPath = self.outPath;
            
            if (![self.manager.dataBase executeUpdate:@"insert into KPieMedia(title,duration,createdDate,imageData,mediaPath,albumPath) values(?,?,?,?,?,?)",dataStr,duration,createDate,encodeImgStr,outUrl,albumPath]) {
                QNWSLog(@"视频拍摄数据库信息----- 插入失败");
            }
            self.isTransition = YES;
#endif
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //通知主线程刷新
                if (self.isTransition) {
                    [self transition];
                }
//                [self addObserver:self forKeyPath:@"isTransition" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

            });
            
        });
        
        
    }else{

        NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *ffPath = [docArray objectAtIndex:0];
        
        NSString *ffmpegPath = [ffPath stringByAppendingPathComponent:@"Media"];
        NSFileManager *ffFilemanager = [NSFileManager defaultManager];
        [ffFilemanager createDirectoryAtPath:ffmpegPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        self.outPath = [ffmpegPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.dateString]];
        QNWSLog(@"outPath == %@",self.outPath);
        NSURL *outUrl = [NSURL fileURLWithPath:self.outPath];
        QNWSLog(@"self.mediaFileParh == %@",self.mediaFileParh);
#pragma mark ------ ffmepg
#if KSimulatorRun
        
        /// 视频拼接
        NSString *logPath = [self.mediaPath stringByAppendingPathComponent:@"log.txt"];
        NSString *concatFilePath = [self.mediaPath stringByAppendingString:@"/concat.txt"];
        QNWSLog(@"concatFilePath=%@", concatFilePath);
        NSString *outPath = [self.mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.dateString]];
        QNWSLog(@"outPath=%@",outPath);
        NSArray *filesArray = [self.fileManager subpathsAtPath:self.mediaPath];
        NSMutableData *fileArray = [[NSMutableData alloc]init];
        
        for (NSString *Str in filesArray) {
            NSString *  strPath = [self.mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",Str]];
            [fileArray appendData:[@"file " dataUsingEncoding:NSUTF8StringEncoding]];
            [fileArray appendData:[strPath dataUsingEncoding:NSUTF8StringEncoding] ];
            [fileArray appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [fileArray writeToFile:concatFilePath atomically:YES];
        
        ffmpegutils *ffmpeg = [ffmpegutils new];
//        ffmpeg.isDebug=YES;
        
        char *clog = (char*)alloca(1024);
        strcpy(clog, [logPath cStringUsingEncoding:NSUTF8StringEncoding]);
        
        ffmpeg.logPath=clog;
        int ret = 1;
        if ([[NSFileManager alloc] fileExistsAtPath:concatFilePath]) {
            /// ret == 0  为转换成功
            ret = [ffmpeg concatVideo:concatFilePath OutTo:outPath];
            QNWSLog(@"ret = %d", ret);
        } else {
            QNWSLog(@"拼接格式文件未找到");
            
        }
        
        if (!ret) {
            /// 视频转码
            int result = [ffmpeg rotationVideo:outPath AndCrop:self.outPath WithFlag:-1];
            if (!result) {
                QNWSLog(@"视频成功");
            }
        }else{
            /// 视频转码
            int result = [ffmpeg rotationVideo:self.mediaFileParh AndCrop:self.outPath WithFlag:-1];
            if (!result) {
                QNWSLog(@"视频成功");
            }
            
        }
        
//        /// 视频转码
//        int result = [ffmpeg rotationVideo:self.mediaFileParh AndCrop:self.outPath WithFlag:-1];
//        if (!result) {
//            QNWSLog(@"视频成功");
//        }
     
        // 获取视频对象
        NSURL *playerPath = outUrl;
        QNWSLog(@"playerPath == %@",playerPath);
        NSString *encodeImgStr = [[WX_ToolClass achieveDataWithImage:[WX_ToolClass thumbnailImageForVideo:playerPath atTime:CMTimeMake(0, 10)]] base64EncodedStringWithOptions:0];

        self.script_Replace_ImgData = encodeImgStr;
        self.script_Replace_Duration = duration;
        QNWSLog(@"duration == %@",duration);
         NSString *albumPath = self.outPath;
        if (![self.manager.dataBase executeUpdate:@"insert into KPieMedia(title,duration,createdDate,imageData,mediaPath,albumPath) values(?,?,?,?,?,?)",dataStr,duration,createDate,encodeImgStr,outUrl,albumPath]) {
            QNWSLog(@"视频拍摄数据库信息----- 插入失败");
        }
        
        [self.fileManager removeItemAtPath:self.mediaPath error:nil];
#endif
    }

}

-(void)popToRoot
{
    
    [WX_ProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark ----- 转换完成对应方法
// 转换完成
-(void)transition
{
    if (self.isTransition) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
        QNWSLog(@"转换完啦");
        
        [self.fileManager removeItemAtPath:self.mediaPath error:nil];
        
        [WX_ProgressHUD dismiss];
        
        [self StateEnableOrUnableWithChoose:NO];
        
        if (self.isFromShootVC) {
            WX_ThemeModel *themeModel = [[WX_ThemeModel alloc]init];
            themeModel.themeTitle = self.dateString;
            if (self.block) {
                self.block(themeModel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else if (self.isFromScriptVC){
            WX_ScriptModel *scriptModel = [[WX_ScriptModel alloc]init];
            scriptModel.videoLenArray = [[NSMutableArray alloc]init];
            WX_ScriptInfoModel *infoModel = [[WX_ScriptInfoModel alloc]init];
            
            infoModel.replace_ShootName = self.dateString;
            
            infoModel.replace_ImgData = self.script_Replace_ImgData;
            
            infoModel.replace_ShootDuration = self.script_Replace_Duration;
            
            [scriptModel.videoLenArray addObject:infoModel];
    
            if (self.scriptBlock) {
                self.scriptBlock(scriptModel);
                
                
                
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (self.isReturn){
            
            WX_ShootCViewController *shootVC = [[WX_ShootCViewController alloc]init];
            
            if (self.themeModel.isAddTheme) {
                
                shootVC.themeModel = self.themeModel;
                shootVC.themeModel.themeTitle = self.dateString;
            }
            QNWSLog(@"shootVC.themeModel.themeStr == %@",shootVC.themeModel.themeStr);
            [self.navigationController pushViewController:shootVC animated:YES];
            
        }else if (self.isPopToRoot){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }

}

#pragma maek ----------- 改变按钮状态
-(void)StateEnableOrUnableWithChoose:(BOOL)choose
{
    if (!self.coverView) {
        self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.coverView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.coverView];
    }
    if (choose) {
        [self.view bringSubviewToFront:self.coverView];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    }else{
        [self.view sendSubviewToBack:self.coverView];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }
}


-(void)shoot:(id)sender
{
    self.num += self.shootTimer.timeInterval;
    self.shootTimeLabel.text = [NSString stringWithFormat:@"%.1f s",self.num];
//    QNWSLog(@"timer == %f",self.num);
    
    [self.playerPgress setProgress:self.num/KFLOAT_KVideoShoot animated:YES];
    self.mask.frame = CGRectMake(0, 0, self.playerPgress.progress*self.playerPgress.frame.size.width +5, KFLOAT_KVideoShootProgressHight);
    self.promptImgView.frame = CGRectMake(self.playerPgress.progress*self.playerPgress.frame.size.width, 0, 5, KFLOAT_KVideoShootProgressHight);
    
    if (self.num >= KFLOAT_KVideoShoot) {
        
        [self shootFinish:self.shootButton];
    }
    
    [self albumBtnShowOrHidden];
    
}

#pragma mark ----- 添加图片 按钮隐藏与显示
// 显示与隐藏添加图片按钮
-(void)albumBtnShowOrHidden
{
    if (!self.isFromScriptVC) {
        if(self.num > 0){
            self.button_ImportVideo.hidden = YES;
        }else{
            self.button_ImportVideo.hidden = NO;
            
        }
    }
}


// 定时器 取消
-(void)shootFinish:(UIButton *)button
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.num/KFLOAT_KVideoShoot*self.playerPgress.frame.size.width, 0, 2, KFLOAT_KVideoShootProgressHight)];
    imgView.backgroundColor = [UIColor blackColor];
    imgView.tag = self.shootVideoArray.count;
    [self.playerPgress addSubview:imgView];
    
    if (self.num >= 3.00000 && self.num < KFLOAT_KVideoShoot) {
        
        NSString *durationStr = [NSString stringWithFormat:@"%.1f",self.num];
        NSArray *durationArray = [durationStr componentsSeparatedByString:@"."];
        self.mediaDuration = [NSString stringWithFormat:@"%@",durationArray[0]];
        QNWSLog(@"self.mediaDuration == %@",self.mediaDuration);
        [self.captureMovieFileOutput stopRecording];//停止录制

    }else if(self.num <= 3.00000){
        
        self.mediaDuration = [NSString stringWithFormat:@"%.0f",self.num];
        [self.captureMovieFileOutput stopRecording];//停止录制
        
    }else if (self.num >= KFLOAT_KVideoShoot){
        
        self.mediaDuration = [NSString stringWithFormat:@"%.0f",self.num];
        
        if (self.shootButton.selected) {
            self.shootButton.selected = NO;
        }
        
        [self.captureMovieFileOutput stopRecording];
 
    }
    
    [self.shootTimer invalidate];
    

}

-(void)clearTheCacheFile
{
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:@"Cache"];
    self.fileManager = [NSFileManager defaultManager];
    [self.fileManager removeItemAtPath:cachePath error:nil];
}





-(void)flashLightType:(BOOL)isOpen
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([self.device hasTorch]) {
        [self.device lockForConfiguration:nil];
     
    }
    if (isOpen) {
        [self.device setTorchMode: AVCaptureTorchModeOn];
        [self.device unlockForConfiguration];

    }else {
        [self.device setTorchMode: AVCaptureTorchModeOff];
        [self.device unlockForConfiguration];
        
    }
}



///**
// 屏幕熄灭,暂停
// */
//-(void)NotificationLock
//{
//    self.shootButton.selected       =   NO;
//    [self shootFinish:self.shootButton];
//}

#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    
    //捕获区域发生改变
    [QNWSNotificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    
    [QNWSNotificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    
    [QNWSNotificationCenter removeObserver:self];

}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    
    //会话出错
    [QNWSNotificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    QNWSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    QNWSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    QNWSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    QNWSLog(@"会话发生错误.");
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        QNWSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.backView addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.backView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:0.35 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
    QNWSLog(@"point.x == %f,point.y == %f",point.x,point.y);
}

-(UIImageView *)focusCursor
{
    if (_focusCursor == nil) {
        _focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _focusCursor.image = [UIImage imageNamed:@"img-jj"];
        _focusCursor.alpha = 0;
        [_backView addSubview:_focusCursor];
    }
    return _focusCursor;
    
}

-(void)dealloc
{
    [self.captureSession stopRunning];
    QNWSLog(@"相机镜头停止啦");
}


@end
