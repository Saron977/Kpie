//
//  WX_Rect.h
//  视频滚动条_Demo
//
//  Created by 王傲擎 on 15/10/30.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WX_Rect : NSObject

@property (nonatomic,assign) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (WX_Rect *)initWithX:(CGFloat)x Y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (WX_Rect *)initWithCGRect:(CGRect)rect;

- (CGRect)rect;
- (CGPoint)center;
@end
