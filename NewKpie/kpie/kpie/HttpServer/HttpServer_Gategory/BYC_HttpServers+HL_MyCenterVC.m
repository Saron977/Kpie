
//
//  BYC_HttpServers+HL_MyCenterVC.m
//  kpie
//
//  Created by sunheli on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_MyCenterVC.h"

@implementation BYC_HttpServers (HL_MyCenterVC)
+ (void)requestPersonalVCUserInfoWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_HomeViewControllerModel *> *arr_Models))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_GetUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        NSArray *arrayRows = dictionary[@"user"];
        if (arrayRows.count > 0) {
            
            NSMutableArray *userInfoModels = [NSMutableArray array];
            for (NSArray *arrayModel in arrayRows) {
                
                BYC_HomeViewControllerModel *model = [BYC_HomeViewControllerModel initModelWithArray:arrayModel];
                [userInfoModels addObject:model];
            }
            QNWSBlockSafe(success,userInfoModels);
        }else QNWSBlockSafe(success,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
    
}

+ (void)requestPersonalVCWokrsWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_HomeViewControllerModel *> *arr_Models))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_GetMineVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        NSArray *arrayRows = dictionary[@"rows"];
        if (arrayRows.count > 0) {
            
            NSMutableArray *userInfoModels = [NSMutableArray array];
            for (NSArray *arrayModel in arrayRows) {
                
                BYC_HomeViewControllerModel *model = [BYC_HomeViewControllerModel initModelWithArray:arrayModel];
                [userInfoModels addObject:model];
            }
            QNWSBlockSafe(success,userInfoModels);
        }else QNWSBlockSafe(success,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
    
}

+ (void)requestPersonalVCForwardWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_HomeViewControllerModel *> *arr_Models))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_GetUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        NSArray *arrayRows = dictionary[@"rows"];
        if (arrayRows.count > 0) {
            
            NSMutableArray *userInfoModels = [NSMutableArray array];
            for (NSArray *arrayModel in arrayRows) {
                
                BYC_HomeViewControllerModel *model = [BYC_HomeViewControllerModel initModelWithArray:arrayModel];
                [userInfoModels addObject:model];
            }
            QNWSBlockSafe(success,userInfoModels);
        }else QNWSBlockSafe(success,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
    
}

+ (void)requestPersonalVCFollowWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_FocusAndFansModel *> *arr_Models))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_GetFocusUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        NSArray *arrayRows = dictionary[@"rows"];
        if (arrayRows.count > 0) {
            
            NSMutableArray *userInfoModels = [NSMutableArray array];
            for (NSArray *arrayModel in arrayRows) {
                
                BYC_FocusAndFansModel *model = [BYC_FocusAndFansModel initModelWithArray:arrayModel];
                [userInfoModels addObject:model];
            }
            QNWSBlockSafe(success,userInfoModels);
        }else QNWSBlockSafe(success,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
    
}

+ (void)requestPersonalVCFansWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray <BYC_FocusAndFansModel *> *arr_Models))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_GetFansUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        NSArray *arrayRows = dictionary[@"rows"];
        if (arrayRows.count > 0) {
            
            NSMutableArray *userInfoModels = [NSMutableArray array];
            for (NSArray *arrayModel in arrayRows) {
                
                BYC_FocusAndFansModel *model = [BYC_FocusAndFansModel initModelWithArray:arrayModel];
                [userInfoModels addObject:model];
            }
            QNWSBlockSafe(success,userInfoModels);
        }else QNWSBlockSafe(success,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
    
}

@end
