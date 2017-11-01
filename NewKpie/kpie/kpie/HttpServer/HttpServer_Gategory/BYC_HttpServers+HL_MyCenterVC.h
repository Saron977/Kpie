//
//  BYC_HttpServers+HL_MyCenterVC.h
//  kpie
//
//  Created by sunheli on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_FocusAndFansModel.h"
#import "HL_PersonalModel.h"

@interface BYC_HttpServers (HL_MyCenterVC)

/**
 *  个人信息
 */
+ (void)requestPersonalVCUserInfoWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_HomeViewControllerModel *> *arr_Models))success failure:(void (^)(NSError *error))failure;

/**
 *  作品
 */
+ (void)requestPersonalVCWokrsWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_HomeViewControllerModel *> *arr_Models))success failure:(void (^)(NSError *error))failure;

/**
 *  转发
 */
+ (void)requestPersonalVCForwardWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_HomeViewControllerModel *> *arr_Models))success failure:(void (^)(NSError *error))failure;

/**
 *  关注
 */
+ (void)requestPersonalVCFollowWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_FocusAndFansModel *> *arr_Models))success failure:(void (^)(NSError *error))failure;

/**
 *  粉丝
 */
+ (void)requestPersonalVCFansWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_FocusAndFansModel *> *arr_Models))success failure:(void (^)(NSError *error))failure;


@end
