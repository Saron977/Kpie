//
//  WX_GeoLoctionTableViewCell.m
//  kpie
//
//  Created by 王傲擎 on 15/11/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_GeoLoctionTableViewCell.h"

@implementation WX_GeoLoctionTableViewCell
{
    

    __weak IBOutlet UIImageView *nameImgView;
    __weak IBOutlet UIImageView *addressImgView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *addressLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)creatTheCellWithName:(NSString *)name Adress:(NSString *)adress
{
    nameLabel.text = name;
    addressLabel.text = adress;
    nameImgView.image = [UIImage imageNamed:@"icon-dt-n"];
    addressImgView.image = [UIImage imageNamed:@""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
