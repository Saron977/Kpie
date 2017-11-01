//
//  BYC_ThirdLoginBindingPhoneNumHandler.m
//  kpie
//
//  Created by 元朝 on 16/11/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ThirdLoginBindingPhoneNumHandler.h"
#import "BYC_DropHandler.h"
#import "BYC_PhoneNumberAlertView.h"
#import "BYC_Tool.h"

static CGFloat const S_HWScale = 4 / 3;
static CGFloat const S_Margin = 50;
static BOOL S_Flag = YES;//和第一次打开APP的时候的一个通知有冲突，保证只准APP打开的时候只弹一次。

@implementation BYC_ThirdLoginBindingPhoneNumHandler

+ (void)show {

    BYC_PhoneNumberAlertView *view_Alert = [BYC_PhoneNumberAlertView phoneNumberAlertView];
    [BYC_DropHandler dropHandleWithView:view_Alert setFrameOrConstraintBlock:^{
        [view_Alert mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = screenWidth - 2 * S_Margin;
            make.width.offset(width);
            make.height.offset(width * S_HWScale);
            make.center.centerOffset(CGPointMake(0, -50));
        }];
    }];
}

//第三方登录的用户才需要填写手机号码
+ (void)exeDorpAlertView:(BYC_AccountModel *)model{

    if (!S_Flag) {return;}
    S_Flag = NO;
    if (!model) return;
    if ([BYC_Tool isMobileNumber:model.cellphonenumber]) return;
    if (model.userInfo.contact.length == 0) {
        
        NSMutableDictionary *mDic = [QNWSUserDefaultsObjectForKey(KSTR_ThirdLoginBindingPhoneNum) mutableCopy];
        int count = [[mDic objectForKey:model.userInfo.userid] intValue];

        if (count < 3) {//弹三次

            [self show];
            ++count;
            [mDic setObject:@(count) forKey:model.userInfo.userid];
            QNWSUserDefaultsSetObjectForKey(mDic, KSTR_ThirdLoginBindingPhoneNum);
            QNWSUserDefaultsSynchronize;
        }
    }
}

@end
