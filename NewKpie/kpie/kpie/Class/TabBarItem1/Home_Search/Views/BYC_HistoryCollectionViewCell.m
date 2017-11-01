//
//  BYC_HistoryCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 16/5/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HistoryCollectionViewCell.h"

@interface BYC_HistoryCollectionViewCell()

@property (nonatomic, strong)  UILabel  *label;

@end

@implementation BYC_HistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = KUIColorFromRGB(0X777A7D).CGColor;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {

    if (_label == nil) {
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = KUIColorFromRGB(0XBFC5C9);
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(_label.superview);
            make.centerY.equalTo(_label.superview);
        }];
    }
}

-(void)setString_Text:(NSString *)string_Text {
    
    _label.text = string_Text;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    _label.textColor = self.highlighted ?  KUIColorFromRGB(0x40AE9E) : KUIColorFromRGB(0XBFC5C9);
    self.backgroundColor =  self.highlighted ?  KUIColorFromRGBA(0x000000, .2f) : [UIColor clearColor];
}

@end
