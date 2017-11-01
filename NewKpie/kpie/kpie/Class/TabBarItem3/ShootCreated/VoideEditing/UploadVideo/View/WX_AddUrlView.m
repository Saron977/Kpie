//
//  WX_AddUrlView.m
//  kpie
//
//  Created by 王傲擎 on 16/9/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_AddUrlView.h"
#import "WX_ToolClass.h"

typedef enum {
    ENUM_ADDNOTIFI      = 0,    /**<   创建监听 */
    ENUM_REMOVENOTIFI   = 1,    /**    移除监听 */
}NotifiAddOrRemove;

#define INTERVAL_KEYBOARD 20
#define URLVIEWOBJECT @"UrlViewObject"

static WX_AddUrlView   *view_MainBack; /**< 图层_主背景界面 */

@interface WX_AddUrlView()<UITextFieldDelegate>
@property (nonatomic, strong) UIView                    *view_Back;             /**<   背景图 */
@property (nonatomic, strong) UIView                    *view_TextFiledBack;    /**<   text 背景框 */
@property (nonatomic, strong) UITextField               *textField_Url;         /**<   网址链接 */
@property (nonatomic, strong) UIView                    *view_Top;              /**<   顶部背景图 */
@property (nonatomic, strong) UILabel                   *label_Placeholder;     /**<   提示文字 */
@property (nonatomic, strong) UIView                    *view_Middle;           /**<   中部背景图 */
@property (nonatomic, strong) UIView                    *view_Bottom;           /**<   低部背景图 */
@property (nonatomic, strong) UIButton                  *button_Done;           /**<   完成按钮 */
@property (nonatomic, strong) UIButton                  *button_Cancel;         /**<   取消按钮 */
@property (nonatomic, assign) NotifiAddOrRemove         ENUM_Notifi;            /**<   是否移除监听 */
@property (nonatomic, copy  ) NSString                  *placeholder;           /**<   提示文字 */
@end

@implementation WX_AddUrlView

