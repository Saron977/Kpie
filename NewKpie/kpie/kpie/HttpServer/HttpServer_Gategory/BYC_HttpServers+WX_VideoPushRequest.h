//
//  BYC_HttpServers+WX_VideoPushRequest.h
//  kpie
//
//  Created by 王傲擎 on 2017/6/28.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_BaseVideoModel.h"

typedef NS_ENUM(NSInteger,ENUM_PushType) {
    ENUM_VideoPushType_Video            =   0,  /**<   推送_普通视频 */
    ENUM_VideoPushType_Script           =   1,  /**<   推送_剧本合拍 */
};/**< 推送_视频信息 */

@interface BYC_HttpServers (WX_VideoPushRequest)

/**
 标签数据
 
 @param videoID 视频ID
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)WX_RequestVideoPushWithVideoID:(NSArray *)videoID ENUM_PushType:(ENUM_PushType)type success:(void (^)(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *video_Model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
