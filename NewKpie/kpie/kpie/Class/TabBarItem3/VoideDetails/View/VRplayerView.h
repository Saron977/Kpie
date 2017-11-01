//
//  VRplayerView.h
//  kpie
//
//  Created by sunheli on 16/6/24.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UtoVRPlayer/UtoVRPlayer.h>
#import "BYC_MediaPlayerDelegate.h"

typedef NS_ENUM(NSUInteger, ENUM_UIScreenOrientation) {
    
    /**竖屏*/
    ENUM_UIScreenOrientationPortrait,
    /**横屏*/
    ENUM_UIScreenOrientationLandscape,
    /**横屏右*/
    ENUM_UIScreenOrientationLandscapeRight,
    /**横屏左*/
    ENUM_UIScreenOrientationLandscapeLeft
};

typedef NS_ENUM(NSUInteger, ENUM_OutPlayerStatus) {
    ENUM_PlayerStatusPlay,
    ENUM_PlayerStatusPuse,
    ENUM_PlayerStatusStop
};


@protocol VRPlayerViewDelegate <NSObject>

/**
 *  返回按钮,
 *
 *  返回上一级界面, 全屏时退出全屏,
 */
- (void)backToPrePage;
/**
 *  更多按钮
 *
 *  举报视频
 */
- (void)mediaPlayReportTheVideo;
/**
 *  播放按钮
 *
 *  @param sender button_play
 */
-(void)buttonPlayOrPauseDelegate:(UIButton *)sender;
/**
 *  螺旋
 *
 *  @param sender button_gyroscope
 */
-(void)gyroscope:(UIButton *)sender;
/**
 *  双屏
 *
 *  @param sender button_duralScreen
 */
-(void)duralScreen:(UIButton *)sender;

-(void)sliderTap:(UITapGestureRecognizer *)tap;

/**
 *  进度条开始滑动
 */
- (void)sliderDidStart:(UISlider *)sender;
/**
 *  进度条滑动到某个时间
 *
 *  @param time 当前滑动到的时间
 */
- (void)sliderToTime:(NSTimeInterval)time;
/**
 *  进度条滑动结束
 */
- (void)sliderDidEnd:(UISlider *)slider;


@end
@interface VRplayerView : UIView
/** VR播放器 */
@property (nonatomic, strong) UVPlayer                 *VR_Player;
/** 播放源 */
@property (nonatomic, strong)UVPlayerItem              *playItem;

@property (nonatomic, strong) UIView                   *topView;
/**顶部返回按钮*/
@property (nonatomic, strong) UIButton                 *button_Top_back;
/**顶部更多按钮*/
@property (nonatomic, strong) UIButton                 *button_Top_More;
/**标题容器视图*/
@property (nonatomic, strong) UIView                   *view_Top_Title;
/**顶部title按钮*/
@property (nonatomic, strong) UILabel                  *label_Top_Title;


@property (nonatomic, strong) UIView                   *bottomView;
/**点击播放按钮*/
@property (nonatomic, strong) UIButton                 *button_Play;
/**全屏按钮*/
@property (nonatomic, strong) UIButton                 *button_FullScreen;
/**
 *  双屏
 */
@property (nonatomic, strong) UIButton                 *button_DuralScreen;
/**
 *  螺旋
 */
@property (nonatomic, strong) UIButton                 *button_Gyroscope;

/**进度条*/
@property (nonatomic, strong) UISlider                 *slider_ProgressBar;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView           *progressView;

/**当前播放时间*/
@property (nonatomic, strong) UILabel                  *label_CurrentTime;
/**整个视频时间*/
@property (nonatomic, strong) UILabel                  *label_AllTime;
/** 给slider添加手势*/
@property (nonatomic, strong) UITapGestureRecognizer    *tap;
/**时间容器视图*/
@property (nonatomic, strong) UIView                   *view_Time;

@property (nonatomic, assign) BOOL                       isFullScreen;

@property (nonatomic, strong) UIAlertView                *alert1;
@property (nonatomic, strong) UIAlertView                *alert2;

/**单击屏幕手势*/
@property (nonatomic, strong) UITapGestureRecognizer                      *gesture_TapOneScreen;
/**控制器YES代表隐藏状态，NO不隐藏状态*/
@property (nonatomic, assign) BOOL                                        toolBarHidden;
@property(nonatomic, strong) NSTimer                                      *timer;                         /**< 定时器 */

/**屏幕状态*/
@property (nonatomic, assign) ENUM_UIScreenOrientation   screenOrientation;
@property (nonatomic, assign) ENUM_UIScreenOrientation   screen_Orientation;

/** 外界控制播放的状态 */
@property (nonatomic, assign) ENUM_OutPlayerStatus controlPlayerStatus;
/**  手动控制播放器状态 */
@property (nonatomic, assign) ENUM_OutPlayerStatus controlPlayer_Status;
/**  自定义的VR代理 */
@property (nonatomic, weak) id <VRPlayerViewDelegate> VRdelagete;

@property (nonnull, assign) id <BYC_MediaPlayerDelegate> mediaDelagete;

/**
 *  重置VRPlayer
 */
-(void)releaseVRPlayer;

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

@end

