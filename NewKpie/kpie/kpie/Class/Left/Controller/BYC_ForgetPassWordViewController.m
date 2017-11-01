//
//  BYC_ForgetPassWordViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_ForgetPassWordViewController.h"
#import "BYC_Tool.h"
#import "BYC_AccountTool.h"
#import "BYC_AccountModel.h"
#import "BYC_RSA.h"
#import "BYC_TimerTools.h"
#import "BYC_PropertyManager.h"
#import "BYC_HttpServers+HL_ForgetPassWordVC.h"
#import "BYC_HttpServers+BYC_Account.h"

@interface BYC_ForgetPassWordViewController ()<UITextFieldDelegate> {
    
    dispatch_source_t _timer;
}
/**
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *textField_PhoneNum;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *textField_PassWord;
/**
 *  再次密码
 */
@property (weak, nonatomic) IBOutlet UITextField *textField_AgainPassWord;
/**
 *  找回按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *button_Register;
/**
 *  验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *textField_VerificationCode;
/**
 *  获取验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *button_GetVerificationCode;
@end

@implementation BYC_ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
}

#pragma mark - 点击事件
- (IBAction)buttonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    switch (sender.tag) {
        case 1://获取验证码
        {
        
            if (![BYC_Tool isMobileNumber:_textField_PhoneNum.text]) {
                [self.view showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
                return;
            }
            
            [BYC_PropertyManager sharedBYC_PropertyManager].isMessageVerification = YES;
            NSDictionary *dic = [BYC_Tool encryptionPhoneNum:_textField_PhoneNum.text isRegister:NO];
            [self requestDataWithParameters:dic type:0];
        }
            
            break;
        case 2://找回按钮
        {
            NSDictionary *dic = @{@"cellphonenumber":_textField_PhoneNum.text,
                                  @"password":[BYC_RSA encryptString:_textField_AgainPassWord.text],
                                  @"validatecode":_textField_VerificationCode.text};
            [self requestDataWithParameters:dic type:1];

        }
            
            break;
        default:
            break;
    }
}

- (void)requestDataWithParameters:(id)parameters type:(NSInteger)integer {
    
    [self.view showHUDWithTitle:integer == 0 ? @"正在发送验证码" : @"正在找回密码" WithState:BYC_MBProgressHUDShowTurnplateProgress];
        switch (integer) {
            case 0://发送验证码
            {
                
                [BYC_HttpServers requestSendSmsDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation) {
                    [self.view showHUDWithTitle:@"正在发送验证码" WithState:BYC_MBProgressHUDShowTurnplateProgress];
                    if (self.view.isDisplayHUD)
                        [self.view showAndHideHUDWithTitle:@"验证码发送成功" WithState:0];
                    [BYC_TimerTools<UIButton *> GCDTimerWithObject:_button_GetVerificationCode];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
            }
                break;
            case 1://找回密码
            {
                [BYC_HttpServers requestForgetPassWordWithParameters:parameters success:^(AFHTTPRequestOperation *operation) {
                    [self.view hideHUDWithTitle:@"成功找回,请继续登录" WithState:BYC_MBProgressHUDHideProgress];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
                break;
            default:
            {
                
            }
                break;
        }
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不能有换行
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    NSString *passwordText = textField == _textField_PassWord?toBeString:_textField_PassWord.text;     //得到密码
    NSString *againPasswordText = textField == _textField_AgainPassWord?toBeString:_textField_AgainPassWord.text;     //得到确认密码
    NSString *verificationCodeText = textField == _textField_VerificationCode?toBeString:_textField_VerificationCode.text;     //得到密码
    
    //手机号不能超过11位
    if (_textField_PhoneNum == textField) {
        if (toBeString.length > 11) {
            
            return NO;
        }else {
            
            if (toBeString.length == 11 && [BYC_Tool isMobileNumber:textField == _textField_PhoneNum?toBeString:_textField_PhoneNum.text] == 0) {
                
                [self.view showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
            }
            
        }
    }
    
    
    //密码不能超过16位
    if (_textField_PassWord == textField) {
        if (toBeString.length > 16) {
            
            return NO;
        }
    }
    
    //密码不能超过16位
    if (_textField_AgainPassWord == textField) {
        if (toBeString.length > 16) {
            
            return NO;
        }
    }
    
    if (_textField_AgainPassWord == textField && string.length > 0) {
        
        
        
        if (againPasswordText.length == passwordText.length) {
        
            if (![againPasswordText isEqualToString:passwordText]) {
                [self.view showAndHideHUDWithTitle:@"两次密码输入不一致" WithState:BYC_MBProgressHUDHideProgress];
                return NO;
            }
        }
        
        if (againPasswordText.length > passwordText.length) {
            
            if (![againPasswordText isEqualToString:passwordText]) {
                [self.view showAndHideHUDWithTitle:@"不能超过上面输入的密码" WithState:BYC_MBProgressHUDHideProgress];
                return NO;
            }
        }
        
    }
    
    //验证码不能超过6位
    if (_textField_VerificationCode == textField) {
        if (toBeString.length > 6) {
            
            return NO;
        }
    }
    
    if ([BYC_Tool isMobileNumber:textField == _textField_PhoneNum?toBeString:_textField_PhoneNum.text] != 0 && passwordText.length >= 8 && passwordText.length <= 16 && verificationCodeText.length == 6 && [passwordText isEqualToString:againPasswordText]) {
        _button_Register.backgroundColor = KUIColorBaseGreenNormal;
        _button_Register.userInteractionEnabled = YES;
        
    }else{
        _button_Register.backgroundColor = KUIColorBackgroundTouchDown;
        _button_Register.userInteractionEnabled = NO;
        
    }
    return YES;
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}
@end
