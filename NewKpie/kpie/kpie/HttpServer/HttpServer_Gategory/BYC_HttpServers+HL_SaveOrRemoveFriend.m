//
//  BYC_HttpServers+HL_SaveOrRemoveFriend.m
//  kpie
//
//  Created by sunheli on 16/10/24.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_SaveOrRemoveFriend.h"

@implementation BYC_HttpServers (HL_SaveOrRemoveFriend)

+(void)requestSaveFriendWithParameters:(id)parameters success:(void (^)(BOOL isSaveSuccess))success failure:(void (^)(NSError *error))failure{
    [BYC_HttpServers Get:KQNWS_SaveFriendsUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"添加关注====%@===",responseObject[@"success"]);
        if ([responseObject[@"success"] isEqualToNumber:@1]) {
            QNWSBlockSafe(success,YES);
        }
        else{
            QNWSBlockSafe(success,NO);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
    
}

+(void)requestRemoveFriendWithParameters:(id)parameters success:(void (^)(BOOL isRemoveSuccess))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_RemoveFriendsUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSLog(@"取消关注====%@===",responseObject[@"success"]);
        if ([responseObject[@"success"] isEqualToNumber:@1]) {
            QNWSBlockSafe(success,YES);
        }
        else{
            QNWSBlockSafe(success,NO);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
}

+(void)requestBlackWithParameters:(id)parameters success:(void (^)(BOOL isBlackSuccess))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_UpdateBlackListUserUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] isEqualToNumber:@1]) {
            QNWSBlockSafe(success,YES);
        }
        else{
            QNWSBlockSafe(success,NO);
        }
        [[UIView alloc] showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
}

@end
