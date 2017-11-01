//
//  BYC_CheckLoginButton.m
//  kpie
//
//  Created by 元朝 on 16/9/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_CheckLoginButton.h"
#import "BYC_LoginAndRigesterView.h"

@interface BYC_CheckLoginButton ()

@property (nonatomic, strong)  id  target;
@property (nonatomic, assign)  SEL action;
@property (nonatomic, strong)  UIEvent *event;
@end

@implementation BYC_CheckLoginButton

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.isCheckLogin) {
        
        [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
            
            [super sendAction:action to:target forEvent:event];
        }];
    } else [super sendAction:action to:target forEvent:event];
}

@end
