//
//  BYC_HttpServers+HL_TagVC.m
//  kpie
//
//  Created by sunheli on 17/1/22.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_TagVC.h"

@implementation BYC_HttpServers (HL_TagVC)

+ (void)requestTagVCVideosWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *themeVideos))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [BYC_HttpServers Post:KQNWS_VideoThemeUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr_Videos = [NSArray array];
        arr_Videos = [BYC_BaseVideoModel initModelsWithArrayDic:responseObject[@"data"]];
        QNWSBlockSafe(success,operation,arr_Videos);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
