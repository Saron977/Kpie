//
//  BYC_RegisterViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_RegisterViewController.h"
#import "BYC_UserAgreementViewController.h"
#import "BYC_RSA.h"
#import "BYC_Tool.h"
#import "BYC_PersonalDataViewController.h"
#import "BYC_AccountTool.h"
#import "BYC_ImageFromColor.h"
#import "BYC_TimerTools.h"
#import "BYC_PropertyManager.h"
#import "BYC_HttpServers+BYC_Account.h"
#import "UITextField+BYC_Tool.h"

@interface BYC_RegisterViewController ()<UITextFieldDelegate>
/**手机号码*/
@property (weak, nonatomic  ) IBOutlet UITextField *textField_PhoneNum;
/**密码*/
@property (weak, nonatomic  ) IBOutlet UITextField *textField_PassWord;
/**注册按钮*/
@property (weak, nonatomic  ) IBOutlet UIButton    *button_Register;
/**验证码*/
@property (weak, nonatomic  ) IBOutlet UITextField *textField_VerificationCode;
/**获取验证码按钮*/
@property (weak, nonatomic  ) IBOutlet UIButton    *button_GetVerificationCode;

//判断密文
@property (strong, nonatomic) NSString    *SignString;
@property (weak, nonatomic  ) IBOutlet UIButton    *button_selectAgree;
@end

@implementation BYC_RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    [self exeTextFieldAction];
}

- (void)exeTextFieldAction {
    
    [_textField_PhoneNum.rac_textSignal subscribeNext:^(id x) {
        
        if (![_textField_PhoneNum textFieldPhoneNumberShowRightView:YES])
            _textField_PhoneNum.text  = [_textField_PhoneNum.text substringToIndex:_textField_PhoneNum.text.length - 1];
    }];
}

- (void)requestDataWithUrl:(NSString *)url parameters:(id)parameters type:(NSInteger)integer {
    
    [self.view showHUDWithTitle: integer == 0 ? @"正在发送验证码" :  @"注册中..."  WithState:BYC_MBProgressHUDHideProgress];
        
        switch (integer) {
            case 0://发送验证码
            {
                
                [BYC_HttpServers requestSendSmsDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation) {
                    
                    if (self.view.isDisplayHUD)
                        [self.view showAndHideHUDWithTitle:@"验证码发送成功" WithState:0];
                    [BYC_TimerTools<UIButton *> GCDTimerWithObject:_button_GetVerificationCode];
                    
                } failure:nil];
            }
                break;
            case 1://注册
            {
                
                [BYC_HttpServers requestRegisterAccountDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation, BYC_AccountModel *model) {
                    
                    if (self.view.isDisplayHUD)
                        [self.view showAndHideHUDWithTitle:@"注册成功" WithState:0];
                    //把账户模型归档
                    [BYC_AccountTool saveAccount:model];
                    BYC_PersonalDataViewController *personalDataVC = [[BYC_PersonalDataViewController alloc] init];
                    personalDataVC.isRegistered = YES;
                    [self.navigationController pushViewController:personalDataVC animated:YES];
                    
                } failure:nil];
                
            }
                break;
            default:
                break;
        }
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
            NSDictionary *dic = [BYC_Tool encryptionPhoneNum:_textField_PhoneNum.text isRegister:YES];
            [self requestDataWithUrl:KQNWS_SendSmsUrl parameters:dic type:0];
        }
            
            break;
        case 2://注册
        {

            if (![BYC_Tool isMobileNumber:_textField_PhoneNum.text]) {
                [self.view showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
                return;
            }
            
            if (!(_textField_PassWord.text.length >= 8 && _textField_PassWord.text.length <= 16)) {
                [self.view showAndHideHUDWithTitle:@"请输入8到16位的密码" WithState:BYC_MBProgressHUDHideProgress];
                return;
            }
            
            if (!(_textField_VerificationCode.text.length == 6) ) {
                [self.view showAndHideHUDWithTitle:@"请输入6位数验证码" WithState:BYC_MBProgressHUDHideProgress];
                return;
            }
            if (!_button_selectAgree.selected) {
                [self.view showAndHideHUDWithTitle:@"您暂未同意《用户协议》" WithState:BYC_MBProgressHUDHideProgress];
                return;
            }
            
            NSDictionary *dic = @{@"cellphonenumber":_textField_PhoneNum.text,@"password":[BYC_RSA encryptString:_textField_PassWord.text],@"validatecode":_textField_VerificationCode.text};
            
            [self requestDataWithUrl:KQNWS_RegisterUserUrl parameters:dic type:1];
        }
            
            break;
        case 3://用户协议
        {
        
            BYC_UserAgreementViewController *userAgreementVC = [[BYC_UserAgreementViewController alloc] init];
            [self.navigationController pushViewController:userAgreementVC animated:YES];
        }
            break;
        case 4://是否同意用户协议
        {
            
            if (!sender.selected) sender.selected = YES;
            else sender.selected = NO;
            
            if ([BYC_Tool isMobileNumber:_textField_PhoneNum.text] != 0 && _textField_PassWord.text.length >= 8 && _textField_PassWord.text.length <= 16 && _textField_VerificationCode.text.length == 6 && _button_selectAgree.selected) {
                [_button_Register setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
                _button_Register.backgroundColor = KUIColorBaseGreenNormal;
            }else _button_Register.backgroundColor = KUIColorFromRGB(0XDEDEDE);
        }
            
            break;
            
        default:
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
    NSString *verificationCodeText = textField == _textField_VerificationCode?toBeString:_textField_VerificationCode.text;     //得到密码

    //密码不能超过16位
    if (_textField_PassWord == textField) {
        if (toBeString.length > 16)return NO;
    }
    
    //验证码不能超过6位
    if (_textField_VerificationCode == textField) {
        if (toBeString.length > 6)return NO;
    }

    if ([BYC_Tool isMobileNumber:textField == _textField_PhoneNum?toBeString:_textField_PhoneNum.text] != 0 && passwordText.length >= 8 && passwordText.length <= 16 && verificationCodeText.length == 6 && _button_selectAgree.selected) {
        [_button_Register setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
        _button_Register.backgroundColor = KUIColorBaseGreenNormal;
    }else _button_Register.backgroundColor = KUIColorBackgroundTouchDown;
    return YES;
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}


@end
