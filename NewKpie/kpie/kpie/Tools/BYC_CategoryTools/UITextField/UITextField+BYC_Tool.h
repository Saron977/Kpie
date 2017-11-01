//
//  UITextField+BYC_Tool.h
//  kpie
//
//  Created by 元朝 on 16/11/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (BYC_Tool)

/**
 * 手机号码验证,是否需要右侧删除视图
 */
- (BOOL)textFieldPhoneNumberShowRightView:(BOOL)flag;

/**
 * 增加删除按钮
 */
- (void)addTextFieldRightView;
@end
