//
//  BYC_InStepCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 15/10/27.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_InStepCollectionViewCell.h"

@interface BYC_InStepCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Picture;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_header;
@property (weak, nonatomic) IBOutlet UILabel     *label_Name;
@property (weak, nonatomic) IBOutlet UILabel     *label_title;
@property (weak, nonatomic) IBOutlet UILabel     *label_playNumber;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_ShowNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_LabelPlayNumberWidth;

@end

@implementation BYC_InStepCollectionViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    //用户头像加白色边框、圆形，暂时不需要
    self.imageV_header.layer.cornerRadius = 14.5f;
    self.imageV_header.layer.masksToBounds = YES;
}



-(void)setModel:(BYC_InStepCollectionViewCellModel *)model {
    
    if (_model != model) {
        
        _model = model;
        
        [_imageV_header sd_setImageWithURL:[NSURL URLWithString:_model.users.headportrait] placeholderImage:nil];
        [_imageV_Picture sd_setImageWithURL:[NSURL URLWithString:_model.picturejpg] placeholderImage:nil];
        _label_Name.text = _model.users.nickname;
        
        if(_model.isvr == 2) {
        
            _label_playNumber.text = [NSString stringWithFormat:@"%ld",(long)_model.templets];
            _imageV_ShowNum.image = [UIImage imageNamed:@"hepaishow_icon_zhizuo"];
        }else {
        
            _label_playNumber.text = [NSString stringWithFormat:@"%ld",(long)_model.views];
            _imageV_ShowNum.image = [UIImage imageNamed:@"icon-yanjing"];
        }
        

        [_label_playNumber sizeToFit];
        _constraint_LabelPlayNumberWidth.constant = _label_playNumber.ksize.width;
        _label_title.text = _model.videotitle;
        
    }
}

-(void)setLeftLikeModel:(BYC_LeftLikeModel *)leftLikeModel {
    
    if (_leftLikeModel != leftLikeModel) {
        
        _leftLikeModel = leftLikeModel;
        [_imageV_header sd_setImageWithURL:[NSURL URLWithString:_leftLikeModel.headPortrait] placeholderImage:nil];
        [_imageV_Picture sd_setImageWithURL:[NSURL URLWithString:_leftLikeModel.pictureJPG] placeholderImage:nil];
        _label_Name.text = _model.users.nickname;
        _label_playNumber.text = [NSString stringWithFormat:@"%ld",(long)_leftLikeModel.views];
        [_label_playNumber sizeToFit];
        _constraint_LabelPlayNumberWidth.constant = _label_playNumber.ksize.width;
        _label_title.text = _leftLikeModel.videoTitle;
        
    }
}

@end
