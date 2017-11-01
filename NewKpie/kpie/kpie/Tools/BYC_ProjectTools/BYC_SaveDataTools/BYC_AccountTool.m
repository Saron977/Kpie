//
//  BYC_AccountTool.m
//  kpie
//
//  Created by 元朝 on 15/11/10.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_AccountTool.h"
#import "UMMobClick/MobClick.h"
#import "BYC_HistoryKeywordsHandler.h"
#import "BYC_HttpServers+BYC_Account.h"

#define BYC_AccountFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"UserAccount.data"]

@implementation BYC_AccountTool
static BYC_AccountModel *_userAccount;

+ (void)saveAccount:(BYC_AccountModel *)account {
    
    [NSKeyedArchiver archiveRootObject:account toFile:BYC_AccountFileName];
    [QNWSNotificationCenter postNotificationName:KSTR_KLoginSuccessed object:account userInfo:nil];
}


+ (BYC_AccountModel *)userAccount {
    if (_userAccount == nil)
        _userAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:BYC_AccountFileName];
    return _userAccount;
}

+ (void)clearUserAccount {

    //退出登录前需要调用这个接口。但是要是没有网络退出的时候调用不成功，后台会有顶号推送问题哦。
    [BYC_HttpServers requestLogoutSuccess:nil failure:nil];
    
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:BYC_AccountFileName]) {
        _userAccount = nil;
        [defaultManager removeItemAtPath:BYC_AccountFileName error:nil];
    }
    [QNWSNotificationCenter postNotificationName:KSTR_KLoginOut object:nil userInfo:nil];
    [BYC_HistoryKeywordsHandler clearHistoryKeyword];//清除关键字历史
    QNWSUserDefaultsSetObjectForKey(nil, KSTR_KThirdLogin);//清除第三方登陆成功的标识
    [MobClick profileSignOff];//账号登出时需调用此接口，调用之后友盟统计不再发送账号相关内容。
}
@end
