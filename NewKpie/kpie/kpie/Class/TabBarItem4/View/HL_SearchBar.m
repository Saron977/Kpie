//
//  HL_SearchBar.m
//  kpie
//
//  Created by sunheli on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_SearchBar.h"

@interface HL_SearchBar ()<UITextFieldDelegate>

@end
@implementation HL_SearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:0.7];
        //外层
        UIView *whiteBg = [[UIView alloc] init];
        whiteBg.frame = CGRectMake(8, 8, frame.size.width - 2* 8,frame.size.height - 2* 8);
        whiteBg.layer.cornerRadius = 6;
        whiteBg.clipsToBounds = YES;
        whiteBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteBg];
        // 左边的放大镜图标
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, whiteBg.kheight, whiteBg.kheight)];
        [iconView setImage:[self scaleToSize:[UIImage imageNamed:@"icon_sousuo_chaxun_n"] size:CGSizeMake(14, 14)]];
        iconView.contentMode = UIViewContentModeCenter | UIViewContentModeScaleAspectFit;
        iconView.left = 5;
        iconView.mj_y = whiteBg.mj_y;
        [whiteBg addSubview:iconView];
        //textfield
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(iconView.left + iconView.kwidth, 0, whiteBg.kwidth - 5 - iconView.kwidth, whiteBg.kheight)];
        textField.font = [UIFont systemFontOfSize:13];
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [whiteBg addSubview:textField];
        self.textField = textField;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangeText) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setCanEditing:(BOOL)canEditing
{
    _canEditing = canEditing;
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}

@synthesize text = _text;
- (void)setText:(NSString *)text
{
    _text = text;
    self.textField.text = text;
}

- (NSString *)text
{
    return self.textField.text;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


#pragma mark -----textField代理

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([self.delegate respondsToSelector:@selector(searchBarDidtouch:)]) {
        [self.delegate searchBarDidtouch:self];
    }
    return _canEditing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBar:didSearch:)]) {
        [self.delegate searchBar:self didSearch:textField.text];
    }
    return YES;
}

- (void)textFieldChangeText
{
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:self.textField.text];
    }
}


@end
