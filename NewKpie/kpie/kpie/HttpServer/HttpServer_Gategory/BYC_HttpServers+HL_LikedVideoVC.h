//
//  BYC_HttpServers+HL_LikedVideoVC.h
//  kpie
//
//  Created by sunheli on 16/10/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "HL_LikedVideoModel.h"

@interface BYC_HttpServers (HL_LikedVideoVC)

+ (void)requestLikedVideoVCDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, HL_LikedVideoModel *likedVideoModel))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
