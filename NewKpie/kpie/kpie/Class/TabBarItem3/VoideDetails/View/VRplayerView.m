
//
//  VRplayerView.m
//  kpie
//
//  Created by sunheli on 16/6/24.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "VRplayerView.h"
#import <UtoVRPlayer/UtoVRPlayer.h>
#import "ZFPlayer.h"
#import "BYC_MainNavigationController.h"

@implementation VRplayerView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self initVRPlayerView];
        [self initTopView];
        [self initBottomView];
        [self initGestureAction];
    }
    
    return self;
}

-(void)initVRPlayerView{
    
    if (!_VR_Player) {
        UVPlayerViewStyle style = UVPlayerViewStyleNone;
        self.VR_Player.viewStyle = style;
        self.VR_Player.playMode = UVPlayerPlayModeSerial;
        [self addSubview:_VR_Player.playerView];
        [self.VR_Player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
    }
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
}

- (void)initTopView {
    _topView = [[UIView alloc]init];
    _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _button_Top_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Top_back setImage:[UIImage imageNamed:@"btn_bfy_back_n"] forState:UIControlStateNormal];
    [_button_Top_back setImage:[UIImage imageNamed:@"btn_bfy_back_n"] forState:UIControlStateSelected];
    [_button_Top_back addTarget:self action:@selector(playerBack:) forControlEvents:UIControlEventTouchUpInside];
    _button_Top_back.backgroundColor = [UIColor clearColor];
    
    _view_Top_Title = [[UIView alloc]init];
    _view_Top_Title.backgroundColor = [UIColor clearColor];
    
    _label_Top_Title = [[UILabel alloc]init];
    _label_Top_Title.font = [UIFont systemFontOfSize:15];
    _label_Top_Title.textColor = [UIColor whiteColor];
    _label_Top_Title.text = @"labellabellabel";
    _label_Top_Title.textAlignment = NSTextAlignmentCenter;
    _label_Top_Title.backgroundColor = [UIColor clearColor];
    _label_Top_Title.hidden = YES;
    
    
    
    
    _button_Top_More = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Top_More setImage:[UIImage imageNamed:@"btn_bfy_more_n"] forState:UIControlStateNormal];
    [_button_Top_More setImage:[UIImage imageNamed:@"btn_bfy_more_h"] forState:UIControlStateSelected];
    [_button_Top_More addTarget:self action:@selector(playerMore:) forControlEvents:UIControlEventTouchUpInside];
    _button_Top_More.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_topView];
    [_topView addSubview:_button_Top_back];
    [_topView addSubview:_button_Top_More];
    [_topView addSubview:_view_Top_Title];
    [_view_Top_Title addSubview:_label_Top_Title];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.leading.equalTo(_topView.superview);
        make.height.offset(44);
    }];
    
    [_button_Top_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_button_Top_back.superview);
        make.width.offset(44);
    }];
    
    
    [_view_Top_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topView.mas_bottom).offset(0);
        make.left.equalTo(_button_Top_back.mas_right).offset(0);
        make.trailing.equalTo(_view_Top_Title.mas_trailing).offset(0);
        make.height.offset(44);
    }];
    
    [_label_Top_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topView.mas_bottom).offset(0);
        make.centerX.equalTo(_topView.mas_centerX);
        make.centerY.equalTo(_topView.mas_centerY);
        
    }];
    
    [_button_Top_More mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_topView);
        make.right.equalTo(_topView.mas_right).offset(-5);
        make.width.mas_equalTo(44);
    }];
}
#pragma mark ---- 返回按钮
-(void)playerBack:(UIButton *)button{
    if (!self.isFullScreen) {
        // player加到控制器上，只有一个player时候
        self.controlPlayerStatus = ENUM_PlayerStatusPuse;
        [_VRdelagete backToPrePage];
    }else {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

#pragma mark ---- 显示更多按钮
-(void)playerMore:(UIButton *)button{
    if ([self.VRdelagete respondsToSelector:@selector(mediaPlayReportTheVideo)]) {
        [self.VRdelagete mediaPlayReportTheVideo];
    }
    
}

/**
 *  初始化底部视图
 */
- (void)initBottomView {
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    _button_Play = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Play setImage:[UIImage imageNamed:@"icon_bfy_bofang_n"] forState:UIControlStateNormal];
    [_button_Play setImage:[UIImage imageNamed:@"icon_bfy_zanting_n"] forState:UIControlStateSelected];
    [_button_Play addTarget:self action:@selector(playerAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_Play.backgroundColor = [UIColor clearColor];
    _button_Play.selected = YES;
    NSLog(@"_button_Play===%d",_button_Play.selected);
    
    _view_Time = [[UIView alloc] init];
    _view_Time.backgroundColor = [UIColor clearColor];
    
    _label_CurrentTime = [[UILabel alloc] init];
    _label_CurrentTime.font = [UIFont systemFontOfSize:10];
    _label_CurrentTime.textColor = [UIColor whiteColor];
    _label_CurrentTime.text = @"00:00";
    
    _label_AllTime = [[UILabel alloc] init];
    _label_AllTime.font = [UIFont systemFontOfSize:10];
    _label_AllTime.textColor = [UIColor whiteColor];
    _label_AllTime.text = @" / 00:00";
    
    _button_Gyroscope = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Gyroscope setImage:[UIImage imageNamed:@"bfy_icon_qiehuan_n"] forState:UIControlStateNormal];
    [_button_Gyroscope setImage:[UIImage imageNamed:@"bfy_icon_qiehuan_s"] forState:UIControlStateSelected];
    [_button_Gyroscope addTarget:self action:@selector(playerAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_Gyroscope.backgroundColor = [UIColor clearColor];
    
    _button_DuralScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_DuralScreen setImage:[UIImage imageNamed:@"bfy_icon_vr_n"] forState:UIControlStateNormal];
    [_button_DuralScreen setImage:[UIImage imageNamed:@"bfy_icon_vr_s"] forState:UIControlStateSelected];
    [_button_DuralScreen addTarget:self action:@selector(playerAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_DuralScreen.backgroundColor = [UIColor clearColor];
    
    
    _button_FullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_FullScreen setImage:[UIImage imageNamed:@"icon_bfy_quanping_h"] forState:UIControlStateNormal];
    [_button_FullScreen setImage:[UIImage imageNamed:@"icon_bfy_quanping_n"] forState:UIControlStateSelected];
    [_button_FullScreen addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_FullScreen.backgroundColor = [UIColor clearColor];
    NSLog(@"_button_FullScreen===%d",_button_FullScreen.selected);
    _slider_ProgressBar= [[UISlider alloc]init]; // 初始化滑块
    _slider_ProgressBar.minimumValue = 0;       // 最小值
    _slider_ProgressBar.maximumValue = 0;// 最大值
    _slider_ProgressBar.value = 0;              // 当前值
    _slider_ProgressBar.minimumTrackTintColor = KUIColorFromRGB(0x4BC8BD);    // 最小值一侧图标
    _slider_ProgressBar.maximumTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];    // 最大值一侧图标
    _slider_ProgressBar.continuous = YES;     // 移动过程中是否触发值变化事件
    _slider_ProgressBar.enabled = NO;
    
    _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.trackTintColor    = [UIColor clearColor];
    _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    
    //开始滑动
    [_slider_ProgressBar addTarget:self action:@selector(sliderTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    //滑动中
    [_slider_ProgressBar addTarget:self action:@selector(sliderChangedAction:) forControlEvents:UIControlEventValueChanged];
    //滑动结束
    [_slider_ProgressBar addTarget:self action:@selector(sliderTouchCancel:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    [_slider_ProgressBar setThumbImage:[UIImage imageNamed:@"icon_bfy_handle"] forState:UIControlStateNormal]; // 自定义滑块图标
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressTapAction:)];
    self.tap.numberOfTapsRequired = 1;
    self.tap.numberOfTouchesRequired = 1;
    [self.slider_ProgressBar addGestureRecognizer:self.tap];
    
    self.slider_ProgressBar.enabled = YES;
    
    [self addSubview:_bottomView];
    [_bottomView addSubview:_button_Play];
    [_bottomView addSubview:_slider_ProgressBar];
    [_bottomView addSubview:_progressView];
    [_bottomView addSubview:_button_DuralScreen];
    [_bottomView addSubview:_button_Gyroscope];
    [_bottomView addSubview:_button_FullScreen];
    [_bottomView addSubview:_view_Time];
    [_view_Time addSubview:_label_CurrentTime];
    [_view_Time addSubview:_label_AllTime];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.offset(44);
    }];
    
    [_button_Play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView.mas_left).offset(5);
        make.centerY.equalTo(_bottomView.mas_centerY).offset(-3);
        make.width.height.offset(40);
        
    }];
    
    [_button_FullScreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY).offset(-3);
        make.right.equalTo(_bottomView.mas_right).offset(0);
        make.width.mas_equalTo(45);
    }];
    
    [_button_DuralScreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_button_FullScreen.mas_left).offset(0);
        make.centerY.equalTo(_bottomView.mas_centerY).offset(-3);
        make.width.height.mas_equalTo(35);
    }];
    
    [_button_Gyroscope mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_button_DuralScreen.mas_left).offset(0);
        make.centerY.equalTo(_bottomView.mas_centerY).offset(-3);
        make.width.height.mas_equalTo(35);
    }];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_button_Play.mas_trailing).offset(0);
        make.right.equalTo(_button_Gyroscope.mas_left).offset(0);
        make.centerY.equalTo(_bottomView.mas_centerY).offset(-2);
        
    }];
    
    [_slider_ProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_button_Play.mas_trailing).offset(0);
        make.right.equalTo(_button_Gyroscope.mas_left).offset(0);
        make.centerY.equalTo(_bottomView.mas_centerY).offset(-3);
    }];
    
    [_view_Time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomView.mas_bottom).offset(-2);
        make.top.equalTo(_slider_ProgressBar.mas_bottom).offset(3);
        make.left.equalTo(_button_Play.mas_right).offset(0);
        make.width.offset(110);
    }];
    
    [_label_CurrentTime sizeToFit];
    [_label_CurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_view_Time.mas_centerY);
        make.leading.equalTo(_view_Time.mas_leading).offset(0);
    }];
    [_label_AllTime sizeToFit];
    [_label_AllTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_view_Time.mas_centerY);
        make.leading.equalTo(_label_CurrentTime.mas_trailing).offset(0);
    }];
    
}
#pragma mark ----- 给进度条加的手势
-(void)progressTapAction:(UITapGestureRecognizer *)tap{
    if ([self.VRdelagete respondsToSelector:@selector(sliderTap:)]) {
        [self.VRdelagete sliderTap:tap];
    }
    
}

