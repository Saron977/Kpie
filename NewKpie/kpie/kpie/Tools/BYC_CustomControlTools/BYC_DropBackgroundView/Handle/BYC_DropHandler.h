//
//  BYC_DropHandler.h
//  kpie
//
//  Created by 元朝 on 16/11/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_DropHandler : NSObject


/**
 操作需要弹出的视图

 @param view  需要弹出的视图
 @param block 弹出的视图需要设置的布局block
 */
+ (void)dropHandleWithView:(UIView *)view setFrameOrConstraintBlock:(void(^)())block;

@end
