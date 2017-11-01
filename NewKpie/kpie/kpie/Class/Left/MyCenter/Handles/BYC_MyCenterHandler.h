//
//  BYC_MyCenterHandler.h
//  kpie
//
//  Created by 元朝 on 16/9/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_HomeViewControllerModel.h"
#import "BYC_FocusAndFansHandler.h"
#import "BYC_MyCenterVCWorksHandler.h"

@interface BYC_MyCenterHandler : NSObject
/******🔻用户信息组🔻******/

/**登录的用户信息*/
@property (nonatomic, strong) BYC_AccountModel           *model_User;
/**当前用户的个人信息,注意（就算是登录用户的个人中心 此对象的用户信息不等全与登录的用户信息，后台反回的信息不够全）*/
@property (nonatomic, strong) BYC_AccountModel           *model_CurrentUser;
/**需要被关注或取消关注的个人信息*/
@property (nonatomic, strong) BYC_AccountModel           *model_ToFocusUser;

/******🔺用户信息组🔺******/

/**是否已经打开过控制器*/
@property (nonatomic, assign) BOOL                       isOpenTheVC;

/**YES:打开自己的个人中心  NO:打开别人的个人中心*/
@property (nonatomic, assign) BOOL                       isOpenSelfCenter;
/**YES:在关注或者粉丝列表点击自己*/
@property (nonatomic, assign) BOOL                       isTapSelfCenter;
/**作品操作*/
@property (nonatomic, strong) BYC_MyCenterVCWorksHandler *handler_Works;
/**关注操作*/
@property (nonatomic, strong) BYC_FocusAndFansHandler    *handler_Focus;
/**粉丝操作*/
@property (nonatomic, strong) BYC_FocusAndFansHandler    *handler_Fans;

@end
