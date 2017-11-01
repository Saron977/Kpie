//
//  BYC_NewVersionsHandler.m
//  kpie
//
//  Created by 元朝 on 16/11/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_NewVersionsHandler.h"

@implementation BYC_NewVersionsHandler

+ (void)exeNewVersionsHandle {

    {//取消记录登录弹窗信息
    QNWSUserDefaultsSetObjectForKey(@{}, KSTR_ThirdLoginBindingPhoneNum);
    QNWSUserDefaultsSynchronize;
    }
    
}

@end
