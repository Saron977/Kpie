//
//  BYC_MediaPlayerDelegate.h
//  kpie
//
//  Created by 元朝 on 16/3/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, ENUM_PlayStatus) {
    
    /**播放中*/
    ENUM_PlayStatusPlaying,
    /**播放暂停*/
    ENUM_PlayStatusPause,
    /**播放结束*/
    ENUM_PlayStatusStop,
    /**播放显示广告*/
    ENUM_PlayStatusShowAD,
    /**缓冲状态*/
    ENUM_PlayStatusBuffering
};


@protocol BYC_MediaPlayerDelegate <NSObject>

/**
 *  播放
 */
- (void)play;
/**
 *  暂停
 */
- (void)pause;
/**
 *  停止
 */
- (void)stop;

/**
 *  进度条开始滑动
 */
- (void)sliderDidStart;
/**
 *  进度条滑动到某个时间
 *
 *  @param time 当前滑动到的时间
 */
- (void)sliderToTime:(NSTimeInterval)time;
/**
 *  进度条滑动结束
 */
- (void)sliderDidEnd;
/**
 *  视频播放跳到相应的时间
 *
 *  @param time 当前播放的时间
 */
- (void)jumpedToTime:(NSTimeInterval)time;

/**
 *  返回按钮,
 *
 *  返回上一级界面, 全屏时退出全屏,
 */
- (void)videoPlayViewPop;
/**
 *  更多按钮
 *
 *  举报视频
 */
- (void)videoPlayReportTheVideo;
@end

@protocol BYC_MediaPlayerTransport <NSObject>

@property (weak, nonatomic) id <BYC_MediaPlayerDelegate> delegate;
/**
 *  可以开始播放了
 *
 */
- (void)setStart;
/**
 *  设置当前时间和剩余时间
 *
 *  @param time     当前时间
 *  @param duration 剩余时间
 */
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
/**
 *  设置滑动到的时间
 *
 *  @param time 设置滑动到某时的时间
 */
- (void)setScrubbingTime:(NSTimeInterval)time;
/**
 *  播放完成
 */
- (void)playbackComplete;

/**
 *  当前播放状态
 */
- (void)currentPlayStatus:(ENUM_PlayStatus)PlayStatus;
/**
 *  计算下载进度
 */
- (void)calculateDownloadProgress:(AVPlayerItem *)playerItem;
- (void)bufferingSomeSecond;
@end
