//
//  WX_AnimationLayer.m
//  kpie
//
//  Created by 王傲擎 on 16/5/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_AnimationLayer.h"


@implementation WX_AnimationLayer


+(id)setViewLayerAnimationWithView:(UIView *)view Color:(UIColor*)color ShowOrHidden:(BOOL)isShow
{
    if (isShow) {
        
        view.layer.backgroundColor = [UIColor clearColor].CGColor;
        CAShapeLayer *pulseLayer = [CAShapeLayer layer];
        pulseLayer.frame = view.layer.bounds;
        pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
        pulseLayer.fillColor = color.CGColor;//填充色
//        pulseLayer.shadowColor = color.CGColor;
        pulseLayer.opacity = 0.0;
        
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = view.bounds;
        replicatorLayer.instanceCount = 1;//创建副本的数量,包括源对象。
        replicatorLayer.instanceDelay =  .0;//复制副本之间的延迟
        [replicatorLayer addSublayer:pulseLayer];
        [view.layer addSublayer:replicatorLayer];
        
        CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnima.fromValue = @(0.3);
        opacityAnima.toValue = @(0.0);
        
        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.15, 1.15, 0.0)];
        scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.45, 1.45, 0.0)];
        
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[opacityAnima, scaleAnima];
        groupAnima.duration = 4.0;
        groupAnima.autoreverses = NO;
        groupAnima.repeatCount = HUGE;
        [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
    }else{
            /// 有BUG 屏蔽
//        for (CAReplicatorLayer *layer in view.layer.sublayers) {
//            if ([layer isKindOfClass:[CAReplicatorLayer class]]) {
//                [layer removeFromSuperlayer];
//            }
//        }
    }

    return view;

}

+(id)setViewAnimationWithView:(UIView *)view StartPonit:(CGPoint)startPoint EndPoint:(CGPoint)endPoint BeginTime:(CGFloat)beginTime ShowOrHidden:(BOOL)isShow Controller:(UIViewController*)controller
{
    if (isShow) {
        
        //位移动画
//        view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration=.45f;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
        positionAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
        positionAnimation.beginTime = CACurrentMediaTime() + beginTime;
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        [view.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        view.layer.position=endPoint;
        
        //缩放动画
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration=.45f;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scaleAnimation.fromValue = @(0);
        scaleAnimation.toValue = @(1);
        scaleAnimation.beginTime = CACurrentMediaTime() + beginTime;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.delegate = controller;

        [view.layer addAnimation:scaleAnimation forKey:@"transformscale"];
        
        view.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
        
       
        
//        view.center = endPoint;
        
//        [view.layer setValue:scaleAnimation.toValue forKeyPath:@"transform.translation.x"];
//        [view.layer setValue:scaleAnimation.toValue forKeyPath:@"transform.translation.y"];
//        [UIView animateWithDuration:0.6f delay:0.5f usingSpringWithDamping:.03f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            [view.layer setValue:@(10) forKeyPath:@"transform.translation.x"];
//            [view.layer setValue:@(10) forKeyPath:@"transform.translation.y"];
//        } completion:^(BOOL finished) {
//            
//        }];
        
    }else{
        view.transform = CGAffineTransformMakeScale(.1f, .1f);
        startPoint = CGPointFromString([NSString stringWithFormat:@"%@",[view.layer valueForKeyPath:@"position"]]);
        //位移动画
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration=.45;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
        positionAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
        positionAnimation.beginTime = CACurrentMediaTime() + beginTime;
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;

        [view.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        //btn.layer.position=startPoint;
        
        //缩放动画
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration=.45;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = @(1);
        scaleAnimation.toValue = @(0);
        scaleAnimation.beginTime = CACurrentMediaTime() + beginTime;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.delegate = controller;

        [view.layer addAnimation:scaleAnimation forKey:@"transformscale"];
        view.transform = CGAffineTransformIdentity;
//        view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//        view.center = endPoint;
        
    }
    
    
    return view;

}

+(id)setViewPopSpringAnimationWithView:(UIView*)view Speed:(CGFloat)speed Tension:(CGFloat)tension Friction:(CGFloat)friction Mass:(CGFloat)mass Bounciness:(CGFloat)bounciness Controller:(UIViewController*)controller
{
//    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    
//    springAnimation.delegate = controller;
//    
//    springAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
//    
//    // 设置动画参数
//    springAnimation.springSpeed = speed;
//    springAnimation.dynamicsTension = tension;
//    springAnimation.dynamicsFriction = friction;
//    springAnimation.dynamicsMass = mass;
//    springAnimation.springBounciness = Bounciness;
//    
//    [view.layer pop_addAnimation:springAnimation forKey:nil];
    
    [view.layer pop_removeAllAnimations];
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    // 设置代理
    spring.delegate            = controller;
    
    // 动画起始值 + 动画结束值
    spring.fromValue           = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    spring.toValue             = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    
    // 参数的设置
    spring.springSpeed         = speed;
    spring.springBounciness    = bounciness;
    spring.dynamicsMass        = mass;
    spring.dynamicsFriction    = friction;
    spring.dynamicsTension     = tension;
    
    // 执行动画
    [view.layer pop_addAnimation:spring forKey:nil];
    
    return view;
}

+(id)removePopAnimationViewLayer:(UIView *)view
{
    [view.layer pop_removeAllAnimations];
    return view;
}


@end
