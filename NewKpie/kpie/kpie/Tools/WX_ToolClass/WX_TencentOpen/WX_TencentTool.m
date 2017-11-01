//
//  WX_TencentTool.m
//  kpie
//
//  Created by 王傲擎 on 2017/4/17.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import "WX_TencentTool.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "NSString+BYC_HaseCode.h"
#import "BYC_RSA.h"

typedef void(^block_Account)(NSDictionary *dic);
@interface WX_TencentTool()<TencentSessionDelegate>


@property (nonatomic, strong)   TencentOAuth                                            *tencentOAuth;
@property (nonatomic, strong)   NSArray                                                 *permission_Array;
@property (nonatomic, strong)   block_Account                                           block;
@property (nonatomic, assign)   WX_TencentPlatform                                      ENUM_TencentPlatform;

@end


@implementation WX_TencentTool
QNWSSingleton_implementation(WX_TencentTool);

+ (void)WX_SetTencentToolQQIDAndAppKey
{
    WX_TencentTool *tencentTool                                     =   [[WX_TencentTool alloc]init];
    [tencentTool SetTencentToolQQIDAndAppKey];
}
- (void)SetTencentToolQQIDAndAppKey
{
    _tencentOAuth                                                   =   [[TencentOAuth alloc]initWithAppId:@"1104776482" andDelegate:self];
}


+ (void)WX_loginTencentPlatform:(WX_TencentPlatform)tencentPlatform presentingController:(id)presentingController thirdAccountDictionary:(void(^)(NSDictionary *thirdAccountDic))thirdAccountDicBlock
{
    WX_TencentTool *tencentTool                                                         =   [[WX_TencentTool alloc]init];
    [tencentTool LoginTencentPlatform:tencentPlatform presentingController:presentingController AccountDictionary:^(NSDictionary *accountDic) {
        if(accountDic)thirdAccountDicBlock(accountDic);
    }];
}

- (void)LoginTencentPlatform:(WX_TencentPlatform)tencentPlatform presentingController:(id)presentingController AccountDictionary:(void(^)(NSDictionary *accountDic))accountDicBlock
{
    _ENUM_TencentPlatform                                           =   tencentPlatform;
    _permission_Array                                               =   [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    _tencentOAuth.authShareType = AuthShareType_QQ; /// 有出现未指定授权类型 需要添加这句话....搞了好久
    [_tencentOAuth authorize:_permission_Array];
    self.block = ^(NSDictionary *dic) {
        accountDicBlock(dic);
    };
}


#pragma mark ----- TencentSessionDelegate
- (void) tencentDidLogin
{
    if (_tencentOAuth.accessToken.length > 0) {
        // 获取用户信息
        [_tencentOAuth getUserInfo];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                QNWSShowHUD(@"登录失败", 0);
            });
            QNWSLog(@"登录失败,获取qq登录token失败");
        });
    }
}

- (void)tencentDidNotNetWork
{
    QNWSLog(@"tencentDidNotNetWork无网络连接，请设置网络");
}

- (void) tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        QNWSLog(@"用户取消登录");
    }else{
        QNWSLog(@"登录失败");
    }
}

- (void) getUserInfoResponse:(APIResponse *)response
{
    if (response && response.retCode == URLREQUEST_SUCCEED) {
        NSDictionary *userInfo                                      =   [response jsonResponse];
        NSString *str_Channel                                       =   _ENUM_TencentPlatform == 0 ? @"QQ" : @"微信";
        NSDictionary *dic_Info;
        @try {
            NSString *str_UserId                                    =   _tencentOAuth.openId;
            NSString *passWord                                      =   [BYC_RSA encryptString:_tencentOAuth.openId];
            NSString *str_DeviceToken                               =   QNWSUserDefaultsObjectForKey(KSTR_KDeviceToken) == nil ? @"":QNWSUserDefaultsObjectForKey(KSTR_KDeviceToken);
            NSString *str_ImageUrl                                  =   userInfo[@"figureurl_qq_2"];
            NSString *str_NickName                                  =   userInfo[@"nickname"];
            //                NSNumber *sex = [NSNumber numberWithBool:false];//这样写登录不上去，只能写下面的字符串了。原因待查。
            NSString *sex                                           =   @"false";
            NSString *str_City                                      =   @"";
            NSString *str_AccessToken                               =   _tencentOAuth.accessToken;
            
            //后台需要传递的数据规则
            NSString *total                                         =   [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",str_UserId,
                                                                         passWord,
                                                                         str_DeviceToken,
                                                                         str_ImageUrl,
                                                                         str_NickName,
                                                                         sex,//性别0
                                                                         str_City,//城市
                                                                         str_AccessToken];
            
            NSInteger totalInteger                                  =   [total javaHashCode];//hashCode编码
            NSString *totalString                                   =   [NSString stringWithFormat:@"%ld",(long)totalInteger];
            NSString *rsaString                                     =   [BYC_RSA encryptString:totalString];
            NSDictionary *userInfo_Dic                              =   @{
                                                                          @"city":str_City,//城市
                                                                          @"mydescription":@"",
                                                                          @"nationality":@"中国"
                                                                          };
            NSMutableDictionary *users_Dic                          =   [[NSMutableDictionary alloc]init];
            
            [users_Dic setObject:str_UserId                         forKey:@"cellphonenumber"];
            [users_Dic setObject:str_Channel                        forKey:@"channel"];
            [users_Dic setObject:str_DeviceToken                    forKey:@"devicetokens"];
            [users_Dic setObject:str_ImageUrl                       forKey:@"headportrait"];
            [users_Dic setObject:str_NickName                       forKey:@"nickname"];
            [users_Dic setObject:passWord                           forKey:@"password"];
            [users_Dic setObject:@"iOS"                             forKey:@"platform"];
            [users_Dic setObject:sex                                forKey:@"sex"];//性别0
            [users_Dic setObject:userInfo_Dic                       forKey:@"userInfo"];
            
            NSMutableDictionary *dic_All                            =   [[NSMutableDictionary alloc]init];
            [dic_All addEntriesFromDictionary:@{
                                                @"accessToken":str_AccessToken,
                                                @"totalData":rsaString,
                                                }];
            [dic_All setObject:users_Dic                            forKey:@"users"];
            
            dic_Info                                                =   [NSDictionary dictionaryWithDictionary:dic_All];

            
        } @catch (NSException *exception) {QNWSShowException(exception);}
        QNWSUserDefaultsSetObjectForKey(KSTR_KThirdLogin, KSTR_KThirdLogin);
        [QNWSUserDefaults synchronize]; //记录第三方登陆的标志
        dispatch_async(dispatch_get_main_queue(), ^{
            QNWSWeakSelf(self);
            weakself.block(dic_Info);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            QNWSShowHUD(@"获取用户信息失败",0);
        });
    }
}


//- (void)
@end
