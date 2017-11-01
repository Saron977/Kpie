//
//  HL_VideoDetailBottomView.m
//  kpie
//
//  Created by sunheli on 16/7/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_VideoDetailBottomView.h"

@implementation HL_VideoDetailBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBottomView];
        [self setViewAutolayout];
        self.backgroundColor = KUIColorFromRGB(0xFCFCFC);
    }
    return self;
}

-(void)initBottomView{
    
    _view_script = [[UIView alloc]init];
    _view_script.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    
    _button_writeComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_writeComment setBackgroundColor:KUIColorFromRGB(0xF0F0F0)];
    [_button_writeComment setTitle:@"写评论..." forState:UIControlStateNormal];
    _button_writeComment.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button_writeComment setTitleColor:KUIColorWordsBlack3 forState:UIControlStateNormal];
    [_button_writeComment setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
    _button_writeComment.layer.cornerRadius = 5;
    _button_writeComment.layer.masksToBounds = YES;
    _button_writeComment.layer.borderWidth = 1;
    _button_writeComment.layer.borderColor = KUIColorFromRGB(0xDEDEDE).CGColor;
    _button_writeComment.tag = 1100;
    [_button_writeComment addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_comment = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_comment setImage:[UIImage imageNamed:@"video_btn_pinglun_n"] forState:UIControlStateNormal];
    [_button_comment setImage:[UIImage imageNamed:@"video_btn_pinglun_h"] forState:UIControlStateSelected];
    _button_comment.tag = 1101;
    [_button_comment addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _lable_commentCount = [[UILabel alloc]init];
    _lable_commentCount.textColor = KUIColorBaseGreenNormal;
    _lable_commentCount.font = [UIFont systemFontOfSize:9];
    _lable_commentCount.text = @"2266";
    [_lable_commentCount sizeToFit];
    
    _button_like = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_like setImage:[UIImage imageNamed:@"video_btn_like_n"] forState:UIControlStateNormal];
    [_button_like setImage:[UIImage imageNamed:@"video_btn_like_s"] forState:UIControlStateSelected];
    _button_like.tag = 1102;
    [_button_like addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _lable_likeCount = [[UILabel alloc]init];
    _lable_likeCount.textColor = KUIColorBaseGreenNormal;
    _lable_likeCount.font = [UIFont systemFontOfSize:9];
    _lable_likeCount.text = @"6624";
    [_lable_likeCount sizeToFit];
    
    _button_forward = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_forward setImage:[UIImage imageNamed:@"video_btn_share_n"] forState:UIControlStateNormal];
    [_button_forward setImage:[UIImage imageNamed:@"video_btn_share_h"] forState:UIControlStateSelected];
    _button_forward.tag = 1103;
    [_button_forward addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_view_script];
    [self addSubview:_button_writeComment];
    [self addSubview:_button_like];
    [self addSubview:_button_comment];
    [self addSubview:_button_forward];
    [self addSubview:_lable_commentCount];
    [self addSubview:_lable_likeCount];
    
}

-(void)setViewAutolayout{
    [_view_script mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    
    [_button_writeComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(screenWidth*0.46);
    }];
    
    [_button_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_button_writeComment.mas_right).offset(19);
        make.width.height.mas_equalTo(24);
    }];
    [_lable_commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_comment.mas_right);
        make.bottom.equalTo(_button_comment.mas_top).offset(11);
    }];
    
    [_button_like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_button_comment.mas_right).offset((screenWidth-115-screenWidth*0.46)/2);
        make.width.height.mas_equalTo(24);
    }];
    [_lable_likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_like.mas_right);
        make.bottom.equalTo(_button_like.mas_top).offset(11);
    }];
    
    [_button_forward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_button_like.mas_right).offset((screenWidth-115-screenWidth*0.46)/2-10);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(24);
    }];

}

-(void)setFocusListModel:(BYC_BaseVideoModel *)focusListModel{
    _focusListModel = focusListModel;
    _lable_commentCount.text = [NSString stringWithFormat:@"%lu",focusListModel.comments];
    _lable_likeCount.text = [NSString stringWithFormat:@"%lu",focusListModel.favorites];
    [_lable_commentCount sizeToFit];
    [_lable_likeCount sizeToFit];

}

-(void)clickButtonAction:(UIButton *)sender{
    if (self.buttonDelegate && [self.buttonDelegate respondsToSelector:@selector(clickBottomButton:)]) {
        [self.buttonDelegate clickBottomButton:sender];
    }
}


@end
