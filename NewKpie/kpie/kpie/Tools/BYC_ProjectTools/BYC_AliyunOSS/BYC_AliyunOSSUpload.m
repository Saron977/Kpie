//
//  BYC_AliyunOSSUpload.m
//  kpie
//
//  Created by 元朝 on 15/12/2.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_AliyunOSSUpload.h"
#import "AFNetworking.h"
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import "BYC_PropertyManager.h"

#import "WX_UploadProgress.h"
#import "NSDictionary+BYC_NullChangeNilWithDic.h"

/**oss*/
static id<OSSCredentialProvider> _credential;
static  OSSClient *_ossClient;
@implementation BYC_AliyunOSSUpload


/**
 *  阿里云上传数据
 *
 *  @param objectKey  上传阿里云的文件路径
 *  @param data       上传数据
 *  @param resourceType 数据类型
 *  @param completion 成功或者失败的回调
 */
+ (void)uploadWithObjectKey:(NSString *)objectKey Data:(NSData *)data andType:(ResourceType)resourceType completion:(void (^)(BOOL finished))completion {

        
    {//设置OSSToken
        __block  NSString *ossToken;
        _credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
            {
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    /*以下注释是因为新接口之后无效了。。。*/
//                    NSString *stringIP = [QNWS_Main_HostIP copy];
//                    NSString *urlstr = [NSString stringWithFormat:@"%@%@",stringIP ? stringIP : KQNWS_KPIE_MAIN_URL ,KQNWS_OssUrl];
                    NSString *urlstr = [NSString stringWithFormat:@"%@%@", QNWS_Main_HostIP ,KQNWS_OssUrl];
                    NSURL *url = [NSURL URLWithString:urlstr];
                    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
                    urlrequest.HTTPMethod = @"POST";
                    NSString *bodyStr = [NSString stringWithFormat:@"content=%@",contentToSign];
                    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
                    [urlrequest setValue:[BYC_AccountTool userAccount].token forHTTPHeaderField:@"checkTokenKey"];
                    [urlrequest setValue:[BYC_AccountTool userAccount].userid forHTTPHeaderField:@"sessionKey"];
                    urlrequest.HTTPBody = body;
                    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
                    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
                    [requestOperation start];
                    [requestOperation waitUntilFinished];
                    NSDictionary *respondDataDic = [NSDictionary changeType:(NSDictionary *)[requestOperation.responseSerializer responseObjectForResponse:requestOperation.response data:requestOperation.responseData error:nil]];
                    ossToken =  respondDataDic[@"msg"];
                    

#pragma mark ---------- 本地/测试上传阿里云(语音评论,上传视频,图片)...........
                     //***************************************************************************//
                     //*********************************** 勿动 ***********************************//
                     //***************************************************************************//
                    /*以下注释是因为新接口之后无效了。。。*/
//                    if (![KQNWS_KPIE_MAIN_URL isEqualToString:stringIP] && stringIP.length > 0) {
//                        NSArray *array = [ossToken componentsSeparatedByString:@"\n"];
//                        ossToken = [array lastObject];
//                    }
                    //***************************************************************************//
                    
                });
            }
            return ossToken;
        }];
        
        NSString *endpoint = @"http://oss-cn-shenzhen.aliyuncs.com";
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 2;
        conf.timeoutIntervalForRequest = 30;
        conf.timeoutIntervalForResource = 24 * 60 * 60;
        _ossClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:_credential clientConfiguration:conf];
    
    }
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    /*以下注释是因为新接口之后无效了。。。*/
//    NSString *str_HostIP = [QNWS_Main_HostIP copy];
//    if ([str_HostIP isEqualToString:@"http://www.kpie.com.cn/api/"] || [str_HostIP isEqualToString:@"http://112.74.88.81/api/"] || str_HostIP.length == 0) {
        //正式环境分类bucketName
        if (resourceType == resourceTypeImage) put.bucketName = KQNWS_BucketNameJPG;
        else if (resourceType == resourceTypeVideo) put.bucketName = KQNWS_BucketNameVIDEOS;
//    }else put.bucketName = KQNWS_BucketNameTest;//测试环境无需细分bucketName

    put.objectKey = objectKey;
    put.uploadingData = data ;//直接上传NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        //这里可以自定义上传进度条bytesSent:实时发送字节数 totalByteSent:已经发送字节总数 totalBytesExpectedToSend:数据资源总字节数
        Float64 sentByte = totalByteSent;
        Float64 expectedSendByte = totalBytesExpectedToSend;
        QNWSLog(@"阿里云上传%lld, %lld, %lld, %.2f", bytesSent, totalByteSent, totalBytesExpectedToSend, sentByte/expectedSendByte);
    };
    
    OSSTask * putTask = [_ossClient putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(YES);
            });
        } else {
            QNWSLog(@"上传错误信息: %@" , task.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion) completion(NO);
            });
        }
        return nil;
    }];
}


