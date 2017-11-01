//
//  BYC_View_MediaPlayerUI.m
//  kpie
//
//  Created by 元朝 on 16/3/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_View_MediaPlayerUI.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BrightnessView.h"
#import "BYC_MediaPlayer.h"



typedef NS_ENUM(NSUInteger, ENUM_PanGestureDirection) {
    
    /**没有滑动*/
    ENUM_PanGestureDirectionNull,
    /**横向移动*/
    ENUM_PanGestureDirectionHorizontal,
    /**纵向移动*/
    ENUM_PanGestureDirectionVertical
};

typedef NS_ENUM(NSUInteger, ENUM_PanGestureAction) {
    
    /**没有滑动事件*/
    ENUM_PanGestureActionNull,
    /**横向移动进度*/
    ENUM_PanGestureActionProgress,
    /**纵向移动调节音量*/
    ENUM_PanGestureActionVolume,
    /**纵向移动调节亮度*/
    ENUM_PanGestureActionLight
};

@interface BYC_View_MediaPlayerUI()<UIGestureRecognizerDelegate>
/**点击播放按钮*/
@property (nonatomic, strong) UIButton                 *button_Play;
/**进度条*/
@property (nonatomic, strong) UISlider                 *slider_ProgressBar;
@property (nonatomic ,strong) UIProgressView           *progress_Video;
/**时间容器视图*/
@property (nonatomic, strong) UIView                   *view_Time;
/**当前播放时间*/
@property (nonatomic, strong) UILabel                  *label_CurrentTime;
/**整个视频时间*/
@property (nonatomic, strong) UILabel                  *label_AllTime;
/**全屏按钮*/
@property (nonatomic, strong) UIButton                 *button_FullScreen;
/**单击屏幕手势*/
@property (nonatomic, strong) UITapGestureRecognizer   *gesture_TapOneScreen;
/**双击屏幕手势*/
@property (nonatomic, strong) UITapGestureRecognizer   *gesture_TapTwoScreen;
/**进度*/
@property (nonatomic, strong) UIPanGestureRecognizer   *gesture_PanProgressAndVoiceOrLightScreen;
/**控制器YES代表隐藏状态，NO不隐藏状态*/
@property (nonatomic, assign) BOOL                     toolBarHidden;
/**隐藏视图定时器*/
@property (nonatomic, strong) NSTimer                  *timer;
/**滑动手势的方向*/
@property (nonatomic, assign) ENUM_PanGestureDirection panGestureDirection;
/**滑动事件手势*/
@property (nonatomic, assign) ENUM_PanGestureAction    panGestureAction;
/**播放状态*/
@property (nonatomic, assign)  ENUM_PlayStatus         playStatus;

/**播放器实例*/
@property (nonatomic, strong) AVPlayer                 *player;
/**构建媒体资源的动态视角数据模型*/
@property (strong, nonatomic) AVPlayerItem             *playerItem;
/**顶部View视图*/
@property (nonatomic, strong) UIView                   *view_Top;
/**底部View视图*/
@property (nonatomic, strong) UIView                   *view_Bottom;
/**屏幕状态*/
@property (nonatomic, assign) ENUM_ScreenOrientation   screenOrientation;

@property (strong, nonatomic) NSArray                  *excludedViews;
/**用来保存快进开始的时候的已播放的时长*/
@property (nonatomic, assign) CGFloat                  float_HasBeenPlayingTime;
/**声音slider*/
@property (nonatomic, strong) UISlider                 *volumeViewSlider;
/**亮度View*/
@property (nonatomic, strong) BrightnessView           *brightnessView;
/**播放状态提示视图*/
@property (nonatomic, strong) UIView                   *view_playStatus;
/**顶部返回按钮*/
@property (nonatomic, strong) UIButton                 *button_Top_back;
/**顶部更多按钮*/
@property (nonatomic, strong) UIButton                 *button_Top_More;
/**标题容器视图*/
@property (nonatomic, strong) UIView                   *view_Top_Title;
/**顶部title按钮*/
//@property (nonatomic, strong) UILabel                  *label_Top_Title;
/***/
@property (nonatomic, weak  ) UILabel                  *label_Buffering;
/**记录上一个视频状态*/
@property (nonatomic, assign) NSInteger                lastStatus;
/***/
@property (nonatomic, weak)  BYC_MediaPlayer           *mediaPlayer;

