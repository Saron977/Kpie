//
//  AFHTTPRequestOperation+BYC_AddRequestUrl.h
//  ZZKT
//
//  Created by 元朝 on 2017/1/10.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPRequestOperation (BYC_AddRequestUrl)

/**增加请求连接*/
@property (nonatomic, strong) NSString *requestUrl;

@end
