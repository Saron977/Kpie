//
//  BYC_HttpServers+HL_LikedVideoVC.m
//  kpie
//
//  Created by sunheli on 16/10/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_LikedVideoVC.h"

@implementation BYC_HttpServers (HL_LikedVideoVC)

+ (void)requestLikedVideoVCDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, HL_LikedVideoModel *likedVideoModel))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [BYC_HttpServers Post:KQNWS_GetListUserFavoritesUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr_LikedVideoModels = (NSArray *)responseObject[@"data"];
        HL_LikedVideoModel *likeVideoModel = [[HL_LikedVideoModel alloc]init];
        likeVideoModel.array_LikedVideoModel = [BYC_BaseVideoModel initModelsWithArrayDic:arr_LikedVideoModels];
        QNWSBlockSafe(success,operation,likeVideoModel);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         QNWSBlockSafe(failure,operation,error);
    }];

}

@end