-(void)createUrlViewWithView:(WX_AddUrlView *)urlView Frame:(CGRect)frame Placeholder:(NSString *)placeholder
{
    if (!view_MainBack) {
        view_MainBack = urlView;
        urlView = view_MainBack;
        view_MainBack.backgroundColor = KUIColorFromRGBA(0x000000, 0.5f);
//        view_MainBack.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDropDownWithTap:)];
//        [view_MainBack addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:view_MainBack];
        
        
        [view_MainBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        view_MainBack.placeholder = placeholder;
        
        [view_MainBack createUIWithFrame:frame];
        
//        [view_MainBack createOrRemoveNotifiWith:ENUM_ADDNOTIFI];
        
        view_MainBack.state_UrlView = ENUM_ViewDidLoad;
    }
}

/**
 *  创建ui
 */
-(void)createUIWithFrame:(CGRect)frame
{
    _view_Back = [[UIView alloc]init];
    _view_Back.layer.masksToBounds = YES;
    _view_Back.layer.cornerRadius = 10.f;
    _view_Back.backgroundColor = KUIColorFromRGB(0xffffff);
    _view_Back.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDropDownWithTap:)];
    [_view_Back addGestureRecognizer:tap];
    
    [view_MainBack addSubview:_view_Back];
    
    [_view_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view_MainBack).offset(frame.origin.y);
        make.left.equalTo(view_MainBack).offset(frame.origin.x);
        make.width.mas_equalTo(frame.size.width);
        make.height.mas_equalTo(frame.size.height);
    }];

    
    /**
     顶部背景图
     */
    _view_Top = [[UIView alloc]init];
    _view_Top.backgroundColor = [UIColor clearColor];
    [_view_Back addSubview:_view_Top];
    [_view_Top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(_view_Back);
        make.height.mas_equalTo(@70);
    }];
    
    /**
     提示文字
     */
    NSString *placeholder = view_MainBack.placeholder;
    CGSize size_Placeholder = [WX_ToolClass changeSizeWithString:placeholder FontOfSize:17 bold:ENUM_NormalSystem];
    
    _label_Placeholder = [[UILabel alloc]init];
    _label_Placeholder.text = placeholder;
    _label_Placeholder.textColor = KUIColorFromRGB(0x4d606f);
    _label_Placeholder.font = [UIFont systemFontOfSize:17];
    [_view_Top addSubview:_label_Placeholder];
    
    [_label_Placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(_view_Top);
        make.width.mas_equalTo(size_Placeholder.width);
        make.height.mas_equalTo(size_Placeholder.height);
    }];
    
    /**
     中部视图背景图
     */
    _view_Middle = [[UIView alloc]init];
    _view_Middle.backgroundColor = [UIColor clearColor];
    [_view_Back addSubview:_view_Middle];
    
    [_view_Middle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_view_Top);
        make.top.equalTo(_view_Top.mas_bottom);
        make.height.mas_equalTo(@79);
    }];
    
    /**
     输入框背景
     */
    _view_TextFiledBack = [[UIView alloc]init];
    _view_TextFiledBack.backgroundColor = KUIColorFromRGB(0xfcfcfc);
    _view_TextFiledBack.layer.masksToBounds = YES;
    _view_TextFiledBack.layer.cornerRadius = 10.f;
    _view_TextFiledBack.layer.borderWidth = 1;
    _view_TextFiledBack.layer.borderColor = KUIColorFromRGB(0xdedede).CGColor;
    [_view_Middle addSubview:_view_TextFiledBack];
    
    [_view_TextFiledBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_Middle).offset(15);
        make.right.equalTo(_view_Middle).offset(-15);
        make.top.equalTo(_view_Middle);
        make.height.mas_equalTo(@44);
    }];
    
    
    /**
     输入框
     */
    _textField_Url = [[UITextField alloc]init];
    _textField_Url.backgroundColor = KUIColorFromRGB(0xfcfcfc);
    _textField_Url.placeholder = @"请输入网址";
    _textField_Url.returnKeyType = UIReturnKeyDone;
    _textField_Url.font = [UIFont systemFontOfSize:15];
    _textField_Url.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField_Url.layer.masksToBounds = YES;
    _textField_Url.layer.cornerRadius = 10.f;
    _textField_Url.keyboardType = UIKeyboardTypeURL;

    _textField_Url.delegate = self;
    [_view_Middle addSubview:_textField_Url];
    
    [_textField_Url mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_view_TextFiledBack).offset(1);
        make.bottom.equalTo(_view_TextFiledBack).offset(-1);
        make.left.equalTo(_view_TextFiledBack).offset(10);
        make.right.equalTo(_view_TextFiledBack).offset(-10);
    }];
    
    /**
     底部试图背景图
     */
    _view_Bottom = [[UIView alloc]init];
    _view_Bottom.backgroundColor = KUIColorFromRGB(0xdedede);
    [_view_Back addSubview:_view_Bottom];
    
    [_view_Bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_view_Top);
        make.top.equalTo(_view_Middle.mas_bottom);
        make.bottom.equalTo(_view_Back);
    }];
    
    /**
     *  确定按钮
     */
    _button_Done = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Done setTitle:@"确 定" forState:UIControlStateNormal];
    [_button_Done setTitleColor:KUIColorFromRGB(0x2ca298) forState:UIControlStateNormal];
    _button_Done.titleLabel.font = [UIFont systemFontOfSize:17];
    _button_Done.backgroundColor = KUIColorFromRGB(0xffffff);
    [_button_Done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [_view_Bottom addSubview:_button_Done];
    
    [_button_Done mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(_view_Bottom);
        make.top.equalTo(_view_Bottom).offset(1);
        make.width.mas_equalTo(@149.5);
    }];
    
    /**
     *  取消按钮
     */
    _button_Cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Cancel setTitle:@"取 消" forState:UIControlStateNormal];
    [_button_Cancel setTitleColor:KUIColorFromRGB(0x2ca298) forState:UIControlStateNormal];
    _button_Cancel.titleLabel.font = [UIFont systemFontOfSize:17];
    _button_Cancel.backgroundColor = KUIColorFromRGB(0xffffff);
    [_button_Cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_view_Bottom addSubview:_button_Cancel];
    
    [_button_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_view_Bottom);
        make.top.equalTo(_view_Bottom).offset(1);
        make.width.mas_equalTo(@149.5);
    }];
}

