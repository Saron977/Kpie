//
//  BYC_ScrollViewPanGestureRecognizer.h
//  kpie
//
//  Created by 元朝 on 15/10/29.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_ScrollViewPanGestureRecognizer : NSObject

/**
 *  记录发生冲突的手势集合
 */
@property (nonatomic, strong)  NSMutableArray <__kindof UIGestureRecognizer *> *instancePanGestures;
+(instancetype)sharePanGestureWith:(UIScrollView *)scrollView;
@end
