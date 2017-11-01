//
//  BYC_HttpServers+WX_GeekVC.m
//  kpie
//
//  Created by 王傲擎 on 16/7/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+WX_GeekVC.h"

@implementation BYC_HttpServers (WX_GeekVC)

/// 添加关注
+ (void)requestGeekVCSaveFriendsUserWithParameters:(NSDictionary *)parameters success:(void (^)(NSInteger result))success failure:(void (^)(NSError *error))failure
{
    [BYC_HttpServers Post:KQNWS_SaveFriendsUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger result = [(NSNumber*)responseObject[@"result"] integerValue];
        QNWSBlockSafe(success,result);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        QNWSBlockSafe(failure,error);

    }];
//    
//    [BYC_HttpServers Post:KQNWS_SaveFriendsUserUrl parameters:parameters success:^(id responseObject) {
//        NSInteger result = [(NSNumber*)responseObject[@"result"] integerValue];
//        QNWSBlockSafe(success,result);
//        
//    } failure:^(NSError *error) {
//        QNWSBlockSafe(failure,error);
//        
//    }];
}

///取消关注
+ (void)requestGeekVCRemoveFriendsUserWithParameters:(NSDictionary *)parameters success:(void (^)(NSInteger result))success failure:(void (^)(NSError *error))failure
{

    [BYC_HttpServers Post:KQNWS_RemoveFriendsUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger result = [(NSNumber*)responseObject[@"result"] integerValue];
        QNWSBlockSafe(success,result);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        QNWSBlockSafe(failure,error);
    }];
//    [BYC_HttpServers Post:KQNWS_RemoveFriendsUserUrl parameters:parameters success:^(id responseObject) {
//        NSInteger result = [(NSNumber*)responseObject[@"result"] integerValue];
//        QNWSBlockSafe(success,result);
//        
//    } failure:^(NSError *error) {
//        QNWSBlockSafe(failure,error);
//        
//    }];
}

/// 添加喜欢,点赞
+(void)requestGeekVCSaveUserFavoritesWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{

    [BYC_HttpServers Post:KQNWS_SaveUserFavorites parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSInteger result = [(NSNumber*)responseObject[@"result"] integerValue];
        if (result == 0) {
            NSArray *array_Result = [responseObject[@"rows"] firstObject];
            QNWSBlockSafe(success,array_Result);
            
        }else{
            QNWSBlockSafe(success,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(success,nil);

    }];
    
//    [BYC_HttpServers Post:KQNWS_SaveUserFavorites parameters:parameters success:^(id responseObject) {
//        NSInteger result = [(NSNumber*)responseObject[@"result"] integerValue];
//        if (result == 0) {
//            NSArray *array_Result = [responseObject[@"rows"] firstObject];
//            QNWSBlockSafe(success,array_Result);
//            
//        }else{
//            QNWSBlockSafe(success,nil);
//        }
//        
//    } failure:^(NSError *error) {
//        QNWSBlockSafe(failure,error);
//        
//    }];

}

/// 取消喜欢,点赞
+(void)requestGeekVCRemoveUserFavoritesWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [BYC_HttpServers Post:KQNWS_RemoveUserFavorites parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger result = [(NSNumber*)responseObject[@"result"] integerValue];
        if (result == 0) {
            NSArray *array_Result = [responseObject[@"rows"] firstObject];
            QNWSBlockSafe(success,array_Result);
            
        }else{
            QNWSBlockSafe(success,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        QNWSBlockSafe(failure,error);

    }];
//    
//    [BYC_HttpServers Post:KQNWS_RemoveUserFavorites parameters:parameters success:^(id responseObject) {
//        NSInteger result = [(NSNumber*)responseObject[@"result"] integerValue];
//        if (result == 0) {
//            NSArray *array_Result = [responseObject[@"rows"] firstObject];
//            QNWSBlockSafe(success,array_Result);
//
//        }else{
//            QNWSBlockSafe(success,nil);
//        }
//        
//    } failure:^(NSError *error) {
//        QNWSBlockSafe(failure,error);
//        
//    }];
}
@end
