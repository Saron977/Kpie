//
//  BYC_ScrollSubtitleCell.h
//  kpie
//
//  Created by 元朝 on 16/7/13.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ScrollSubtitleCell.h"

@interface BYC_ScrollSubtitleCell ()

/**背景*/
@property (nonatomic, strong)  UIImageView *imageV;
/***/
@property (nonatomic, strong)  UILabel  *label_Title;
@end

@implementation BYC_ScrollSubtitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self initSubViews];
    }
    return self;
}

-(void)setStr_Title:(NSString *)str_Title {

    _str_Title = str_Title;
    _label_Title.text = _str_Title;
}

-(void)setIsSelected:(BOOL)isSelected {

    _isSelected = isSelected;
    _imageV.hidden = _isSelected;
    _label_Title.textColor = _isSelected ? KUIColorWordsBlack2 :[UIColor whiteColor];
}

#pragma mark - 初始化子视图
- (void)initSubViews {
    
    _imageV = [[UIImageView alloc] init];
    [self addSubview:_imageV];
    _imageV.backgroundColor = KUIColorBackground1;
    _imageV.layer.cornerRadius = 8;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
    _imageV.hidden = YES;
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {make.top.leading.bottom.trailing.insets(UIEdgeInsetsMake(8, 9, 9, 9));}];
    
    _label_Title = ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {(void)make.center;}];
        label;
    });
}

@end
