//
//  BYC_AccountTool.h
//  kpie
//
//  Created by 元朝 on 15/11/10.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_AccountModel.h"

@interface BYC_AccountTool : NSObject
/**
 *  保存用户数据
 */
+ (void)saveAccount:(BYC_AccountModel *)account;
/**
 *  获取用户数据
 */
+ (BYC_AccountModel *)userAccount;
/**
 *  清除用户数据
 */
+ (void)clearUserAccount;
@end
