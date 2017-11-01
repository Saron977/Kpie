//
//  BYC_ShowTitleOnWindow.h
//  kpie
//
//  Created by 元朝 on 16/4/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYC_ShowTitleOnWindow : UIWindow

/**
 *  系统键盘提醒
 *
 *  @param cuewords 提醒语
 */
+ (void)showAnimationKeyBoardCuewords:(NSString *)cuewords;

@end
