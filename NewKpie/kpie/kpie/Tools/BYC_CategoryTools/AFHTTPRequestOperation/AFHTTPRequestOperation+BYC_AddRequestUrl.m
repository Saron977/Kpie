//
//  AFHTTPRequestOperation+BYC_AddRequestUrl.m
//  ZZKT
//
//  Created by 元朝 on 2017/1/10.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import "AFHTTPRequestOperation+BYC_AddRequestUrl.h"


@implementation AFHTTPRequestOperation (BYC_AddRequestUrl)


- (NSString *)requestUrl {
    return objc_getAssociatedObject(self, @selector(requestUrl));
}

- (void)setRequestUrl:(NSString *)requestUrl {
    
    objc_setAssociatedObject(self, @selector(requestUrl), requestUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
