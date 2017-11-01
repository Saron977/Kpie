//
//  BYC_HttpServers+BYC_MotifData.h
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_BaseChannelModels.h"
#import "BYC_MotifModel.h"
#import "BYC_BaseChannelColumnModel.h"

@interface BYC_HttpServers (BYC_MotifData)

/**
 *  首页频道、发现社区、发现活动接口请求路径
 *
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestMotifDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray <BYC_MotifModel *> *arr_MotifModels, BYC_BaseChannelModels *models))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
