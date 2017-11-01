//
//  BYC_RuntTime.h
//  kpie
//
//  Created by 元朝 on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_RuntTime : NSObject

void SwizzlingMethod(Class cls,SEL originSEL,SEL swizzledSEL);
@end
