//
//  HL_PersonalTableViewCell.m
//  kpie
//
//  Created by sunheli on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_PersonalTableViewCell.h"

@interface HL_PersonalTableViewCell ()

@property (nonatomic, strong) UIImageView      *imageV_Icon;
@property (nonatomic, strong) UILabel         *lable_Class;
@property (nonatomic, strong) UIButton         *button_more;
@property (nonatomic, strong) UIView           *H_spiteLine;
@property (nonatomic, weak)   UIView           *vie_Red;


@end

@implementation HL_PersonalTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
        self.contentView.backgroundColor = KUIColorFromRGB(0xFCFCFC);
        self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = KUIColorFromRGB(0xDEDEDE);
        self.opaque = YES;
    }
    return self;
}

-(void)initCellView{
    self.imageV_Icon = [[UIImageView alloc]init];
    
    self.lable_Class =[[UILabel alloc]init];
    self.lable_Class.textColor = KUIColorFromRGB(0x21262C);
    self.lable_Class.font = [UIFont systemFontOfSize:17];
    [self.lable_Class sizeToFit];
    
    self.button_more = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_more setImage:[UIImage imageNamed:@"wode_icon_xiayibu_n"] forState:UIControlStateNormal];
    
    self.H_spiteLine = [[UIView alloc]init];
    self.H_spiteLine.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    
    [self.contentView addSubview:self.imageV_Icon];
    [self.contentView addSubview:self.lable_Class];
    [self.contentView addSubview:self.button_more];
    [self.contentView addSubview:self.H_spiteLine];
    
    [self.imageV_Icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(9);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.width.height.mas_equalTo(24);
    }];
    [self.button_more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.width.height.mas_equalTo(18);
    }];
    
    [self.H_spiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_Icon.mas_right).offset(14);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.lable_Class mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_Icon.mas_right).offset(14);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];

}

-(UIView *)vie_Red {

    if (!_vie_Red) {
        UIView *view_RedTemp  = [UIView new];
        _vie_Red = view_RedTemp;
        [self.contentView addSubview:_vie_Red];
        _vie_Red.backgroundColor = [UIColor redColor];
        CGFloat wh = 6;
        _vie_Red.layer.cornerRadius = wh / 2.0;
        _vie_Red.clipsToBounds = YES;
        
        [_vie_Red mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(wh);
            make.left.equalTo(self.lable_Class.mas_right).offset(-2);
            make.top.equalTo(self.lable_Class.mas_top).offset(-1);
        }];
    }
    
    return _vie_Red;
}

- (void)exeAddRedView {

    (void)self.vie_Red;
}

- (void)exeRemoveRedView {

    QNWSUserDefaultsSetValueForKey(nil, KSTR_KMsgAndNotRed);
    [_vie_Red removeFromSuperview];
    _vie_Red = nil;
}

-(void)setPersonalStr:(NSString *)personalStr{
    self.lable_Class.text = personalStr;
    
    }

-(void)setPersonalIcoStr:(NSString *)personalIcoStr{
    
    self.imageV_Icon.image = [UIImage imageNamed:personalIcoStr];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
