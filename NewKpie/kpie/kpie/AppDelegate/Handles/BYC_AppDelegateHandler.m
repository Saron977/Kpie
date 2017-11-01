//
//  BYC_AppDelegateHandler.m
//  kpie
//
//  Created by 元朝 on 16/9/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AppDelegateHandler.h"
#import "BYC_MainNavigationController.h"
#import "BYC_FirstViewController.h"
#import "BYC_PersonalDataViewController.h"
#import "BYC_AccountTool.h"
#import "BYC_SetBackgroundColor.h"
#import "BYC_LeftMassegeViewController.h"
#import "BYC_MainTabBarController.h"
#import "BYC_LeftViewController.h"
#import "SSZipArchive.h"
#import "BYC_NetworkMonitoringHandler.h"
#import "AppDelegate.h"
#import "BYC_RequestADHandler.h"
#import "BYC_NewVersionsHandler.h"

//皮肤zip文件路径
#define DicTempSkinZipPath [NSTemporaryDirectory() stringByAppendingPathComponent:@"ThemePictures/SkinPictrue.zip"]
//皮肤图片资源路径
#define DicCacheSkinZipPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"ThemePictures"]

@interface BYC_AppDelegateHandler ()

/***/
@property (nonatomic, strong)  BYC_RequestADHandler  *handler_AD;
/***/
@property (nonatomic, strong)  AppDelegate  *appDelegate;
/**广告数据*/
@property (nonatomic, strong)  BYC_ADModel  *model_AD;

@end

@implementation BYC_AppDelegateHandler

+ (instancetype)appDelegateHandler:(AppDelegate *)appDelegate {

    BYC_AppDelegateHandler *mySelf = [BYC_AppDelegateHandler new];
    mySelf.appDelegate = appDelegate;
    return mySelf;
}

/**
 *  打开app
 */
- (void)loadRootViewController {
    
    //判断是否第一次开启应用 没有的情况下存个值 添加引导页
    NSString *string_OldVersionNum = QNWSUserDefaultsObjectForKey(KSTR_FIRST_OPEN_OldAPPLICATION_KEY);
    NSString *string_NewVersionNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!QNWSUserDefaultsObjectForKey(KSTR_FIRST_OPEN_APPLICATION_KEY) || ![string_OldVersionNum isEqualToString:string_NewVersionNum]) {
        
        [BYC_NewVersionsHandler exeNewVersionsHandle];
        // 添加引导页
        BYC_FirstViewController *guidPageControl = [[BYC_FirstViewController alloc]init];
        guidPageControl.delegate                 = self;
        guidPageControl.onStartClick             = @selector(initRootViewController);
        _appDelegate.window.rootViewController           = guidPageControl;
    } else {
        
        _handler_AD = [BYC_RequestADHandler requestADHandlerWithBlock:^(BYC_ADModel *model){
            
            if (model) _model_AD = model;
            [self openApp];
        }];
        // 获取皮肤数据
//        [self skinFromNet];
    }
}

// 皮肤获取
-(void)skinFromNet
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"1" forKey:@"skin.type"];
    [BYC_HttpServers Get:KQNWS_GetListSkin parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"total"] intValue] > 0) {
            
            NSArray *arraySkin = responseObject[@"rows"];
            if (arraySkin.count > 0) {//有数据代表有活动
                
                //之前没有下载皮肤资源
                if (![[NSFileManager defaultManager] fileExistsAtPath:DicCacheSkinZipPath])
                    [self downloadZip:responseObject[@"rows"][0]];
            }else {//没有数据代表活动结束，那就必须移除所有皮肤资源
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:DicTempSkinZipPath])
                    [[NSFileManager defaultManager] removeItemAtPath:DicTempSkinZipPath error:nil];
                if ([[NSFileManager defaultManager] fileExistsAtPath:DicCacheSkinZipPath])
                    [[NSFileManager defaultManager] removeItemAtPath:DicCacheSkinZipPath error:nil];
            }
            
            [QNWSNotificationCenter postNotificationName:KNotification_ReloadImage object:nil];
            
        }
    } failure:nil];
    
}