/**YES:屏幕自动旋转*/
@property (nonatomic, assign) BOOL                     isAutoRotationScreen;

@end

@implementation BYC_View_MediaPlayerUI

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

/**
 *  初始化子视图
 */
- (void)initSubviews {
    
    [self initTopView];
    [self initBottomView];
    [self initGestureAction];
}

/**
 *  初始化手势事件
 */
- (void)initGestureAction {
    
    _gesture_TapOneScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mediaPlayerAction:)];
    _gesture_TapOneScreen.numberOfTapsRequired = 1;
    _gesture_TapTwoScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mediaPlayerAction:)];
    _gesture_TapTwoScreen.numberOfTapsRequired = 2;
    
    _gesture_PanProgressAndVoiceOrLightScreen     = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mediaPlayerAction:)];
    _gesture_PanProgressAndVoiceOrLightScreen.delegate = self;
    
    [self addGestureRecognizer:_gesture_TapOneScreen];
    [self addGestureRecognizer:_gesture_TapTwoScreen];
    [self addGestureRecognizer:_gesture_PanProgressAndVoiceOrLightScreen];
    [self setupGestureEnabled:NO];
    
    //关键的一句话，使用[A requireGestureRecognizerToFail：B]函数，它可以指定当A手势发生时，即便A已经滿足条件了，也不会立刻触发，会等到指定的手势B确定失败之后才触发,B不失败，那么A就不能执行。
    [_gesture_TapOneScreen requireGestureRecognizerToFail:_gesture_TapTwoScreen];
}

- (void)initParame {
    
    //监控设备方向的变化
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [QNWSNotificationCenter addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    _slider_ProgressBar.enabled = YES;
    [self setupGestureEnabled:!_view_Top.hidden];
    self.excludedViews = @[self.view_Bottom];
    [self resetTimer];
}
/**
 *  初始化隐藏工具栏定时器
 */
- (void)resetTimer {
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(toolBarHiddeAnimation) userInfo:nil repeats:YES];
}

/**
 *  暂停timer
 */
- (void)pauseTimer {
    
    [self.timer setFireDate:[NSDate distantFuture]];
}
/**
 *  不暂停timer
 */
- (void)startTimer {
    
    if (_view_Bottom.alpha == 1 && self.playStatus != ENUM_PlayStatusStop)
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    
}

/**
 *  返回按钮
 */
-(void)mediaPlayerBack:(UIButton*)btn
{
    switch (self.mediaPlayer.screen_Orientation) {
        case ENUM_ScreenOrientationPortrait:
            [_delegate videoPlayViewPop];
            break;
        case ENUM_ScreenOrientationLandscape:
        {
            _button_FullScreen.selected = NO;
            [self setNavigationRotate:NO];
            
        }
            break;
        case ENUM_ScreenOrientationLandscapeRight:
        {
            _button_FullScreen.selected = NO;
            [self setNavigationRotate:NO];
            
        }
            break;
        case ENUM_ScreenOrientationLandscapeLeft:
        {
            _button_FullScreen.selected = NO;
            [self setNavigationRotate:NO];
            
        }
            break;
        default:
            break;
    }
}

/**
 *  更多按钮
 */
-(void)mediaPlayerMore:(UIButton*)btn
{
    [_delegate videoPlayReportTheVideo];
    
}

/**
 *  初始化顶部视图
 */
