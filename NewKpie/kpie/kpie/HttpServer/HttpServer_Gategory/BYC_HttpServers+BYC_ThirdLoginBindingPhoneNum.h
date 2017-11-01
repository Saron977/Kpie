//
//  BYC_HttpServers+BYC_ThirdLoginBindingPhoneNum.h
//  kpie
//
//  Created by 元朝 on 16/11/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"

@interface BYC_HttpServers (BYC_ThirdLoginBindingPhoneNum)

+ (void)requestThirdLoginBindingPhoneNumWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
