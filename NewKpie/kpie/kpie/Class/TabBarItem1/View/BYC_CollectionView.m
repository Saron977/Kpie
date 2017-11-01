//
//  BYC_CollectionView.m
//  kpie
//
//  Created by 元朝 on 15/10/29.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_CollectionView.h"
#import "BYC_ScrollViewPanGestureRecognizer.h"
@implementation BYC_CollectionView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    if (gestureRecognizer.state != 0)
        for (id instance in [BYC_ScrollViewPanGestureRecognizer sharePanGestureWith:nil].instancePanGestures)
            if (otherGestureRecognizer == instance)[gestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
        return NO;
}

@end