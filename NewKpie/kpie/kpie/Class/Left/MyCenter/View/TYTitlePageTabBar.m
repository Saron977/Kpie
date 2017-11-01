//
//  TYTitlePageTabBar.m
//  TYSlidePageScrollViewDemo
//
//  Created by SunYong on 15/7/16.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "TYTitlePageTabBar.h"

@interface TYTitlePageTabBar ()
@property (nonatomic, strong) NSArray *btnArray;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, weak) UIView *horIndicator;

@end

@implementation TYTitlePageTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textFont = [UIFont systemFontOfSize:14];
        _selectedTextFont = [UIFont systemFontOfSize:16];
        _textColor =KUIColorFromRGB(0X8F8F8F);
        _selectedTextColor = KUIColorBaseGreenNormal;
        _horIndicatorColor = KUIColorBaseGreenNormal;
        _horIndicatorHeight = 2;
        
        [self addHorIndicatorView];
        [self addTitleBtnArray];
        
    }
    return self;
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray
{
    return [self initWithTitleArray:titleArray imageNameArray:nil];
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray imageNameArray:(NSArray *)imageNameArray
{
    if (self = [super init]) {
        _titleArray = titleArray;
        _imageArray = imageNameArray;
//        [self addTitleBtnArray];
        [self.button_Works setTitle:_titleArray[0] forState:UIControlStateNormal];
        [self.button_Focus setTitle:_titleArray[1] forState:UIControlStateNormal];
        [self.button_Fans setTitle:_titleArray[2] forState:UIControlStateNormal];
        [self.button_Works setImage:_imageArray[0] forState:UIControlStateNormal];
        [self.button_Focus setImage:_imageArray[1] forState:UIControlStateNormal];
        [self.button_Fans setImage:_imageArray[2] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
//    [self addTitleBtnArray];
    [self.button_Works setTitle:_titleArray[0] forState:UIControlStateNormal];
    [self.button_Focus setTitle:_titleArray[1] forState:UIControlStateNormal];
    [self.button_Fans setTitle:_titleArray[2] forState:UIControlStateNormal];
    
}

#pragma mark - add subView

- (void)addHorIndicatorView
{
    UIView *horIndicator = [[UIView alloc]init];
    horIndicator.backgroundColor = _horIndicatorColor;
    [self addSubview:horIndicator];
    _horIndicator = horIndicator;
}

- (void)addTitleBtnArray
{
    if (_btnArray) {
        [self removeTitleBtnArray];
    }
    
    NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:_titleArray.count];
//    for (NSInteger index = 0; index < _titleArray.count; ++index) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.tag = index;
//        button.titleLabel.numberOfLines = 2;
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        button.titleLabel.font = _textFont;
//        [button setTitle:_titleArray[index] forState:UIControlStateNormal];
//        [button setTitleColor:_textColor forState:UIControlStateNormal];
//        [button setTitleColor:_selectedTextColor forState:UIControlStateSelected];
//        if (index < _imageArray.count) {
//            NSString *imageName = _imageArray[index];
//            if (imageName.length > 0) {
//                [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//            }
//        }
//        
//        [button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
//        [btnArray addObject:button];
//        if (index == 0) {
//            [self selectButton:button];
//        }
//    }
    self.button_Works = [self customButton];
    self.button_Works.tag = 0;
    [self addSubview:self.button_Works];
    
    self.button_Focus = [self customButton];
    self.button_Focus.tag = 1;
    [self addSubview:self.button_Focus];
    
    self.button_Fans  = [self customButton];
    self.button_Fans.tag = 2;
    [self addSubview:self.button_Fans];
    
    [btnArray addObject:self.button_Works];
    [btnArray addObject:self.button_Focus];
    [btnArray addObject:self.button_Fans];
    
    if (_selectedPage == 0) {
        [self selectButton:self.button_Works];
    }
    _btnArray = [btnArray copy];
}

-(UIButton *)customButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = _textFont;
    [button setTitleColor:_textColor forState:UIControlStateNormal];
    [button setTitleColor:_selectedTextColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - private menthod
- (void)removeTitleBtnArray
{
    [_btnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _btnArray = nil;
}

- (void)selectButton:(UIButton *)button
{
    if (_selectBtn) {
        _selectBtn.selected = NO;
        if (_selectedTextFont) {
            
            _selectBtn.titleLabel.font = _textFont;
            
        }
    }
    _selectBtn = button;
    
    CGRect frame = _horIndicator.frame;
    frame.origin.x = CGRectGetMinX(_selectBtn.frame) + _horIndicatorSpacing;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        _horIndicator.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    _selectBtn.selected = YES;
    if (_selectedTextFont) {
        _selectBtn.titleLabel.font = _selectedTextFont;
        
    }
}
#pragma mark - action method
// clicked
- (void)tabButtonClicked:(UIButton *)button
{
    
    //防止重新点击
    if (_selectBtn == button) {
        return;
    }
    [self selectButton:button];
    
    // need ourself call this method
    [self clickedPageTabBarAtIndex:button.tag];
}

#pragma mark - override method
// override
- (void)switchToPageIndex:(NSInteger)index
{
    if (index >= 0 && index < _btnArray.count) {
        [self selectButton:_btnArray[index]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnWidth = (CGRectGetWidth(self.frame)-_edgeInset.left-_edgeInset.right + _titleSpacing)/_btnArray.count - _titleSpacing;
    CGFloat viewHeight = CGRectGetHeight(self.frame)-_edgeInset.top-_edgeInset.bottom;
    
    [_btnArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.frame = CGRectMake(idx*(btnWidth+_titleSpacing)+_edgeInset.left, _edgeInset.top, btnWidth, viewHeight);
    }];
    
    NSInteger curIndex = 0;
    if (_selectBtn) {
        curIndex = [_btnArray indexOfObject:_selectBtn];
    }
    
    _horIndicator.frame = CGRectMake(curIndex*(btnWidth+_titleSpacing)+_edgeInset.left + _horIndicatorSpacing, CGRectGetHeight(self.frame) - _horIndicatorHeight, btnWidth - _horIndicatorSpacing * 2, _horIndicatorHeight);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
