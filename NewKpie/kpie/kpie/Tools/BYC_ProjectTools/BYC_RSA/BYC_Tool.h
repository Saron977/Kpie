//
//  BYC_Tool.h
//  kpie
//
//  Created by 元朝 on 15/11/9.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_Tool : NSObject


/**
 正则判断手机号码地址格式

 @param mobileNum 需要判断的手机号码
 @return 判断结果
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 正则判断邮箱号码地址格式
 
 @param mobileNum 需要判断的邮箱号码
 @return 判断结果
 */
+ (BOOL)isEmailWithText:(NSString *)email;

/**
 *  获取验证码校验算法
 *
 *  @param PhoneNum 手机号码
 *
 *  @return 加密算法
 */
+ (NSDictionary *)encryptionPhoneNum:(NSString *)PhoneNum isRegister:(BOOL)isRegister;

/**
 *   获取一个随机整数，范围在[from,to），包括from，包括to
 *
 *  @param from 从什么范围
 *  @param to   到什么范围
 *
 *  @return 结果
 */
+(long long)getRandomNumber:(long long)from to:(long long)to;
@end