/**
 *  完成,返回字符串
 *
 */
-(void)done:(UIButton*)btn
{
    [self checkTextFieldUrl:_textField_Url.text complete:^(BOOL success, NSString *Url) {
        if (success) {
            [self.delegate UrlText:Url];
            [self removeUrlView];
            blockUrlString(Url);
        }
    }];
}

/**
 *  取消,界面移除
 *
 */
-(void)cancel:(UIButton*)btn
{
    [self removeUrlView];
}

/**
 *  合成字符串正确性
 *
 *  @param urlString textField.text
 *  @param complete  回调信息
 */
-(void)checkTextFieldUrl:(NSString*)urlString complete:(void(^)(BOOL success, NSString *Url))complete
{
    if (urlString.length > 0) {
        // 检查是否包含 .
        if([urlString rangeOfString:@"."].location !=NSNotFound){
            NSString *complete_Url = [NSString stringWithFormat:@"<lk>%@</lk>",urlString];
            complete(YES,complete_Url);
        }else{
            [view_MainBack showAndHideHUDWithTitle:@"请输入正确的网站链接" WithState:BYC_MBProgressHUDHideProgress];
            complete(NO,urlString);
        }
    }else{
        [view_MainBack showAndHideHUDWithTitle:@"请输入网站链接" WithState:BYC_MBProgressHUDHideProgress];
        complete(NO,urlString);
    }
}

/**
 *  移除界面
 */
-(void)removeUrlView
{
    [view_MainBack removeFromSuperview];
    view_MainBack = nil;
    _state_UrlView = ENUM_ViewDisappear;
}

/**
 *  创建移除监听
 *
 *  @param notifiType 枚举
 */
-(void)createOrRemoveNotifiWith:(NotifiAddOrRemove)notifiType
{
    switch (notifiType) {
            /**
             *  创建监听
             */
        case ENUM_ADDNOTIFI:
        {
            [QNWSNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:URLVIEWOBJECT];
            
            [QNWSNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:URLVIEWOBJECT];
            _ENUM_Notifi = ENUM_ADDNOTIFI;
        }
            break;
            
            /**
             *  移除监听
             */
            case ENUM_REMOVENOTIFI:
        {
            [QNWSNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:URLVIEWOBJECT];
            
            [QNWSNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:URLVIEWOBJECT];
            
            _ENUM_Notifi = ENUM_REMOVENOTIFI;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -------- 键盘遮罩
//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    if ([notification.object isEqualToString:URLVIEWOBJECT]) {
        
        /// 获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        /// 计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = kbHeight/3 +INTERVAL_KEYBOARD;
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        /// 将视图上移计算好的偏移
        if(offset > 0){
            [view_MainBack mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.offset(-offset);
                make.right.left.height.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            
            /// 告诉self.view约束需要更新
            [self setNeedsUpdateConstraints];
            /// 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
            [self updateConstraintsIfNeeded];
            
            [UIView animateWithDuration:duration animations:^{
                [view_MainBack layoutIfNeeded];
            }];
        }
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    if ([notify.object isEqualToString:URLVIEWOBJECT]) {
        
        /// 键盘动画时间
        double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        /// 视图下沉恢复原状
        [view_MainBack mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.bottom.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        /// 告诉self.view约束需要更新
        [self setNeedsUpdateConstraints];
        /// 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:duration animations:^{
            [view_MainBack layoutIfNeeded];
        }];
    }

}

/**
 *  键盘落下
 *
 *  @param tap tap
 */
-(void)keyboardDropDownWithTap:(UITapGestureRecognizer*)tap
{
    if ([_textField_Url becomeFirstResponder])[_textField_Url resignFirstResponder];
}

#pragma mark ----- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)dealloc
{
    QNWSLog(@"%s 掉了",__func__);
//    if (_ENUM_Notifi == ENUM_ADDNOTIFI) {
//        [self createOrRemoveNotifiWith:ENUM_REMOVENOTIFI];
//    }
}

@end
