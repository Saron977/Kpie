//
//  BYC_TimerTools.h
//  kpie
//
//  Created by 元朝 on 16/4/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_TimerTools<BYC_Type> : NSObject

+(void)GCDTimerWithObject:(nonnull BYC_Type)object;
@end
