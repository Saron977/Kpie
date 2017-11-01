//
//  HL_FocusTableViewHeader.m
//  kpie
//
//  Created by sunheli on 16/7/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_FocusTableViewHeader.h"
#import "DateFormatting.h"
#import "BYC_AccountModel.h"

@interface HL_FocusTableViewHeader ()

@property (nonatomic, strong) UIImageView *imageV_userIcon;
@property (nonatomic, strong) UILabel     *lable_userName;
@property (nonatomic, strong) UIImageView *imageV_userSex;
@property (nonatomic, strong) UIButton    *button_Forward;
@property (nonatomic, strong) UILabel     *lable_time;
@property (nonatomic, strong) UILabel     *lable_descrip;
@property (nonatomic, strong) UIImageView *imageV_forward;

@end

static NSString *descrip;
static NSString *lableStr;

@implementation HL_FocusTableViewHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTableViewHeader];
        self.backgroundColor = KUIColorFromRGB(0xFCFCFC);
    }
    return self;
}

-(void)initTableViewHeader{

    self.imageV_userIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UMS_User_profile_default"]];
    self.imageV_userIcon.clipsToBounds = YES;
    self.imageV_userIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV_userIcon.layer.cornerRadius = 15;
    
    self.lable_userName = [[UILabel alloc]init];
    self.lable_userName.font = [UIFont systemFontOfSize:14];
    self.lable_userName.textColor = KUIColorFromRGB(0x3C4F5F);
    
    self.imageV_userSex = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dongtai_icon__xb_nan"]];
    
    self.button_Forward = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_Forward setTitleColor:KUIColorFromRGB(0x4D606F) forState:UIControlStateNormal];
    [self.button_Forward setTitle:@"转发" forState:UIControlStateNormal];
    self.button_Forward.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.button_Forward sizeToFit];
    
    self.lable_time = [[UILabel alloc]init];
    self.lable_time.font = [UIFont systemFontOfSize:9];
    self.lable_time.textColor = KUIColorFromRGB(0x6C7B8A);
    self.lable_time.text = @"06-06 08:16";
    [self.lable_time sizeToFit];
    self.lable_time.textAlignment = NSTextAlignmentRight;
    
    self.lable_descrip =[[UILabel alloc]init];
    self.lable_descrip.font = [UIFont systemFontOfSize:14];
    self.lable_descrip.textColor = KUIColorFromRGB(0x4D606F);
    self.lable_descrip.numberOfLines = 0;
    self.lable_descrip.text = @"             ";
    [self.lable_descrip sizeToFit];
    
    self.imageV_forward = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dongtai_img_zfbg"]];
    
    [self addSubview:self.imageV_userIcon];
    [self addSubview:self.lable_userName];
    [self addSubview:self.imageV_userSex];
    [self addSubview:self.button_Forward];
    [self addSubview:self.lable_time];
    [self addSubview:self.lable_descrip];
    [self addSubview:self.imageV_forward];
    
    [self.imageV_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(9);
        make.top.equalTo(self.mas_top).offset(12);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.lable_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_userIcon.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    [self.imageV_userSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lable_userName.mas_centerY);
        make.left.equalTo(self.lable_userName.mas_right).offset(4);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.button_Forward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lable_userName.mas_centerY);
        make.left.equalTo(self.imageV_userSex.mas_right).offset(10);
    }];
    
    [self.lable_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    [self.lable_descrip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_userIcon.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-8);
        make.top.equalTo(self.lable_userName.mas_bottom).offset(10);
    }];
    
    [self.imageV_forward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(18);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(6);
    }];
}

-(void)setModel:(BYC_BaseVideoModel *)model{
    _model = model;
    [self.imageV_userIcon sd_setImageWithURL:[NSURL URLWithString:model.users.headportrait] placeholderImage:[UIImage imageNamed:@"UMS_User_profile_default"]];
    self.lable_userName.text = model.users.nickname;
    
    self.lable_time.text = [model.onmstime substringToIndex:model.onmstime.length-7];
    
    NSString *Str =[model.video_Description stringByReplacingOccurrencesOfString:@"#review#" withString:@""];
    NSMutableAttributedString *attStr;
    if([Str rangeOfString:@"#"].location !=NSNotFound){
        if ([Str rangeOfString:@"#"].location !=0) {
        NSRange range = [Str rangeOfString:@"#"];
        lableStr = [NSString stringWithFormat:@"%@",[Str substringFromIndex:range.location]];
        descrip = [Str substringToIndex:range.location];
        attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",lableStr,descrip]];
        [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0xF89117) range:NSMakeRange(0, lableStr.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(lableStr.length, attStr.length-lableStr.length)];
        }
        else{
            Str = [Str substringFromIndex:1];
            NSRange range = [Str rangeOfString:@"#"];
            lableStr = [NSString stringWithFormat:@"#%@",[Str substringToIndex:range.location+1]];
            descrip = [Str substringFromIndex:range.location+1];
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",lableStr,descrip]];
            [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0xF89117) range:NSMakeRange(0, lableStr.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(lableStr.length, attStr.length-lableStr.length)];
        }
    }
    else{
        descrip = model.video_Description;
        attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",descrip]];
        [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(0, attStr.length)];
    }
    self.lable_descrip.attributedText = attStr;
    [self.lable_descrip sizeToFit];
    
    if (model.users.sex == 0) {
        
        _imageV_userSex.image = [UIImage imageNamed:@"dongtai_icon__xb_nan"];
    }else if(model.users.sex == 1) {
        _imageV_userSex.image = [UIImage imageNamed:@"dongtai_icon__xb_nv"];
    }
}

+(CGFloat)returnHeightOfFocusHeaderView:(BYC_BaseVideoModel *)model{
    if (![model.video_Description isEqualToString:@""]) {
        CGRect descripRect = [model.video_Description boundingRectWithSize:CGSizeMake(screenWidth-47-12,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGSize textSize = [model.video_Description sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        CGFloat textRow = (descripRect.size.height / textSize.height);
        
        return 42 + descripRect.size.height+10 + textRow/2;
    }
    else return 42 + 10;
    
}

@end
