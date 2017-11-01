//
//  AppDelegate.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
/**
 _ooOoo_
 o8888888o
 88" . "88
 (| -_- |)
 O\ = /O
 ____/`---'\____
 .   ' \\| |// `.
 / \\||| : |||// \
 / _||||| -:- |||||- \
 | | \\\ - /// | |
 | \_| ''\---/'' | |
 \ .-\__ `-` ___/-. /
 ___`. .' /--.--\ `. . __
 ."" '< `.___\_<|>_/___.' >'"".
 | | : `- \`.;`\ _ /`;.`/ - ` : | |
 \ \ `-. \_ __\ /__ _/ .-` / /
 ======`-.____`-.___\_____/___.-`____.-'======
 `=---='
 
 .............................................
 佛祖保佑            永无BUG
 佛曰:
 写字楼里写字间，写字间里程序员；
 程序人员写程序，又拿程序换酒钱。
 酒醒只在网上坐，酒醉还来网下眠；
 酒醉酒醒日复日，网上网下年复年。
 但愿老死电脑间，不愿鞠躬老板前；
 奔驰宝马贵者趣，公交自行程序员。
 别人笑我忒疯癫，我笑自己命太贱；
 不见满街漂亮妹，哪个归得程序员？
 
 
 
 ━━━━━━神兽出没━━━━━━
 Code is far away from bug with the animal protecting神兽保佑,代码无bug
 　　　┏┓　　　┏┓
 　　┏┛┻━━━┛┻┓
 　　┃　　　　　　　┃
 　　┃　　　━　　　┃
 　　┃　┳┛　┗┳　┃
 　　┃　　　　　　　┃
 　　┃　　　┻　　　┃
 　　┃　　　　　　　┃
 　　┗━┓　　　┏━┛
 　　　　┃　　　┃
 　　　　┃　　　┃
 　　　　┃　　　┗━━━┓
 　　　　┃　　　　　　　┣┓
 　　　　┃　　　　　　　┏┛
 　　　　┗┓┓┏━┳┓┏┛
 　　　　　┃┫┫　┃┫┫
 　　　　　┗┻┛　┗┻┛
 
 ━━━━━━感觉萌萌哒━━━━━━
 Code is far away from bug with the animal protecting神兽保佑,代码无bug
 　　　　　　　　┏┓　　　┏┓
 　　　　　　　┏┛┻━━━┛┻┓
 　　　　　　　┃　　　　　　　┃
 　　　　　　　┃　　　━　　　┃
 　　　　　　　┃　＞　　　＜　┃
 　　　　　　　┃　　　　　　　┃
 　　　　　　　┃...　⌒　...　┃
 　　　　　　　┃　　　　　　　┃
 　　　　　　　┗━┓　　　┏━┛
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┗━━━┓
 　　　　　　　　　┃　　　　　　　┣┓
 　　　　　　　　　┃　　　　　　　┏┛
 　　　　　　　　　┗┓┓┏━┳┓┏┛
 　　　　　　　　　　┃┫┫　┃┫┫
 　　　　　　　　　　┗┻┛　┗┻┛
 Code is far away from bug with the animal protecting神兽保佑,代码无bug
 　　　　　　　　┏┓　　　┏┓+ +
 　　　　　　　┏┛┻━━━┛┻┓ + +
 　　　　　　　┃　　　　　　　┃
 　　　　　　　┃　　　━　　　┃ ++ + + +
 　　　　　　 ████━████ ┃+
 　　　　　　　┃　　　　　　　┃ +
 　　　　　　　┃　　　┻　　　┃
 　　　　　　　┃　　　　　　　┃ + +
 　　　　　　　┗━┓　　　┏━┛
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┃ + + + +
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┃ +
 　　　　　　　　　┃　　　┃
 　　　　　　　　　┃　　　┃　　+
 　　　　　　　　　┃　 　　┗━━━┓ + +
 　　　　　　　　　┃ 　　　　　　　┣┓
 　　　　　　　　　┃ 　　　　　　　┏┛
 　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 　　　　　　　　　　┃┫┫　┃┫┫
 　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */


#import "AppDelegate.h"
#import "AppDelegate+BYC_DidFinishLaunchingMethod.h"
#import "UMessage.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+BYC_RemoteNotificationsHandle.h"
#import <TencentOpenAPI/TencentOAuth.h>
#endif


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
       result = [TencentOAuth HandleOpenURL:url];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        result =[TencentOAuth HandleOpenURL:url];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == FALSE) {
       result = [TencentOAuth HandleOpenURL:url];
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    QNWSUserDefaultsSetObjectForKey(pushToken, KSTR_KDeviceToken);//登陆注册的时候需要带Devicetoken
    [QNWSUserDefaults synchronize];
    [UMessage registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
    
        QNWSLog(@"我是前台打开的哟");
        [self excNotification:userInfo State:ENUM_RemoteNotificationsStateActive];
        
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
    
        [self excNotification:userInfo State:ENUM_RemoteNotificationsStateInactive];
        QNWSLog(@"我是后台打开的哟");
    }
    
    
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self excNotification:userInfo State:ENUM_RemoteNotificationsStateActive];
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    [self excNotification:userInfo State:ENUM_RemoteNotificationsStateInactive];
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
    
}
#endif
@end
