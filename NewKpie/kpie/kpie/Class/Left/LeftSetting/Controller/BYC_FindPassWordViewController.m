//
//  BYC_FindPassWordViewController.m
//  kpie
//
//  Created by 元朝 on 15/12/29.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_FindPassWordViewController.h"
#import "BYC_RSA.h"
#import "BYC_ImageFromColor.h"
#import "BYC_HttpServers+BYC_Account.h"

@interface BYC_FindPassWordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField_OriginalPassWord;
@property (weak, nonatomic) IBOutlet UITextField *textField_NewPassWord1;
@property (weak, nonatomic) IBOutlet UITextField *textField_NewPassWord2;

@property (weak, nonatomic) IBOutlet UIButton *button_Find;


@end

@implementation BYC_FindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改密码";
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不能有换行
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    NSString *originalPassWord = textField == _textField_OriginalPassWord?toBeString:_textField_OriginalPassWord.text;     //得到密码
    NSString *NewPassWord1 = textField == _textField_NewPassWord1?toBeString:_textField_NewPassWord1.text;     //得到密码
    NSString *NewPassWord2 = textField == _textField_NewPassWord2?toBeString:_textField_NewPassWord2.text;     //得到确认密码
    
    //原密码不能超过16位
    if (_textField_OriginalPassWord == textField) {
        if (toBeString.length > 16) {
            
            return NO;
        }
    }
    
    //新密码不能超过16位
    if (_textField_NewPassWord1 == textField) {
        if (toBeString.length > 16) {
            
            return NO;
        }
    }
    
    //新密码不能超过16位
    if (_textField_NewPassWord2 == textField) {
        if (toBeString.length > 16) {
            
            return NO;
        }
    }
    
    if (originalPassWord.length >= 8 && originalPassWord.length <= 16 && NewPassWord1.length >= 8 && NewPassWord1.length <= 16 && [NewPassWord1 isEqualToString:NewPassWord2]) {
        [_button_Find setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
        _button_Find.backgroundColor = KUIColorBaseGreenNormal;
    }else _button_Find.backgroundColor = KUIColorFromRGB(0X111111);
    return YES;
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    
    if (!(_textField_OriginalPassWord.text.length >= 8 && _textField_OriginalPassWord.text.length <= 16)) {
        
        [self.view showAndHideHUDWithTitle:@"原密码不符合规范" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }

    if (!(_textField_NewPassWord1.text.length >= 8 && _textField_NewPassWord1.text.length <= 16)) {
        
        [self.view showAndHideHUDWithTitle:@"新密码不规范" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }

    if (![_textField_NewPassWord1.text isEqualToString:_textField_NewPassWord2.text]) {
        
        [self.view showAndHideHUDWithTitle:@"新密码不一致" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }

    NSDictionary *parameters = @{@"userId":[BYC_AccountTool userAccount].userid,@"oldPassword":[BYC_RSA encryptString:_textField_OriginalPassWord.text],@"password":[BYC_RSA encryptString:_textField_NewPassWord1.text]};
    
    [BYC_HttpServers requestChangePassWordDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation) {
        
        if (self.view.isDisplayHUD)
            [self.view showAndHideHUDWithTitle:@"密码更改成功" WithState:0];
       [self.navigationController popViewControllerAnimated:YES];
        
    } failure:nil];
    

}

@end
