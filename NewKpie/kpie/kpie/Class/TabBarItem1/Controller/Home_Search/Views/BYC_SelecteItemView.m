//
//  BYC_SelecteItemView.m
//  kpie
//
//  Created by 元朝 on 16/5/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_SelecteItemView.h"

@interface BYC_SelecteItemView()

/**按钮集合*/
@property (nonatomic, strong)  NSMutableArray <UIButton *> *mArray_Buttons;
/**底部视图*/
@property (nonatomic, strong)  UIView   *view_Bottom;
/**button宽度*/
@property (nonatomic, assign)  CGFloat  buttonWidth;
/**选中的下标*/
@property (nonatomic, assign)  NSUInteger  selectIndex;

@end


@implementation BYC_SelecteItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initParam];
        [self setupBottomViews];
    }
    return self;
}

- (void)initParam {

    _mArray_Buttons = [NSMutableArray array];
    
}

- (void)setupBottomViews {

    _view_Bottom = [[UIView alloc] init];
    _view_Bottom.backgroundColor = KUIColorFromRGB(0x40AE9E);
    [self addSubview:_view_Bottom];
    [_view_Bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.bottom.equalTo(_view_Bottom.superview);
        make.height.offset(1);
        make.width.offset(_buttonWidth);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KUIColorFromRGBA(0xFFFFFF,.5);
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.bottom.equalTo(view.superview);
        make.height.offset(.5f);
        make.width.offset(screenWidth);
    }];
}

#pragma mark - set方法

-(void)setArray_Titles:(NSArray<NSString *> *)array_Titles {

    _array_Titles = array_Titles;
    _buttonWidth = screenWidth / array_Titles.count;
    [_view_Bottom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(_buttonWidth);
    }];
    
    for (int i = 0; i < array_Titles.count; i++) {
        NSString *title = array_Titles[i];
        
        if (_mArray_Buttons.count != array_Titles.count) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            if (i == 0) [button setTitleColor:KUIColorFromRGB(0X87A4C9) forState:UIControlStateNormal];
            else [button setTitleColor:KUIColorFromRGB(0X828E9A) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.bottom.equalTo(button.superview);
                make.width.offset(_buttonWidth);
                make.leading.offset(_buttonWidth * i);
            }];
            
            [_mArray_Buttons addObject:button];
            
        }else [_mArray_Buttons[i] setTitle:title forState:UIControlStateNormal];
    }
}

-(void)setSelectIndex:(NSUInteger)selectIndex {

    for (UIButton *btn in _mArray_Buttons)
        [btn setTitleColor:KUIColorFromRGB(0X828E9A) forState:UIControlStateNormal];
    [_mArray_Buttons[selectIndex] setTitleColor:KUIColorFromRGB(0X87A4C9) forState:UIControlStateNormal];
}

- (void)buttonAction:(UIButton *)button {

    if (_delegate_SelecteItemView && [_delegate_SelecteItemView respondsToSelector:@selector(selecteItemView:selectedIndex:)])
    [_delegate_SelecteItemView selecteItemView:self selectedIndex:button.tag];
}

- (void)bottomViewScrollOffset:(CGFloat)offset {
    
    [_view_Bottom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(offset  / self.array_Titles.count);
    }];
    
    self.selectIndex = offset  / self.array_Titles.count / _buttonWidth;
}

@end
