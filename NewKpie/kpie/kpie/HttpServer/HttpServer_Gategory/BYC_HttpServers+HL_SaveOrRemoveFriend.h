//
//  BYC_HttpServers+HL_SaveOrRemoveFriend.h
//  kpie
//
//  Created by sunheli on 16/10/24.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"

@interface BYC_HttpServers (HL_SaveOrRemoveFriend)


/**
 添加关注

 @param parameters 差数 userId/touserid
 @param success
 @param failure
 */
+(void)requestSaveFriendWithParameters:(id)parameters success:(void (^)(BOOL isSaveSuccess))success failure:(void (^)(NSError *error))failure;


/**
 取消关注

 @param parameters 差数 userId/touserid
 @param success
 @param failure
 */
+(void)requestRemoveFriendWithParameters:(id)parameters success:(void (^)(BOOL isRemoveSuccess))success failure:(void (^)(NSError *error))failure;



/**
 拉黑

 @param parameters 差数   /userid/touserid/type 0移除 1拉黑
 @param success
 @param failure    
 */
+(void)requestBlackWithParameters:(id)parameters success:(void (^)(BOOL isBlackSuccess))success failure:(void (^)(NSError *error))failure;


@end
