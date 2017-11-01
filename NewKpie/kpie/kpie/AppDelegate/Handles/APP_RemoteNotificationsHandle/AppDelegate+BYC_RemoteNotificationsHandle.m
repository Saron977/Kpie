//
//  AppDelegate+BYC_RemoteNotificationsHandle.m
//  kpie
//
//  Created by 元朝 on 2016/12/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

static NSString * const AppDelegate_PushMsg    = @"PushMsg";
static NSString * const AppDelegate_GoType     = @"go_type";
static NSString * const AppDelegate_ResID      = @"res_id";

#import "AppDelegate+BYC_RemoteNotificationsHandle.h"
#import "BYC_BackHomeVC.h"
#import "BYC_JumpToVCHandler.h"
#import "BYC_LeftMassegeViewController.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_HttpServers+WX_VideoPushRequest.h"
#import "BYC_HttpServers+HL_VideoPlayVC.h"
#import "BYC_JumpToVCHandler.h"



@interface AppDelegate()<UIAlertViewDelegate>
@end

@implementation AppDelegate (BYC_RemoteNotificationsHandle)

- (void)excNotification:(NSDictionary *)userInfo State:(ENUM_RemoteNotificationsState)state{
    
    if (QNWSDictionaryObjectForKey(userInfo, AppDelegate_GoType) && QNWSDictionaryObjectForKey(userInfo, AppDelegate_ResID) && state == ENUM_RemoteNotificationsStateInactive) {
        ENUM_GoType goType = 0;
        switch ([userInfo[AppDelegate_GoType] integerValue]) {
            case 0:
                // 系统
            {
                goType   = ENUM_GoType_System;
            }
                break;
            case 1:
                // 视频
            {
                goType   = ENUM_GoType_Video;
            }
                break;
            case 2:
                // 栏目
            {
                goType   = ENUM_GoType_Column;
            }
                break;
            case 3:
                // 剧本合拍
            {
                goType   = ENUM_GoType_Script;
            }
                break;
            case 4:
                // 视频合拍
            {
                goType   = ENUM_GoType_InStep;
            }
                break;
            case 5:
                // 网址
            {
                goType   = ENUM_GoType_WebView;
            }
                break;
                
            default:
                break;
        }
        [self WX_NotificationOpenWithUseInfo:userInfo Type:goType];

    }

    if ([userInfo[AppDelegate_PushMsg] isEqualToString:KSTR_KComment]) {//消息小红点标识
        QNWSUserDefaultsSetValueForKey(@1, KSTR_KMsgAndNotRed);
        if (state == ENUM_RemoteNotificationsStateActive) {
            [QNWSNotificationCenter postNotificationName:KNotification_Comment object:nil];
        }
        else if (state == ENUM_RemoteNotificationsStateInactive){
            
          [self openMassageOrNotification:NO];
        }
        
        
    
    }
    
    if ([userInfo[AppDelegate_PushMsg] isEqualToString:KSTR_KNeedTeacher]) {//名师点评
        QNWSUserDefaultsSetValueForKey(@1, KSTR_KMsgAndNotRed);
    if (state == ENUM_RemoteNotificationsStateActive) {
        [QNWSNotificationCenter postNotificationName:KNotification_TeacherComments object:nil];
    }
    else if (state == ENUM_RemoteNotificationsStateInactive){
        [self openMassageOrNotification:YES];
    }

    }
    
    if ([userInfo[AppDelegate_PushMsg] isEqualToString:KSTR_KNeedLogout]) {//顶号
        

        [BYC_BackHomeVC cleanUserInfoAndBackHomeVC];
    }
    
    //积分推送标识
    if ([userInfo[AppDelegate_PushMsg] isEqualToString:KSTR_KUserfavoritessave])
        [[UIView alloc] showAndHideHUDWithTitle:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] WithState:BYC_MBProgressHUDHideProgress];
    
    
    //红点
    if ([userInfo[AppDelegate_PushMsg] isEqualToString:KSTR_KShowActivityRed]) {
    
        if (state == ENUM_RemoteNotificationsStateActive) {
           
            //其实可以动态给tabBar上的所以button添加红点，根据后台传参动态设置，后台不是我写，此功能没实现。
           

            /*代码奔溃，我也奔溃 NSDictionary lenght未识别报错。我不懂，怎么两种Alert都包这钟错误。待查，先不弹提示了吧啊。阿西吧。。。
            if ([[UIDevice currentDevice].systemVersion intValue] < 10) {
            
                 @try {÷
                 [[[UIAlertView alloc] initWithTitle: @"有新的活动"
                 message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                 delegate:self
                 cancelButtonTitle:@"稍后再看"
                 otherButtonTitles:@"去瞧瞧", nil] show];
                 } @catch (NSException *exception) {
                 QNWSShowException(exception);
                 } @finally {
                 
                 }

                 UIAlertController *alertController = [UIAlertController new];
                 alertController.title = @"有新的活动";
                 alertController.message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                 [alertController addAction: [UIAlertAction actionWithTitle:@"稍后再看" style:UIAlertActionStyleCancel handler:nil]];
                 
                 [alertController addAction: [UIAlertAction actionWithTitle:@"去瞧瞧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
                 [QNWSNotificationCenter postNotificationName:KNotification_HideTabBarButtonRed object:nil userInfo:@{@"tag":@1}];
                 [self exeOpenActivePage:[userInfo objectForKey:@"column"]];
                 }]];
                 
                 
                 
                 @try {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 
                 //presentViewController:alertController会崩溃。
                 [KMainTabBarVC.viewControllers[KMainTabBarVC.selectedIndex] presentViewController:alertController animated:YES completion:nil];
                 });
                 } @catch (NSException *exception) {
                 QNWSShowException(exception);
                 } @finally {
                 }
            }
                 */

//            }



            [QNWSNotificationCenter postNotificationName:KNotification_ShowTabBarButtonRed object:nil userInfo:@{@"tag":@1}];
            
        }else if (state == ENUM_RemoteNotificationsStateInactive) {
        
            [self exeOpenActivePage:[userInfo objectForKey:@"column"]];
        }
        
    }
}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    if (buttonIndex == 0) {
//        
//    }else {
//    
//        
//    }
//}

/// 选择推送类型
- (void)WX_NotificationOpenWithUseInfo:(NSDictionary*)userInfo Type:(ENUM_GoType)goType
{
    switch (goType) {
        case ENUM_GoType_Video:
            /// 跳转到视频播放
        {
            [self exeOpenVideoPageWithVideoID:userInfo[AppDelegate_ResID] ENUM_VideoType:ENUM_VideoType_NormalVideo];
        }
            break;
        case ENUM_GoType_Column:
            /// 跳转到栏目
        {
            [self exeOpenActivePage:userInfo[AppDelegate_ResID]];
        }
            break;
        case ENUM_GoType_Script:
            /// 跳转到剧本
        {
            [self exeOpenVideoPageWithVideoID:userInfo[AppDelegate_ResID] ENUM_VideoType:ENUM_VideoType_Scripte];
        }
            break;
        case ENUM_GoType_InStep:
            /// 跳转到合拍
        {
            [self exeOpenVideoPageWithVideoID:userInfo[AppDelegate_ResID] ENUM_VideoType:ENUM_VideoType_JoinShooting];
        }
            break;
            
        case ENUM_GoType_WebView:
            /// 跳转到网页
        {
            [BYC_JumpToVCHandler jumpToWebWithUrl:userInfo[AppDelegate_ResID]];
        }
            break;
            
        default:
            break;
    }

}

/// 跳转到活动
- (void)exeOpenActivePage:(NSString *)activeID {

    [QNWSNotificationCenter postNotificationName:KNotification_HideTabBarButtonRed object:nil userInfo:@{@"tag":@1}];
    [BYC_JumpToVCHandler jumpToColumnWithColumnId:activeID];
}

/// 跳转到视频__视频播放/剧本合拍
- (void)exeOpenVideoPageWithVideoID:(NSString*)videoID ENUM_VideoType:(ENUM_VideoType)videoType
{
    [BYC_HttpServers WX_RequestVideoPushWithVideoID:@[videoID] ENUM_PushType:videoType == ENUM_VideoType_Scripte ? ENUM_VideoPushType_Script:ENUM_VideoPushType_Video success:^(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *video_Model) {

        [HL_JumpToVideoPlayVC jumpToVCWithModel:video_Model[0]
                                   andVideoTepy:videoType andisComment:videoType == ENUM_VideoType_JoinShooting ?NO:YES
                                    andFromType:ENU_FromOtherVideo];
        [QNWSNotificationCenter postNotificationName:KNotification_HideTabBarButtonRed object:nil userInfo:@{@"tag":@1}];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)openMassageOrNotification:(BOOL)isNotification{
    [QNWSNotificationCenter postNotificationName:KNotification_HideRedPoint object:nil];
    BYC_LeftMassegeViewController *massageVC = [[BYC_LeftMassegeViewController alloc]init];
    massageVC.isFrmeRemoteNotification = isNotification;
    [KMainNavigationVC pushViewController:massageVC animated:YES];
}

@end
