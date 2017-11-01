//
//  AppDelegate+BYC_BYC_DidFinishLaunchingMethod.m
//  kpie
//
//  Created by 元朝 on 16/6/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "AppDelegate+BYC_DidFinishLaunchingMethod.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "BYC_HttpServerSelectViewController.h"
#import "UncaughtExceptionHandler.h"
#import "BYC_NetworkMonitoringHandler.h"
#import "BYC_CheckUpdate.h"
#import "BYC_ThirdLoginBindingPhoneNumHandler.h"
#import "AppDelegate+BYC_RemoteNotificationsHandle.h"

#define NotificationLock CFSTR("com.apple.springboard.lockcomplete")
#define NotificationChange CFSTR("com.apple.springboard.lockstate")
#define NotificationPwdUI CFSTR("com.apple.springboard.hasBlankedScreen")

static BYC_AppDelegateHandler *_handlerAppDelegate;
static NSDictionary *S_LaunchOptions;

@implementation AppDelegate (BYC_DidFinishLaunchingMethod)

#pragma mark --1.Appdelegate Method
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    {//网络处理
        
        [BYC_NetworkMonitoringHandler networkMonitoringHandler];
    }
    
    {//友盟
        //配置分享
        [BYC_UMengShareTool setShareAppIDAndAppKey];
        //配置推送
        [BYC_UMengShareTool setPushAppIDAndAppKeyWithApplication:application LaunchOptions:launchOptions];
        //配置友盟统计
        [BYC_UMengShareTool setUMStatistics];
    }
    {// QQ
        //配置分享_登录
        [WX_TencentTool WX_SetTencentToolQQIDAndAppKey];
        
    }
    {//异常总处理
#ifdef DEBUG // 调试异常情况
#else

        InstallUncaughtExceptionHandler();
#endif
        
    }
    
    {// 百度地图
        
        // com.WXX.QNWS.Kpie    ----            K0j3aldINyWx6AnVg1ZrMmT2
        // com.QNWS.Kpie        ----            UBcHGHevMXzNPURVgBvyjg7Q
        BMKMapManager *manager = [[BMKMapManager alloc]init];
        //通过key来启动百度服务.key如果有问题,地图就无法显示
        [manager start:@"UBcHGHevMXzNPURVgBvyjg7Q" generalDelegate:nil];
    }
    
    _handlerAppDelegate = [BYC_AppDelegateHandler appDelegateHandler:self];
    
    {//注册通知
    
        S_LaunchOptions = launchOptions;
        [self setupRegisterNotification];
    }

    
    [self selectHttpServer:^{

         [_handlerAppDelegate loadRootViewController];
    }];
    
    
//    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationLock, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
//    
//    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationChange, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    
    return YES;
}

//static void screenLockStateChanged(CFNotificationCenterRef center,void* observer,CFStringRef name,const void* object,CFDictionaryRef userInfo){
//    
//    NSString* lockstate = (__bridge NSString*)name;
//    
//    if ([lockstate isEqualToString:(__bridge  NSString*)NotificationLock]) {
//        
//        QNWSLog(@"locked.锁屏");
//        [QNWSNotificationCenter postNotificationName:@"NotificationLock" object:nil];
//        
//    }else{
//        QNWSLog(@"状态改变了");
//        [QNWSNotificationCenter postNotificationName:@"NotificationLock" object:nil];
//    }
//}

- (void)setupRegisterNotification {
    
    [QNWSNotificationCenter addObserverForName:KNotification_AppDidOpen object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        {//检测版本更新
            
            [BYC_CheckUpdate checkUpdate];
        }
        
        {//第三方登录未绑定手机号，需要弹窗绑定
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                [BYC_ThirdLoginBindingPhoneNumHandler exeDorpAlertView:[BYC_AccountTool userAccount]];
            });
        }
        if (S_LaunchOptions) {
            
            
            _pushNotificationKey = [S_LaunchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if (_pushNotificationKey) {
                
                [self excNotification:_pushNotificationKey State:ENUM_RemoteNotificationsStateInactive];
            }
        }
    }];
}

/**
 *  选择服务器
 */
- (void)selectHttpServer:(void(^)())complete {
    
#ifdef DEBUG //调试模式
    
    BYC_HttpServerSelectViewController *httpVC = [[BYC_HttpServerSelectViewController alloc] init];
    
    httpVC.makeSure = ^(){
        
        complete();
    };
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:httpVC];
    self.window.rootViewController = navigationController;
    
#else //发布
    complete();
    
#endif
}
@end
