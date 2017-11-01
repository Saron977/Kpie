//
//  BYC_HttpServerManager.h
//  kpie
//
//  Created by 元朝 on 16/6/6.
//  Copyright © 2016年 QNWS. All rights reserved.
// 全局属性管理类

#import <Foundation/Foundation.h>

/**服务器IP地址*/
extern NSString const * QNWS_Main_HostIP;

@interface BYC_PropertyManager : NSObject
QNWSSingleton_interface(BYC_PropertyManager)

/**YES:短信验证*/
@property (nonatomic, assign) BOOL     isMessageVerification;
@end