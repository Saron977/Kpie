//
//  BYC_HttpServers+HL_ForgetPassWordVC.m
//  kpie
//
//  Created by sunheli on 16/11/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_ForgetPassWordVC.h"

@implementation BYC_HttpServers (HL_ForgetPassWordVC)

+ (void)requestForgetPassWordWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [BYC_HttpServers Post:KQNWS_ForgetPasswordUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QNWSBlockSafe(success,operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,operation,error);
    }];
}

@end
