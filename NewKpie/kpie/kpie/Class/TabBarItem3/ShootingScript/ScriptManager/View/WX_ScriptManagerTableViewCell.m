//
//  WX_ScriptManagerTableViewCell.m
//  kpie
//
//  Created by 王傲擎 on 16/4/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ScriptManagerTableViewCell.h"

@implementation WX_ScriptManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleimgView.layer.masksToBounds = YES;
    _titleimgView.layer.cornerRadius = 10.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
