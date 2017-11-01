//
//  HL_BindPhoneNumberView.m
//  kpie
//
//  Created by sunheli on 16/9/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_BindPhoneNumberView.h"
#import "BYC_Tool.h"

@interface HL_BindPhoneNumberView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField_PhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textField_Code;

@end
@implementation HL_BindPhoneNumberView

- (IBAction)touchAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
            //获取验证码
            [self getVcode];
            break;
        case 2:
            //跳过绑定手机号
            [self skipBindPhone];
            break;
        case 3:
            //确定完成绑定
            [self completeBindPhone];
            break;
            
        default:
            break;
    }
    
}

-(void)getVcode{
    
    if (![BYC_Tool isMobileNumber:self.textField_PhoneNumber.text]) {
        [self showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }
}

-(void)skipBindPhone{
    
}

-(void)completeBindPhone{
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 10:
            self.textField_PhoneNumber.text = textField.text;
            break;
          case 11:
            self.textField_Code.text = textField.text;
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
    NSString *textFieldStr = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    NSString *phoneNumText = textField == self.textField_PhoneNumber ? textFieldStr:self.textField_PhoneNumber.text;//获得手机号
//    NSString *vCodeText = textField == self.textField_Code ? textFieldStr:self.textField_Code.text;     //得到验证码
    
    //手机号不能超过11位
    if (self.textField_PhoneNumber == textField) {
        if (textFieldStr.length > 11)return NO;
        else {
            
            if (textFieldStr.length == 11 && [BYC_Tool isMobileNumber:textField == self.textField_PhoneNumber ? textFieldStr:self.textField_PhoneNumber.text] == NO)
                [self showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
        }
    }
    
    //验证码不能超过6位
    if (self.textField_Code == textField) {
        if (textFieldStr.length > 6)return NO;
    }
    return YES;
}



@end
