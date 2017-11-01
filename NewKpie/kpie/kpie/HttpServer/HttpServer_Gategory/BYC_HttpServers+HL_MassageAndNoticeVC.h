//
//  BYC_HttpServers+HL_MassageAndNoticeVC.h
//  kpie
//
//  Created by sunheli on 16/10/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_LeftNotificationModel.h"

@interface BYC_HttpServers (HL_MassageAndNoticeVC)

/**
 我的消息

 @param parameters {"upType":0,"userId":"8af4bf094e96bbe6014e99f20321000c"}
 @param success
 @param failure
 */
+(void)requestMassageDataWithParameters:(id)parameters success:(void (^)(NSMutableArray<BYC_LeftMassegeModel *> *arr_massageModel)) success failure:(void (^)(NSError *error))failure;


/**
 我的消息已读

 @param parameters userid
 @param success
 @param failure
 */
+(void)requestMassageReadDataWithParameters:(id)parameters success:(void (^)(BOOL isReadSuccess)) success failure:(void (^)(NSError *error))failure;

/**
 我的通知

private Integer userType = 0;

 @param parameters 当前登录用户编号--userId 类型--upType 创建--createDate 用户的类型--userType
 @param success
 @param failure
 */
+(void)requestNotificationDataWithParameters:(id)parameters success:(void (^)(NSMutableArray<BYC_LeftNotificationModel *> *arr_massageModel)) success failure:(void (^)(NSError *error))failure;


/**
 我的通知已读

 @param parameters 友盟token
 @param success
 @param failure    
 */
+(void)requestNotificationReadDataWithParameters:(id)parameters success:(void (^)(BOOL isReadSuccess)) success failure:(void (^)(NSError *error))failure;




@end
