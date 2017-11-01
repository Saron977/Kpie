//
//  BYC_HttpServers+BYC_MyCenterVC.h
//  kpie
//
//  Created by 元朝 on 16/9/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_MyCenterHandler.h"

@interface BYC_HttpServers (BYC_MyCenterVC)

+ (void)requestMyCenterDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_MyCenterHandler *handler))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
