//
//  BYC_SetBackgroundColor.m
//  kpie
//
//  Created by 元朝 on 15/12/17.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_SetBackgroundColor.h"

@interface BYC_SetBackgroundColor()

@property (nonatomic, strong)  CAGradientLayer  *gradLayer;

@end

@implementation BYC_SetBackgroundColor

// 设置背景色
- (void)setBackgroundViewColor:(UIViewController *)controller
{
    if (_gradLayer == nil) {
//        _gradLayer = [CAGradientLayer layer];
        _gradLayer.frame = CGRectMake(0, 0, screenWidth, screenHeight);//尺寸要与view的layer一致
    }
    UIColor *color1 = KUIColorFromRGB(0xf0f0f0);
    _gradLayer.backgroundColor = color1.CGColor ;
    [controller.view.layer addSublayer:_gradLayer];
    [controller.view.layer insertSublayer:_gradLayer atIndex:0];
}

@end
