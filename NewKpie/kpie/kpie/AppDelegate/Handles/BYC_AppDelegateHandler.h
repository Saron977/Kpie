//
//  BYC_AppDelegateHandler.h
//  kpie
//
//  Created by 元朝 on 16/9/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_AppDelegateHandler : NSObject

+ (instancetype)appDelegateHandler:(NSObject *)appDelegate;

- (void)loadRootViewController;
@end