- (void)initTopView {
    
    _view_Top = [[UIView alloc] init];
    _view_Top.backgroundColor = KUIColorFromRGBA(0x000000, 0.68);
    [self addSubview:_view_Top];
    
    [_view_Top mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.top.leading.equalTo(_view_Top.superview);
        make.height.offset(44);
        
    }];
    
    
    _button_Top_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Top_back setImage:[UIImage imageNamed:@"btn_bfy_back_n"] forState:UIControlStateNormal];
    [_button_Top_back setImage:[UIImage imageNamed:@"btn_bfy_back_n"] forState:UIControlStateSelected];
    [_button_Top_back addTarget:self action:@selector(mediaPlayerBack:) forControlEvents:UIControlEventTouchUpInside];
    _button_Top_back.backgroundColor = [UIColor clearColor];
    [_view_Top addSubview:_button_Top_back];
    
    _view_Top_Title = [[UIView alloc]init];
    _view_Top_Title.backgroundColor = [UIColor clearColor];
    [_view_Top addSubview:_view_Top_Title];
    
    
    _label_Top_Title = [[UILabel alloc]init];
    _label_Top_Title.font = [UIFont systemFontOfSize:15];
    _label_Top_Title.textColor = [UIColor whiteColor];
    _label_Top_Title.textAlignment = NSTextAlignmentCenter;
    _label_Top_Title.backgroundColor = [UIColor clearColor];
    _label_Top_Title.hidden = YES;
    [_view_Top_Title addSubview:_label_Top_Title];
    
    
    
    _button_Top_More = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Top_More setImage:[UIImage imageNamed:@"btn_bfy_more_n"] forState:UIControlStateNormal];
    [_button_Top_More setImage:[UIImage imageNamed:@"btn_bfy_more_h"] forState:UIControlStateSelected];
    [_button_Top_More addTarget:self action:@selector(mediaPlayerMore:) forControlEvents:UIControlEventTouchUpInside];
    _button_Top_More.backgroundColor = [UIColor clearColor];
    [_view_Top addSubview:_button_Top_More];
    
    [_button_Top_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_button_Top_back.superview);
        make.width.offset(40);
    }];
    
    
    [_view_Top_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_view_Top_Title.superview.mas_bottom);
        make.left.equalTo(_button_Top_back.mas_right);
        make.trailing.equalTo(_view_Top_Title.mas_trailing);
        make.height.offset(40);
    }];
    
    [_label_Top_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_view_Top_Title.superview.mas_bottom);
        make.centerX.equalTo(_view_Top_Title.mas_centerX);
        make.centerY.equalTo(_view_Top_Title.mas_centerY);
        
    }];
    
    [_button_Top_More mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(_view_Top_Title.superview);
        make.leading.equalTo(_view_Top_Title.mas_trailing);
    }];
    
    
}
/**
 *  初始化底部视图
 */
- (void)initBottomView {
    
    _view_Bottom = [[UIView alloc] init];
    _view_Bottom.backgroundColor = KUIColorFromRGBA(0x000000, 0.68);
    [self addSubview:_view_Bottom];
    
    [_view_Bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.leading.trailing.equalTo(_view_Bottom.superview);
        make.height.offset(44);
    }];
    
    
    _button_Play = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Play setImage:[UIImage imageNamed:@"icon_bfy_bofang_n"] forState:UIControlStateNormal];
    [_button_Play setImage:[UIImage imageNamed:@"icon_bfy_zanting_n"] forState:UIControlStateSelected];
    [_button_Play addTarget:self action:@selector(mediaPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_Play.backgroundColor = [UIColor clearColor];
    
    _view_Time = [[UIView alloc] init];
    _view_Time.backgroundColor = [UIColor clearColor];
    
    _label_CurrentTime = [[UILabel alloc] init];
    _label_CurrentTime.font = [UIFont systemFontOfSize:10];
    _label_CurrentTime.textColor = [UIColor whiteColor];
    _label_CurrentTime.text = @"--:--";
    _label_CurrentTime.textAlignment = NSTextAlignmentRight;
    
    _label_AllTime = [[UILabel alloc] init];
    _label_AllTime.font = [UIFont systemFontOfSize:10];
    _label_AllTime.textColor = [UIColor whiteColor];
    _label_AllTime.text = @"/--:--";
    _label_AllTime.textAlignment = NSTextAlignmentLeft;
    
    _button_FullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_FullScreen setImage:[UIImage imageNamed:@"icon_bfy_quanping_n"] forState:UIControlStateNormal];
    [_button_FullScreen setImage:[UIImage imageNamed:@"icon_bfy_quanping_h"] forState:UIControlStateSelected];
    [_button_FullScreen addTarget:self action:@selector(mediaPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_FullScreen.backgroundColor = [UIColor clearColor];
    
    _slider_ProgressBar= [[UISlider alloc] init]; // 初始化滑块
    _slider_ProgressBar.minimumValue = 0;       // 最大值
    _slider_ProgressBar.maximumValue = MAXFLOAT;// 最小值
    _slider_ProgressBar.value = 0;              // 当前值
    _slider_ProgressBar.minimumTrackTintColor = KUIColorFromRGB(0x4BC8BD);    // 最小值一侧图标
    _slider_ProgressBar.maximumTrackTintColor = [UIColor clearColor];    // 最大值一侧图标
    _slider_ProgressBar.continuous = YES;     // 移动过程中是否触发值变化事件
    _slider_ProgressBar.enabled = NO;
    
    [_slider_ProgressBar addTarget:self action:@selector(sliderValueChangedAction) forControlEvents:UIControlEventValueChanged];
    [_slider_ProgressBar addTarget:self action:@selector(sliderTouchUpInsideAction) forControlEvents:UIControlEventTouchUpInside];
    [_slider_ProgressBar addTarget:self action:@selector(sliderValueTouchDownAction) forControlEvents:UIControlEventTouchDown];
    [_slider_ProgressBar addTarget:self action:@selector(sliderValueTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_slider_ProgressBar addTarget:self action:@selector(sliderValueTouchCancel) forControlEvents:UIControlEventTouchCancel];
    [_slider_ProgressBar setThumbImage:[UIImage imageNamed:@"icon_bfy_handle"] forState:UIControlStateNormal]; // 自定义滑块图标
    
    _progress_Video = [[UIProgressView alloc] init];
    _progress_Video.trackTintColor = [UIColor grayColor];
    _progress_Video.progressTintColor = [UIColor redColor];
    
    [_view_Bottom addSubview:_button_Play];
    [_view_Bottom addSubview:_slider_ProgressBar];
//    [_view_Bottom insertSubview:_progress_Video belowSubview:_slider_ProgressBar];
    [_view_Bottom addSubview:_view_Time];
    [_view_Time addSubview:_label_CurrentTime];
    [_view_Time addSubview:_label_AllTime];
    [_view_Time addSubview:_button_FullScreen];
    
    [_button_Play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_button_Play.superview);
        make.width.offset(40);
        
    }];
    
    [_view_Time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_button_Play.superview);
        make.width.offset(110);
    }];
    
    [_label_CurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label_CurrentTime.superview.mas_centerY);
        make.leading.equalTo(_label_CurrentTime.superview.mas_leading);
    }];
    [_label_AllTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label_AllTime.superview.mas_centerY);
        make.leading.equalTo(_label_CurrentTime.mas_trailing);
    }];
    
    [_label_AllTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_label_CurrentTime);
    }];
    
    [_button_FullScreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(_label_AllTime.superview);
        make.leading.equalTo(_label_AllTime.mas_trailing);
    }];
    
    [_slider_ProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_button_Play.superview);
        make.leading.equalTo(_button_Play.mas_trailing).offset(10);
        make.trailing.equalTo(_view_Time.mas_leading).offset(-10);
    }];
    
