//
//  BYC_AccountModel.m
//  kpie
//
//  Created by 元朝 on 15/11/9.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_AccountModel.h"
#import "NSObject+MJCoding.h"
#import "NSString+BYC_Tools.h"

@interface BYC_AccountModel()<MJCoding>

@end

@implementation BYC_AccountModel
MJCodingImplementation

- (void)setRegdate:(NSString *)regdate {

    _regdate = [NSString getDateStr:regdate];
}

- (void)setAttentionstate:(NSInteger)attentionstate {

    _attentionstate = attentionstate;
    _whetherFocusForCell = _attentionstate;
}

-(void)setWhetherFocusForCell:(WhetherFocusForCell)whetherFocusForCell {

    _whetherFocusForCell = whetherFocusForCell;
    _attentionstate = _whetherFocusForCell;
}

-(void)setLastlogintime:(NSString *)lastlogintime {
    
    _lastlogintime = [NSString getDateStr:lastlogintime];
}

-(BYC_UserInfoModel *)userInfo {
    
    if (!_userInfo) _userInfo = [BYC_UserInfoModel new];
    return _userInfo;
}

-(BYC_UserLevel *)userLevel {
    
    if (!_userLevel) _userLevel = [BYC_UserLevel new];
    return _userLevel;
}

-(BYC_UserTitle *)userTitle {
    
    if (!_userTitle) _userTitle = [BYC_UserTitle new];
    return _userTitle;
}

-(NSString *)userid {

    if (_userid) return _userid;
    else return @"";
}

#pragma MJCoding
+ (NSArray *)mj_ignoredCodingPropertyNames {
    
    return @[@"handler"];
}
@end
