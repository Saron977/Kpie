//
//  BYC_DropHandler.m
//  kpie
//
//  Created by 元朝 on 16/11/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_DropHandler.h"
#import "UIImage+ImageEffects.h"

//隐藏弹出视图的通知
NSString * const Notification_DismissAnimation = @"Notification_DismissAnimation";
static BYC_DropHandler *mySelf;
@interface BYC_DropHandler()

/**背景*/
@property (nonatomic, strong)  UIImageView  *imgV_BackgroundView;

/**展示的view*/
@property (nonatomic, strong)  UIView  *alertView;

@end

@implementation BYC_DropHandler

+ (void)dropHandleWithView:(UIView *)view setFrameOrConstraintBlock:(void(^)())block{

    mySelf = [BYC_DropHandler new];
    mySelf.alertView = view;
    block();
    
    [mySelf registerNotification];
    
}

- (void)registerNotification {

    [QNWSNotificationCenter addObserverForName:Notification_DismissAnimation object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        [mySelf dismissAnimation];
    }];
}

-(void)setAlertView:(UIView *)alertView {

    _alertView = alertView;
    [self.imgV_BackgroundView addSubview:_alertView];
    [self exeAlertPopupView];
}

-(UIImageView *)imgV_BackgroundView {

    if (!_imgV_BackgroundView) {
        _imgV_BackgroundView = [[UIImageView alloc] initWithFrame:[self mainScreenFrame]];
        _imgV_BackgroundView.opaque = YES;
        _imgV_BackgroundView.userInteractionEnabled = YES;
        UIImage *image = [self convertViewToImage];
        UIImage *imageBlur = [image blurImageWithRadius:20];
        _imgV_BackgroundView.image = imageBlur;
        _imgV_BackgroundView.alpha = 0;
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAnimation)];
        [_imgV_BackgroundView addGestureRecognizer:tag];
        [KQNWS_KeyWindow addSubview:_imgV_BackgroundView];
    }
    return _imgV_BackgroundView;
}

- (void)exeAlertPopupView {
    
    CGRect screen = [self mainScreenFrame];
    CATransform3D move = CATransform3DIdentity;
    CGFloat init_alertViewYPosition = CGRectGetHeight(screen) / 2;
    move = CATransform3DMakeTranslation(0, -init_alertViewYPosition, 0);
    move = CATransform3DRotate(move, 40 * M_PI/180, 0, 0, 1.0f);
    _alertView.layer.transform = move;
    
    [self showAnimation];
}

- (void)showAnimation {
    
        [UIView animateWithDuration:0.3f animations:^{
            _imgV_BackgroundView.alpha = 1.0f;
        }];
    
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CATransform3D init = CATransform3DIdentity;
                         _alertView.layer.transform = init;
                         
                     }
                     completion:nil];
}

- (void)dismissAnimation
{
    
    [UIView animateWithDuration:0.8f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect screen = [self mainScreenFrame];
                         CATransform3D move = CATransform3DIdentity;
                         CGFloat init_alertViewYPosition = CGRectGetHeight(screen);
                         
                         move = CATransform3DMakeTranslation(0, init_alertViewYPosition, 0);
                         move = CATransform3DRotate(move, -40 * M_PI/180, 0, 0, 1.0f);
                         _alertView.layer.transform = move;
                         _imgV_BackgroundView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [_imgV_BackgroundView removeFromSuperview];
                         mySelf = nil;
                     }];
    
}


- (CGRect)mainScreenFrame
{
    return [UIScreen mainScreen].bounds;
}

- (UIImage *)convertViewToImage
{
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return capturedScreen;
}

-(void)dealloc {

    QNWSLog(@"111111111111");

}

@end
