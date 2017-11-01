//
//  BYC_ScrollViewPanGestureRecognizer.m
//  kpie
//
//  Created by 元朝 on 15/10/29.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_ScrollViewPanGestureRecognizer.h"
static BYC_ScrollViewPanGestureRecognizer *instancePanGesture;

@implementation BYC_ScrollViewPanGestureRecognizer

+(instancetype)sharePanGestureWith:(UIScrollView *)scrollView {

    BYC_ScrollViewPanGestureRecognizer *instancePanGesture = [[self alloc] init];
    for (id instance in scrollView.gestureRecognizers)
        if ([instance isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")])
            if (![instancePanGesture.instancePanGestures containsObject:instance])
            [instancePanGesture.instancePanGestures addObject: instance];
    return instancePanGesture;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancePanGesture = [super allocWithZone:zone];
    });

    return instancePanGesture;
}

-(NSMutableArray <__kindof UIGestureRecognizer *> *)instancePanGestures {

    if (_instancePanGestures == nil) {
        
        _instancePanGestures = [NSMutableArray array];
    }
    
    return _instancePanGestures;
}

@end
