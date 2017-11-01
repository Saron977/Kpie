//
//  BYC_BaseButton.m
//  kpie
//
//  Created by 元朝 on 16/4/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseButton.h"
#import "BYC_ImageFromColor.h"

@interface BYC_BaseButton()

@end

@implementation BYC_BaseButton

+(instancetype)buttonWithType:(UIButtonType)buttonType WithFrame:(CGRect)rect{

    BYC_BaseButton *button = (BYC_BaseButton *)[UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:rect] forState:UIControlStateHighlighted];
    [button setTitleColor:KUIColorFromRGB(0X4BC8BD) forState:UIControlStateHighlighted];
    return button;
}

@end
