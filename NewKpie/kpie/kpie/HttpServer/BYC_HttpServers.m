//
//  BYC_HttpServers.m
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#include "AFNetworking.h"
#import "BYC_BackHomeVC.h"
#import "NSDictionary+BYC_NullChangeNilWithDic.h"
#import "BYC_PropertyManager.h"
#import "AFHTTPRequestOperation+BYC_AddRequestUrl.h"
#import "AFHTTPRequestOperationManager+BYC_AddRequestUrl.h"

@implementation BYC_HttpServers
+ (void)Get:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    [self getRequest:URLString parameters:parameters success:success failure:failure];
}

+ (void)Post:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self postRequest:URLString parameters:parameters success:success failure:failure];
}

+ (void)getRequest:(NSString *)URLString
    parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    if ([parameters isKindOfClass:[NSArray class]]) {
        NSMutableString *mStr = [NSMutableString string];
        
        for (NSString *str in parameters) {
            [mStr appendString:@"/"];
            [mStr appendString:str];
        }
        URLString = [NSString stringWithFormat:@"%@%@%@",[QNWS_Main_HostIP copy] ,URLString,mStr];
        parameters = nil;

    } else URLString = [NSString stringWithFormat:@"%@%@",[QNWS_Main_HostIP copy] ,URLString];
        
    AFHTTPRequestOperationManager *manager = [self getManager:URLString parameters:parameters];
    
    // 登陆会配置此项
    if ([BYC_AccountTool userAccount]) {
        
        //申明请求的数据是json类型
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:[BYC_AccountTool userAccount].token forHTTPHeaderField:@"checkTokenKey"];
        [manager.requestSerializer setValue:[BYC_AccountTool userAccount].userid forHTTPHeaderField:@"sessionKey"];
    }
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleResponseObject:responseObject success:success error:nil failure:nil andRequestOperation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self handleResponseObject:nil success:nil error:error failure:failure andRequestOperation:operation];
    }];
}

+ (void)postRequest:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    URLString = [NSString stringWithFormat:@"%@%@",[QNWS_Main_HostIP copy] ,URLString];
    AFHTTPRequestOperationManager *manager = [self getManager:URLString parameters:parameters];

    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleResponseObject:responseObject success:success error:nil failure:nil andRequestOperation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self handleResponseObject:nil success:nil error:error failure:failure andRequestOperation:operation];
    }];
}

/**
 *  根据返回来的数据判断是否token失效了，失效返回YES ， 不失效返回NO
 *
 *  @param responseObject jeson数据
 *
 *  @return 返回
 */
+ (BOOL)isInvalidOfToken:(id)responseObject {
    
    if ([responseObject[@"result"] intValue] == 99 && [BYC_AccountTool userAccount]) {
        [BYC_BackHomeVC cleanUserInfoAndBackHomeVC];
        return YES;
    }else return NO;
}

/**
 *  处理结果
 *
 *  @param responseObject jeson数据
 *
 *  @param success 成功的回调
 *  
 *  @param error 错误数据
 *
 *  @param failure 失败的回调
 *
 *  @param operation 请求操作对象
 */
+ (void)handleResponseObject:(id)responseObject success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success error:(NSError *)error failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure andRequestOperation:(AFHTTPRequestOperation *)operation{

    NSAssert(!(success && failure), @"无需同时传两个回调参数,以免混淆。默认优先处理成功回调");
    NSAssert(!(error && responseObject), @"无需同时传两个参数,以免混淆。默认优先处理成功回调");
    NSAssert(!(success && error), @"无需同时传两个参数,以免混淆。默认优先处理成功回调");
    NSAssert(!(failure && responseObject), @"无需同时传两个参数,以免混淆。默认优先处理成功回调");
    if (success) {
        
        if ([self isInvalidOfToken:responseObject]) return;//不知道还有没有用，新接口不知道如何检测token失效
        
        responseObject = [NSDictionary changeType:responseObject];
        #ifdef DEBUG // 调试异常情况
        
        [BYC_HttpServers isfailure:responseObject success:^{
            
            QNWSBlockSafe(success, operation,responseObject);
        } failure:^{QNWSBlockSafe(failure, operation, nil);}];
        #else
            @try {
                
                [BYC_HttpServers isfailure:responseObject success:^{
                    
                    QNWSBlockSafe(success, operation,responseObject);
                } failure:^{QNWSBlockSafe(failure, operation, nil);}];
            } @catch (NSException *exception) {QNWSShowException(exception);}
        #endif
    
    }else {
    
        #ifdef DEBUG // 调试异常情况
        [BYC_HttpServers exefailure:operation error:error failure:failure];
        #else
            @try {[BYC_HttpServers exefailure:operation error:error failure:failure];}
            @catch (NSException *exception) {QNWSShowException(exception);}
        #endif

    }
}

