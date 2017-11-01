//
//  BYC_HttpServers+WX_GeekVC.h
//  kpie
//
//  Created by 王傲擎 on 16/7/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"

@interface BYC_HttpServers (WX_GeekVC)

+ (void)requestGeekVCSaveFriendsUserWithParameters:(NSDictionary *)parameters success:(void (^)(NSInteger result))success failure:(void (^)(NSError *error))failure;  /**< 添加关注 */

+ (void)requestGeekVCRemoveFriendsUserWithParameters:(NSDictionary *)parameters success:(void (^)(NSInteger result))success failure:(void (^)(NSError *error))failure; /**< 取消关注 */


+ (void)requestGeekVCSaveUserFavoritesWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *array_Result))success failure:(void (^)(NSError *error))failure;  /**< 添加喜欢,点赞 */

+ (void)requestGeekVCRemoveUserFavoritesWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *array_Result))success failure:(void (^)(NSError *error))failure; /**< 取消喜欢,点赞 */


@end