#pragma mark  ----- slider响应事件
//开始滑动
- (void)sliderTouchDownAction:(UISlider *)slider {
    if ([self.VRdelagete respondsToSelector:@selector(sliderDidStart:)]) {
        [self.VRdelagete sliderDidStart:slider];
    }
    
}
//滑动中
- (void)sliderChangedAction:(UISlider *)slider {
    
    if ([self.VRdelagete respondsToSelector:@selector(sliderToTime:)]) {
        [self.VRdelagete sliderToTime:slider.value];
    }
}

//滑动结束
- (void)sliderTouchCancel:(UISlider *)slider {
    if ([self.VRdelagete respondsToSelector:@selector(sliderDidEnd:)]) {
        [self.VRdelagete sliderDidEnd:slider];
    }
    
}

#pragma mark----各种点击事件
- (void)playerAction:(id)object {
    
    if ((UIButton *)object == _button_Play) {//点击播放按钮
        
        _button_Play.selected = !_button_Play.selected;
        if ([self.VRdelagete respondsToSelector:@selector(buttonPlayOrPauseDelegate:)]) {
            [self.VRdelagete buttonPlayOrPauseDelegate:_button_Play];
        }
        return;
    }
    
    if ((UIButton *)object == _button_Gyroscope) {//点击螺旋按钮
        
        _button_Gyroscope.selected = !_button_Gyroscope.selected;
        if ([self.VRdelagete respondsToSelector:@selector(gyroscope:)]) {
            [self.VRdelagete gyroscope:_button_Gyroscope];
        }
        return;
    }
    if ((UIButton *)object == _button_DuralScreen) {//点击双屏按钮
        _button_DuralScreen.selected = !_button_DuralScreen.selected;
        if ([self.VRdelagete respondsToSelector:@selector(duralScreen:)]) {
            [self.VRdelagete duralScreen:_button_DuralScreen];
        }
        return;
    }
}

