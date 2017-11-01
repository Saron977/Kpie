//
//  BYC_HttpServers+HL_ForgetPassWordVC.h
//  kpie
//
//  Created by sunheli on 16/11/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"

@interface BYC_HttpServers (HL_ForgetPassWordVC)

+ (void)requestForgetPassWordWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
