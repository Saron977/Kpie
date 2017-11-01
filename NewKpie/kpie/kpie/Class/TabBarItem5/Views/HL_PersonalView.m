//
//  HL_PersonalView.m
//  kpie
//
//  Created by sunheli on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_PersonalView.h"

@interface HL_PersonalView ()

@property (nonatomic, strong) UIImageView *imageV_userIcon;            /**<     个人头像 */
@property (nonatomic, strong) UILabel     *lable_userName;         /**<     用户名label */
@property (nonatomic, strong) UIButton    *button_Edit;            /**<     编辑资料btn */
@property (nonatomic, strong) UIButton    *button_myCenter;        /**<      我的个人主页btn*/
@property (nonatomic, strong) UIButton    *button_more;

@property (nonatomic, strong) UIButton    *button_Work;            /**<     作品btn */
@property (nonatomic, strong) UIButton    *button_Forward;         /**<     转发btn */
@property (nonatomic, strong) UIButton    *button_Follow;          /**<     关注btn */
@property (nonatomic, strong) UIButton    *button_Fans;            /**<     粉丝btn */

@property (nonatomic, strong) UIView      *H_splitLine;              /**<     分割线 */
@property (nonatomic, strong) UIView      *V_splitLine1;
@property (nonatomic, strong) UIView      *V_splitLine2;
@property (nonatomic, strong) UIView      *V_splitLine3;

@property (nonatomic, strong) UITapGestureRecognizer *tap;           //**<     点击头像*/

@end

@implementation HL_PersonalView
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {

        [self initView];
        [self setViewAutoLayout];
    }
    return self;
}

-(void)initView{

    self.imageV_userIcon = [[UIImageView alloc]init];
    self.imageV_userIcon.clipsToBounds = YES;
    self.imageV_userIcon.layer.cornerRadius = 130/4;
    self.imageV_userIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personalViewButtonAction:)];
    [self.imageV_userIcon addGestureRecognizer:self.tap];
    self.imageV_userIcon.userInteractionEnabled = YES;
    self.imageV_userIcon.image = [UIImage imageNamed:@"icon-tx-160"];
    
    
    self.lable_userName = [[UILabel alloc]init];
    self.lable_userName.font = [UIFont systemFontOfSize:15];
    self.lable_userName.textColor = KUIColorFromRGB(0x21262C);
    self.lable_userName.text = @"昵称";
    [self.lable_userName sizeToFit];
    
    self.button_Edit =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_Edit setImage:[UIImage imageNamed:@"wode_btn_bjzl_n"] forState:UIControlStateNormal];
    [self.button_Edit addTarget:self action:@selector(personalViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button_myCenter =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_myCenter setTitleColor:KUIColorFromRGB(0x4D606F) forState:UIControlStateNormal];
    self.button_myCenter.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button_myCenter setTitle:@"我的个人主页" forState:UIControlStateNormal];
    self.button_myCenter.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.button_myCenter addTarget:self action:@selector(personalViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button_more = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_more setImage:[UIImage imageNamed:@"wode_icon_xiayibu_n"] forState:UIControlStateNormal];
    
    self.H_splitLine = [[UIView alloc]init];
    self.H_splitLine.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    self.V_splitLine1 = [[UIView alloc]init];
    self.V_splitLine1.backgroundColor = KUIColorFromRGB(0xDEDEDE);
//    self.V_splitLine2 = [[UIView alloc]init];
//    self.V_splitLine2.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    self.V_splitLine3 = [[UIView alloc]init];
    self.V_splitLine3.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    
    
    
    self.button_Work = [self createCategoryBtn:@selector(personalViewButtonAction:)];
//    self.button_Forward = [self createCategoryBtn:@selector(personalViewButtonAction:)];
    self.button_Follow = [self createCategoryBtn:@selector(personalViewButtonAction:)];
    self.button_Fans = [self createCategoryBtn:@selector(personalViewButtonAction:)];
    
    [self.button_Work setAttributedTitle:[self customAttributedString:@"作品\n0"] forState:UIControlStateNormal];
    [self.button_Follow setAttributedTitle:[self customAttributedString:@"关注\n0"] forState:UIControlStateNormal];
    [self.button_Fans setAttributedTitle:[self customAttributedString:@"粉丝\n0"] forState:UIControlStateNormal];
    
    [self addSubview:self.imageV_userIcon];
    [self addSubview:self.lable_userName];
    [self addSubview:self.button_Edit];
    [self addSubview:self.button_myCenter];
    [self addSubview:self.button_more];
    [self addSubview:self.H_splitLine];
    [self addSubview:self.V_splitLine1];
