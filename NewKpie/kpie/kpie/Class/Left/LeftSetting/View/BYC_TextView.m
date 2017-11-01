//
//  BYC_TextView.m
//  传智微博
//
//  Created by apple on 15-3-13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYC_TextView.h"

@interface BYC_TextView ()

@property (nonatomic, weak) UILabel *placeHolderLabel;

@end

@implementation BYC_TextView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:13];
    }
    return self;
}
- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        
        UILabel *label = [[UILabel alloc] init];
        

        [self addSubview:label];
        
        _placeHolderLabel = label;
        
    }
    
    return _placeHolderLabel;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeHolderLabel.font = font;
    [self.placeHolderLabel sizeToFit];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    self.placeHolderLabel.text = placeHolder;
    self.placeHolderLabel.textColor = KUIColorWordsBlack3;
    // label的尺寸跟文字一样
    [self.placeHolderLabel sizeToFit];
}

- (void)setHidePlaceHolder:(BOOL)hidePlaceHolder
{
    _hidePlaceHolder = hidePlaceHolder;
    
    
    self.placeHolderLabel.hidden = hidePlaceHolder;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    self.placeHolderLabel.left = 5;
    self.placeHolderLabel.top = 8;
}

@end
