//
//  BYC_KeyboardToolBar.m
//  自定义键盘
//
//  Created by 元朝 on 16/3/1.
//  Copyright © 2016年 BYC. All rights reserved.

#import "BYC_KeyboardToolBar.h"
#import "EMCDDeviceManager.h"
#import "EMAudioRecorderUtil.h"
#import "NSString+BYC_HaseCode.h"

static CGFloat const KeyboardToolBarHeight = 50;
static CGFloat const key_TextViewEdge = 10;

@interface BYC_KeyboardToolBar()<UITextViewDelegate,RefreshRecordDataDelegate>

/**是否发送:YES 发送  NO 不发送*/
@property (nonatomic, assign)  BOOL  isSendMsg;
/**不显示录音提示视图:YES 不显示  NO 显示*/
@property (nonatomic, assign)  BOOL  isRemoveVoiceView;
/**录音按钮*/
@property (nonatomic, strong) UIButton    *button_Voice;
/**评论按钮*/
@property (nonatomic, strong) UIButton    *button_comment;
/**语音按钮*/
@property (nonatomic, strong) UIButton    *button_Record;


/**记录键盘的当前状态*/
@property (nonatomic, assign)  KeyboardStatus  currentStatus;//默认文本输入
/**记录键盘的上一次状态*/
@property (nonatomic, assign)  KeyboardStatus  lastStatus;
/**因为切换语音的时候导致文字还在button上显示出来，所以处理一下*/
@property (nonatomic, copy)  NSString  *strin_record;

/**记录输入Emoji表情之前的文本内容*/
@property (nonatomic, copy)  NSString  *string_OldTextField;
@property (nonatomic, strong) UIView   *scripView;

/**记录切换到语音前的frame*/
@property (nonatomic, assign)  CGRect  rect_LastFrame;
@end

@implementation BYC_KeyboardToolBar
#pragma mark - 本类系统相关方法(包括自定义的初始化方法)

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, screenHeight, screenWidth, KeyboardToolBarHeight)];
    if (self) {
        self.backgroundColor = KUIColorFromRGB(0XFFFFFF);
        [self initViews];
        self.currentStatus = KeyboardStatusText;//默认文本输入
    }
    return self;
}

-(void)dealloc {
    QNWSLog(@"%@",NSStringFromClass([self class]));
    
}
#pragma mark - 初始化子视图

- (void)initViews {
    
    self.scripView = [[UIView alloc]init];
    self.scripView.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    [self addSubview:self.scripView];
    [self.scripView mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.top.left;
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(0.5);
    }];
    
    _button_Voice     = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_Voice.tag = 1001;
    [_button_Voice addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button_Voice];
    [_button_Voice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        (void)make.top.left.bottom;
        make.width.offset(52);
    }];
    
    _button_comment    = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_comment.tag = 1003;
    _button_comment.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_comment setTitle:@"发送" forState:UIControlStateNormal];
    [_button_comment setTitleColor:KUIColorFromRGB(0x6C7B8A) forState:UIControlStateNormal];
    [_button_comment setTitleColor:KUIColorBaseGreenHighlight forState:UIControlStateHighlighted];
    [_button_comment addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button_comment];
    [_button_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        (void)make.top.right.bottom;
        make.width.offset(42);
    }];
    
    
    _button_Emoji = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_Emoji.tag = 1002;
    _button_Emoji.contentMode = UIViewContentModeCenter;
    [_button_Emoji setImage:[UIImage imageNamed:@"icon-biaoqing-n"] forState:UIControlStateNormal];
    [_button_Emoji setImage:[UIImage imageNamed:@"icon-jianpang-n"] forState:UIControlStateSelected];
    [_button_Emoji addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button_Emoji];
    [_button_Emoji mas_makeConstraints:^(MASConstraintMaker *make) {
        
        (void)make.top.bottom;
        make.trailing.equalTo(_button_comment.mas_leading);
        make.width.offset(42);
    }];
    
    [self initTextView_Content];
    _button_Voice.backgroundColor     = [UIColor clearColor];
    _button_comment.backgroundColor    = [UIColor clearColor];
}

