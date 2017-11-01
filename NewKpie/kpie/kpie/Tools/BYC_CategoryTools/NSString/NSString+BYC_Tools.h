//
//  NSString+BYC_Tools.h
//  kpie
//
//  Created by 元朝 on 16/2/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BYC_Tools)

/**
 *  计算字符串尺寸
 *
 *  @param string 需要被计算的字符串
 *  @param font   字符串字体大小
 *  @param size   尺寸
 *
 *  @return 放回计算好了的尺寸
 */
- (CGSize)sizeWithfont:(NSInteger)font boundingRectWithSize:(CGSize)size;
/**
 *  格式化日期xxxx-xx-xx xx:xx:xx
 *
 *  @param time 时间戳
 *
 *  @return 日期
 */
+ (NSString *)getDateStr:(NSString *)time;
@end
