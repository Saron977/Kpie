//
//  BYC_MyCenterFocusRequestDataHandler.h
//  kpie
//
//  Created by 元朝 on 16/9/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_MyCenterHandler.h"

@interface BYC_MyCenterFocusRequestDataHandler : NSObject

/**
 *  取消和关注请求操作类
 *
 *  @param model      被操作对象
 *  @param handler    操作对象
 *  @param completion 操作完成回调
 */
+ (void)whetherSelectFocusWithToUserID:(BYC_AccountModel *)model handler:(BYC_MyCenterHandler *)handler completion:(void(^)(BOOL success, WhetherFocusForCell status))completion;

@end