- (void)initTextView_Content {
    
    _textView_Content = [[BYC_KeyBoardTextView alloc] init];
    // 文本框文字高度改变回调
    QNWSWeakSelf(self);
    _textView_Content.textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){

        CGFloat height = textHeight + key_TextViewEdge * 2;
        weakself.frame = CGRectMake(weakself.left, weakself.bottom - height, weakself.kwidth, height);
    };
    _textView_Content.delegate = self;
    _textView_Content.layer.cornerRadius = 5;
    _textView_Content.backgroundColor = KUIColorFromRGB(0xF2F2F2);
    [self addSubview:_textView_Content];

    [_textView_Content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(key_TextViewEdge);
        make.left.equalTo(_button_Voice.mas_right);
        make.right.equalTo(_button_Emoji.mas_left);
        make.bottom.offset(-key_TextViewEdge);
    }];
    
    
    [QNWSNotificationCenter addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:_textView_Content];
}

#pragma mark - 属性的get 及 set 方法

-(void)setCurrentStatus:(KeyboardStatus)currentStatus {
    
    _lastStatus    = _currentStatus;
    _currentStatus = currentStatus;
    self.isSmile = NO;
    self.isVoice = NO;
    switch (currentStatus) {
        case KeyboardStatusText:
        {
            _button_Record.hidden = YES;
            _button_Emoji.selected = NO;
            if (_lastStatus == KeyboardStatusEmoji) {//表情 --> 文本
                self.isSmile = YES;
                self.isVoice = NO;
                [_textView_Content becomeFirstResponder];
            }
            
            if (_lastStatus == KeyboardStatusVoice) {//语音 --> 文本
                self.isVoice = YES;
                self.isSmile = NO;
//                if (_strin_record.length) {
                    _textView_Content.text = _strin_record;
                    _strin_record = @"";
//                }
//                else _textView_Content.placeholder = @"在此处输入...";
                
                [_textView_Content becomeFirstResponder];
            }

            [_button_Voice setImage:[UIImage imageNamed:@"icon-yuyin-n"] forState:UIControlStateNormal];
            [_button_Voice setImage:[UIImage imageNamed:@"icon-yuyin-h"] forState:UIControlStateHighlighted];
        }
            
            break;
        case KeyboardStatusVoice:
        {
            self.isVoice = YES;
            self.isSmile = NO;
            [self showButton_Record];
            if (_lastStatus == KeyboardStatusEmoji) {//表情切换过来
                self.isSmile = YES;
            }
            
            if (_lastStatus == KeyboardStatusText) {//文本切换过来
                self.isVoice = YES;
            }

            [_textView_Content resignFirstResponder];
            _button_Emoji.selected = NO;
            [_button_Voice setImage:[UIImage imageNamed:@"icon-jianpang-n"] forState:UIControlStateNormal];
            [_button_Voice setImage:[UIImage imageNamed:@"icon-jianpang-h"] forState:UIControlStateHighlighted];
        }
            
            break;
        case KeyboardStatusEmoji:
        {
            self.isVoice = NO;
            self.isSmile = YES;
            _button_Record.hidden = YES;
            _button_Emoji.selected = YES;
            [_button_Voice setImage:[UIImage imageNamed:@"icon-yuyin-n"] forState:UIControlStateNormal];
            [_button_Voice setImage:[UIImage imageNamed:@"icon-yuyin-h"] forState:UIControlStateHighlighted];
        }
            break;
            
        default:
            break;
    }
    
    if (_delegate_KeyboardToolBar && [_delegate_KeyboardToolBar respondsToSelector:@selector(clickActionWithStatus:)])
        [_delegate_KeyboardToolBar clickActionWithStatus:_currentStatus];
}

#pragma mark - 网络请求数据
#pragma mark - UIScrollView 以及其子类的数据源和代理
#pragma mark - 其它系统类的代理（例如UITextField,UITextView等）

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    
    if ([text isEqualToString: @"\n"] ) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView.text.length > 120 && text.length > 0) {//textView的contentSize赋值不能及时，导致textView高度定到最大的时候，textView不能滑动，问题待优化，目前就先这么处理吧。
        
        [[UIView alloc] showAndHideHUDWithTitle:@"字数不能超过120字" WithState:BYC_MBProgressHUDShowTurnplateProgress];
        return NO;
    }
    
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            
            [self showAndHideHUDWithTitle:@"请重新输入,不能包含Emoji表情" WithState:BYC_MBProgressHUDHideProgress];
            return NO;
        }
    }
    return YES;
}

