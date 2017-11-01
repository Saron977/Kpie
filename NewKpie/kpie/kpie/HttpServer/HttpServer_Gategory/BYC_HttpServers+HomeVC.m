//
//  BYC_HttpServers+HomeVC.m
//  kpie
//
//  Created by 元朝 on 16/7/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HomeVC.h"
#import "AFHTTPRequestOperationManager.h"


@implementation BYC_HttpServers (HomeVC)

+ (void)requestHomeVCAusleseDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_AusleseVCModels *models))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    [BYC_HttpServers Post:KQNWS_GetHomeEliteDataMotif parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BYC_AusleseVCModels *models = [[BYC_AusleseVCModels alloc] init];
        NSDictionary *dictionary    = (NSDictionary *)responseObject[@"data"];
        models.arr_MotifModels      = [BYC_MotifModel initModelsWithArrayDic:dictionary[@"HomeMotifData"]];
        models.arr_BannerModels     = [BYC_BaseVideoModel initModelsWithArrayDic:dictionary[@"HomeBarEliteData"]];
        models.arr_RecommendModels  = [BYC_BaseVideoModel initModelsWithArrayDic:dictionary[@"HomeKpieEliteData"]];
        models.arr_VideoModels      = [BYC_BaseVideoModel initModelsWithArrayDic:dictionary[@"HomeSelectData"]];
        QNWSBlockSafe(success, operation,models);

    } failure:failure];
}


@end
