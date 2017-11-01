    //
//  BYC_HttpServers+FocusVC.m
//  kpie
//
//  Created by sunheli on 16/7/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+FocusVC.h"
#import "HL_LikeModel.h"


@implementation BYC_HttpServers (FocusVC)

+(void)requestFocusVCFocusListWithParameters:(NSDictionary *)parameters success:(void (^)(HL_FocusArrModel *focusModels))success failure:(void (^)(NSError *))failure{
        
    [BYC_HttpServers Post:KQNWS_GetFriendsJsonArrayList2VideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *data_arr = (NSArray *)responseObject[@"data"];
        HL_FocusArrModel *focusModels = [[HL_FocusArrModel alloc]init];
        focusModels.arr_FocusList = [BYC_BaseVideoModel initModelsWithArrayDic:data_arr];

        QNWSBlockSafe(success,focusModels);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];
}

/**
 *  添加喜欢  / 取消喜欢
 */
+(void)requestFocusVCSaveUserFavoritesWithParameters:(NSArray *)parameters andWithType:(NSInteger)type success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_SaveUserFavorites parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] isEqualToNumber:@1]) {
            QNWSBlockSafe(success,YES);
        }
        else{
            [[UIView alloc] showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress];
        } 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];

}

+(void)requestAddFriendVCDataWithParameters:(NSDictionary *)parameters success:(void (^)(BYC_MyCenterHandler *handler))success failure:(void (^)(NSError *error))failure{
    [BYC_HttpServers Post:KQNWS_GetMayFriendUser parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        BYC_MyCenterHandler *handler      = [BYC_MyCenterHandler new];
        handler.handler_Focus.mArr_Models = [BYC_AccountModel initModelsWithArrayDic:responseObject[@"data"]];
        QNWSBlockSafe(success, handler);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

@end
