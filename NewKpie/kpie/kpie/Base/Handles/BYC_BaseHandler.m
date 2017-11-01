//
//  BYC_BaseHandler.m
//  kpie
//
//  Created by 元朝 on 16/9/14.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseHandler.h"

@implementation BYC_BaseHandler

-(void)dealloc {
    
    [QNWSNotificationCenter removeObserver:self];
}

@end
