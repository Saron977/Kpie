//
//  BYC_HomeCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 15/10/27.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_HomeCollectionViewCell.h"

@interface BYC_HomeCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Picture;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_header;
@property (weak, nonatomic) IBOutlet UILabel     *label_Name;
@property (weak, nonatomic) IBOutlet UILabel     *label_title;
@property (weak, nonatomic) IBOutlet UILabel     *label_playNumber;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_LabelPlayNumberWidth;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_ShootCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraint_imageView_shootCountHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraint_imageView_shootCountWidth;

@end

@implementation BYC_HomeCollectionViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.imageV_header.layer.cornerRadius = 14.5f;
    self.imageV_header.layer.masksToBounds = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}



-(void)setModel:(BYC_BaseVideoModel *)model {
    
    _model = model;
    _contraint_imageView_shootCountHeight.constant = 8;
    _contraint_imageView_shootCountWidth.constant  = 14;
    _imageView_ShootCount.image = [UIImage imageNamed:@"icon-yanjing"];
        
        [_imageV_header sd_setImageWithURL:[NSURL URLWithString:model.users.headportrait] placeholderImage:nil];
        [_imageV_Picture sd_setImageWithURL:[NSURL URLWithString:model.picturejpg] placeholderImage:nil];
        _label_Name.text = model.users.nickname;
        if (model.isvr == 2) _label_playNumber.text = [NSString stringWithFormat:@"%ld",(long)model.templets];
           
        else _label_playNumber.text = [NSString stringWithFormat:@"%ld",(long)model.views];
        
        [_label_playNumber sizeToFit];
        _constraint_LabelPlayNumberWidth.constant = _label_playNumber.ksize.width;
        _label_title.text = model.videotitle;
}

-(void)setScriptModel:(HL_ColumnVideoScriptModel *)scriptModel{
    
    _scriptModel = scriptModel;
    _contraint_imageView_shootCountHeight.constant = 14;
    _contraint_imageView_shootCountWidth.constant = 14;
    _imageView_ShootCount.image = [UIImage imageNamed:@"icon_download_n"];
    [_imageV_header sd_setImageWithURL:[NSURL URLWithString:scriptModel.users.headportrait] placeholderImage:nil];
    [_imageV_Picture sd_setImageWithURL:[NSURL URLWithString:scriptModel.jpgurl] placeholderImage:nil];
    _label_Name.text = _scriptModel.users.nickname;
    _label_playNumber.text = [NSString stringWithFormat:@"%ld",(long)scriptModel.downloadcount];

    
    [_label_playNumber sizeToFit];
    _constraint_LabelPlayNumberWidth.constant = _label_playNumber.ksize.width;
    _label_title.text = scriptModel.scriptname;

    
}


@end