//    [_progress_Video mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(_slider_ProgressBar);
//        make.height.offset(2);
//        make.width.equalTo(_slider_ProgressBar);
//    }];
    
}

- (void)mediaPlayerAction:(id)object {
    
    if ((UIButton *)object == _button_Play) {//点击播放按钮
        
        _button_Play.selected = !_button_Play.selected;
        if (_button_Play.selected) self.playStatus = ENUM_PlayStatusPlaying;
        else {
            
            [self showPauseView];
            _isPauseByUser = YES;
            self.playStatus = ENUM_PlayStatusPause;
        }
        return;
    }
    
    if ((UIButton *)object == _button_FullScreen) {//点击全屏按钮
        
        self.screenOrientation = _button_FullScreen.selected == YES ? ENUM_ScreenOrientationPortrait : ENUM_ScreenOrientationLandscape;
        return;
    }
    
    if ((UITapGestureRecognizer *)object == _gesture_TapOneScreen) {//单击屏幕手势
        
        [self toolBarHiddeAnimation];
        return;
    }
    
    if ((UITapGestureRecognizer *)object == _gesture_TapTwoScreen) {//双击屏幕手势
        if (_screenOrientation == ENUM_ScreenOrientationPortrait) self.screenOrientation = ENUM_ScreenOrientationLandscape;
        else self.screenOrientation = ENUM_ScreenOrientationPortrait;
        return;
    }
    
    if ((UIPanGestureRecognizer *)object == _gesture_PanProgressAndVoiceOrLightScreen) {//进度清扫
        
        [self panActionSelect];
        return;
    }
}

