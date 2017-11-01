//
//  WX_ProgressHUD.h
//  kpie
//
//  Created by 王傲擎 on 15/12/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

//#define sheme_white
#define sheme_black
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:16]
//-------------------------------------------------------------------------------------------------------------------------------------------------
#ifdef sheme_white
#define HUD_STATUS_COLOR		[UIColor whiteColor]
#define HUD_SPINNER_COLOR		[UIColor whiteColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:1.0 alpha:0.8]
#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"ProgressHUD.bundle/success-white.png"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"ProgressHUD.bundle/error-white.png"]
#endif
//-------------------------------------------------------------------------------------------------------------------------------------------------
#ifdef sheme_black
#define HUD_STATUS_COLOR		[UIColor blackColor]
#define HUD_SPINNER_COLOR		[UIColor blackColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0.8 alpha:0.3]
#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"ProgressHUD.bundle/success-black.png"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"ProgressHUD.bundle/error-black.png"]
#endif
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------

@interface WX_ProgressHUD : UIView
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (WX_ProgressHUD *)shared;

+ (void)dismiss;
+ (void)show:(NSString *)status;
+ (void)showSuccess:(NSString *)status;
+ (void)showError:(NSString *)status;

@property (atomic, strong) UIWindow *window;
@property (atomic, strong) UIToolbar *hud;
@property (atomic, strong) UIActivityIndicatorView *spinner;
@property (atomic, strong) UIImageView *image;
@property (atomic, strong) UILabel *label;
@end
