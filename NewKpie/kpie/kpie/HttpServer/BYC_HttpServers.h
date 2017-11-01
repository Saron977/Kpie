//
//  BYC_HttpServers.h
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#include "AFNetworking.h"
#import "NSDictionary+BYC_PropertyWithDictionary.h"

@interface BYC_HttpServers : NSObject
/**
 *  发送get请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)Get:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)Post:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  返回根据key返回value
 *
 *  @param operation 请求操作
 *  @param key       key
 *
 *  @return value
 */
+ (id)getValueWithRequestOperation:(AFHTTPRequestOperation *)operation key:(NSString *)key;

/**
 *  发送post请求
 *
 *  @param URLString            请求的基本的url
 *  @param parametersWithToken  请求的参数字典+校验Token
 *  @param progress             上传进度
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)PostWithProgress:(NSString *)URLString
     parametersWithToken:(id)parametersWithToken
          UploadProgress:(void(^)(CGFloat uploadProgress))uploadProgress
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
