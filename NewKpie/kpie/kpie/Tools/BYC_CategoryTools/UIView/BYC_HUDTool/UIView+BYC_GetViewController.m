//
//  UIView+BYC_GetViewController.m
//  kpie
//
//  Created by 元朝 on 16/5/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "UIView+BYC_GetViewController.h"

@implementation UIView (BYC_GetViewController)

#pragma  得到BGViewController控制器
//得到ViewController控制器
- (UIViewController *)getBGViewController
{
    UIResponder *next = [self nextResponder];
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) return (UIViewController *)next;
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
@end
