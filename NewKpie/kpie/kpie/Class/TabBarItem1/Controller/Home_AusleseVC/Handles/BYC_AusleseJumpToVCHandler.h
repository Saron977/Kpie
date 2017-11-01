//
//  BYC_AusleseJumpToVCHandler.h
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseVideoModel.h"

@interface BYC_AusleseJumpToVCHandler : NSObject

/**
 *  精选控制器 banner 和 推荐 的各种挑转
 *
 *  @param models 需要跳转的模型
 */
+ (void)jumpToVCWithModel:(BYC_BaseVideoModel *)model;
@end
