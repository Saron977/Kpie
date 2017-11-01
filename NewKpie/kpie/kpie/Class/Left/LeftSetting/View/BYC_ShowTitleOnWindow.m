//
//  BYC_ShowTitleOnWindow.m
//  kpie
//
//  Created by 元朝 on 16/4/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ShowTitleOnWindow.h"

static  BYC_ShowTitleOnWindow *window;
@implementation BYC_ShowTitleOnWindow

/**
 *  系统键盘提醒
 *
 *  @param cuewords 提醒语
 */
+ (void)showAnimationKeyBoardCuewords:(NSString *)cuewords {
    
    
    if (window == nil) {

        window = [[BYC_ShowTitleOnWindow alloc] initWithFrame:CGRectMake(0, screenHeight/ 2.0, screenWidth, screenHeight/ 2.0)];
        window.windowLevel = MAXFLOAT;
        window.hidden = NO;
        window.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, (screenHeight / 2.0 - 30) / 2.0, window.ksize.width - 40, 30)];
        label.layer.cornerRadius = 3.f;
        label.backgroundColor = KUIColorFromRGBA(0x000000, .8f);
        label.text = cuewords;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [window addSubview:label];
    }
    window.alpha = 0;
    [UIView animateWithDuration:.35f animations:^{
        window.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.75f animations:^{
            window.alpha = 0;
        } completion:^(BOOL finished) {
            [window removeFromSuperview];
            window = nil;
        }];
    }];
}


@end