//滑动事件
- (void)panActionSelect {
    
    //当前位置
    CGPoint point_Location = [_gesture_PanProgressAndVoiceOrLightScreen locationInView:self];
    // 根据上次和本次的坐标信息，算出速率
    CGPoint point_velocty = [_gesture_PanProgressAndVoiceOrLightScreen velocityInView:self];
    switch (_gesture_PanProgressAndVoiceOrLightScreen.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 比较速率大小
            CGFloat x = fabs(point_velocty.x);
            CGFloat y = fabs(point_velocty.y);
            if (x > y) { // 水平移动
                self.panGestureDirection  = ENUM_PanGestureDirectionHorizontal;
                self.panGestureAction = ENUM_PanGestureActionProgress;
                // 记录快进开始的时候的已播放的时长
                CMTime time                 = self.mediaPlayer.player.currentTime;
                self.float_HasBeenPlayingTime  =  time.value/time.timescale;
                self.playStatus = ENUM_PlayStatusPause;
                [self pauseTimer];
            } else if (x < y){ // 垂直移动
                self.panGestureDirection = ENUM_PanGestureDirectionVertical;
                // 控制音量
                if (point_Location.x < self.bounds.size.width / 2) self.panGestureAction = ENUM_PanGestureActionVolume;
                // 亮度调节
                else self.panGestureAction = ENUM_PanGestureActionLight;
                
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panGestureDirection) {
                case ENUM_PanGestureDirectionHorizontal:{
                    [self horizontalMoved:point_velocty.x]; // 水平移动取x方向的值
                    break;
                }
                case ENUM_PanGestureDirectionVertical:{
                    [self verticalMoved:point_velocty.y]; // 垂直移动取y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panGestureDirection) {
                case ENUM_PanGestureDirectionHorizontal:{
                    
                    // 滑动结束
                    [self sliderTouchUpInsideAction];
                    //把float_HasBeenPlayingTime滞空，不然会越加越多，导致数据混乱
                    self.float_HasBeenPlayingTime = 0;
                    break;
                }
                case ENUM_PanGestureDirectionVertical:{
                    
                    break;
                }
                default:
                    break;
            }
            
            // 移动结束后，状态置为空
            self.panGestureAction    = ENUM_PanGestureActionNull;
            self.panGestureDirection = ENUM_PanGestureDirectionNull;
            
            break;
        }
        default:
            break;
    }
}

//水平移动
- (void)horizontalMoved:(CGFloat)value {
    
    [self.delegate sliderDidStart];
    // 每次滑动需要叠加时间
    self.float_HasBeenPlayingTime += value / 200;
    CGFloat movieTotalTime = [self getMovieTotalTime];
    // 需要限定float_HasBeenPlayingTime的范围
    if (self.float_HasBeenPlayingTime > movieTotalTime) self.float_HasBeenPlayingTime = movieTotalTime;
    else if (self.float_HasBeenPlayingTime < 0)self.float_HasBeenPlayingTime = 0;
    [self sliderToTime:_float_HasBeenPlayingTime];
    // 快进快退的方法,默认前进
    NSString *style = @">>";
    if (value < 0) style = @"<<";
    else if (value > 0) style = @">>";
    [self showPlayProgressViewWithText:[NSString stringWithFormat:@"%@  %@ / %@",style,[self formatSeconds:self.float_HasBeenPlayingTime],[self formatSeconds:movieTotalTime]]];
    
}

- (CGFloat)getMovieTotalTime {
    
    CMTime totalTime           = self.mediaPlayer.playerItem.duration;
    return (CGFloat)totalTime.value/totalTime.timescale;
}

//垂直移动
- (void)verticalMoved:(CGFloat)value {
    
    //更改系统的音量
    if (self.panGestureAction == ENUM_PanGestureActionVolume) self.volumeViewSlider.value      -= value / 10000;
    //亮度
    else if (self.panGestureAction == ENUM_PanGestureActionLight) {
        
        [UIScreen mainScreen].brightness -= value / 10000;
        [[UIApplication sharedApplication].keyWindow addSubview: self.brightnessView];
    }
}

-(UISlider *)volumeViewSlider {
    
    if (_volumeViewSlider) return _volumeViewSlider;
    else return [self getSystemVolume];
}

//获取系统音量
- (UISlider *)getSystemVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (success)return _volumeViewSlider;
    else return nil;
}

-(BrightnessView *)brightnessView {
    
    // 亮度view加到window最上层
    if (!_brightnessView)_brightnessView = [BrightnessView sharedBrightnesView];
    return _brightnessView;
}


