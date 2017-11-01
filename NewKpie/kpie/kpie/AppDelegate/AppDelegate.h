//
//  AppDelegate.h
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_UMengShareTool.h"
#import "BYC_NetworkMonitoringHandler.h"
#import "BYC_AppDelegateHandler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    @public
    //是否有远程推送通知
    NSDictionary *_pushNotificationKey;
    NSMutableData *_data_Skin; // 皮肤数据
}

@property (strong, nonatomic) UIWindow *window;

@end

