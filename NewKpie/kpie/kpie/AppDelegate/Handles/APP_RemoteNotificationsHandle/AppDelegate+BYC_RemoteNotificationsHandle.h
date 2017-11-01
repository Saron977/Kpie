//
//  AppDelegate+BYC_RemoteNotificationsHandle.h
//  kpie
//
//  Created by 元朝 on 2016/12/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "AppDelegate.h"

typedef NS_ENUM(NSUInteger, ENUM_RemoteNotificationsState) {
    ENUM_RemoteNotificationsStateActive,//前台
    ENUM_RemoteNotificationsStateInactive,//后台或者iOS10自己点击通知进入
};

typedef NS_ENUM(NSInteger, ENUM_GoType) {
    ENUM_GoType_System  =   0,      /**<   跳转类型_系统 */
    ENUM_GoType_Video   =   1,      /*<    跳转类型_视频 **/
    ENUM_GoType_Column  =   2,      /*<    跳转类型_栏目 **/
    ENUM_GoType_Script  =   3,      /*<    跳转类型_剧本合拍 **/
    ENUM_GoType_InStep  =   4,      /*<    跳转类型_视频合拍 **/
    ENUM_GoType_WebView =   5,      /*<    跳转类型_网址 **/
};/*<  友盟推送_跳转类型 **/

@interface AppDelegate (BYC_RemoteNotificationsHandle)

- (void)excNotification:(NSDictionary *)userInfo State:(ENUM_RemoteNotificationsState)state;
@end
