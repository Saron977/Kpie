//
//  BYC_HttpServers+BYC_Settings.m
//  kpie
//
//  Created by 元朝 on 16/10/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+BYC_Settings.h"
#import "BYC_HttpServers+BYC_BaseRequset.h"

@implementation BYC_HttpServers (BYC_Settings)

+ (void)requestUsingFeedbackDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers requestCommonDontDataWithUrl:KQNWS_SaveUserFeedbackUrl parameters:parameters success:success failure:failure];
}

+ (void)requestMyLevelDataWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray <NSArray <BYC_MyLevelModel *> *> *arr_Models, BYC_UpgradeStatusModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    [BYC_HttpServers Get:KQNWS_GetMyLevel parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSMutableArray *m_Arr = [NSMutableArray array];
            [m_Arr addObject:[BYC_MyLevelModel initModelsWithArrayDic:responseObject[@"data"][@"basic"]]];
            [m_Arr addObject:[BYC_MyLevelModel initModelsWithArrayDic:responseObject[@"data"][@"grow"]]];
            [m_Arr addObject:[BYC_MyLevelModel initModelsWithArrayDic:responseObject[@"data"][@"novice"]]];
            BYC_UpgradeStatusModel *model = [BYC_UpgradeStatusModel initModelWithDictionary:responseObject[@"data"][@"level"][0]];
            QNWSBlockSafe(success, operation, m_Arr, model);

    } failure:failure];
}

+ (void)requestUpgradeDescriptionDataWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray <BYC_UpgradeDescriptionModel *> *arr_Models))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers Get:KQNWS_GetUpgradeDescription parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

       QNWSBlockSafe(success, operation, [BYC_UpgradeDescriptionModel initModelsWithArrayDic:responseObject[@"data"]]);

    } failure:failure];
}


+ (void)requestSaveUserInfoDataWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers requestCommonDontDataWithUrl:KQNWS_SaveUserInfoUrl parameters:parameters success:success failure:failure];
}

@end