#pragma setter method
-(void)setControlPlayerStatus:(ENUM_OutPlayerStatus)controlPlayerStatus{
    _controlPlayerStatus = controlPlayerStatus;
    switch (_controlPlayerStatus) {
        case ENUM_PlayerStatusPlay:{
            _button_Play.selected = YES;
            [_VR_Player play];
            [self setNeedsLayout]; //是标记 异步刷新 会调但是慢
            [self layoutIfNeeded]; //加上此代码立刻刷新
        }
            break;
        case ENUM_PlayerStatusPuse:{
            _button_Play.selected = NO;
            [_VR_Player pause];
        }
            
            break;
        case ENUM_PlayerStatusStop:{
            _button_Play.selected = NO;
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            [_VR_Player pause];
        }
            break;
            
        default:
            break;
    }
}

-(void)setPlayItem:(UVPlayerItem *)playItem{
    _playItem = playItem;
    if (QNWSUserDefaultsObjectForKey(KSTR_KNetwork_IsWiFi)) {
        if (*KNetwork_Type == ENUM_NETWORK_TYPE_WiFi) {
            [self.VR_Player appendItem:_playItem];
        }
        else{
            if (!self.alert1) {
                self.alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前为非Wi-fi网络，继续播放需要关闭“仅Wi-Fi联网”功能。是否关闭 ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定关闭", nil];
                self.alert1.tag = 401;
                [self.alert1 show];
                [self interfaceOrientation:UIInterfaceOrientationPortrait];
            }
        }
    }
    else{
        if (*KNetwork_Type == ENUM_NETWORK_TYPE_WiFi) {
            [self.VR_Player appendItem:_playItem];
        }
        else{
            if (!self.alert2) {
                self.alert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"“仅Wi-Fi联网”功能已关闭，当前为非Wi-Fi网络，是否继续播放 ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
                self.alert2.tag = 501;
                [self.alert2 show];
            }
        }
    }
    // 添加通知
    [self addNotifications];
    // 根据屏幕的方向设置相关UI
    [self onDeviceOrientationChangeVR];
}

