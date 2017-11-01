//
//  BYC_HttpServers+HL_ColumnVC.h
//  kpie
//
//  Created by sunheli on 16/10/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "HL_ColumModel.h"

@interface BYC_HttpServers (HL_ColumnVC)

/**
 *  精选数据
 *
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestColumnDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, HL_ColumModel *models))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
