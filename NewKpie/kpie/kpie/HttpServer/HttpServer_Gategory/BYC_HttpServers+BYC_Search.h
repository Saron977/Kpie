//
//  BYC_HttpServers+BYC_Search.h
//  kpie
//
//  Created by 元朝 on 16/10/23.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_MyCenterHandler.h"

@class BYC_BaseVideoModel;

@interface BYC_HttpServers (BYC_Search)

/**
 *  关键字相关提示
 */
+ (void)requestSearchListDataWithParameters:(NSArray *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray *arr))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户数据
 */

+ (void)requestSearchUserListDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray<BYC_AccountModel *> *arrModels, NSInteger total))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)requestSearchUserHandelListDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_MyCenterHandler *handler, NSInteger total))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  视频数据
 */
+ (void)requestSearchVideoListDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *arrModels, NSInteger total))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
