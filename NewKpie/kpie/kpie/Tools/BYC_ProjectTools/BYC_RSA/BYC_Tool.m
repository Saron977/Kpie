//
//  BYC_RSA.m
//  kpie
//
//  Created by 元朝 on 15/11/9.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_Tool.h"
#import "BYC_SubmitIDFAHandle.h"
#import "BYC_RSA.h"
#import "NSString+BYC_MD5.h"


@implementation BYC_Tool

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{

    NSString * MOBILE = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL flag = [regextestmobile evaluateWithObject:mobileNum];
//    if (!flag) QNWSShowAndHideHUD(@"请输入正确的手机号码", 0);//为了不影响其他地方的代码，就注释掉了。
    return flag;
}

//判断邮箱正确性
+ (BOOL)isEmailWithText:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL flag = [emailTest evaluateWithObject:email];
    if (!flag) QNWSShowAndHideHUD(@"请输入正确的邮箱地址", 0);
    return flag;
}

/**
 *  获取验证码校验算法
 *  sncode   设备编号
	token    请求时间
	password 密码
	vcode    加密字符串
 
 *  @param PhoneNum 手机号码
 *  @param isRegister YES:代表注册  NO:代表忘记密码
 *  @return 经过加密算法后的字典
 */
+ (NSDictionary *)encryptionPhoneNum:(NSString *)PhoneNum isRegister:(BOOL)isRegister {

    NSString *password   = [NSString stringWithFormat:@"%lld",[self getRandomNumber:10000000 to:9999999999999999]];
    NSString *token      = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSString *sncode     = [BYC_SubmitIDFAHandle getIDFA];
    NSString *str_Md5    = [[[NSString stringWithFormat:@"snCode=%@&mobile=%@&password=%@&token=%@",sncode,PhoneNum,password,token] getStringMD5] uppercaseString];
    NSString *vCode      = [BYC_RSA encryptString:str_Md5];
    NSDictionary *dic    = @{@"mobile":PhoneNum,@"snCode":sncode,@"token":token,@"password":password,@"vCode":vCode};
    
    if (!isRegister) {
        
        NSMutableDictionary *mDic = [dic mutableCopy];
        QNWSDictionarySetObjectForKey(mDic, [NSNumber numberWithInt:1], @"act")
        return [mDic copy];
    }
    return dic;
}

/**
 *   获取一个随机整数，范围在[from,to），包括from，包括to
 *
 *  @param from 从什么范围
 *  @param to   到什么范围
 *
 *  @return 结果
 */
+(long long)getRandomNumber:(long long)from to:(long long)to {
    return (long long)(from + (arc4random() % (to - from + 1)));
}
@end
