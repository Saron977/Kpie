//
//  BYC_CenterCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 15/11/13.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_CenterCollectionViewCell.h"
#import "DateFormatting.h"
@interface BYC_CenterCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Picture;

@property (weak, nonatomic) IBOutlet UILabel *label_TitleName;

@property (weak, nonatomic) IBOutlet UILabel *label_time;
@end

@implementation BYC_CenterCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)setModel:(BYC_HomeViewControllerModel *)model {

    _model = model;
    
    [_imageV_Picture sd_setImageWithURL:[NSURL URLWithString:model.picturejpg] placeholderImage:nil];
    _label_TitleName.text = model.videotitle;
    _label_time.text = [model.onmstime substringToIndex:model.onmstime.length-7];
    
}

@end
