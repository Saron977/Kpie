//
//  UIColor+CustomSliderColor.m
//  视频滚动条_Demo
//
//  Created by 王傲擎 on 15/10/30.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "UIColor+CustomSliderColor.h"

@implementation UIColor (CustomSliderColor)
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    // Bypass '#' character
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithHexString:@"#ececec"];
}

+ (UIColor *)navBarBackgroundColor
{
    return [UIColor colorWithHexString:@"#0c0c0d"];
}

+ (UIColor *)navBarTextColor
{
    return [UIColor colorWithHexString:@"#84bd00"];
}

+ (UIColor *)navBarBackButtonColor
{
    return [UIColor colorWithHexString:@"#cbccd1"];
}

+ (UIColor *)mainTextColor
{
    return [UIColor colorWithHexString:@"#ffffff"];
}

+ (UIColor *)secondaryTextColor
{
    return [UIColor colorWithHexString:@"#cbccd1"];
}

@end
