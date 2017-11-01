//
//  UIView+BYC_HUD.m
//  kpie
//
//  Created by 元朝 on 15/11/16.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "UIView+BYC_HUD.h"
UIKIT_EXTERN BYC_MBProgressHUD *my_HUD;

@implementation UIView (BYC_HUD)
- (void)showHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state {
    
    [BYC_MBProgressHUD showHUDWithTitle:title WithState:state];
}

- (void)hideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state {
    
    [BYC_MBProgressHUD hideHUDWithTitle:title WithState:state];
}

- (void)showAndHideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState)state {

    [BYC_MBProgressHUD showAndHideHUDWithTitle:title WithState:state hideDelayed:1.f];
}

/**显示和隐藏并且Block回调*/
- (void)showAndHideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state completion:(void (^)(BOOL))completion {

    [BYC_MBProgressHUD showAndHideHUDWithTitle:title WithState:state hideDelayed:1.f completion:^(BOOL finished) {
        QNWSBlockSafe(completion,finished);
    }];
}

/**显示和隐藏详细信息的文本，也就是可以换行并且Block回调*/
- (void)showAndHideHUDWithDetailsTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state completion:(void (^)(BOOL))completion {
    
    [self showAndHideHUDWithDetailsTitle:title WithState:state hideDelayed:2.f completion:^(BOOL finished) {
        QNWSBlockSafe(completion,finished);
    }];
}


/**显示和隐藏详细信息的文本，也就是可以换行并且Block回调*/
- (void)showAndHideHUDWithDetailsTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state hideDelayed:(NSTimeInterval)time completion:(void (^)(BOOL))completion {
    
    [BYC_MBProgressHUD showAndHideHUDWithDetailsTitle:title WithState:state hideDelayed:time completion:^(BOOL finished) {
        QNWSBlockSafe(completion,finished);
    }];
}

- (BOOL)isDisplayHUD {

    if (my_HUD) return YES;
    else return NO;
}
@end
