//
//  BYC_HttpServers+BYC_Settings.h
//  kpie
//
//  Created by 元朝 on 16/10/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_MyLevelModel.h"
#import "BYC_UpgradeStatusModel.h"
#import "BYC_UpgradeDescriptionModel.h"

@interface BYC_HttpServers (BYC_Settings)

/**
 *  发送post使用反馈
 *
 *  @param parameters           请求的参数字典
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestUsingFeedbackDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  我的等级
 *
 *  @param parameters           请求的参数字典
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestMyLevelDataWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray <NSArray <BYC_MyLevelModel *> *> *arr_Models, BYC_UpgradeStatusModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  等级说明
 *
 *  @param parameters           请求的参数字典
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestUpgradeDescriptionDataWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray <BYC_UpgradeDescriptionModel *> *arr_Models))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  完善个人资料
 *
 *  @param parameters           请求的参数字典
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestSaveUserInfoDataWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
