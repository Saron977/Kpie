//
//  WX_AnimationLayer.h
//  kpie
//
//  Created by 王傲擎 on 16/5/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "POP.h"
@interface WX_AnimationLayer : NSObject

/** 设置波纹效果 YES_展示 NO_隐藏*/
+(id)setViewLayerAnimationWithView:(UIView *)view Color:(UIColor*)color ShowOrHidden:(BOOL)isShow;

/** 按络线移动动画效果 YES_展示 NO_隐藏 controller_设置代理方法, 在调用该方法页面实现*/
+(id)setViewAnimationWithView:(UIView*)view StartPonit:(CGPoint)startPoint EndPoint:(CGPoint)endPoint BeginTime:(CGFloat)beginTime ShowOrHidden:(BOOL)isShow Controller:(UIViewController*)controller;

/** 设置弹性 Speed_速度 Tension_拉力 Friction_摩擦力 Mass_质量 Bounciness_弹力 controller_设置代理, 在调用该方法页面实现*/
+(id)setViewPopSpringAnimationWithView:(UIView*)view Speed:(CGFloat)speed Tension:(CGFloat)tension Friction:(CGFloat)friction Mass:(CGFloat)mass Bounciness:(CGFloat)bounciness Controller:(UIViewController*)controller;

/** 删除添加上的POP动画*/
+(id)removePopAnimationViewLayer:(UIView*)view;
@end

