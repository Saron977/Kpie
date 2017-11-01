//
//  BYC_HttpServers+BYC_MyCenterVC.m
//  kpie
//
//  Created by 元朝 on 16/9/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+BYC_MyCenterVC.h"
#import "BYC_FocusAndFansModel.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_MyCenterUserModel.h"

@implementation BYC_HttpServers (BYC_MyCenterVC)

+ (void)requestMyCenterDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_MyCenterHandler *handler))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers Post:KQNWS_GetUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *data_Dic = (NSDictionary *)responseObject[@"data"];
        BYC_MyCenterHandler *handler      = [BYC_MyCenterHandler new];
        handler.handler_Focus.mArr_Models = [BYC_FocusAndFansModel initModelsWithArrayDic:data_Dic[@"FocusUserData"]];
        handler.handler_Works.mArr_Models = [BYC_BaseVideoModel initModelsWithArrayDic:data_Dic[@"UserVideoData"]];
        handler.handler_Fans.mArr_Models  = [BYC_FocusAndFansModel initModelsWithArrayDic:data_Dic[@"FansUserData"]];
        handler.model_CurrentUser         = [BYC_AccountModel initModelWithDictionary:data_Dic[@"Users"]];
        QNWSBlockSafe(success, operation, handler);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIView alloc] showAndHideHUDWithTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress];
        QNWSBlockSafe(failure, operation, error);
    }];
}

@end
