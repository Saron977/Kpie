//
//  BYC_BaseView.m
//  kpie
//
//  Created by 元朝 on 16/9/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseView.h"

@implementation BYC_BaseView

-(void)dealloc {

    [QNWSNotificationCenter removeObserver:self];
}

@end