+ (id)getValueWithRequestOperation:(AFHTTPRequestOperation *)operation key:(NSString *)key {

    NSString *str_Query = operation.requestUrl;
    
    if ([str_Query containsString:key]) {
        
        NSString *str_SubString1 = [str_Query substringFromIndex:[str_Query rangeOfString:key].location];
        NSString *str_SubString2 = [str_SubString1 substringFromIndex:[str_SubString1 rangeOfString:@"="].location + 1];
        NSString *str_SubString3;
        if ([str_SubString2 containsString:@"&"])
            str_SubString3 = [str_SubString2 substringToIndex:[str_SubString2 rangeOfString:@"&"].location];
        else str_SubString3 = str_SubString2;
        return str_SubString3;
    }else return nil;
}

+ (void)PostWithProgress:(NSString *)URLString
     parametersWithToken:(id)parametersWithToken
          UploadProgress:(void(^)(CGFloat progress))uploadProgress
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    URLString = [NSString stringWithFormat:@"%@%@",[QNWS_Main_HostIP copy] ,URLString];

    AFHTTPRequestOperationManager *manager = [self getManager:URLString parameters:parametersWithToken ];
    AFHTTPRequestOperation *opt = [manager POST:URLString parameters:parametersWithToken success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleResponseObject:responseObject success:success error:nil failure:nil andRequestOperation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self handleResponseObject:nil success:nil error:error failure:failure andRequestOperation:operation];
    }];
    
    //上传进度
    [opt setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progress = ((float)totalBytesWritten) / (totalBytesExpectedToWrite*1.0f);
        QNWSLog(@"上传进度:%f",progress);
        uploadProgress(progress);
    }];
}

+ (AFHTTPRequestOperationManager *)getManager:(NSString *)URLString parameters:(id)parameters{

    // 创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[BYC_AccountTool userAccount].token forHTTPHeaderField:@"checkTokenKey"];
    [manager.requestSerializer setValue:[BYC_AccountTool userAccount].userid forHTTPHeaderField:@"sessionKey"];
    manager.requestSerializer.timeoutInterval = 20;
    
    NSDictionary *dic_Temp = [QNWSDictionaryObjectForKey(parameters, KSTR_DictionaryTemp) mutableCopy];
    NSMutableString *str_Url;
    if (dic_Temp) {
        [parameters removeObjectForKey:KSTR_DictionaryTemp];
        str_Url = [NSMutableString stringWithFormat:@"%@?%@",URLString,[self getUrlStringWithParame:parameters]];
        [str_Url appendString:@"&"];
        [str_Url appendString:[self getUrlStringWithParame:dic_Temp]];
        
    }else str_Url = [NSMutableString stringWithFormat:@"%@?%@",URLString,[self getUrlStringWithParame:parameters]];
    
    QNWSLog(@"当前请求的url = %@",str_Url);
    manager.requestUrl = str_Url;
    return manager;
}

+ (NSString *)getUrlStringWithParame:(NSDictionary *)dic {
    
    NSString *mStr = [NSMutableString string];
    for (id obj1 in [dic allKeys]) mStr = [mStr stringByAppendingString: [NSString stringWithFormat:@"%@=%@&",obj1,dic[obj1]]];
    if (mStr.length > 0) mStr = [mStr substringToIndex:mStr.length - 1];
    return mStr;
}

/**
 * 根据返回数据responseObject的success字段判断是否成功或失败
 *
 *  @param responseObject  请求回调的数据
 *  @param success  后台确认返还的是成功了的数据
 *  @param failure  后台确认返还的是失败了的数据
 */
+ (void)isfailure:(id)responseObject success:(void(^)())success failure:(void(^)())failure {
    if ([responseObject[@"success"] isEqualToNumber:@0]) {
        
        if (((NSString *)responseObject[@"msg"]).length > 0)
            [[UIView alloc] showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
                
                QNWSBlockSafe(failure);
            }];
        else [[UIView alloc] showAndHideHUDWithTitle:@"未知原因请求失败。" WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
            
            QNWSBlockSafe(failure);
        }];
    }else {
    
        if (((NSString *)responseObject[@"msg"]).length > 0)
            //后台返回的提示不够准确，只能注释掉咯。。。自己单独按实际情况写咯。
//            [[UIView alloc] showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
                QNWSBlockSafe(success);
//            }];
        else QNWSBlockSafe(success);
    }
//    }
}

/**
 *  请求失败进行失败提示以及回调
 *
 *  @param responseObject  请求失败的操作对象
 *  @param success  失败原因
 *  @param failure  失败回调
 */
+ (void)exefailure:(AFHTTPRequestOperation *)operation error:(NSError *)error failure:(void(^)())failure {

    if (error.localizedDescription) {
        
        [[UIView alloc] showAndHideHUDWithTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
            
            QNWSBlockSafe(failure, operation, error);
        }];
    }
}
@end
