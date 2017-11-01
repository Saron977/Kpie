//
//  HL_EmptyDataView.m
//  kpie
//
//  Created by sunheli on 16/7/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_EmptyDataView.h"

@interface HL_EmptyDataView ()

@property (nonatomic, strong) UILabel  *lable_emptyStr;
@property (nonatomic, strong) UIView   *left;
@property (nonatomic, strong) UIView   *right;

@end
@implementation HL_EmptyDataView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor redColor];
    if (self) {
        self.left = [[UIView alloc] init];
        self.left.backgroundColor = KUIColorBackgroundCuttingLine;
        [self addSubview:self.left];
        self.right = [[UIView alloc] init];
        self.right.backgroundColor = KUIColorBackgroundCuttingLine;
        [self addSubview:self.right];
        self.lable_emptyStr = [[UILabel alloc] init];
        self.lable_emptyStr.font = [UIFont systemFontOfSize:13];
        self.lable_emptyStr.textColor = KUIColorWordsBlack3;
        self.lable_emptyStr.text  = @"抱歉，暂无数据";
        self.lable_emptyStr.numberOfLines = 0;
        self.lable_emptyStr.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lable_emptyStr];
        
        [self.left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(self.mas_left).offset(screenWidth * 0.1);
            make.centerY.equalTo(self.lable_emptyStr.mas_centerY);
            make.right.equalTo(self.lable_emptyStr.mas_left).offset(-screenWidth * 0.05);
        }];
        
        [self.right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(self.lable_emptyStr.mas_right).offset(screenWidth * 0.05);
            make.centerY.equalTo(self.lable_emptyStr.mas_centerY);
            make.right.equalTo(self.mas_right).offset( - screenWidth * 0.1);
        }];
        
        [self.lable_emptyStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-screenHeight * 0.1);
            make.right.equalTo(self.right.mas_left).offset(-screenWidth * 0.05);
            make.left.equalTo(self.left.mas_right).offset(screenWidth * 0.05);
        }];

    }
    return self;
}
-(void)setEmptyStr:(NSString *)emptyStr{
    _emptyStr = emptyStr;
    self.lable_emptyStr.text = _emptyStr;
}
@end
