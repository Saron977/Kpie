//
//  HL_ColumnGroupView.m
//  kpie
//
//  Created by sunheli on 16/11/14.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_ColumnGroupView.h"

@implementation HL_ColumnGroupView

-(instancetype)init{
    self = [super init];
    if (self) {
       
        [self initGroupView];
        [self makeLayoutGroupView];
    }
    
    return self;
}

-(void)initGroupView{
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 15;
    self.layer.borderWidth = 1;
    self.layer.borderColor = KUIColorBaseGreenNormal.CGColor;
    
    _button_Group1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Group1 setBackgroundColor:KUIColorBaseGreenNormal];
    [_button_Group1 setTitleColor:KUIColorWordsBlack3 forState:UIControlStateNormal];
    [_button_Group1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _button_Group1.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_Group1 setTitle:@"------" forState:UIControlStateNormal];
    _button_Group1.selected = YES;
    _button_Group1.tag = 3;
    
    
    _button_Group2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Group2 setTitleColor:KUIColorWordsBlack2 forState:UIControlStateNormal];
    [_button_Group2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _button_Group2.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_Group2 setTitle:@"------" forState:UIControlStateNormal];
    _button_Group2.selected = NO;
    _button_Group2.tag = 4;
    
    _button_Group3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Group3 setTitleColor:KUIColorWordsBlack2 forState:UIControlStateNormal];
    [_button_Group3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _button_Group3.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_Group3 setTitle:@"------" forState:UIControlStateNormal];
    _button_Group3.selected = NO;
    _button_Group3.tag = 5;

    
    _imageView_Split1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_sqfgx"]];
    _imageView_Split2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_sqfgx"]];
    
    [self addSubview:_button_Group1];
    [self addSubview:_button_Group2];
    [self addSubview:_button_Group3];
    
    [self addSubview:_imageView_Split1];
    [self addSubview:_imageView_Split2];

}

-(void)makeLayoutGroupView{
    [_button_Group1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo((screenWidth-42)/3);
    }];
    
    [_imageView_Split1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_Group1.mas_right);
        make.top.equalTo(self.mas_top).offset(3);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
        make.width.mas_equalTo(1);
    }];
    
    [_button_Group2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView_Split1.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo((screenWidth-42)/3);
    }];
    
    [_imageView_Split2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_Group2.mas_right);
        make.top.equalTo(self.mas_top).offset(3);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
        make.width.mas_equalTo(1);
    }];
    
    [_button_Group3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(_imageView_Split2.mas_right);
    }];
    
}
@end
