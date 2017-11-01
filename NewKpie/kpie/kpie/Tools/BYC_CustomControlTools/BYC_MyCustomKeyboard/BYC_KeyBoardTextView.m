//
//  BYC_KeyBoardTextView.m
//  kpie
//
//  Created by 元朝 on 16/8/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_KeyBoardTextView.h"

/**接收到表情的通知*/
UIKIT_EXTERN NSString * const Notification_SelectedFaceName;

@interface BYC_KeyBoardTextView ()

/**占位文字View: 为什么使用UITextView，这样直接让占位文字View = 当前textView,文字就会重叠显示*/
@property (nonatomic, weak) UITextView *placeholderView;
/**文字高度*/
@property (nonatomic, assign) NSInteger int_TextHeight;
/**文字最大高度*/
@property (nonatomic, assign) NSInteger int_TextMaxHeight;

@end

@implementation BYC_KeyBoardTextView


- (UITextView *)placeholderView
{
    if (_placeholderView == nil) {
        UITextView *placeholderView = [[UITextView alloc] init];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderView];
        [_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            (void)make.top.leading.bottom.trailing;
        }];
    }
    return _placeholderView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self initParam];
    }
    return self;
}

- (void)initParam {

    // 设置文本框占位文字
    self.placeholder = @"请输入文字";
}

- (void)setup
{
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.returnKeyType = UIReturnKeyDone;
    self.layer.borderWidth = 1;
    self.font = [UIFont systemFontOfSize:12];
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

-(void)setUInt_MaxNumberOfLines:(NSUInteger)uInt_MaxNumberOfLines {

    _uInt_MaxNumberOfLines = uInt_MaxNumberOfLines;
    
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _int_TextMaxHeight = ceil(self.font.lineHeight * _uInt_MaxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
    
}

- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setTextHeightChangeBlock:(void (^)(NSString *, CGFloat))textChangeBlock
{
    _textHeightChangeBlock = textChangeBlock;
    
    [self textDidChange];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderView.hidden = self.text.length > 0;
    self.placeholderView.text = placeholder;

}

//
- (void)textDidChange
{//textView的contentSize赋值不能及时，导致textView高度定到最大的时候，textView不能滑动，问题待优化，目前就先这么处理吧。

    if (self.text.length > 120 && self.text.length > 0) {//textView的contentSize赋值不能及时，导致textView高度定到最大的时候，textView不能滑动，问题待优化，目前就先这么处理吧。
        self.text = [self.text substringToIndex:121];
        [[UIView alloc] showAndHideHUDWithTitle:@"字数不能超过120字" WithState:BYC_MBProgressHUDShowTurnplateProgress];
        return;
    }
    
    // 占位文字是否显示
    self.placeholderView.hidden = self.text.length > 0;
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if (_int_TextHeight != height) { // 高度不一样，就改变了高度
        _int_TextHeight = height;
        _textHeightChangeBlock(self.text,height);
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handelReceiveSelectedFaceName:(NSNotification *)notification {
    
    
    QNWSLog(@"notification = %@",notification.object);
    
}

@end
