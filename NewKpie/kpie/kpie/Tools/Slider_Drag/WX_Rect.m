//
//  WX_Rect.m
//  视频滚动条_Demo
//
//  Created by 王傲擎 on 15/10/30.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_Rect.h"

@implementation WX_Rect

- (WX_Rect *)initWithX:(CGFloat)x Y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    if (self = [super init])
    {
        self.x = x;
        self.y = y;
        self.width = width;
        self.height = height;
    }
    return self;
}

- (WX_Rect *)initWithCGRect:(CGRect)rect
{
    if (self = [super init])
    {
        self.x = rect.origin.x;
        self.y = rect.origin.y;
        self.width = rect.size.width;
        self.height = rect.size.height;
    }
    return self;
}

- (CGRect)rect
{
    return CGRectMake(self.x, self.y, self.width, self.height);
}

- (CGPoint)center
{
    return CGPointMake(self.x + self.width / 2.f, self.y + self.height / 2.f);
}

@end