#pragma mark ------------- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 401) {
        if (buttonIndex == 0) {
            QNWSUserDefaultsSetObjectForKey(@"wifi", KSTR_KNetwork_IsWiFi);
        }else if (buttonIndex == 1){
            [self closeOnlyWifi];
            QNWSUserDefaultsSetObjectForKey(nil, KSTR_KNetwork_IsWiFi);
        }
    }
    if (alertView.tag == 501) {
        if (buttonIndex == 0) {[self interfaceOrientation:UIInterfaceOrientationPortrait];}
        else if (buttonIndex == 1){
            [self.VR_Player appendItem:_playItem];
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            self.controlPlayerStatus = ENUM_PlayerStatusPlay;
        }
    }
}
-(void)closeOnlyWifi{
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否在Wi-Fi网络再播放 ？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Wi-Fi时播放",@"继续播放", nil];
    alter.tag = 501;
    [alter show];
}
/**
 *  添加观察者、通知
 */
- (void)addNotifications{
    // 监测设备方向
    [self listeningRotating];
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChangeVR)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}
/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChangeVR
{
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            self.button_FullScreen.selected = YES;
            // 设置返回按钮的约束
            self.isFullScreen = YES;
            [UIApplication sharedApplication].statusBarHidden = NO;
            KMainNavigationVC.interactivePopGestureRecognizer.enabled = YES;
        }
            break;
        case UIInterfaceOrientationPortrait:{
            self.isFullScreen = !self.isFullScreen;
            _button_FullScreen.selected = NO;
            _label_Top_Title.hidden = YES;
            _button_Top_More.hidden = NO;
            
            _VR_Player.gyroscopeEnabled = NO;
            _VR_Player.duralScreenEnabled = NO;
            _button_Gyroscope.selected = NO;
            _button_DuralScreen.selected = NO;
            self.isFullScreen = NO;
            [UIApplication sharedApplication].statusBarHidden = NO;
            KMainNavigationVC.interactivePopGestureRecognizer.enabled = YES;
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            _button_FullScreen.selected = YES;
            _label_Top_Title.hidden = NO;
            _button_Top_More.hidden = YES;
            
            _VR_Player.gyroscopeEnabled = YES;
            _VR_Player.duralScreenEnabled = YES;
            _button_Gyroscope.selected = YES;
            _button_DuralScreen.selected = YES;
            self.isFullScreen = YES;
            [UIApplication sharedApplication].statusBarHidden = YES;
            KMainNavigationVC.interactivePopGestureRecognizer.enabled = NO;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            _button_FullScreen.selected = YES;
            _label_Top_Title.hidden = NO;
            _button_Top_More.hidden = YES;
            
            _VR_Player.gyroscopeEnabled = YES;
            _VR_Player.duralScreenEnabled = YES;
            _button_Gyroscope.selected = YES;
            _button_DuralScreen.selected = YES;
            self.isFullScreen = YES;
            [UIApplication sharedApplication].statusBarHidden = YES;
            KMainNavigationVC.interactivePopGestureRecognizer.enabled = NO;
        }
            break;
            
        default:
            break;
    }
}
/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscape];
        
    }else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortrait];
        
    }
}
/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscape
{
    self.button_Top_More.hidden = YES;
    self.label_Top_Title.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = YES;
    KMainNavigationVC.interactivePopGestureRecognizer.enabled = NO;
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortrait
{
    self.button_Top_More.hidden = NO;
    self.label_Top_Title.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    KMainNavigationVC.interactivePopGestureRecognizer.enabled = YES;
}

- (void)fullScreenAction:(UIButton *)sender
{
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortraitUpsideDown:{
            ZFPlayerShared.isAllowLandscape = NO;
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            ZFPlayerShared.isAllowLandscape = YES;
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            ZFPlayerShared.isAllowLandscape = NO;
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            ZFPlayerShared.isAllowLandscape = NO;
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
            
        default: {
            ZFPlayerShared.isAllowLandscape = NO;
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
    }
    
}


//单击屏幕
- (void)initGestureAction {
    //单击顶部和底部View显示or隐藏
    _gesture_TapOneScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneGestureRecognizer:)];
    _gesture_TapOneScreen.numberOfTapsRequired = 1;
    [self.VR_Player.playerView addGestureRecognizer:_gesture_TapOneScreen];
}
#pragma mark  ----- 单击屏幕手势
-(void)tapOneGestureRecognizer:(UITapGestureRecognizer *)oneTap{
    [self toolBarHiddeAnimation];
}

