//
//  BYC_View_MediaPlayerUI.h
//  kpie
//
//  Created by 元朝 on 16/3/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_MediaPlayerDelegate.h"

typedef NS_ENUM(NSUInteger, ENUM_ScreenOrientation) {
    
    /**未知*/
    ENUM_ScreenOrientationUnknown,
    /**竖屏*/
    ENUM_ScreenOrientationPortrait,
    /**横屏*/
    ENUM_ScreenOrientationLandscape,
    /**横屏右*/
    ENUM_ScreenOrientationLandscapeRight,
    /**横屏左*/
    ENUM_ScreenOrientationLandscapeLeft
};

@interface BYC_View_MediaPlayerUI : UIView<BYC_MediaPlayerTransport>

/**
 *  播放器一些操作功能的代理
 */
@property (weak, nonatomic) id <BYC_MediaPlayerDelegate> delegate;
/**YES: 代表用户点击的暂停*/
@property (nonatomic, assign)  BOOL                    isPauseByUser;
/**YES: 代表替换了视频连接*/
@property (nonatomic, assign)  BOOL                    isReplaceUrl;

/**顶部title按钮*/
@property (nonatomic, strong) UILabel                  *label_Top_Title;

/**
 *  是否在cell上展示
 *
 *  @param isOK YES : 是  NO ： 不是
 */
- (void)playerAboveCell:(BOOL)isOK;
@end
