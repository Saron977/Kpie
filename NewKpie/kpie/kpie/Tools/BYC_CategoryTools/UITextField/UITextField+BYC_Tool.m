//
//  UITextField+BYC_Tool.m
//  kpie
//
//  Created by 元朝 on 16/11/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "UITextField+BYC_Tool.h"
#import "BYC_Tool.h"

@implementation UITextField (BYC_Tool)

- (BOOL)textFieldPhoneNumberShowRightView:(BOOL)flag{

    if (self.text.length > 11) {
        
        return NO;
    }else {
        
        if (self.text.length == 11 && ![BYC_Tool isMobileNumber:self.text]) QNWSShowAndHideHUD(@"请输入正确的手机号码", 0);
        if (self.text.length > 0 && flag) [self addTextFieldRightView];
        else self.rightView = nil;
    }
    return YES;
}

- (void)addTextFieldRightView {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"iconfont-shanchu"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 45, 45);
    CGRect rect = rightButton.frame;
    rect.size.width += 20;
    rightButton.frame = rect;
    rightButton.contentMode = UIViewContentModeCenter;
    self.rightView     = rightButton;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)clearButtonAction:(UIButton *)button {
    
    self.text = @"";
    self.rightView = nil;
}

@end
