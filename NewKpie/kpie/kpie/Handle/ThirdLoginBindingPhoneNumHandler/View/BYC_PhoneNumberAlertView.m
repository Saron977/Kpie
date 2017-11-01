//
//  BYC_PhoneNumberAlertView.m
//  kpie
//
//  Created by 元朝 on 16/11/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_PhoneNumberAlertView.h"
#import "UITextField+BYC_Tool.h"
#import "BYC_Tool.h"
#import "BYC_HttpServers+BYC_ThirdLoginBindingPhoneNum.h"
#import "BYC_AccountTool.h"

UIKIT_EXTERN NSString * const Notification_DismissAnimation;

@interface BYC_PhoneNumberAlertView ()

@property (weak, nonatomic) IBOutlet UITextField *textF_PhoneNum;

@end

@implementation BYC_PhoneNumberAlertView

- (void)awakeFromNib {

    [super awakeFromNib];
    [self exeTextFieldAction];
}

+ (instancetype)phoneNumberAlertView {

    return [[[NSBundle mainBundle] loadNibNamed:@"BYC_PhoneNumberAlertView" owner:nil options:nil] firstObject];
}

- (void)exeTextFieldAction {
    
    [_textF_PhoneNum.rac_textSignal subscribeNext:^(id x) {
        
        if (_textF_PhoneNum.isFirstResponder) {
            
            if (![_textF_PhoneNum textFieldPhoneNumberShowRightView:YES])
                _textF_PhoneNum.text  = [_textF_PhoneNum.text substringToIndex:_textF_PhoneNum.text.length - 1];
        }
    }];
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    [QNWSNotificationCenter postNotificationName:Notification_DismissAnimation object:nil];
}

- (IBAction)makeSureAction:(UIButton *)sender {
    
    if (_textF_PhoneNum.text.length != 11 || ![BYC_Tool isMobileNumber:_textF_PhoneNum.text]) {
    
        QNWSShowAndHideHUD(@"请输入正确的手机号码", 0);
        return;
    }
    
    [BYC_HttpServers requestThirdLoginBindingPhoneNumWithParameters:@[[BYC_AccountTool userAccount].userid,_textF_PhoneNum.text] success:^(AFHTTPRequestOperation *operation) {
        
        
        [BYC_AccountTool userAccount].userInfo.contact = _textF_PhoneNum.text;
        [self cancelAction:nil];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self cancelAction:nil];
    }];
}


@end
