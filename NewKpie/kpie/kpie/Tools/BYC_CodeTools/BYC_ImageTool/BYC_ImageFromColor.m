//
//  BYC_ImageFromColor.m
//  kpie
//
//  Created by 元朝 on 15/11/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_ImageFromColor.h"

@implementation BYC_ImageFromColor


//通过颜色来生成一个纯色图片
+ (UIImage *)imageFromColor:(UIColor *)color withImageFrame:(CGRect)frame{
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