-(void)textViewChanged:(NSNotification *)notification {
    
    UITextView *textView = (UITextView *)notification.object;
    if ([textView isFirstResponder]) {
        if ([NSString stringContainsEmoji:textView.text]) {
            
            textView.text = _string_OldTextField;//还原成原来的文本
            [self showAndHideHUDWithTitle:@"请重新输入,不能包含Emoji表情" WithState:BYC_MBProgressHUDHideProgress];
            return;
        }
        _string_OldTextField = textView.text;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    self.currentStatus = KeyboardStatusText;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

#pragma mark - 自定义类的代理 - RefreshRecordDataDelegate

-(void)refreshRecordData:(float)power {
    
    if (!_isRemoveVoiceView)[self showVoice:power];
}


#pragma mark - 本类创建的的相关方法（不是本类系统的方法）

- (void)buttonAction:(UIButton *)button {

    switch (button.tag) {
        case 1001://语音、文本切换
            
            if (_rect_LastFrame.size.width == 0) [self resetFrmae:YES];
            else [self resetFrmae:NO];
            
            [self exchangeVoiceAndText:button];
            break;
        case 1002://表情、文本切换
            [self exchangeEmojiAndText];
            break;
        case 1003://发送内容
            [self sendContent];
            break;
        case 1004://按住说话模式
            [self pressWithSpeak];
            break;
            
        default:
            break;
    }
}

- (void)resetFrmae:(BOOL)isOK {

    if (isOK) {//恢复到最初未输入文字的状态
        
        _rect_LastFrame = self.frame;//记录切换前的frame
        self.frame = CGRectMake(self.left, self.bottom - KeyboardToolBarHeight, self.kwidth, KeyboardToolBarHeight);
    } else {//还原上一次的状态
        
        self.frame = _rect_LastFrame;
        _rect_LastFrame = CGRectZero;
    }
}

- (void)showButton_Record {

    if (_button_Record == nil) {
        
        _button_Record = [UIButton buttonWithType:UIButtonTypeCustom];
        _button_Record.tag = 1004;
        _button_Record.titleLabel.font = [UIFont systemFontOfSize:15];
        [_button_Record setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_button_Record setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _button_Record.backgroundColor = [UIColor whiteColor];
        [_button_Record addTarget:self action:@selector(buttonAction1) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        [_button_Record addTarget:self action:@selector(buttonAction2) forControlEvents:UIControlEventTouchDown];
        [_button_Record addTarget:self action:@selector(buttonAction3) forControlEvents:UIControlEventTouchDragOutside];
        [_button_Record addTarget:self action:@selector(buttonAction4) forControlEvents:UIControlEventTouchDragEnter];
        [_textView_Content addSubview:_button_Record];
        [_button_Record mas_makeConstraints:^(MASConstraintMaker *make) {
            (void)make.top.leading.bottom;
            make.trailing.equalTo(_button_Emoji.mas_leading);
        }];
    }
    _strin_record = _textView_Content.text;
    _textView_Content.text = @"";
    _button_Record.hidden = NO;
}

- (void)buttonAction1 {
    
    _isRemoveVoiceView = YES;//不显示
    if (_isSendMsg)[self didFinishRecoingVoiceAction:nil];
     else[self didCancelRecordingVoiceAction:nil];
    [_button_Record setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_button_Record setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _button_Record.backgroundColor = [UIColor whiteColor];
}
- (void)buttonAction2 {
    _button_Record.enabled = NO;
    _isRemoveVoiceView = NO;//显示
    [self didStartRecordingVoiceAction:nil];
    _isSendMsg = YES;
    [_button_Record setTitle:@"手指松开，完成发送" forState:UIControlStateNormal];
    _button_Record.backgroundColor = [UIColor colorWithRed:0.61f green:0.63f blue:0.67f alpha:1.00f];
}
- (void)buttonAction3 {

    _isRemoveVoiceView = NO;//显示
    _isSendMsg = NO;
    UIView *view_back = [KQNWS_KeyWindow viewWithTag:1012];
    view_back.hidden = NO;
    UIView *view_paly = [KQNWS_KeyWindow viewWithTag:1013];
    view_paly.hidden = YES;
    [_button_Record setTitle:@"手指松开，取消发送" forState:UIControlStateNormal];
    _button_Record.backgroundColor = [UIColor colorWithRed:0.61f green:0.63f blue:0.67f alpha:1.00f];
}
- (void)buttonAction4 {

    _isRemoveVoiceView = NO;//显示
    _isSendMsg = YES;
    UIView *view_back = [KQNWS_KeyWindow viewWithTag:1012];
    view_back.hidden = YES;;
    UIView *view_paly = [KQNWS_KeyWindow viewWithTag:1013];
    view_paly.hidden = NO;
    [_button_Record setTitle:@"手指松开，完成发送" forState:UIControlStateNormal];
    _button_Record.backgroundColor = [UIColor colorWithRed:0.61f green:0.63f blue:0.67f alpha:1.00f];
    
}

//语音跟文本/表情切换
- (void)exchangeVoiceAndText:(UIButton *)button {

    if (_currentStatus == KeyboardStatusText || _currentStatus == KeyboardStatusEmoji)self.currentStatus = KeyboardStatusVoice;
        else if (_currentStatus == KeyboardStatusVoice)self.currentStatus = KeyboardStatusText;
}
//表情跟文本/语音切换
- (void)exchangeEmojiAndText {

    if (_currentStatus == KeyboardStatusText || _currentStatus == KeyboardStatusVoice )self.currentStatus = KeyboardStatusEmoji;
    else if (_currentStatus == KeyboardStatusEmoji)self.currentStatus = KeyboardStatusText;
}

- (void)pressWithSpeak {

    if (_delegate_KeyboardToolBar && [_delegate_KeyboardToolBar respondsToSelector:@selector(clickActionWithStatus:)])
        [_delegate_KeyboardToolBar clickActionWithStatus:KeyboardStatusSpeak];
}

- (void)sendContent {

    if (_textView_Content.text.length == 0) {
        [[UIView alloc] showAndHideHUDWithTitle:@"您还没有输入评论内容！" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }
    if (_currentStatus == KeyboardStatusEmoji)
        _button_Emoji.selected = NO;
    if (_delegate_KeyboardToolBar && [_delegate_KeyboardToolBar respondsToSelector:@selector(clickActionWithStatus:)])
        [_delegate_KeyboardToolBar clickActionWithStatus:KeyboardStatusSendMsg];
}
/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        
        if (!error) {
            
            if (aDuration < 1) {
              
                 QNWSLog(@"时间太短");
                [self showLabelAndDelayedRemoveVoiceView:@"录音时间太短"];
                
            }else {

                QNWSLog(@"录音完成");
                if (_delegate_KeyboardToolBar && [_delegate_KeyboardToolBar respondsToSelector:@selector(sendVoiceData:withVoiceDuration:)])
                    [_delegate_KeyboardToolBar sendVoiceData:[NSData dataWithContentsOfFile:recordPath] withVoiceDuration:aDuration];
                [self removeVoiceView];
            }

        }else {

            switch (error.code) {
                case -100:
                    QNWSLog(@"录音时间太短");
                    [self showLabelAndDelayedRemoveVoiceView:@"录音时间太短"];
                    break;
                case -101:
                    QNWSLog(@"录音转换失败");
                    [self removeVoiceView];
                    break;
                case -102:
                    QNWSLog(@"录音停止");
                    [self removeVoiceView];
                    break;
                case -103:
                    QNWSLog(@"录音还没有开始");
                    [self removeVoiceView];
                    break;
                    
                default:
                    [self removeVoiceView];
                    break;
            }
            if (_delegate_KeyboardToolBar && [_delegate_KeyboardToolBar respondsToSelector:@selector(recordVoiceDataFail)]) {
                [_delegate_KeyboardToolBar recordVoiceDataFail];
            }
        }
    }];

}
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [self removeVoiceView];
    if (_delegate_KeyboardToolBar && [_delegate_KeyboardToolBar respondsToSelector:@selector(recordVoiceDataFail)]) {
        [_delegate_KeyboardToolBar recordVoiceDataFail];
    }

}
/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    [QNWSNotificationCenter postNotificationName:@"videoPause" object:KSTR_KVoiceWillStart];
    [EMAudioRecorderUtil sharedInstance].delegateEMAudioRecorderUtil = self;
    
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error){
            if (error) {
                QNWSLog(@"录音失败");
            }
        }];
        QNWSLog(@"开始录音\n");
}