- (void)toolBarHiddeAnimation {
    
    QNWSLog(@"%s",__func__);
    
    [UIView animateWithDuration:.35 animations:^{
        
        if (_toolBarHidden) {//不隐藏
            
            _view_Bottom.alpha = 1;
            //            _view_Bottom.transform = CGAffineTransformIdentity;
            
            _view_Top.alpha = 1;
            //            _view_Top.transform = CGAffineTransformIdentity;
            
        }else {//隐藏
            
            _view_Bottom.alpha = 0;
            //            _view_Bottom.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(_view_Bottom.frame));
            
            _view_Top.alpha = 0;
            //            _view_Top.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(_view_Top.frame));
        }
    } completion:^(BOOL finished) {
        
        if (_toolBarHidden)
            [self startTimer];
        else [self pauseTimer];
        _toolBarHidden = !_toolBarHidden;
    }];
}

- (void)sliderValueChangedAction {
    
    [self pauseTimer];
    [self sliderValueChange];
}

- (void)sliderTouchUpInsideAction {
    
    [self startTimer];
    if (self.mediaPlayer.playerItem.isPlaybackBufferEmpty) self.playStatus = ENUM_PlayStatusBuffering;
    else if (self.mediaPlayer.playerItem.playbackLikelyToKeepUp)
        self.playStatus = ENUM_PlayStatusPlaying;
    else self.playStatus = ENUM_PlayStatusBuffering;
    [self.delegate sliderDidEnd];
}

- (void)sliderValueTouchDownAction {
    
    [self pauseTimer];
    [self.delegate sliderDidStart];
}

- (void)sliderValueTouchUpOutside {
    
    [self startTimer];
    if (self.mediaPlayer.playerItem.isPlaybackBufferEmpty) self.playStatus = ENUM_PlayStatusBuffering;
    else if (self.mediaPlayer.playerItem.playbackLikelyToKeepUp)
        self.playStatus = ENUM_PlayStatusPlaying;
    else self.playStatus = ENUM_PlayStatusBuffering;
    [self.delegate sliderDidEnd];
}

- (void)sliderValueTouchCancel {
    
    QNWSLog(@"%s",__func__);
}

- (void)sliderValueChange {
    
    [self setScrubbingTime:_slider_ProgressBar.value];
    [self sliderToTime:_slider_ProgressBar.value];
}

- (void)sliderToTime:(NSTimeInterval)time {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderToTime:)])
        [self.delegate sliderToTime:time];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return ![self.excludedViews containsObject:touch.view] && ![self.excludedViews containsObject:touch.view.superview];
}

-(void)setScreenOrientation:(ENUM_ScreenOrientation)screenOrientation {
    
    _screenOrientation = screenOrientation;
    switch (screenOrientation) {
        case ENUM_ScreenOrientationPortrait://竖屏
            
            _button_FullScreen.selected = NO;
            _label_Top_Title.hidden = YES;
            _button_Top_More.hidden = NO;
            break;
        case ENUM_ScreenOrientationLandscape://横屏
            _button_FullScreen.selected = YES;
            _label_Top_Title.hidden = NO;
            _button_Top_More.hidden = YES;
            break;
            
        default:
            _label_Top_Title.hidden = YES;
            _button_Top_More.hidden = NO;
            break;
    }
    
    if (!_isAutoRotationScreen)
        [self setNavigationRotate:_button_FullScreen.selected];
    _isAutoRotationScreen = NO;//还原
    
}

-(void)setPlayStatus:(ENUM_PlayStatus)playStatus {
    
    _playStatus = playStatus;
    QNWSLog(@"playStatus == %zi",playStatus );
    switch (_playStatus) {
        case ENUM_PlayStatusPlaying: {
            
            _isPauseByUser = NO;
            _button_Play.selected = YES;
            [self play];
            [self hidePlayProgressView];
            if (_lastStatus == ENUM_PlayStatusStop ) {
                
                _toolBarHidden = YES;
                [self toolBarHiddeAnimation];
            }
            break;
        }
        case ENUM_PlayStatusPause: {
            
            _button_Play.selected = NO;
            [self pause];
            break;
        }
        case ENUM_PlayStatusStop: {
            
            _isPauseByUser = NO;
            _button_Play.selected = NO;
            _slider_ProgressBar.value = 0.0f;
            if (_isReplaceUrl) {//替换视频
                
                _isReplaceUrl = NO;
                _label_CurrentTime.text = @"--:--";
                _label_AllTime.text = @"--:--";
                _progress_Video.progress = 0;
            }
            [self stop];
            [self setScreenOrientation:ENUM_ScreenOrientationPortrait];
            
            _toolBarHidden = YES;
            [self toolBarHiddeAnimation];
            
            break;
        }
        case ENUM_PlayStatusShowAD: {
            
            _isPauseByUser = YES;
            _button_Play.selected = NO;
            break;
        }
        case ENUM_PlayStatusBuffering: {
            
            _isPauseByUser = NO;
            [self showLoadingBufferingView];
            break;
        }
    }
    _lastStatus = playStatus;
}

