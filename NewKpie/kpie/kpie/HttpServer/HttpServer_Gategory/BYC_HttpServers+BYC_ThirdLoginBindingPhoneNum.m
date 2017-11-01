//
//  BYC_HttpServers+BYC_ThirdLoginBindingPhoneNum.m
//  kpie
//
//  Created by 元朝 on 16/11/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+BYC_ThirdLoginBindingPhoneNum.h"

@implementation BYC_HttpServers (BYC_ThirdLoginBindingPhoneNum)

+ (void)requestThirdLoginBindingPhoneNumWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers Get:KQNWS_UserInfo_Contact parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [QNWSView showAndHideHUDWithTitle:@"绑定成功" WithState:0 completion:^(BOOL finished) {
            QNWSBlockSafe(success,operation);
        }];
        
    } failure:failure];
}

@end
