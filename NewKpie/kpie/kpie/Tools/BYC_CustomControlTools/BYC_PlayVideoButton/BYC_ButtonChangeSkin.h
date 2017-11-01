//
//  BYC_ButtonChangeSkin.h
//  kpie
//
//  Created by 元朝 on 16/2/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_CheckLoginButton.h"


@interface BYC_ButtonChangeSkin : BYC_CheckLoginButton


-(void)setImageDic:(NSDictionary *)imageDic forState:(UIControlState)state;
-(void)setBackgroundImageDic:(NSDictionary *)backgroundImageDic forState:(UIControlState)state;
@end
