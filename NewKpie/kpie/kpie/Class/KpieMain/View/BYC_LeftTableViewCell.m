//
//  BYC_LeftTableViewCell.m
//  kpie
//
//  Created by 元朝 on 15/12/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LeftTableViewCell.h"

@implementation BYC_LeftTableViewCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    _imageV_Arrow.highlighted = highlighted;
    _imageV_Header.highlighted = highlighted;
    _label_Title.textColor = self.highlighted ?  KUIColorFromRGB(0x40AE9E) : [UIColor whiteColor];
    self.backgroundColor =  self.highlighted ?  KUIColorFromRGBA(0x000000, .2f) : [UIColor clearColor];

}
@end
