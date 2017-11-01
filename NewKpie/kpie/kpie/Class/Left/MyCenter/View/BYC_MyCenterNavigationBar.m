//
//  BYC_MyCenterNavigationBar.m
//  kpie
//
//  Created by 元朝 on 16/9/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MyCenterNavigationBar.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_MyCenterUserModel.h"
#import "BYC_MyCenterHandler.h"

@interface BYC_MyCenterNavigationBar ()

@property (nonatomic, strong)  BYC_MyCenterUserModel *model;

@end
@implementation BYC_MyCenterNavigationBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initNavgationBar];

    }
    return self;
}

-(void)initNavgationBar{
    
//    BYC_MyCenterNavigationBar *customNavBar = [[BYC_MyCenterNavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, KHeightNavigationBar)];
    
    UIButton *btn_Back = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_Back setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [btn_Back setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [[btn_Back rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.getBGViewController.navigationController popViewControllerAnimated:YES];
    }];

    [self addSubview:btn_Back];
    [btn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        
        (void)make.centerYWithinMargins.offset(10);
        (void)make.left.offset(-10);
        make.width.height.offset(KHeightNavigationBar);
    }];
    
    UILabel *label = [UILabel new];
    label.text = @"个人中心";
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        (void)make.centerXWithinMargins;
        (void)make.centerYWithinMargins.offset(10);
    }];
    
    _button_SelectedBlacklist = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_SelectedBlacklist setImage:[UIImage imageNamed:@"icon-more-n"] forState:UIControlStateNormal];
    [_button_SelectedBlacklist setImage:[UIImage imageNamed:@"icon-more-h"] forState:UIControlStateHighlighted];
    [_button_SelectedBlacklist addTarget:self action:@selector(selectedBlackListAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button_SelectedBlacklist];
    
    [_button_SelectedBlacklist mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.centerYWithinMargins.offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.height.mas_equalTo(45);
    }];
}

-(void)selectedBlackListAction:(UIButton *)sender{
    if (self.blackDelegate && [self.blackDelegate respondsToSelector:@selector(ShowSelectedBlackListDelegate:)]) {
        [self.blackDelegate ShowSelectedBlackListDelegate:_model];
    }
}

-(void)setHandle:(BYC_MyCenterHandler *)handle {
    
    _handle = handle;
    self.model = (BYC_MyCenterUserModel *)_handle.model_CurrentUser;
    
    
}

-(void)setModel:(BYC_MyCenterUserModel *)model {
    
    _model = model;
    [self loadData];
}

-(void)loadData{
    if ([[BYC_AccountTool userAccount].userid isEqualToString:_model.userid])
        _button_SelectedBlacklist.hidden = YES;
    else
        _button_SelectedBlacklist.hidden = NO;
}



@end