/**
 *  展示播放进度
 *
 *  @param string 进度数据
 */
- (void)showPlayProgressViewWithText:(NSString *)string {
    
    if (![self.view_playStatus viewWithTag:10]) {//初始化进度视图
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.tag  = 10;
        label.textColor = [UIColor whiteColor];
        [_view_playStatus addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(label.superview).insets(UIEdgeInsetsMake(0, 10 , 0, 10));
            make.centerY.equalTo(label.superview.mas_centerY);
            make.height.offset(80);
        }];
    }
    
    UILabel *label = (UILabel *)[_view_playStatus viewWithTag:10];
    label.text = string;
}

/**
 *  展示暂停按钮
 */
- (void)showPauseView {
    
    if (![self.view_playStatus viewWithTag:11]) {//初始化进度视图
        
        UIButton *button = [[UIButton alloc] init];
        button.tag  = 11;
        [button setImage:[UIImage imageNamed:@"btn-play-n"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn-play-h"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removePlayBtn) forControlEvents:UIControlEventTouchUpInside];
        [_view_playStatus addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.superview.mas_centerX);
            make.centerY.equalTo(button.superview.mas_centerY);
            make.height.offset(80);
            make.width.offset(80);
        }];
    }
}

/**
 *  展示缓冲
 */
- (void)showLoadingBufferingView {
    
    QNWSLog(@"%s",__func__);
    if (![self.view_playStatus viewWithTag:12]) {//初始化进度视图
        UIView *view = ({
            
            UIView *view = [[UIView alloc] init];
            view.tag  = 12;
            [_view_playStatus addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view.superview.mas_centerX);
                make.centerY.equalTo(view.superview.mas_centerY);
                make.height.offset(150);
                make.width.offset(150);
            }];
            view;
        });
        
        UIImageView *imageView = ({
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [view addSubview:imageView];
            imageView.image = [UIImage imageNamed:@"movieLoading"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.equalTo(imageView.superview).insets(UIEdgeInsetsMake(20, 0, 0, 0));
                make.height.offset(80);
            }];
            imageView;
        });
        [self imageVBufferingAnimation:imageView];
        
        
        UILabel *label = ({
            
            UILabel *label = [[UILabel alloc] init];
            [view addSubview:label];
            label.text = @"已缓冲 0%";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = [UIColor whiteColor];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.leading.trailing.equalTo(label.superview);
                make.top.equalTo(imageView.mas_bottom);
            }];
            label;
        });
        
        _label_Buffering = label;
    }
}

/**
 *  循环旋转动画
 *
 *  @param imageV 需要旋转的视图
 */
- (void)imageVBufferingAnimation:(UIView *)view {
    
    CABasicAnimation *baseAni = [CABasicAnimation animation];
    baseAni.keyPath = @"transform.rotation";
    baseAni.toValue = @(M_PI * 2);
    baseAni.duration = .75f;
    baseAni.repeatCount = MAXFLOAT;
    [view.layer addAnimation:baseAni forKey:nil];
}

- (void)hidePlayProgressView {
    
    QNWSLog(@"%s",__func__);
    // 移除视图
    [_view_playStatus removeFromSuperview];
    _view_playStatus = nil;
}


- (void)removePlayBtn {
    
    self.playStatus = ENUM_PlayStatusPlaying;
}

-(UIView *)view_playStatus {
    
    if (!_view_playStatus) {//初始化进度视图
        
        _view_playStatus = [[UIView alloc] init];
        [self addSubview:_view_playStatus];
        [_view_playStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(_view_playStatus.superview).insets(UIEdgeInsetsMake(0, 0 , CGRectGetHeight(_view_Bottom.frame), 0));
        }];
    }
    
    for (UIView *view in _view_playStatus.subviews) [view removeFromSuperview];
    return _view_playStatus;
}

