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
#import "BYC_LoginHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>

static BYC_LoginAndRigesterView *LRView;
@interface BYC_LoginAndRigesterView() {

    __weak IBOutlet UIView *view_QQ;
    __weak IBOutlet UIView *view_WeChat;
    __weak IBOutlet UIView *view_Weibo;

    __weak IBOutlet NSLayoutConstraint *constraint_WeChatLeft;

    __weak IBOutlet NSLayoutConstraint *constraint_WeiboLeft;
}

/**登录成功的回调*/
@property (nonatomic, copy)  void (^success)();
/**登录失败的回调*/
@property (nonatomic, weak)  void (^failure)();

/**回调*/
@property (nonatomic, copy)  void (^block)();

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
    QNWSBlockSafe(_failure);
}

+(void)removeAppearView
{
    if (LRView) {
        [LRView removeFromSuperview];
        LRView = nil;
        QNWSLog(@"%@类 死了",[self class]);
    }
}


-(void)dealloc {

    [self disappearView];
    _success = nil;
    QNWSLog(@"%@类 死了",[self class]);
}

+(void)checkLoginStateBlock:(void(^)(BOOL isLogin))block {

    //未登录跳转去登录
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterViewSuccess:^{
            QNWSBlockSafe(block, YES);
        } failure:nil];
    }else QNWSBlockSafe(block, NO);
}
+(void)shareLoginAndRigesterViewSuccess:(void(^)())success failure:(void(^)())failure{

    if (!LRView) {
        
        LRView = [[NSBundle mainBundle] loadNibNamed:@"BYC_LoginAndRigesterView" owner:nil options:nil][0];
        LRView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        LRView.backgroundColor = KUIColorFromRGBA(0x000000, .5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:LRView action:@selector(disappearView)];
        [LRView addGestureRecognizer:tap];
        LRView.success = success;
        LRView.failure = failure;
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
                [WX_TencentTool WX_loginTencentPlatform:WX_Tencent_QQ presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {
                    if (thirdAccountDic) {
                        [self requestDataWithParameters:thirdAccountDic type:YES];
                    }
                }];
                
                [self disappearView];
                
                return;
                
            }
            
            [BYC_UMengShareTool loginPlatform:UMengShareToQQ presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {

                [self requestDataWithParameters:thirdAccountDic type:YES];
            }];
            
        }
            break;
        case 3://微信登录
        {
            
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
            
                return;
            }
            [BYC_UMengShareTool loginPlatform:UMengShareToWechatSession presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {
                
                [self requestDataWithParameters:thirdAccountDic type:YES];
            }];
        }
            break;
        case 4://微博登录
        {
            [BYC_UMengShareTool loginPlatform:UMengShareToSina presentingController:self thirdAccountDictionary:^(NSDictionary *thirdAccountDic) {
                
                [self requestDataWithParameters:thirdAccountDic type:YES];
            }];
            
        }
            break;
        case 5://手机登录
        {
            BYC_LoginViewController *loginVC = [[BYC_LoginViewController alloc] initWithSuccess:_success];
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

- (void)requestDataWithParameters:(id)parameters type:(BOOL)isThird {
    
    [BYC_LoginHandler requestDataWithParameters:parameters type:isThird success:^(AFHTTPRequestOperation *operation, BYC_AccountModel *model) {
        
            QNWSBlockSafe(_success);
        
    } failure:nil];
}

-(void)layoutSubviews {

    [super layoutSubviews];
    
    
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && ![QQApiInterface isQQInstalled]) {
        
//        view_QQ.hidden = YES;
        view_WeChat.hidden = YES;
//        constraint_WeiboLeft.constant = 71;
        
        view_QQ.hidden = NO;
        
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
