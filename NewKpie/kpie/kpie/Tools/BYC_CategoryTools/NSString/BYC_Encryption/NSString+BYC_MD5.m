//
//  NSString+BYC_MD5.m
//  kpie
//
//  Created by 元朝 on 16/1/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "NSString+BYC_MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (BYC_MD5)

- (NSString *)getStringMD5{
    
    const char *src = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, (CC_LONG)strlen(src), result);
    NSString * ret = [[NSString alloc] initWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]];
    [NSString defaultCStringEncoding];
    return ret;
}

@end