- (void)removeVoiceView {

    UIView *view_Voice = [KQNWS_KeyWindow viewWithTag:1010];
    [view_Voice removeFromSuperview];
    view_Voice = nil;
    _button_Record.enabled = YES;
}

- (void)showLabelAndDelayedRemoveVoiceView:(NSString *)textContent {
    
    UIView *view_Voice = [KQNWS_KeyWindow viewWithTag:1010];
    UILabel *label = [[UILabel alloc] initWithFrame:view_Voice.bounds];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = textContent;
    label.backgroundColor = [UIColor blackColor];
    [view_Voice addSubview:label];
    [self performSelector:@selector(removeVoiceView) withObject:nil afterDelay:1];
}

- (void)showVoice:(float)power {

    UIView *view_Voice = [KQNWS_KeyWindow viewWithTag:1010];
    UIImageView *imageV_Voice;
    imageV_Voice = (UIImageView *)[KQNWS_KeyWindow viewWithTag:1011];
    if (view_Voice == nil && !_isRemoveVoiceView) {
        
        //正在录音
        view_Voice = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 150) / 2.0f, screenHeight - 250-150-50, 150, 150)];
        view_Voice.layer.cornerRadius = 10;
        view_Voice.layer.masksToBounds = YES;
        view_Voice.clipsToBounds = YES;
        view_Voice.tag = 1010;
        view_Voice.backgroundColor = KUIColorFromRGBA(0x000000, .3);
        UIView *view_Play = [[UIView alloc] initWithFrame:view_Voice.bounds];
        view_Play.backgroundColor = [UIColor clearColor];
        view_Play.tag = 1013;
        UIImageView *imageV_Play = [[UIImageView alloc] initWithFrame:CGRectMake(10, (150 - 90)/2.0f , 60, 90)];
        imageV_Play.image = [UIImage imageNamed:@"recorder"];
        [view_Play addSubview:imageV_Play];
        imageV_Voice = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV_Play.frame) + 10, CGRectGetMinY(imageV_Play.frame), 60, 90)];
        imageV_Voice.tag = 1011;
        imageV_Voice.image = [UIImage imageNamed:@"v1"];
        [view_Play addSubview:imageV_Voice];
        [view_Voice addSubview:view_Play];
        //取消录音
        UIView *backView = [[UIView alloc] initWithFrame:view_Voice.bounds];
        backView.backgroundColor = [UIColor clearColor];
        backView.tag = 1012;
        backView.hidden = YES;
        UIImageView *imageV_Cancel = [[UIImageView alloc] initWithFrame:CGRectMake((150 - 120) / 2.0f, (150 - 90)/2.0f , 120, 90)];
        imageV_Cancel.image = [UIImage imageNamed:@"cancel"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV_Cancel.frame) , 150, 30)];
        label.text = @"松开手指,取消发送";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = KUIColorBaseGreenHighlight;
        [backView addSubview:imageV_Cancel];
        [backView addSubview:label];
        [view_Voice addSubview:backView];
        [KQNWS_KeyWindow addSubview:view_Voice];
    }

    if (power >  1 / 7.0f * 6)imageV_Voice.image = [UIImage imageNamed:@"v7"];
    if (power <= 1 / 7.0f)imageV_Voice.image = [UIImage imageNamed:@"v1"];
    if (power >  1 / 7.0f     && power <= 1 / 7.0f * 2)imageV_Voice.image = [UIImage imageNamed:@"v2"];
    if (power >  1 / 7.0f * 2 && power <= 1 / 7.0f * 3)imageV_Voice.image = [UIImage imageNamed:@"v3"];
    if (power >  1 / 7.0f * 3 && power <= 1 / 7.0f * 4)imageV_Voice.image = [UIImage imageNamed:@"v4"];
    if (power >  1 / 7.0f * 4 && power <= 1 / 7.0f * 5)imageV_Voice.image = [UIImage imageNamed:@"v5"];
    if (power >  1 / 7.0f * 5 && power <= 1 / 7.0f * 6)imageV_Voice.image = [UIImage imageNamed:@"v6"];
}

@end
