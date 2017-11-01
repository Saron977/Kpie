//
//  BYC_MyCenterHandler.m
//  kpie
//
//  Created by 元朝 on 16/9/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MyCenterHandler.h"

@implementation BYC_MyCenterHandler


-(BYC_AccountModel *)model_User {
    
    if (!_model_User) _model_User = [BYC_AccountTool userAccount];
    return _model_User;
}

/**当前用户的个人信息,注意（就算是登录用户的个人中心 此对象的用户信息不等全与登录的用户信息，后台反回的信息不够全）*/
-(void)setModel_CurrentUser:(BYC_AccountModel *)model_CurrentUser {
    
    _model_CurrentUser = model_CurrentUser;
    if ([_model_CurrentUser.userid isEqualToString:self.model_User.userid]) {

        self.model_User = model_CurrentUser;
        self.model_User.handler       = self;
        _isOpenSelfCenter = YES;
        _model_CurrentUser = self.model_User;
    }
}

-(BYC_MyCenterVCWorksHandler *)handler_Works {

    if (!_handler_Works) _handler_Works = [BYC_MyCenterVCWorksHandler new];
    return _handler_Works;
}

-(BYC_FocusAndFansHandler *)handler_Focus {

    if (!_handler_Focus) _handler_Focus = [BYC_FocusAndFansHandler new];
    return _handler_Focus;
}

-(BYC_FocusAndFansHandler *)handler_Fans {

    if (!_handler_Fans) _handler_Fans = [BYC_FocusAndFansHandler new];
    return _handler_Fans;
}
@end
