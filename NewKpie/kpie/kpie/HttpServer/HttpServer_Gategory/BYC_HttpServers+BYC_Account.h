//
//  BYC_HttpServers+BYC_Account.h
//  kpie
//
//  Created by 元朝 on 16/10/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
@class BYC_AccountModel;

@interface BYC_HttpServers (BYC_Account)

/**
 *  发送post请求登陆
 *
 *  @param parameters           请求的参数字典
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestLoginAccountDataIsThird:(BOOL)isThird parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_AccountModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  发送post请求修改密码
 *
 *  @param parameters           请求的参数字典
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestChangePassWordDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  发送post请求注册
 *
 *  @param parameters           请求的参数字典
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestRegisterAccountDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, BYC_AccountModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  发送post请求发送验证码
 *
 *  @param parameters           请求的参数字典
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestSendSmsDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  退出登录前必掉的接口，涉及到后台怎么推顶号的通知。但是没有网络退出，调用这个接口不成功，可能顶号会错乱。（后台应该考虑的逻辑）
 *
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)requestLogoutSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