- (void)setNavigationRotate:(BOOL)isOK {
    
    int interfaceOrientation;//旋转方向
    if (isOK)interfaceOrientation = UIInterfaceOrientationLandscapeRight;
    else interfaceOrientation = UIInterfaceOrientationPortrait;
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    [invocation setArgument:&interfaceOrientation atIndex:2];//runtime机制，只能写2。0 1 已经被占用
    [invocation invoke];
}


- (void)calculateDownloadProgress:(AVPlayerItem *)playerItem {
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
    CMTime duration = playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    [self.progress_Video setProgress:timeInterval / totalDuration animated:YES];
    //不需要一定要等到缓冲池满，只要缓冲大于20s就行了
    _label_Buffering.text = [NSString stringWithFormat:@"已缓冲 %zi%%",(unsigned long)((NSUInteger)(durationSeconds / 20.0f * 100) > 100 ? 100 : (NSUInteger)(durationSeconds / 20.0f * 100))];
    QNWSLog(@"=======  %@",_label_Buffering.text);
    if ((durationSeconds > 20.0f || timeInterval == totalDuration) && self.playStatus != ENUM_PlayStatusPlaying && !_isPauseByUser)
        self.playStatus = ENUM_PlayStatusPlaying;
}

- (void)bufferingSomeSecond
{
    //playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.mediaPlayer.playerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}

-(void)setDelegate:(id<BYC_MediaPlayerDelegate>)delegate {
    
    _delegate = delegate;
    _mediaPlayer = _delegate;
}


//播放器在cell 上进行相关处理工作
- (void)playerAboveCell:(BOOL)isOK {
    
    _button_FullScreen.hidden = isOK;
    _view_Top.hidden = isOK;
    [self setupGestureEnabled:!isOK];
    [_view_Time mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(isOK ? 90 : 110);
    }];
}

//不在cell上面触发手势事件
- (void)setupGestureEnabled:(BOOL)isOK {
    
    _gesture_PanProgressAndVoiceOrLightScreen.enabled = isOK;
}

-(void)deviceOrientationDidChange:(NSNotification *)notification {

    _isAutoRotationScreen = YES;
    switch ([UIDevice currentDevice].orientation) {

        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            self.screenOrientation = ENUM_ScreenOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            self.screenOrientation = ENUM_ScreenOrientationLandscape;
            break;
        default:
            self.screenOrientation = ENUM_ScreenOrientationUnknown;
            break;
    }
}

#pragma mark - BYC_MediaPlayerTransport
/**
 *  可以开始播放了
 *
 */
- (void)setStart {
    
    //此时应该初始化所有参数，并且在初始化完成之后此时状态应该是播放中、、
    [self initParame];
}
/**
 *  设置当前时间和剩余时间
 *
 *  @param time     当前时间
 *  @param duration 剩余时间
 */
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    
    if (time > duration) _label_CurrentTime.text = [self formatSeconds:duration];
    else if (time < 0) {
        
        if (duration > 3600) _label_CurrentTime.text = @"00:00:00";
        else _label_CurrentTime.text = @"00:00";
    }
    else _label_CurrentTime.text = [self formatSeconds:time];
    _label_AllTime.text = [NSString stringWithFormat:@"/%@",[self formatSeconds:duration]];
    _slider_ProgressBar.minimumValue = 0.0f;
    _slider_ProgressBar.maximumValue = duration;
    _slider_ProgressBar.value = time;
}

- (NSString *)formatSeconds:(NSUInteger)value {
    
    NSString *str = nil;
    
    if (value < 3600) return str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(value/60.f)),lround(floor(value/1.f))%60];
    else return str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(value/3600.f)),lround(floor(((NSUInteger)value)%3600)/60.f),lround(floor(value/1.f))%60];
}
/**
 *  设置滑动到的时间
 *
 *  @param time 设置滑动到某时的时间
 */
- (void)setScrubbingTime:(NSTimeInterval)time {
    
    _label_CurrentTime.text = [self formatSeconds:time];
}
/**
 *  播放完成
 */
- (void)playbackComplete {
    
    self.playStatus = ENUM_PlayStatusStop;
    
}

/**
 *  当前播放状态
 */
- (void)currentPlayStatus:(ENUM_PlayStatus)PlayStatus {
    
    self.playStatus = PlayStatus;
}


/**
 *  播放
 */
- (void)play {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(play)])[self.delegate play];
}
/**
 *  暂停
 */
- (void)pause {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pause)])[self.delegate pause];
}
/**
 *  停止
 */
- (void)stop {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(stop)])[self.delegate stop];
}

@end
