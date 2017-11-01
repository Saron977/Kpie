//
//  BYC_MTCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 16/4/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MTCollectionViewCell.h"

@interface BYC_MTCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *label_Title;


@end

@implementation BYC_MTCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTitle:(NSString *)title {

    _label_Title.text = title;
}

-(void)setTextColor:(UIColor *)textColor {

    _label_Title.textColor = textColor;
}
@end
