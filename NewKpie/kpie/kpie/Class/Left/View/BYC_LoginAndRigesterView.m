//
//  BYC_LoginAndRigesterView.m
//  kpie
//
//  Created by 元朝 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LoginAndRigesterView.h"
#import "BYC_LoginViewController.h"
#import "BYC_RegisterViewController.h"
#import "BYC_UserAgreementViewController.h"
#import "BYC_MainNavigationController.h"
#import "BYC_UMengShareTool.h"
#import "BYC_AccountModel.h"
#import "BYC_AccountTool.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

static BYC_LoginAndRigesterView *LRView;
@interface BYC_LoginAndRigesterView()<UMSocialUIDelegate> {

    __weak IBOutlet UIView *view_QQ;
    __weak IBOutlet UIView *view_WeChat;
    __weak IBOutlet UIView *view_Weibo;

    __weak IBOutlet NSLayoutConstraint *constraint_WeChatLeft;

    __weak IBOutlet NSLayoutConstraint *constraint_WeiboLeft;
    
    
}



@end
@implementation BYC_LoginAndRigesterView

-(void)awakeFromNib {

    [super awakeFromNib];


}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    [self disappearView];
    
}
- (void)disappearView {

    [LRView removeFromSuperview];
    LRView = nil;
}

-(void)dealloc {

    [self disappearView];
    QNWSLog(@"%@类 死了",[self class]);
}

+(void)shareLoginAndRigesterView {

    if (!LRView) {
        
        LRView = [[NSBundle mainBundle] loadNibNamed:@"BYC_LoginAndRigesterView" owner:nil options:nil][0];
        LRView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        LRView.backgroundColor = KUIColorFromRGBA(0x000000, .5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:LRView action:@selector(disappearView)];
        [LRView addGestureRecognizer:tap];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:LRView];
}

- (IBAction)btnActions:(UIButton *)sender {

    switch (sender.tag) {
        case 1:
            [self disappearView];
            break;
        case 2://QQ登录
        {
        
            if (![QQApiInterface isQQInstalled]) {
                
                return;
                
            }
            
            [BYC_UMengShareTool loginPlatform:UMengShareToQQ presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {
                
                [self requestDataWithUrl:KQNWS_WQWThirdLoginUserUrl parameters:thirdAccountDic type:0];
            }];
            
        }
            break;
        case 3://微信登录
        {
            
            if (![WXApi isWXAppInstalled]) {
            
                return;
            }
            [BYC_UMengShareTool loginPlatform:UMengShareToWechatSession presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {
                
                [self requestDataWithUrl:KQNWS_WQWThirdLoginUserUrl parameters:thirdAccountDic type:0];
            }];
        }
            break;
        case 4://微博登录
        {
            [BYC_UMengShareTool loginPlatform:UMengShareToSina presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {
                
                [self requestDataWithUrl:KQNWS_WQWThirdLoginUserUrl parameters:thirdAccountDic type:0];
            }];
            
        }
            break;
        case 5://手机登录
        {
            BYC_LoginViewController *loginVC = [[BYC_LoginViewController alloc] init];
            [KMainNavigationVC pushViewController:loginVC animated:YES];
        }
            break;
        case 6://用户协议
        {
            BYC_UserAgreementViewController *userAgreementVC = [[BYC_UserAgreementViewController alloc] init];
            [KMainNavigationVC pushViewController:userAgreementVC animated:YES ];
        }
            break;
        case 7://注册
        {
            BYC_RegisterViewController *registerVC = [[BYC_RegisterViewController alloc] init];
            [KMainNavigationVC pushViewController:registerVC animated:YES];
        }

            break;
            
        default:
            break;
    }
    
    [self disappearView];

}

- (void)requestDataWithUrl:(NSString *)url parameters:(id)parameters type:(NSInteger)integer {
    
    [self showHUDWithTitle:@"正在努力登录中..." WithState:BYC_MBProgressHUDShowTurnplateProgress];
    [BYC_HttpServers Post:url parameters:parameters success:^(id responseObject) {
        
        //结果反馈
        NSInteger result = [responseObject[@"result"] intValue];
        
        switch (integer) {
            case 0://登录
            {
                
                switch (result) {
                    case 0:
                    {
                        
                        //把账户模型归档
                        BYC_AccountModel *userModel = [BYC_AccountModel userAccountWithDict:responseObject];
                        [BYC_AccountTool saveAccount:userModel];
                        [self hideHUDWithTitle:@"登录成功啦😁(＞﹏＜)" WithState:BYC_MBProgressHUDHideProgress];
                    }
                        break;
                        
                    case 6:
                    {
                        
                        [self hideHUDWithTitle:@"用户名或密码错误，再试一次吧☺️..." WithState:BYC_MBProgressHUDHideProgress];
                    }
                        break;
                        
                    default:
                        [self hideHUDWithTitle:@"登录失败..." WithState:BYC_MBProgressHUDHideProgress];
                        break;
                }
                
            }
                break;
                
            default:
            {
                
            }
                break;
        }
        
    } failure:^(NSError *error) {
        
        [self showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
//        [self hideHUDWithTitle:@"登录失败了，再试一次吧☺️..." WithState:BYC_MBProgressHUDHideProgress];
    }];
}

-(void)layoutSubviews {

    [super layoutSubviews];
    
    
    if (![WXApi isWXAppInstalled] && ![QQApiInterface isQQInstalled]) {
        
        view_QQ.hidden = YES;
        view_WeChat.hidden = YES;
        constraint_WeiboLeft.constant = 71;
        
    }else if (![WXApi isWXAppInstalled]) {
        
        view_QQ.hidden = NO;
        view_WeChat.hidden = YES;
        
    }else if (![QQApiInterface isQQInstalled]) {
        
        view_QQ.hidden = YES;
        view_WeChat.hidden = NO;
        constraint_WeChatLeft.constant = 1;
    }
}



@end
