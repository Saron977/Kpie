//
//  BYC_HttpServers+BYC_BaseRequset.h
//  kpie
//
//  Created by 元朝 on 16/10/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"

@interface BYC_HttpServers (BYC_BaseRequset)

/**请求是post，且只要求成功回调，不需要回调特别的参数接口适用。*/
+ (void)requestCommonDontDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//+ (void)requestNormalDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, ...))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure exeBlock:(NSArray *(^)(id responseObject))exeBlock;
@end
