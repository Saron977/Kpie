//
//  BYC_RSA.h
//  kpie
//
//  Created by 元朝 on 15/11/9.
//  Copyright © 2015年 QNWS. All rights reserved.
//  RSA加密

#import <Foundation/Foundation.h>

@interface BYC_RSA : NSObject

/**
 *  加密
 *
 *  @param str 加密对象
 *
 *  @return 加密之后的值
 */
+ (NSString *)encryptString:(NSString *)str;
/**
 *  解密
 *
 *  @param NSData 解密对象
 *
 *  @return 解密之后的值
 */
//+ (NSData *)encryptData:(NSData *)data;
@end
