//
//  AFHTTPRequestOperationManager+BYC_AddRequestUrl.m
//  ZZKT
//
//  Created by 元朝 on 2017/1/10.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import "AFHTTPRequestOperationManager+BYC_AddRequestUrl.h"
#import "BYC_RuntTime.h"
#import "AFHTTPRequestOperation+BYC_AddRequestUrl.h"

@implementation AFHTTPRequestOperationManager (BYC_AddRequestUrl)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingMethod];
    });
}

+(void)swizzlingMethod{
    
    SwizzlingMethod([AFHTTPRequestOperationManager class], @selector(HTTPRequestOperationWithRequest:success:failure:), @selector(byc_HTTPRequestOperationWithRequest:success:failure:));
}

- (NSString *)requestUrl {
    return objc_getAssociatedObject(self, @selector(requestUrl));
}

- (void)setRequestUrl:(NSString *)requestUrl {
    
    objc_setAssociatedObject(self, @selector(requestUrl), requestUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(AFHTTPRequestOperation *)byc_HTTPRequestOperationWithRequest:(NSURLRequest *)request success:(void (^)(AFHTTPRequestOperation * _Nonnull, id _Nonnull))success failure:(void (^)(AFHTTPRequestOperation * _Nonnull, NSError * _Nonnull))failure {

    AFHTTPRequestOperation *operation = [self byc_HTTPRequestOperationWithRequest:request success:success failure:failure];
    operation.requestUrl = self.requestUrl;
    return operation;
}

@end