- (void)toolBarHiddeAnimation {
    QNWSLog(@"%s",__func__);
    QNWSWeakSelf(self);
    [UIView animateWithDuration:.5 animations:^{
        if (_toolBarHidden) {//不隐藏
            weakself.bottomView.alpha = 1;
            weakself.bottomView.transform = CGAffineTransformIdentity;
            
            weakself.topView.alpha = 1;
            weakself.topView.transform = CGAffineTransformIdentity;
        }else {//隐藏
            weakself.bottomView.alpha = 0;
            weakself.bottomView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(weakself.bottomView.frame));
            weakself.topView.alpha = 0;
            weakself.topView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(weakself.topView.frame));
        }
    } completion:^(BOOL finished) {
        
        if (_toolBarHidden) [weakself startTimer];
        else [weakself pauseTimer];
        _toolBarHidden = !_toolBarHidden;
    }];
}

- (void)pauseTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)startTimer {
    if (self.bottomView.alpha == 1) [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
}

-(void)dealloc{
    NSLog(@"VR资源释放了");
    [self.VR_Player prepareToRelease];
    [QNWSNotificationCenter removeObserver:self];
}

-(UVPlayer *)VR_Player {
    if (_VR_Player == nil) {
        _VR_Player = [[UVPlayer alloc]initWithConfiguration:nil];
    }
    return _VR_Player;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _VR_Player.playerView.frame = self.bounds;
    [self layoutIfNeeded];
    
    
}



@end
