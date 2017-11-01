//
//  BYC_PersonalDataViewController.h
//  kpie
//
//  Created by 元朝 on 15/11/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"

@interface BYC_PersonalDataViewController : BYC_BaseViewController

/**YES:代表是从注册页push过来 NO:代表非注册push过来*/
@property (nonatomic, assign)  BOOL  isRegistered;

/**YES:代表是从登录页push过来*/
@property (nonatomic, assign)  BOOL  isLogin;

/**YES:代表是从刚刚打开APP就push过来*/
@property (nonatomic, assign)  BOOL  isStarOpenApp;

@property(nonatomic,assign) id delegate;
@property(nonatomic,assign) SEL onStartClick;

@end
