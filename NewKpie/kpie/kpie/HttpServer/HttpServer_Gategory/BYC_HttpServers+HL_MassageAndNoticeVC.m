//
//  BYC_HttpServers+HL_MassageAndNoticeVC.m
//  kpie
//
//  Created by sunheli on 16/10/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_MassageAndNoticeVC.h"

@implementation BYC_HttpServers (HL_MassageAndNoticeVC)

+(void)requestMassageDataWithParameters:(id)parameters success:(void (^)(NSMutableArray<BYC_LeftMassegeModel *> *arr_massageModel))success failure:(void (^)(NSError *))failure{
    
    [BYC_HttpServers Post:KQNWS_GetMineList1UserCommentsUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr_massageModel = responseObject[@"data"];
        NSMutableArray *massageModels = [NSMutableArray array];
        [arr_massageModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BYC_LeftMassegeModel *model = [BYC_LeftMassegeModel initModelWithDictionary:obj];
            [massageModels addObject:model];
        }];
        QNWSBlockSafe(success,massageModels);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
}

+(void)requestNotificationDataWithParameters:(id)parameters success:(void (^)(NSMutableArray<BYC_LeftNotificationModel *> *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    /// 添加设备类别
    // channel _0 iOS  _1 Android
    [dic setObject:@"0" forKey:@"channel"];
    [BYC_HttpServers Post:KQNWS_GetListCast1PushMsgUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr_notificationModel = responseObject[@"data"];
        NSMutableArray *notificationModels = [NSMutableArray array];
        [arr_notificationModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BYC_LeftNotificationModel *model = [BYC_LeftNotificationModel initModelWithDictionary:obj];
            [notificationModels addObject:model];
        }];
        QNWSBlockSafe(success,notificationModels);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
}

+(void)requestMassageReadDataWithParameters:(id)parameters success:(void (^)(BOOL isReadSuccess))success failure:(void (^)(NSError *))failure{
    [BYC_HttpServers Get:KQNWS_ModifyStateUserCommentsUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [[UIView alloc]showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
}

+(void)requestNotificationReadDataWithParameters:(id)parameters success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure{
    [BYC_HttpServers Get:KQNWS_GetListCast1PushMsgReadUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [[UIView alloc]showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];

}





@end
