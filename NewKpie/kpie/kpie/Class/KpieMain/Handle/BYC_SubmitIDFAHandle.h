//
//  BYC_SubmitIDFAHandle.h
//  kpie
//
//  Created by 元朝 on 16/5/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_SubmitIDFAHandle : NSObject

/**
 *
 *
 *  @return 返回IDFA
 */
+ (NSString *)getIDFA;
/**
 *  排重处理传递IDFA
 */
+ (void)handleOfsubmitIDFA;
@end
