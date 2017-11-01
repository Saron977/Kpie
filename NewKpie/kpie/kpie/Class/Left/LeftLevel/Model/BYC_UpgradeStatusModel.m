//
//  BYC_UpgradeStatusModel.m
//  kpie
//
//  Created by 元朝 on 16/10/24.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_UpgradeStatusModel.h"

@implementation BYC_UpgradeStatusModel

-(BYC_AccountModel *)users {

    if (!_users) _users = [BYC_AccountModel new];
    return _users;
}

-(BYC_UserLevel *)userLevel {

    if (!_userLevel) [BYC_UserLevel new];
    return _userLevel;
}
@end
