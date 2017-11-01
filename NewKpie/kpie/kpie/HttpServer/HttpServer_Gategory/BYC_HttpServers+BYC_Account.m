//
//  BYC_HttpServers+BYC_Account.m
//  kpie
//
//  Created by 元朝 on 16/10/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+BYC_Account.h"
#import "BYC_AccountModel.h"
#import "BYC_HttpServers+BYC_BaseRequset.h"

@implementation BYC_HttpServers (BYC_Account)

+ (void)requestLoginAccountDataIsThird:(BOOL)isThird parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_AccountModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self requestLoginAndRegisterAccountDataWithUrl:isThird ? KQNWS_WQWThirdLoginUserUrl : KQNWS_Login1UserUrl parameters:parameters success:success failure:failure];
}

+ (void)requestRegisterAccountDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_AccountModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self requestLoginAndRegisterAccountDataWithUrl:KQNWS_RegisterUserUrl parameters:parameters success:success failure:failure];
}

+ (void)requestLoginAndRegisterAccountDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_AccountModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    [BYC_HttpServers Post:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BYC_AccountModel *model = [BYC_AccountModel initModelWithDictionary:(NSDictionary *)responseObject[@"data"]];
        
        if (!model) {
            [[UIView alloc] hideHUDWithTitle:@"请求失败，请重新尝试！" WithState:BYC_MBProgressHUDHideProgress];
            return;
        }
        
        QNWSBlockSafe(success, operation,model);
    } failure:failure];
}

+ (void)requestChangePassWordDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    [BYC_HttpServers requestCommonDontDataWithUrl:KQNWS_ModifyPasswordUserUrl parameters:parameters success:success failure:failure];
}

+ (void)requestSendSmsDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers requestCommonDontDataWithUrl:KQNWS_SendSmsUrl parameters:parameters success:success failure:failure];
}

+ (void)requestLogoutSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    if ([BYC_AccountTool userAccount].userid) {
        
        [BYC_HttpServers Get:KQNWS_LogoutUrl parameters:@[[BYC_AccountTool userAccount].userid] success:success failure:failure];
    }

}
@end
