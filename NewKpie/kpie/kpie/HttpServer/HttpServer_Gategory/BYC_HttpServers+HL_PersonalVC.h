//
//  BYC_HttpServers+HL_PersonalVC.h
//  kpie
//
//  Created by sunheli on 16/10/14.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "HL_PersonalModel.h"
#import "BYC_MyCenterHandler.h"

@interface BYC_HttpServers (HL_PersonalVC)

/**
 *  获取我的界面 作品 关注 粉丝数
 */
+ (void)requestPersonalVCDataWithParameters:(NSDictionary *)parameters success:(void (^)(BYC_MyCenterHandler *handler))success failure:(void (^)(NSError *error))failure;

/**
 删除作品

 @param parames userid/videoid
 @param success 
 @param failure
 */
+(void)requestVideosWithDeleteParames:(id)parames success:(void(^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;
@end
