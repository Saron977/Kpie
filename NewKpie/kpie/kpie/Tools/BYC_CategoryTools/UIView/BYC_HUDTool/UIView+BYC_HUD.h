//
//  UIView+BYC_HUD.h
//  kpie
//
//  Created by 元朝 on 15/11/16.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_MBProgressHUD.h"
@interface UIView (BYC_HUD)
/**显示HUD*/
- (void)showHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state;
/**显示和隐藏*/
- (void)showAndHideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState)state;
/**隐藏HUD*/
- (void)hideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state;
/**显示和隐藏并且Block回调*/
- (void)showAndHideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state completion:(void (^)(BOOL finished))completion;
/**显示和隐藏详细信息的文本，也就是可以换行并且Block回调*/
- (void)showAndHideHUDWithDetailsTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state completion:(void (^)(BOOL finished))completion;
/**带延时参数*/
- (void)showAndHideHUDWithDetailsTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state hideDelayed:(NSTimeInterval)time completion:(void (^)(BOOL))completion;


/**
 判断是否存在HUB

 @return 判断结果
 */
- (BOOL)isDisplayHUD;
@end