//    [self addSubview:self.V_splitLine2];
    [self addSubview:self.V_splitLine3];
    [self addSubview:self.button_Work];
//    [self addSubview:self.button_Forward];
    [self addSubview:self.button_Follow];
    [self addSubview:self.button_Fans];
    self.userInfoModel = [BYC_AccountTool userAccount];
}

-(void)setViewAutoLayout{
    [self.imageV_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.mas_top).offset(12);
        make.width.height.mas_equalTo(130/2);
    }];
    [self.button_Edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageV_userIcon.mas_centerY).offset(8);
        make.left.equalTo(self.imageV_userIcon.mas_right).offset(9);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(21);
    }];
    
    [self.lable_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.button_Edit.mas_top).offset(-6);
        make.left.equalTo(self.imageV_userIcon.mas_right).offset(9);
    }];
    
    [self.button_more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.height.mas_equalTo(18);
        make.centerY.equalTo(self.imageV_userIcon.mas_centerY);
    }];
    
    [self.button_myCenter.titleLabel sizeToFit];
    [self.button_myCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.button_more.mas_left).offset(2);
        make.centerY.equalTo(self.imageV_userIcon.mas_centerY);
    }];
    
    [self.H_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV_userIcon.mas_bottom).offset(12);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.button_Work mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.H_splitLine.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo((screenWidth-1)/3);
        make.height.mas_equalTo(50);
    }];
    
    [self.V_splitLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.button_Work.mas_centerY);
        make.left.equalTo(self.button_Work.mas_right);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(24);
    }];
    
    //    [self.button_Forward mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.H_splitLine.mas_bottom);
    //        make.left.equalTo(self.V_splitLine1.mas_right);
    //        make.width.mas_equalTo((screenWidth-2)/4);
    //        make.height.mas_equalTo(50);
    //    }];
    //
    //    [self.V_splitLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.button_Work.mas_centerY);
    //        make.left.equalTo(self.button_Forward.mas_right);
    //        make.width.mas_equalTo(0.5);
    //        make.height.mas_equalTo(24);
    //    }];
    
    [self.button_Follow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.H_splitLine.mas_bottom);
        make.left.equalTo(self.V_splitLine1.mas_right);
        make.width.mas_equalTo((screenWidth-1)/3);
        make.height.mas_equalTo(50);
    }];
    
    [self.V_splitLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.button_Work.mas_centerY);
        make.left.equalTo(self.button_Follow.mas_right);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(24);
    }];
    
    [self.button_Fans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.H_splitLine.mas_bottom);
        make.left.equalTo(self.V_splitLine3.mas_right);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(50);
    }];
}

-(void)setUserInfoModel:(BYC_AccountModel *)userInfoModel{
    
        _userInfoModel = userInfoModel;
        [self.imageV_userIcon sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.headportrait] placeholderImage:[UIImage imageNamed:@"icon-tx-160"]];
    if (_userInfoModel.nickname == nil) self.lable_userName.text = @"昵称";
    else self.lable_userName.text = _userInfoModel.nickname;
        [self.lable_userName sizeToFit];
        if (_userInfoModel.userInfo.videos < 0) {
            _userInfoModel.userInfo.videos = 0;
        }
        [self.button_Work setAttributedTitle:[self customAttributedString:[NSString stringWithFormat:@"作品\n%ld",(long)_userInfoModel.userInfo.videos]] forState:UIControlStateNormal];
//        [self.button_Forward setAttributedTitle:[self customAttributedString:[NSString stringWithFormat:@"转发\n%d",userInfoModel.focus]] forState:UIControlStateNormal];
        [self.button_Follow setAttributedTitle:[self customAttributedString:[NSString stringWithFormat:@"关注\n%ld",(long)_userInfoModel.userInfo.focus]] forState:UIControlStateNormal];
        [self.button_Fans setAttributedTitle:[self customAttributedString:[NSString stringWithFormat:@"粉丝\n%ld",(long)_userInfoModel.userInfo.fans]] forState:UIControlStateNormal];
    
}

/** 创建一个button */
- (UIButton *)createCategoryBtn:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    return button;
}

-(NSAttributedString *)customAttributedString:(NSString *)string{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:KUIColorFromRGB(0x6C7B8A)} range:NSMakeRange(0, 2)];
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:KUIColorFromRGB(0x21262C)} range:NSMakeRange(3, attrStr.length-3)];
    return attrStr;
}


-(void)personalViewButtonAction:(id)sender{
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(personalButtonAction:)]) {
        [self.delegate personalButtonAction:sender];
    }

}

@end
