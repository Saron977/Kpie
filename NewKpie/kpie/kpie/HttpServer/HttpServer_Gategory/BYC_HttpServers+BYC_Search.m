//
//  BYC_HttpServers+BYC_Search.m
//  kpie
//
//  Created by 元朝 on 16/10/23.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+BYC_Search.h"
#import "BYC_BaseVideoModel.h"

@implementation BYC_HttpServers (BYC_Search)

+ (void)requestSearchListDataWithParameters:(NSArray *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray *arr))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers Get:KQNWS_GetUVMatchVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        NSDictionary *arr_TempResult = responseObject[@"data"];
        NSArray *arr_NickName        = arr_TempResult[@"NickName"];
        NSArray *arr_VideoTitle      = arr_TempResult[@"VideoTitle"];
        
        for (NSDictionary *dic in arr_NickName) [mArr addObject:dic[@"nickname"]];
        for (NSDictionary *dic in arr_VideoTitle) [mArr addObject:dic[@"videotitle"]];
        QNWSBlockSafe(success, operation, mArr);
        
    } failure:failure];
}

+ (void)requestSearchUserListDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray<BYC_AccountModel *> *arrModels, NSInteger total))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers Post:KQNWS_GetMatchUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = [BYC_AccountModel initModelsWithArrayDic:responseObject[@"data"]];
        QNWSBlockSafe(success, operation, arr, 0);
    } failure:failure];
}

+ (void)requestSearchUserHandelListDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_MyCenterHandler *handler, NSInteger total))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    [BYC_HttpServers Post:KQNWS_GetMatchUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BYC_MyCenterHandler *handler = [BYC_MyCenterHandler new];
        handler.handler_Focus.mArr_Models = [BYC_AccountModel initModelsWithArrayDic:responseObject[@"data"]];
        QNWSBlockSafe(success, operation, handler, 0);
    } failure:failure];
}

+ (void)requestSearchVideoListDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *arrModels, NSInteger total))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    [BYC_HttpServers Post:KQNWS_GetMatchVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = [BYC_BaseVideoModel initModelsWithArrayDic:responseObject[@"data"]];
        QNWSBlockSafe(success, operation, arr, 0);

    } failure:failure];
}
@end
