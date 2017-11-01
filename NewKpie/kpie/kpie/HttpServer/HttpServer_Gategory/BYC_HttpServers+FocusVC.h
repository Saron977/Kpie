//
//  BYC_HttpServers+FocusVC.h
//  kpie
//
//  Created by sunheli on 16/7/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "HL_FocusArrModel.h"
#import "BYC_BackFocusListCellModel.h"
#import "BYC_MyCenterHandler.h"

@interface BYC_HttpServers (FocusVC)

/**
 *  获取动态数据列表
 */
+ (void)requestFocusVCFocusListWithParameters:(NSDictionary *)parameters success:(void (^)(HL_FocusArrModel *focusModels))success failure:(void (^)(NSError *error))failure;

/**
 *  添加喜欢
 */
+(void)requestFocusVCSaveUserFavoritesWithParameters:(NSArray *)parameters andWithType:(NSInteger)type success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;


/**
 推荐关注

 @param parameters {"upType":2,"userId":"8af4bf094e96bbe6014e99f20321000c","videos":0}
 @param success    
 @param failure
 */
+(void)requestAddFriendVCDataWithParameters:(NSDictionary *)parameters success:(void (^)(BYC_MyCenterHandler *handler))success failure:(void (^)(NSError *error))failure;

@end
