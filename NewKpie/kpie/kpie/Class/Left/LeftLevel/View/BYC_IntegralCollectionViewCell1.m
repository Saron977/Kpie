//
//  BYC_IntegralCollectionViewCell1.m
//  kpie
//
//  Created by 元朝 on 16/1/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_IntegralCollectionViewCell1.h"
#import "BYC_UpgradeStatusModel.h"

@interface BYC_IntegralCollectionViewCell1()

/**等级图*/
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Level;
/**等级图icon*/
@property (weak, nonatomic) IBOutlet UIImageView *imageV_LevelIcon;
/**等级昵称*/
@property (weak, nonatomic) IBOutlet UILabel *label_Level;
/**当前成长值*/
@property (weak, nonatomic) IBOutlet UILabel *label_CurrentGrowthValue;
/**升级到下一级需要成长值*/
@property (weak, nonatomic) IBOutlet UILabel *label_NeedGrowthValue;
/**等级进度条*/
@property (weak, nonatomic) IBOutlet UIView *view_Progress;
/**当前等级*/
@property (weak, nonatomic) IBOutlet UILabel *label_CurrentLevelValue;
/**下一等级*/
@property (weak, nonatomic) IBOutlet UILabel *label_NextLevelValue;

@property (nonatomic, strong)  UIView  *view_ProgressAnimation;

@end

@implementation BYC_IntegralCollectionViewCell1

-(void)setModel:(BYC_UpgradeStatusModel *)model {
    
    _model = model;
    self.label_CurrentGrowthValue.text = [NSString stringWithFormat:@"%ld",(long)_model.users.growth];
    self.label_NeedGrowthValue.text    = [NSString stringWithFormat:@"%ld",(long)(_model.userLevel.maxgrowth - _model.users.growth)];
    
    self.label_CurrentLevelValue.text  = [NSString stringWithFormat:@"Lv%ld",(long)_model.userLevel.levelname];
    self.label_NextLevelValue.text  = [NSString stringWithFormat:@"Lv%d",_model.userLevel.levelname + 1];
    
    [self.imageV_Level sd_setImageWithURL:[NSURL URLWithString:_model.userLevel.levelimg] placeholderImage:nil];
    self.label_Level.text = _model.titlename;
    [self.imageV_LevelIcon sd_setImageWithURL:[NSURL URLWithString:_model.titleimg] placeholderImage:nil];
}


-(void)drawRect:(CGRect)rect {

    [super drawRect:rect];
    CGFloat width = ((CGFloat)(_model.users.growth - _model.userLevel.mingrowth) /(CGFloat)(_model.userLevel.maxgrowth - _model.userLevel.mingrowth)) * self.view_Progress.kwidth;
    [self progressAnimation:width];
    
}

/**
 *  成长值进度动画
 *
 *  @param width 成长值宽度
 */
- (void)progressAnimation:(CGFloat)width {
    
    if (!_view_ProgressAnimation) {

        _view_ProgressAnimation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.view_Progress.kheight)];
        CAShapeLayer *styleLayer = [CAShapeLayer layer];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.view_ProgressAnimation.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)cornerRadii:CGSizeMake(3.0, 3.0)];
        styleLayer.path = shadowPath.CGPath;
        self.view_ProgressAnimation.backgroundColor = KUIColorBaseGreenNormal;
        self.view_ProgressAnimation.layer.mask = styleLayer;
        [self.view_Progress addSubview:_view_ProgressAnimation];
    }
    
    CGRect rect = _view_ProgressAnimation.bounds;
    rect.size.width = 0;
    _view_ProgressAnimation.frame = rect;
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect rect = _view_ProgressAnimation.bounds;
        rect.size.width = width;
        _view_ProgressAnimation.frame = rect;
    } completion:nil];
}

@end
