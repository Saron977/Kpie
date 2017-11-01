//
//  BYC_MBProgressHUD.m
//  kpie
//
//  Created by 元朝 on 15/11/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_MBProgressHUD.h"

BYC_MBProgressHUD *my_HUD;
@interface  BYC_MBProgressHUD()<MBProgressHUDDelegate>

@end

@implementation BYC_MBProgressHUD

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        my_HUD = self;
        my_HUD.delegate = self;
    }
    return my_HUD;
}

+ (void)initHUD {

    if (!my_HUD) {
        
        my_HUD = [[BYC_MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        my_HUD.backgroundColor = KUIColorFromRGBA(0x000000, .2f);
        [[UIApplication sharedApplication].keyWindow addSubview: my_HUD];
        my_HUD.removeFromSuperViewOnHide = YES;
    }
}

+ (void)showHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState)state {

    [self initHUD];
    switch (state) {
        case BYC_MBProgressHUDShowTurnplateProgress:
            my_HUD.mode = MBProgressHUDModeIndeterminate;
            break;
            
        default:
            my_HUD.mode = MBProgressHUDModeCustomView;
            break;
    }
    my_HUD.label.text = title;
    [my_HUD showAnimated:YES];
    
}

+ (void)showAndHideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState)state hideDelayed:(NSTimeInterval)delayed{
    
    [self initHUD];
    switch (state) {
        case BYC_MBProgressHUDShowTurnplateProgress:
            my_HUD.mode = MBProgressHUDModeIndeterminate;
            break;
        default:
            my_HUD.mode = MBProgressHUDModeCustomView;
            break;
    }
    my_HUD.label.text = title;
    [my_HUD showAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [my_HUD hideAnimated:YES];
    });
    
}

/**显示和隐藏并且Block回调*/

+ (void)showAndHideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState)state hideDelayed:(NSTimeInterval)delayed completion:(void (^)(BOOL))completion {
    
    [self initHUD];
    switch (state) {
        case BYC_MBProgressHUDShowTurnplateProgress:
            my_HUD.mode = MBProgressHUDModeIndeterminate;
            break;
        default:
            my_HUD.mode = MBProgressHUDModeCustomView;
            break;
    }
    my_HUD.label.text = title;
    [my_HUD showAnimated:YES];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [my_HUD hideAnimated:YES];
        QNWSBlockSafe(completion,YES);
    });
    
}

/**显示和隐藏详细信息的文本，也就是可以换行并且Block回调*/
+ (void)showAndHideHUDWithDetailsTitle:(NSString *)title WithState:(BYC_MBProgressHUDState)state hideDelayed:(NSTimeInterval)delayed completion:(void (^)(BOOL))completion {
    
    [self initHUD];
    switch (state) {
        case BYC_MBProgressHUDShowTurnplateProgress:
            my_HUD.mode = MBProgressHUDModeIndeterminate;
            break;
        default:
            my_HUD.mode = MBProgressHUDModeCustomView;
            break;
    }
    my_HUD.label.text = title;
    [my_HUD showAnimated:YES];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [my_HUD hideAnimated:YES];
        QNWSBlockSafe(completion,YES);
    });
    
}

+ (void)hideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state {
    //可以自定义customView
//    my_HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.png"]];
    switch (state) {
        case BYC_MBProgressHUDShowTurnplateProgress:
            my_HUD.mode = MBProgressHUDModeIndeterminate;
            break;
        default:
            my_HUD.mode = MBProgressHUDModeCustomView;
            break;
    }
    my_HUD.label.text = title;
    [my_HUD hideAnimated:YES afterDelay:1.5];

}


#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {

    [my_HUD removeFromSuperview];
    my_HUD = nil;
}

-(void)dealloc {
    
    my_HUD = nil;
}
@end
