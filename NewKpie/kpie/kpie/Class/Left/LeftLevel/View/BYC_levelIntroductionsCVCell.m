//
//  BYC_levelIntroductionsCVCell.m
//  kpie
//
//  Created by 元朝 on 16/1/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_levelIntroductionsCVCell.h"
#import "BYC_UpgradeDescriptionModel.h"

@interface BYC_levelIntroductionsCVCell()

@property (weak, nonatomic) IBOutlet UILabel *label_Level;

@property (weak, nonatomic) IBOutlet UILabel *label_Value;

@property (weak, nonatomic) IBOutlet UILabel *label_NickName;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Pic;
@property (weak, nonatomic) IBOutlet UIView *view_Middle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_Left;

@end
@implementation BYC_levelIntroductionsCVCell

-(void)setIndexPath:(NSIndexPath *)indexPath {
        
    if (indexPath.item == 0) {
        
        _label_Level.text    = @"等级";
        _label_Value.text    = @"成长值区间";
        _label_NickName.text = @"对应头衔";
        _imageV_Pic.image    = nil;
        
        _label_Level.textColor      = [UIColor whiteColor];
        _label_NickName.textColor   = [UIColor whiteColor];
        _label_Value.textColor      = [UIColor whiteColor];
        _constraint_Left.constant = 10;
        self.backgroundColor = KUIColorFromRGB(0X367873);
    
    }else {
    
        [self setColorWithIndexPath:indexPath];
        _constraint_Left.constant = 18;
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setColorWithIndexPath:(NSIndexPath *)indexPath{

        _label_Level.backgroundColor = KUIColorFromRGBA(0X367873, indexPath.item % 2 ? 0.4f : 0.2f);
        _label_Value.backgroundColor = KUIColorFromRGBA(0X367873, indexPath.item % 2 ? 0.4f : 0.2f);
        _view_Middle.backgroundColor = KUIColorFromRGBA(0X367873, indexPath.item % 2 ? 0.4f : 0.2f);
}

-(void)setModel:(BYC_UpgradeDescriptionModel *)model {

    _model = model;
    _label_Level.text    = _model.maxlv == _model.minlv ? [NSString stringWithFormat:@"Lv%ld",(long)_model.minlv]:[NSString stringWithFormat:@"Lv%ld~%ld",(long)_model.minlv,(long)_model.maxlv];
    [_imageV_Pic sd_setImageWithURL:[NSURL URLWithString:_model.titleimg] placeholderImage:nil];
    _label_NickName.text = _model.titlename;
    _label_Value.text    = [NSString stringWithFormat:@"%ld~%ld",(long)_model.userLevel.mingrowth,(long)_model.userLevel.maxgrowth];
}

@end
