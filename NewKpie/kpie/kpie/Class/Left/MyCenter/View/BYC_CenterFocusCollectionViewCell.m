//
//  BYC_CenterFocusCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 15/12/9.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_CenterFocusCollectionViewCell.h"
#import "BYC_AccountTool.h"
#import "BYC_LoginAndRigesterView.h"
@interface BYC_CenterFocusCollectionViewCell() {

    BOOL _whetherFocus;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageV_header;
@property (weak, nonatomic) IBOutlet UILabel *label_NickName;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Sex;


@end

@implementation BYC_CenterFocusCollectionViewCell

-(void)setModel:(BYC_AccountModel *)model {

    _model = model;
    _button_Focus.tag = _model.flag_Btn;
    [_imageV_header sd_setImageWithURL:[NSURL URLWithString:_model.headportrait] placeholderImage:[UIImage imageNamed:@"icon-tx-160"]];
    if (_model.nickname.length > 0) {
        _label_NickName.text = model.nickname;
    }
    else _label_NickName.text = @"昵称";
    

    [self settingsButtonFocus:_model.whetherFocusForCell];
    
    if (_model.sex == 0) {
        
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nan"];
    }else if(_model.sex == 1) {
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nv-xiao"];
    }else {
        _imageV_Sex.image = [UIImage imageNamed:@"baomi"];
    }
    [self registerKVO];
}

- (void)registerKVO {
    
    [_model rac_observeKeyPath:@"whetherFocusForCell" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        [self settingsButtonFocus:[value integerValue]];
    }];
}

-(void)setWhetherFocusForCell:(WhetherFocusForCell)whetherFocusForCell {

    _whetherFocusForCell = whetherFocusForCell;
    
    [self settingsButtonFocus:whetherFocusForCell];
}

- (void)settingsButtonFocus:(WhetherFocusForCell)attentionState {

    switch (attentionState) {
        case WhetherFocusForCellHXFocus://互相关注
        case WhetherFocusForCellYES://已关注
            _whetherFocus = YES;
            _button_Focus.enabled = NO;
            [_button_Focus setImage:[UIImage imageNamed:@"icon-focus-h"] forState:UIControlStateNormal];
            break;
        case WhetherFocusForCellFocused://被关注
        case WhetherFocusForCellNO:
            _whetherFocus = NO;
            _button_Focus.enabled = YES;
            [_button_Focus setImage:[UIImage imageNamed:@"icon-gz"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    if ([[BYC_AccountTool userAccount].userid isEqualToString:_model.userid]) {//只要是自己的列表就不出现关注按钮
        
        _button_Focus.enabled = NO;
       [_button_Focus setImage:[UIImage imageNamed:@"icon-focus-h"] forState:UIControlStateNormal];
    }
}

- (IBAction)focusButtonAction:(UIButton *)sender {
    
    if (![BYC_AccountTool userAccount]) {
        
        [BYC_LoginAndRigesterView shareLoginAndRigesterViewSuccess:nil failure:nil];
    }else _whetherFocusBlock(_whetherFocus ,_model ,sender,NO);

}

@end
