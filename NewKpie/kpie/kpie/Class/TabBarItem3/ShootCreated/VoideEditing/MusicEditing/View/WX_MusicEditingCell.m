//
//  WX_MusicEditingCell.m
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_MusicEditingCell.h"


@implementation WX_MusicEditingCell
{
    
//    __weak IBOutlet UIImageView *selectImgView;
    __weak IBOutlet UIView *backView;
//    __weak IBOutlet UIImageView *backImgView;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    if (self.selected) {
//        _titleLabel.textColor = kUIColorFromRGB(0x4BC8BD);
//        self.classLabel.textColor = kUIColorFromRGB(0x4BC8BD);
//        self.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-h."];
//    }else {
//        _titleLabel.textColor = kUIColorFromRGB(0xffffff);
//        self.classLabel.textColor = kUIColorFromRGB(0xffffff);
//        self.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-n."];
//
//    }
//
//    self.isSelected = !self.isSelected;
//    
//    if (!self.isSelected) {
//        _titleLabel.textColor = kUIColorFromRGB(0x4BC8BD);
//        self.classLabel.textColor = kUIColorFromRGB(0x4BC8BD);
//        self.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-h."];
//    }else {
//        _titleLabel.textColor = kUIColorFromRGB(0xffffff);
//        self.classLabel.textColor = kUIColorFromRGB(0xffffff);
//        self.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-n."];
//        
//    }

}



@end
