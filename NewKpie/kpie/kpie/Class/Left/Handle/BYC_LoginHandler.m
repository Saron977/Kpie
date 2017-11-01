//
//  BYC_LoginHandler.m
//  kpie
//
//  Created by 元朝 on 16/10/31.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_LoginHandler.h"
#import "BYC_HttpServers+BYC_Account.h"
#import "BYC_ThirdLoginBindingPhoneNumHandler.h"

@implementation BYC_LoginHandler

+ (void)requestDataWithParameters:(id)parameters type:(BOOL)isThird success:(void (^)(AFHTTPRequestOperation *operation, BYC_AccountModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    QNWSShowHUD(@"正在努力登录中...",1);
    [BYC_HttpServers requestLoginAccountDataIsThird:isThird parameters:parameters success:^(AFHTTPRequestOperation *operation, BYC_AccountModel *model) {
        
            //把账户模型归档
            [BYC_AccountTool saveAccount:model];
            [QNWSView showAndHideHUDWithTitle:@"登录成功" WithState:0 completion:^(BOOL finished) {
                
                if (!isThird) {
                    
                    QNWSUserDefaultsSetObjectForKey(parameters[@"cellphonenumber"], KSTR_KLoginDefaultPhoneNum);
                    [QNWSUserDefaults synchronize];
                }else
                    [BYC_ThirdLoginBindingPhoneNumHandler exeDorpAlertView:model];

                QNWSBlockSafe(success,operation,model);
            }];
    } failure:failure];
}
@end
