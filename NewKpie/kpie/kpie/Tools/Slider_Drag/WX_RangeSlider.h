//
//  WX_RangeSlider.h
//  视频滚动条_Demo
//
//  Created by 王傲擎 on 15/10/30.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WX_RangeSlider : UIControl
// Values
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;

@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat rightValue;

@property (nonatomic, assign) CGFloat minimumDistance;

@property (nonatomic) BOOL pushable;
@property (nonatomic) BOOL disableOverlapping;

// Images
@property (nonatomic) UIImage *trackImage;
@property (nonatomic) UIImage *rangeImage;

@property (nonatomic) UIImage *leftThumbImage;
@property (nonatomic) UIImage *rightThumbImage;

-(void)changeSliderRangeImage:(UIImage *)image;

@end
