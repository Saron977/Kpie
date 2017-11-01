//
//  UIView+BYC_Tools.m
//  kpie
//
//  Created by 元朝 on 16/6/23.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "UIView+BYC_Tools.h"

@implementation UIView (BYC_Tools)

/**
 *  毛玻璃滤镜
 *
 *  @param style 毛玻璃效果
 */
-(void)setBlurEffectWithStyle:(UIBlurEffectStyle)style {
    
    [self setBlurEffectWithStyle:style frame:self.bounds];
}

/**
 *  毛玻璃滤镜
 *
 *  @param style 毛玻璃效果
 *  @param frame 在父视图上的位置
 */
-(void)setBlurEffectWithStyle:(UIBlurEffectStyle)style frame:(CGRect)frame{
    
    if (![self viewWithTag:self.hash]) {
        
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:style];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
        visualEffectView.tag = self.hash;
        visualEffectView.frame = frame;
        [self insertSubview:visualEffectView atIndex:0];
    }
}

/**
 *  毛玻璃滤镜
 *
 *  @param style 毛玻璃效果
 */
-(UIVisualEffectView *)getBlurEffectViewWithStyle:(UIBlurEffectStyle)style {
    
    return [self getBlurEffectViewWithStyle:style frame:self.bounds];
}

/**
 *  得到毛玻璃视图
 *
 *  @param style 毛玻璃风格
 *  @param frame 毛玻璃在父视图上大小位置
 *
 *  @return 返回毛玻璃
 */
-(UIVisualEffectView *)getBlurEffectViewWithStyle:(UIBlurEffectStyle)style frame:(CGRect)frame{
    
    UIVisualEffectView *visualEffectView = [self viewWithTag:self.hash];
    if (!visualEffectView) {
        
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:style];
        visualEffectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
        visualEffectView.frame = frame;
    }

    return visualEffectView;
}
@end
