//
//  BYC_HttpServers+HL_TagVC.h
//  kpie
//
//  Created by sunheli on 17/1/22.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_BaseVideoModel.h"

@interface BYC_HttpServers (HL_TagVC)

/**
 标签数据

 @param parameters {"themeName":"#合拍show#","time":"2016-12-20 03:07:25:706","upType":2}
 @param success success description
 @param failure failure description
 */
+ (void)requestTagVCVideosWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *themeVideos))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
