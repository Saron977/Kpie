//
//  BYC_LoginViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LoginViewController.h"
#import "BYC_RSA.h"
#import "BYC_Tool.h"
#import "BYC_ForgetPassWordViewController.h"
#import "BYC_RegisterViewController.h"
#import "BYC_AccountModel.h"
#import "BYC_AccountTool.h"
#import "BYC_MainNavigationController.h"
#import "BYC_UMengShareTool.h"
#import "BYC_PersonalDataViewController.h"
#import "BYC_ImageFromColor.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "BYC_LoginHandler.h"
#import "UITextField+BYC_Tool.h"

@interface BYC_LoginViewController ()<UITextFieldDelegate> {
    
    __weak IBOutlet UIView *view_QQ;
    __weak IBOutlet UIView *view_WeChat;
    __weak IBOutlet NSLayoutConstraint *constraint_WeiboLeft;
    __weak IBOutlet NSLayoutConstraint *constraint_WeChatLeft;
}

@property (weak, nonatomic) IBOutlet UITextField *textField_PhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *textField_PassWord;
@property (weak, nonatomic) IBOutlet UIButton *button_Login;
/**登录成功的回调*/
@property (nonatomic, copy)  void (^success)();
@end

@implementation BYC_LoginViewController



-(instancetype)initWithSuccess:(void(^)())success {

    self = [super init];
    if (self) {
        self.success = success;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";

    
    [self initRegisterButton];
    [self exeTextFieldAction];
}

- (void)exeTextFieldAction {
    
    _textField_PhoneNum.text = QNWSUserDefaultsObjectForKey(KSTR_KLoginDefaultPhoneNum);
    if (_textField_PhoneNum.text.length > 0) [_textField_PhoneNum addTextFieldRightView];
    
    [_textField_PhoneNum.rac_textSignal subscribeNext:^(id x) {
       
        if (![_textField_PhoneNum textFieldPhoneNumberShowRightView:YES])
            _textField_PhoneNum.text  = [_textField_PhoneNum.text substringToIndex:_textField_PhoneNum.text.length - 1];
    }];
}

- (void)initRegisterButton {

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)registerAction {

    BYC_RegisterViewController *registerVC = [[BYC_RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}


#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不能有换行
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    NSString *passwordText = textField == _textField_PassWord ? toBeString:_textField_PassWord.text;     //得到密码

    //密码不能超过16位
    if (_textField_PassWord == textField) if (toBeString.length > 16) return NO;
    
    if ([BYC_Tool isMobileNumber:textField == _textField_PhoneNum?toBeString:_textField_PhoneNum.text] != 0 && passwordText.length >= 8 && passwordText.length <= 16) {
    [_button_Login setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
        _button_Login.backgroundColor = KUIColorBaseGreenNormal;
    }
    else _button_Login.backgroundColor = KUIColorBackgroundTouchDown;
    return YES;
}

- (IBAction)buttonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 1://登录
        {

            
            if (![BYC_Tool isMobileNumber:_textField_PhoneNum.text]) {
                [self.view showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
                return;
            }
            
            if (!(_textField_PassWord.text.length >= 8 && _textField_PassWord.text.length <= 16)) {
                [self.view showAndHideHUDWithTitle:@"请输入8到16位的密码" WithState:BYC_MBProgressHUDHideProgress];
                return;
            }
            
            NSDictionary *dic = @{@"cellphonenumber":_textField_PhoneNum.text,
                                  @"password":[BYC_RSA encryptString:_textField_PassWord.text],
                                  @"devicetokens":QNWSUserDefaultsObjectForKey(KSTR_KDeviceToken) == nil ? @"":QNWSUserDefaultsObjectForKey(KSTR_KDeviceToken)};
            [self requestDataWithParameters:dic type:NO];
        }
            break;
        case 2://忘记密码
        {
        
            BYC_ForgetPassWordViewController *findPassWordVC = [[BYC_ForgetPassWordViewController alloc] init];
            [self.navigationController pushViewController:findPassWordVC animated:YES];
        }
            
            break;
        case 3://QQ登录
        {
            
            if (![QQApiInterface isQQInstalled]) {
                
                [self.view showAndHideHUDWithTitle:@"您尚未安装QQ,请安装之后重试" WithState:BYC_MBProgressHUDHideProgress];
                return;
                
            }
            
            [BYC_UMengShareTool loginPlatform:UMengShareToQQ presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {

                [self requestDataWithParameters:thirdAccountDic type:YES];
            }];
            
        }
            
            break;
        case 4://微信登录
        {
            
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
                
                [self.view showAndHideHUDWithTitle:@"您尚未安装微信,请安装之后重试" WithState:BYC_MBProgressHUDHideProgress];
                return;
            }
            
            [BYC_UMengShareTool loginPlatform:UMengShareToWechatSession presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {
                
                [self requestDataWithParameters:thirdAccountDic type:YES];
            }];
            
        }
            break;
        case 5://微博登录
        {
            [BYC_UMengShareTool loginPlatform:UMengShareToSina presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {
                
                [self requestDataWithParameters:thirdAccountDic type:YES];
            }];
            
        }
            break;
            
        default:
            break;
    }
}
- (void)requestDataWithParameters:(id)parameters type:(BOOL)isThird {
    
    [BYC_LoginHandler requestDataWithParameters:parameters type:isThird success:^(AFHTTPRequestOperation *operation, BYC_AccountModel *model) {
        
        if (model.userInfo.userid.length > 0) {//userInfo信息不为空
            
            [self.navigationController popViewControllerAnimated:YES];
            QNWSBlockSafe(_success);
        }else {//userInfo信息为空需要继续完善个人资料
            
            BYC_PersonalDataViewController *personalDataVC = [[BYC_PersonalDataViewController alloc] init];
            personalDataVC.isLogin = YES;
            [self.navigationController pushViewController:personalDataVC animated:YES];
        }
        
    } failure:nil];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}

-(void)viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];

    
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && ![QQApiInterface isQQInstalled]) {
        
//        view_QQ.hidden = YES;
        view_WeChat.hidden = YES;
//        constraint_WeiboLeft.constant = 95;
        view_QQ.hidden  =   NO;
        
        
    }else if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        
        view_QQ.hidden = NO;
        view_WeChat.hidden = YES;
        
    }else if (![QQApiInterface isQQInstalled]) {
        
//        view_QQ.hidden = YES;
        view_WeChat.hidden = NO;
//        constraint_WeChatLeft.constant = 1;
        view_QQ.hidden = NO;
    }

}

@end
