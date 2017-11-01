//
//  UUProgressHUD.m
//  1111
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUProgressHUD.h"

@interface UUProgressHUD ()
{
    NSTimer *myTimer;
    int angle;
    
    UILabel *centerLabel;
    UIImageView *edgeImageView;
    
}
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@end

@implementation UUProgressHUD

@synthesize overlayWindow;

+ (UUProgressHUD*)sharedView {
    static dispatch_once_t once;
    static UUProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    });
    return sharedView;
}

+ (void)show {
    [[UUProgressHUD sharedView] show];
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        if (!centerLabel){
            centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
            centerLabel.backgroundColor = [UIColor clearColor];
        }
        
        if (!self.subTitleLabel){
            self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
            self.subTitleLabel.backgroundColor = [UIColor clearColor];
        }
        if (!self.titleLabel){
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
            self.titleLabel.backgroundColor = [UIColor clearColor];
        }
        if (!edgeImageView)
            edgeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Chat_record_circle"]];
        
        self.subTitleLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2 + 30);
        self.subTitleLabel.text = @"上划取消发送";
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.subTitleLabel.textColor = [UIColor yellowColor];
        
        self.titleLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2 - 30);
        self.titleLabel.text = @"时间";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        centerLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2);
        centerLabel.text = @"0";
        centerLabel.textAlignment = NSTextAlignmentCenter;
        centerLabel.font = [UIFont systemFontOfSize:30];
        centerLabel.textColor = [UIColor yellowColor];

        
        edgeImageView.frame = CGRectMake(0, 0, 154, 154);
        edgeImageView.center = centerLabel.center;
        [self addSubview:edgeImageView];
        [self addSubview:centerLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.titleLabel];

        if (myTimer)
            [myTimer invalidate];
        myTimer = nil;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(startAnimation)
                                                 userInfo:nil
                                                  repeats:YES];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        [self setNeedsDisplay];
    });
}
-(void) startAnimation
{
    angle -= 3;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.09];
    UIView.AnimationRepeatAutoreverses = YES;
    edgeImageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    float second = [centerLabel.text floatValue];
//    if (second <= 10.0f) {
//        centerLabel.textColor = [UIColor redColor];
//    }else{
        centerLabel.textColor = [UIColor greenColor];
//    }
    centerLabel.text = [NSString stringWithFormat:@"%.1f",second+0.1];
    [UIView commitAnimations];
}

+ (void)changeSubTitle:(UUProgressState )state
{
    [[UUProgressHUD sharedView] setState:state];
}

- (void)setState:(UUProgressState )state
{
    if (state == UUProgressRecording)
    {
        self.subTitleLabel.text = @"上划取消发送";
        self.subTitleLabel.textColor = [UIColor yellowColor];
    }
    if (state == UUProgressCancle)
    {
        self.subTitleLabel.text = @"松开即可取消";
        self.subTitleLabel.textColor = [UIColor redColor];
    }
}

+ (void)dismissWithSuccess:(NSString *)str {
	[[UUProgressHUD sharedView] dismiss:str];
}

+ (void)dismissWithError:(NSString *)str {
	[[UUProgressHUD sharedView] dismiss:str];
}

- (void)dismiss:(NSString *)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [myTimer invalidate];
        myTimer = nil;
        self.subTitleLabel.text = nil;
        self.titleLabel.text = nil;
        centerLabel.text = state;
        centerLabel.textColor = [UIColor whiteColor];
        
        CGFloat timeLonger;
        if ([state isEqualToString:@"时间太短"]) {
            timeLonger = 1;
        }else{
            timeLonger = 0.6;
        }
        [UIView animateWithDuration:timeLonger
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [centerLabel removeFromSuperview];
                                 centerLabel = nil;
                                 [edgeImageView removeFromSuperview];
                                 edgeImageView = nil;
                                 [self.subTitleLabel removeFromSuperview];
                                 self.subTitleLabel = nil;

                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    });
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled = NO;
        [overlayWindow makeKeyAndVisible];
    }
    return overlayWindow;
}


@end
