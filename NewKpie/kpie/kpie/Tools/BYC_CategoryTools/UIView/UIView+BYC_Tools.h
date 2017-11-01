//
//  UIView+BYC_Tools.h
//  kpie
//
//  Created by 元朝 on 16/6/23.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BYC_Tools)


/**
 *  毛玻璃滤镜
 *
 *  @param style 毛玻璃效果
 */
-(void)setBlurEffectWithStyle:(UIBlurEffectStyle)style;
/**
 *  毛玻璃滤镜
 *
 *  @param style 毛玻璃效果
 *  @param frame 在父视图上的位置
 */
-(void)setBlurEffectWithStyle:(UIBlurEffectStyle)style frame:(CGRect)frame;


/**
 *  毛玻璃滤镜
 *
 *  @param style 毛玻璃效果
 */
-(UIVisualEffectView *)getBlurEffectViewWithStyle:(UIBlurEffectStyle)style;

/**
 *  得到毛玻璃视图
 *
 *  @param style 毛玻璃风格
 *  @param frame 毛玻璃在父视图上大小位置
 *
 *  @return 返回毛玻璃
 */
-(UIVisualEffectView *)getBlurEffectViewWithStyle:(UIBlurEffectStyle)style frame:(CGRect)frame;
@end
