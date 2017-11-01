//
//  BYC_HttpServers+HL_PersonalVC.m
//  kpie
//
//  Created by sunheli on 16/10/14.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_PersonalVC.h"

@implementation BYC_HttpServers (HL_PersonalVC)

+(void)requestPersonalVCDataWithParameters:(NSDictionary *)parameters success:(void (^)(BYC_MyCenterHandler *handler))success failure:(void (^)(NSError *error))failure{
    [BYC_HttpServers Post:KQNWS_GetUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *data_Dic = (NSDictionary *)responseObject[@"data"];
        BYC_MyCenterHandler *handler = [BYC_MyCenterHandler new];
        
        handler.handler_Fans.mArr_Models  = [BYC_AccountModel initModelsWithArrayDic:data_Dic[@"FansUserData"]];
        handler.handler_Focus.mArr_Models = [BYC_AccountModel initModelsWithArrayDic:data_Dic[@"FocusUserData"]];
        handler.handler_Works.mArr_Models = [BYC_BaseVideoModel initModelsWithArrayDic:data_Dic[@"UserVideoData"]];
        handler.model_User                = [BYC_AccountModel initModelWithDictionary:data_Dic[@"Users"]];
        QNWSBlockSafe(success,handler);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
    
}

+(void)requestVideosWithDeleteParames:(id)parames success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure{
    
    [BYC_HttpServers Get:KQNWS_DeletePhoneVideo parameters:parames success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] isEqualToNumber:@1]) {
            
            QNWSBlockSafe(success,YES);
        }
        else QNWSBlockSafe(success,NO);
    [[UIView alloc] showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
}

@end
