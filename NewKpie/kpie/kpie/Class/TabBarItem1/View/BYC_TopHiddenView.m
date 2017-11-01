//
//  BYC_TopHiddenView.m
//  kpie
//
//  Created by 元朝 on 15/12/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_TopHiddenView.h"
#import "UIView+BYC_Tools.h"

@interface BYC_TopHiddenView()

@property (strong, nonatomic)  UIButton    *button_New;
@property (strong, nonatomic)  UIButton    *button_Hot;
@property (strong, nonatomic)  UIView      *view_New;
@property (strong, nonatomic)  UIView      *view_Hot;
@property (nonatomic, strong)  UIView      *viewBottom;

/**毛玻璃视图*/
@property (nonatomic, strong)  UIVisualEffectView *visualEffectView;
@end
@implementation BYC_TopHiddenView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

        [self initViews];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setSelectButton:(BYC_TopHiddenViewSelectedButton)selectButton {

    [self selectButton:selectButton];
}

- (void)initViews {

    _button_New = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_New setTitle:@"----" forState:UIControlStateNormal];
    [_button_New setTitleColor:KUIColorFromRGB(0x4BC8BD) forState:UIControlStateNormal];
    _button_New.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_New addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_New.tag = 1;
    _view_New = [[UIView alloc] init];
    _view_New.backgroundColor = KUIColorFromRGB(0x4BC8BD);
    [_button_New addSubview:_view_New];
    
    _button_Hot = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Hot setTitle:@"----" forState:UIControlStateNormal];
    _button_Hot.titleLabel.font = [UIFont systemFontOfSize:15];
    _button_Hot.tintColor = KUIColorFromRGB(0x4BC8BD);
    [_button_Hot addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_Hot.tag = 2;
    _view_Hot = [[UIView alloc] init];
    _view_Hot.backgroundColor = KUIColorFromRGB(0x4BC8BD);
    _view_Hot.hidden = YES;
    [_button_New addSubview:_view_Hot];

    _viewBottom = [[UIView alloc] init];
    _viewBottom.backgroundColor = KUIColorFromRGB(0x4BC8BD);
    
    
    [self setBlurEffectView];
    [self addSubview:_button_New];
    [self addSubview:_button_Hot];
    [self addSubview:_viewBottom];
    
}

/**
 *  设置毛玻璃
 */
-(void)setBlurEffectView{
    
    _visualEffectView = [self getBlurEffectViewWithStyle:UIBlurEffectStyleDark];
    [self addSubview:_visualEffectView];
}

-(void)setArray_VideoGroup:(NSArray<BYC_MTVideoGroupModel *> *)array_VideoGroup {
    
    [_button_New setTitle:((BYC_MTVideoGroupModel *)array_VideoGroup[0]).videoGroup_Name forState:UIControlStateNormal];
    [_button_Hot setTitle:((BYC_MTVideoGroupModel *)array_VideoGroup[1]).videoGroup_Name forState:UIControlStateNormal];
}

-(void)setArray_SortModel:(NSArray<HL_ColumnVideoSortModel *> *)array_SortModel{
    [_button_New setTitle:array_SortModel[0].sortname forState:UIControlStateNormal];
    [_button_Hot setTitle:array_SortModel[1].sortname forState:UIControlStateNormal];
}

- (void)buttonAction:(UIButton *)sender {

    [self selectButton:sender.tag];

    if (self.buttonAction) {
        
        self.buttonAction(sender.tag);
    }
}

- (void)selectButton:(NSInteger)flag {

    switch (flag) {
        case 1://最新
            
            _view_New.hidden = NO;
            _view_Hot.hidden = YES;
            [_button_New setTitleColor:KUIColorFromRGB(0x4BC8BD) forState:UIControlStateNormal];
            [_button_Hot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            break;
        case 2://最热
            
            _view_New.hidden = YES;
            _view_Hot.hidden = NO;
            [_button_Hot setTitleColor:KUIColorFromRGB(0x4BC8BD) forState:UIControlStateNormal];
            [_button_New setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

-(void)layoutSubviews {

    [super layoutSubviews];
    
    self.kheight = self.kheight + 20;
    _button_New.frame = CGRectMake(0, 0, self.kwidth / 2.0f, self.kheight);
     _view_New.frame = CGRectMake(0, _button_New.bottom - 2, _button_New.kwidth, 2);
     _button_Hot.frame = CGRectMake(_button_New.right, 0, self.kwidth / 2.0f, self.kheight);
    _view_Hot.frame = CGRectMake(_view_New.right, _button_Hot.bottom - 2, _button_Hot.kwidth, 2);
    _viewBottom.frame = CGRectMake(0, self.kheight - .5f, self.kwidth, .5f);
    _visualEffectView.frame = self.bounds;
}

@end