/**
 *  阿里云上传数据 (带上传进度回调)
 *
 *  @param objectKey    上传阿里云的文件路径
 *  @param data         上传数据
 *  @param resourceType 数据类型
 *  @param completion   成功或者失败的回调
 *  @param progressVale 上传进度
 */
+(void)uploadWithProgressObjectKey:(NSString *)objectKey Data:(NSData *)data andType:(ResourceType)resourceType completion:(void (^)(BOOL))completion progressVale:(void (^)(CGFloat))progressVale
{
    
    
    {//设置OSSToken
        __block  NSString *ossToken;
        _credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
            {
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
//                    NSString *stringIP = [QNWS_Main_HostIP copy];
//                    NSString *urlstr = [NSString stringWithFormat:@"%@%@",stringIP ? stringIP : KQNWS_KPIE_MAIN_URL ,KQNWS_OssUrl];

                    NSString *urlstr = [NSString stringWithFormat:@"%@%@", QNWS_Main_HostIP ,KQNWS_OssUrl];
                    NSURL *url = [NSURL URLWithString:urlstr];
                    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
                    urlrequest.HTTPMethod = @"POST";
                    NSString *bodyStr = [NSString stringWithFormat:@"content=%@",contentToSign];
                    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
                    [urlrequest setValue:[BYC_AccountTool userAccount].token forHTTPHeaderField:@"checkTokenKey"];
                    [urlrequest setValue:[BYC_AccountTool userAccount].userid forHTTPHeaderField:@"sessionKey"];
                    urlrequest.HTTPBody = body;
                    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
                    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
                    [requestOperation start];
                    [requestOperation waitUntilFinished];
                    NSDictionary *respondDataDic = [NSDictionary changeType:(NSDictionary *)[requestOperation.responseSerializer responseObjectForResponse:requestOperation.response data:requestOperation.responseData error:nil]];
                    ossToken =  respondDataDic[@"msg"];
                    
#pragma mark ---------- 本地/测试上传阿里云(语音评论,上传视频,图片)...........
                    //***************************************************************************//
                    //*********************************** 勿动 ***********************************//
                    //***************************************************************************//
//                    if (![KQNWS_KPIE_MAIN_URL isEqualToString:stringIP] && stringIP.length > 0) {
//                        NSArray *array = [ossToken componentsSeparatedByString:@"\n"];
//                        ossToken = [array lastObject];
//                    }
                    //***************************************************************************//
                    
                });
            }
            return ossToken;
        }];
        
        NSString *endpoint = @"http://oss-cn-shenzhen.aliyuncs.com";
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 2;
        conf.timeoutIntervalForRequest = 30;
        conf.timeoutIntervalForResource = 24 * 60 * 60;
        _ossClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:_credential clientConfiguration:conf];
        
    }
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
//    NSString *str_HostIP = [QNWS_Main_HostIP copy];
    
//    if ([str_HostIP isEqualToString:@"http://www.kpie.com.cn/api/"] || [str_HostIP isEqualToString:@"http://112.74.88.81/api/"] || str_HostIP.length == 0) {
        //正式环境分类bucketName
        if (resourceType == resourceTypeImage) put.bucketName = KQNWS_BucketNameJPG;
        else if (resourceType == resourceTypeVideo) put.bucketName = KQNWS_BucketNameVIDEOS;
//    }else put.bucketName = KQNWS_BucketNameTest;//测试环境无需细分bucketName
    
    put.objectKey = objectKey;
    put.uploadingData = data ;//直接上传NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        //这里可以自定义上传进度条bytesSent:实时发送字节数 totalByteSent:已经发送字节总数 totalBytesExpectedToSend:数据资源总字节数
        Float64 sentByte = totalByteSent;
        Float64 expectedSendByte = totalBytesExpectedToSend;
//        QNWSLog(@"阿里云上传%lld, %lld, %lld, %.2f", bytesSent, totalByteSent, totalBytesExpectedToSend, sentByte/expectedSendByte);
        Float64 completedSend =  sentByte/expectedSendByte;
        /**
         *   返回发送进度
         */
        progressVale(completedSend);
    };
    
    OSSTask * putTask = [_ossClient putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(YES);
            });
        } else {
            QNWSLog(@"上传错误信息: %@" , task.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion) completion(NO);
            });
        }
        return nil;
    }];
}
@end
