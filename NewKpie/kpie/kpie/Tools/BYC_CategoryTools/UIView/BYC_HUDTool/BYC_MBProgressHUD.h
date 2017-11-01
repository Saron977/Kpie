//
//  BYC_MBProgressHUD.h
//  kpie
//
//  Created by 元朝 on 15/11/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "MBProgressHUD.h"

typedef enum : NSUInteger {
    
    BYC_MBProgressHUDHideProgress = 0,//无旋转盘
    BYC_MBProgressHUDShowTurnplateProgress ,//旋转盘

}BYC_MBProgressHUDState;

@interface BYC_MBProgressHUD : MBProgressHUD
/**显示HUD*/
+ (void)showHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state;
/**隐藏HUD*/
+ (void)hideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state;
/**显示和隐藏*/
+ (void)showAndHideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state hideDelayed:(NSTimeInterval)delayed;
/**显示和隐藏并且Block回调*/
+ (void)showAndHideHUDWithTitle:(NSString *)title WithState:(BYC_MBProgressHUDState )state hideDelayed:(NSTimeInterval)delayed completion:(void (^)(BOOL finished))completion;
/**显示和隐藏详细信息的文本，也就是可以换行并且Block回调*/
+ (void)showAndHideHUDWithDetailsTitle:(NSString *)title WithState:(BYC_MBProgressHUDState)state hideDelayed:(NSTimeInterval)delayed completion:(void (^)(BOOL finished))completion;
@end
