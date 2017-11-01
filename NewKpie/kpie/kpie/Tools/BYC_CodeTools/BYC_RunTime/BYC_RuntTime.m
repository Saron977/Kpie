//
//  BYC_RuntTime.m
//  kpie
//
//  Created by 元朝 on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_RuntTime.h"

@implementation BYC_RuntTime

void SwizzlingMethod(Class cls,SEL originSEL,SEL swizzledSEL) {
    Method originMethod = class_getInstanceMethod(cls, originSEL);
    Method swizzledMethod = nil;
    if (!originMethod) {
        
        originMethod = class_getClassMethod(cls, originSEL);
        if (!originMethod) return;
        swizzledMethod = class_getClassMethod(cls, swizzledSEL);
        if (! swizzledMethod) return;
    }else{
        swizzledMethod = class_getInstanceMethod(cls, swizzledSEL);
        if (!swizzledMethod) return;
    }
    
//    if (class_addMethod(cls, originSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)))
//        class_replaceMethod(cls, swizzledSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
//    else
        method_exchangeImplementations(originMethod, swizzledMethod);
    
}

@end
