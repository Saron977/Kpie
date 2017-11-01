//
//  BYC_SearchListCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 16/5/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_SearchListCollectionViewCell.h"

@interface BYC_SearchListCollectionViewCell()

@property (nonatomic, strong)  UILabel  *label;

@end

@implementation BYC_SearchListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KUIColorBackgroundModule1;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    if (_label == nil) {
        
        _label = ({
        
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = KUIColorWordsBlack2;
            label.textAlignment = NSTextAlignmentLeft;
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(label.superview).offset(20);
                make.centerY.equalTo(label.superview);
            }];
            
            label;
        });
        
        UIView *view_Line = [[UIView alloc] init];
        [self addSubview:view_Line];
        view_Line.backgroundColor = KUIColorBackgroundTouchDown;
        [view_Line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.bottom.trailing.equalTo(view_Line.superview).insets(UIEdgeInsetsMake(0, 20, 0, 0));
            make.height.offset(.5);
        }];
    }
}

-(void)setString_Text:(NSString *)string_Text {
    
    _label.text = string_Text;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    _label.textColor = self.highlighted ?  KUIColorBaseGreenNormal : KUIColorWordsBlack2;
    self.backgroundColor =  self.highlighted ?  KUIColorBackgroundTouchDown : KUIColorBackgroundModule1;
    
}
@end