- (void)downloadZip:(NSString *)downLoadAddress {
    
    NSURL    *url = [NSURL URLWithString:downLoadAddress];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSURLConnection *newConnection = [[NSURLConnection alloc]
                                      initWithRequest:request
                                      delegate:self
                                      startImmediately:YES];
#pragma clang diagnostic pop
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if (!_appDelegate -> _data_Skin)_appDelegate -> _data_Skin = [[NSMutableData alloc] init];;
    [_appDelegate -> _data_Skin appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    /* 下载的数据 */
    //缓存到temp目录下
    NSString *temp      = NSTemporaryDirectory();
    temp                = [temp stringByAppendingPathComponent:@"ThemePictures"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:temp])
        [[NSFileManager defaultManager] createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:nil];
    if ([_appDelegate -> _data_Skin writeToFile:DicTempSkinZipPath atomically:YES])[self unZipFile];
}

//解压ZIP
- (void)unZipFile {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:DicTempSkinZipPath]) {
        
        NSString *destinationPath       = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        destinationPath                 = [destinationPath stringByAppendingPathComponent:@"ThemePictures"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        //解压成功
        if ([SSZipArchive unzipFileAtPath:DicTempSkinZipPath toDestination:DicCacheSkinZipPath])
            [QNWSNotificationCenter postNotificationName:KNotification_ReloadImage object:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_appDelegate -> _data_Skin setLength:0];
}


- (void)openApp {
    
    BYC_AccountModel *userModel = [BYC_AccountTool userAccount];
    if (userModel.userid.length == 0  || userModel.headportrait.length > 0) {//userInfo信息不为空或者未登录

        // 加载首页的试图控制器
        //初始化MMDrawer
        [self initRootViewController];
        
    }else {//userInfo信息为空需要强制性的继续完善个人资料

#pragma mark 调试好所有接口之后再打开
        BYC_PersonalDataViewController *personalDataVC = [[BYC_PersonalDataViewController alloc] init];
        BYC_BaseNavigationController   *baseNav = [[BYC_BaseNavigationController alloc] initWithRootViewController:personalDataVC];
        personalDataVC.isStarOpenApp = YES;
        personalDataVC.delegate = self;
        personalDataVC.onStartClick = @selector(initRootViewController);
        personalDataVC.title = @"完善个人资料";
        _appDelegate.window.rootViewController = baseNav;
    }
}

- (void)initRootViewController {
    
    BYC_MainTabBarController * centerViewController = [[BYC_MainTabBarController alloc] init];
    centerViewController.model_AD = _model_AD;
    //判断是否第一次开启应用 没有的情况下存个值 添加引导页
    NSString *string_OldVersionNum = QNWSUserDefaultsObjectForKey(KSTR_FIRST_OPEN_OldAPPLICATION_KEY);
    NSString *string_NewVersionNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!QNWSUserDefaultsObjectForKey(KSTR_FIRST_OPEN_APPLICATION_KEY) || ![string_OldVersionNum isEqualToString:string_NewVersionNum]) {
        QNWSUserDefaultsSetObjectForKey(@"1", KSTR_FIRST_OPEN_APPLICATION_KEY);
        NSString *string_NewVersionNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        QNWSUserDefaultsSetObjectForKey(string_NewVersionNum, KSTR_FIRST_OPEN_OldAPPLICATION_KEY);
        [QNWSUserDefaults synchronize];// 存盘
    }
    
    KMainNavigationVC.navigationBarHidden = YES;
    [KMainNavigationVC addChildViewController:centerViewController];

    _appDelegate.window.rootViewController = KMainNavigationVC;
    //延迟1s在通知
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QNWSNotificationCenter postNotificationName:KNotification_AppDidOpen object:nil];
    });
}
@end
