//
//  BYC_ThirdLoginBindingPhoneNumHandler.h
//  kpie
//
//  Created by 元朝 on 16/11/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//第三方登陆需要绑定手机号码，展示绑定视图

#import <Foundation/Foundation.h>

@interface BYC_ThirdLoginBindingPhoneNumHandler : NSObject


/**
 执行是否弹出掉落alterView的判断

 @param model 需要传入的用户模型
 */
+ (void)exeDorpAlertView:(BYC_AccountModel *)model;
@end
