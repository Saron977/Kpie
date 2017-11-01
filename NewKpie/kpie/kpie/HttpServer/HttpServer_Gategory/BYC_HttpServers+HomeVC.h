//
//  BYC_HttpServers+HomeVC.h
//  kpie
//
//  Created by 元朝 on 16/7/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_HomeChannelListModel.h"
#import "BYC_OtherViewControllerModel.h"
#import "BYC_AusleseVCModels.h"

@interface BYC_HttpServers (HomeVC)

/**
 *  精选数据
 *
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestHomeVCAusleseDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_AusleseVCModels *models))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
