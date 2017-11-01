//
//  BYC_ButtonAddUnderline.m
//  kpie
//
//  Created by 元朝 on 16/3/15.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ButtonAddUnderline.h"

@implementation BYC_ButtonAddUnderline

-(void)setColor_underline:(UIColor *)color_underline{
    _color_underline = color_underline;
    [self setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat descender = self.titleLabel.font.descender;
    if([_color_underline isKindOfClass:[UIColor class]]){
        CGContextSetStrokeColorWithColor(contextRef, _color_underline.CGColor);
    }
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender+1);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender+1);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}


@end
