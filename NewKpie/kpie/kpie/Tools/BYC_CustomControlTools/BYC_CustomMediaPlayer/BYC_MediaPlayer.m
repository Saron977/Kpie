//
//  BYC_MediaPlayer.m
//  kpie
//
//  Created by 元朝 on 16/3/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MediaPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "BYC_View_MediaPlayer.h"

/**AVPlayerItem的status属性*/
#define KEYPATH_STATUS @"status"
/**AVPlayerItem的loadedTimeRanges属性*/
#define KEYPATH_LOADEDTIMERANGES @"loadedTimeRanges"
/**AVPlayerItem的playbackBufferEmpty属性*/
#define KEYPATH_PLAYBACKBUFFEREMPTY @"playbackBufferEmpty"
/**AVPlayerItem的playbackLikelyToKeepUp属性*/
#define KEYPATH_PLAYBACKLIKELYTOKEEPUP @"playbackLikelyToKeepUp"
/**刷新时间*/
#define REFRESH_INTERVAL 0.5f

static const NSString *PlayerItemStatusContext;

@interface BYC_MediaPlayer()<BYC_MediaPlayerDelegate>

/**以下四个属性是播放视频必须要的*/
/**媒体资源*/
@property (strong, nonatomic) AVAsset              *asset;
/**构建媒体资源的动态视角数据模型*/
@property (strong, nonatomic) AVPlayerItem         *playerItem_Instance;
/**管理流媒体数据播放的对象*/
@property (strong, nonatomic) AVPlayer             *player_Instance;
/**需要呈现媒体资源的UI界面对象*/
@property (strong, nonatomic) BYC_View_MediaPlayer *view_MediaPlayer;
/**实现BYC_MediaPlayerTransport相关协议的对象*/
@property (weak, nonatomic) id <BYC_MediaPlayerTransport> mediaPlayerTransport;
@property (strong, nonatomic) id    timeObserver;
@property (strong, nonatomic) id    itemEndObserver;
/**isAdd 是否已经增加观察者 ： YES表示已经增加观察者*/
@property (nonatomic, assign)  BOOL  isAlreadyAddObserver;
/**YES:表示在左右滑动屏幕改变进度*/
@property (nonatomic, assign)  BOOL  isSliding;
/**YES:表示拖拽进度条结束*/
@property (nonatomic, assign)  BOOL  isDidEndSliding;
/**视频地址*/
@property (nonatomic, copy)  NSString  *string_Mp4Url;
/**标题*/
@property (nonatomic, copy)  NSString  *title_Str;
@end

@implementation BYC_MediaPlayer

QNWSSingleton_implementation(BYC_MediaPlayer)
- (instancetype)initWithURLString:(NSString *)assetURLString TitleString:(NSString *)titleString
{
    NSAssert(assetURLString.length > 0, @"视频链接不能为空！！！");
    
    self = [BYC_MediaPlayer sharedBYC_MediaPlayer];
    
    if (self) {
        
        if (![self.string_Mp4Url isEqualToString:assetURLString] && self.string_Mp4Url.length != 0) {//替换视频连接
            if (self.mediaPlayerTransport) {
                BYC_View_MediaPlayerUI *viewMediaPlayerUI = (BYC_View_MediaPlayerUI *)self.mediaPlayerTransport;
                viewMediaPlayerUI.label_Top_Title.text = titleString;
                viewMediaPlayerUI.isReplaceUrl = YES;
            }
            [self cancelPlayer];//取消原来的一些东西
        }
        self.string_Mp4Url = assetURLString;
        self.title_Str = titleString;
        _asset = [AVAsset assetWithURL:[NSURL URLWithString:assetURLString]];
        [self prepareToPlay];
    }
    
    return self;
}

- (void)stopPlayer {
    
    [self cancelPlayer];
    _asset = nil;
    _player_Instance = nil;
    _playerItem_Instance = nil;
}

- (void)cancelPlayer {
    
    [self.mediaPlayerTransport playbackComplete];
    [self releaseProperty];
}

//释放东西
- (void)releaseProperty {
    
    if (self.itemEndObserver) {
        NSNotificationCenter *nc = QNWSNotificationCenter;
        [nc removeObserver:self.itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.player_Instance.currentItem];
        self.itemEndObserver = nil;
    }
    
    [QNWSNotificationCenter removeObserver:self];
}

/**
 *  播放前准备
 */
- (void)prepareToPlay {
    
    //初始化那些事需要被访问的资源属性
    NSArray *keys = @[
                      @"tracks",
                      @"duration",
                      @"commonMetadata",
                      @"availableMediaCharacteristicsWithMediaSelectionOptions"
                      ];
    self.playerItem_Instance = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
    [self.playerItem_Instance addObserver:self forKeyPath:KEYPATH_STATUS options:NSKeyValueObservingOptionNew context:&PlayerItemStatusContext];
    [self addObserverOrRemove:YES];
    self.player_Instance = [AVPlayer playerWithPlayerItem:self.playerItem_Instance];
    self.view_MediaPlayer = [[BYC_View_MediaPlayer alloc] initWithPlayer:self.player_Instance TitleString:self.title_Str];
    self.mediaPlayerTransport = self.view_MediaPlayer.mediaPlayerTransport;
    self.mediaPlayerTransport.delegate = self;
    
}

/**
 *  增加或者移除观察者,写这个方法目的就是解决视频播放完成之后还继续缓冲，然后导致缓冲足够了就自动播放了。具体原因待查。
 *
 *  @param isAdd YES:增加观察者 NO:移除
 */
- (void)addObserverOrRemove:(BOOL)isAdd {
    
    if (isAdd) {
        
        _isAlreadyAddObserver = YES;
        [self.playerItem_Instance addObserver:self forKeyPath:KEYPATH_LOADEDTIMERANGES options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem_Instance addObserver:self forKeyPath:KEYPATH_PLAYBACKBUFFEREMPTY options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem_Instance addObserver:self forKeyPath:KEYPATH_PLAYBACKLIKELYTOKEEPUP options:NSKeyValueObservingOptionNew context:nil];
    }else {
        
        _isAlreadyAddObserver = NO;
        [self.playerItem_Instance removeObserver:self forKeyPath:KEYPATH_LOADEDTIMERANGES];
        [self.playerItem_Instance removeObserver:self forKeyPath:KEYPATH_PLAYBACKBUFFEREMPTY];
        [self.playerItem_Instance removeObserver:self forKeyPath:KEYPATH_PLAYBACKLIKELYTOKEEPUP];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == &PlayerItemStatusContext/*[keyPath isEqualToString: KEYPATH_STATUS]*/) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.playerItem_Instance removeObserver:self forKeyPath:KEYPATH_STATUS];
            
            if (self.playerItem_Instance.status == AVPlayerItemStatusReadyToPlay) {
                QNWSLog(@"11111111111111111111111111");
                //设置时间的监听者
                [self addPlayerItemTimeObserver];
                [self registerNotification];
                CMTime duration = self.playerItem_Instance.duration;
                // 同步已播放时间
                [self.mediaPlayerTransport setCurrentTime:CMTimeGetSeconds(kCMTimeZero) duration:CMTimeGetSeconds(duration)];
                // 做好开始的准备
                [self.mediaPlayerTransport setStart];
                [self.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusPlaying];
            } else [[UIView alloc] showAndHideHUDWithTitle:@"播放错误" WithState:BYC_MBProgressHUDHideProgress];
        });
    }else if ([keyPath isEqualToString: KEYPATH_LOADEDTIMERANGES]) {
        
        if (!_isDidEndSliding && _isSliding)return;//进度条拖拽结束播放视频
        QNWSLog(@"22222222222222222222222222");
        [self.mediaPlayerTransport calculateDownloadProgress:self.playerItem_Instance];
    }
    else if ([keyPath isEqualToString: KEYPATH_PLAYBACKBUFFEREMPTY]) {
        
        if (self.playerItem_Instance.isPlaybackBufferEmpty) {
            QNWSLog(@"3333333333333333333333333333");
            [self.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusBuffering];
            [self.mediaPlayerTransport bufferingSomeSecond];
        }
        
    }else if ([keyPath isEqualToString: KEYPATH_PLAYBACKLIKELYTOKEEPUP]) {
        
        BYC_View_MediaPlayerUI *viewMediaPlayerUI = (BYC_View_MediaPlayerUI *)self.mediaPlayerTransport;
        // 当缓冲好的时候，这里多了一个是否在滑动的状态判断。在滑动的时候就不播放。滑动结束了在播放
        if (self.playerItem_Instance.playbackLikelyToKeepUp && !_isSliding && !viewMediaPlayerUI.isPauseByUser) {
            
            if (_isDidEndSliding) {//进度条拖拽结束播放视频
                _isDidEndSliding = NO;
                QNWSLog(@"66666666666666666666666");
                [self.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusPlaying];
                return;
            }
            
            QNWSLog(@"4444444444444444444444444");
            if (_controlPlayerStatus == ENUM_ControlPlayerStatusPuse || _controlPlayerStatus == ENUM_ControlPlayerStatusStop)return;
            QNWSLog(@"55555555555555555555555555");
            [self.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusPlaying];
        }
    }
}

/**
 *  注册当前已播放的时间监听者
 */
- (void)addPlayerItemTimeObserver {
    
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);
    QNWSWeakSelf(self);
    self.timeObserver = [self.player_Instance addPeriodicTimeObserverForInterval:interval
                                                                           queue:dispatch_get_main_queue()
                                                                      usingBlock:^(CMTime time) {
                                                                          
                                                                          NSTimeInterval currentTime = CMTimeGetSeconds(time);
                                                                          
                                                                          NSTimeInterval duration = CMTimeGetSeconds(weakself.playerItem_Instance.duration);
                                                                          //这里视频切换的时候duration 的值经常 = Nan，会导致崩溃。所以给了个判断
                                                                          if (weakself.playerItem_Instance.duration.timescale == 0 && weakself.playerItem_Instance.duration.value == 0)return;
                                                                          [weakself.mediaPlayerTransport setCurrentTime:currentTime duration:duration];
                                                                      }];
}

/**
 *  注册通知
 */
- (void)registerNotification {
    
    QNWSWeakSelf(self);
    self.itemEndObserver = [QNWSNotificationCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                             object:self.playerItem_Instance
                                                                              queue:[NSOperationQueue mainQueue]
                                                                         usingBlock:^(NSNotification *notification) {
                                                                             
                                                                             //使用[weakSelf.player seekToTime:kCMTimeZero
                                                                             //completionHandler:^(BOOL finished) {
                                                                             //}];导致播放完了也还会继续缓冲,移除缓冲通知就好了。具体原因待查
                                                                             [weakself.player_Instance seekToTime:kCMTimeZero
                                                                                                completionHandler:^(BOOL finished) {
                                                                                                    
                                                                                                    [weakself.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusPause];
                                                                                                    [weakself.mediaPlayerTransport playbackComplete];
                                                                                                }];
                                                                         }];
    
    
    [QNWSNotificationCenter addObserver:self
     
                                             selector:@selector(activeNotification:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil]; //进入后台
    
    [QNWSNotificationCenter addObserver:self
                                             selector:@selector(activeNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil]; // 返回前台
}

- (void)activeNotification:(NSNotification *)notification {
    
    if (notification.name == UIApplicationWillResignActiveNotification) [self.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusPause];//进入后台
    else if (notification.name == UIApplicationDidBecomeActiveNotification)
        if (_player_Instance.rate != 0) [self.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusPlaying];//进入前台
}

#pragma mark - BYC_MediaPlayerDelegate
/**
 *  播放
 */
- (void)play {
    
    _controlPlayerStatus = ENUM_ControlPlayerStatusPlay;
    [self.player_Instance play];
    if (!_isAlreadyAddObserver) [self addObserverOrRemove:YES];
    
}
/**
 *  暂停
 */
- (void)pause {
    
    _controlPlayerStatus = ENUM_ControlPlayerStatusPuse;
    [self.player_Instance pause];
}
/**
 *  停止
 */
- (void)stop {
    
    _controlPlayerStatus = ENUM_ControlPlayerStatusStop;
    [self.player_Instance setRate:0.0f];
    if (_isAlreadyAddObserver) [self addObserverOrRemove:NO];
}

/**
 *  进度条开始滑动
 */
- (void)sliderDidStart {
    
    _isSliding = YES;
    _isDidEndSliding = NO;
    [self.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusPause];
    [self.player_Instance.currentItem cancelPendingSeeks];
    [self.player_Instance.currentItem.asset cancelLoading];
    //执行这句话的时候经常会崩
    //    @try {
    //
    //        [self.player removeTimeObserver:self.timeObserver];
    //    } @catch (NSException *exception) {
    //        QNWSLog(@"exception  ==--  %@",exception);
    //    } @finally {
    //
    //    }
}
/**
 *  进度条滑动到某个时间
 *
 *  @param time 当前滑动到的时间
 */
- (void)sliderToTime:(NSTimeInterval)time {
    
    [self.playerItem_Instance cancelPendingSeeks];
    [self.player_Instance seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}
/**
 *  进度条滑动结束
 */
- (void)sliderDidEnd {
    
    _isSliding = NO;
    _isDidEndSliding = YES;
    //这里就是第一次播放完了，拖动slider也需要进行再次播放操作
    if (!_isAlreadyAddObserver) {
        [self.mediaPlayerTransport currentPlayStatus:ENUM_PlayStatusPlaying];
        [self addObserverOrRemove:YES];
    }
    [self addPlayerItemTimeObserver];
}
/**
 *  视频播放跳到相应的时间
 *
 *  @param time 当前播放的时间
 */
- (void)jumpedToTime:(NSTimeInterval)time {
    
    [self.player_Instance seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}
/**
 *  返回按钮,
 *
 *  返回上一级界面, 全屏时退出全屏,
 */
- (void)videoPlayViewPop {
    [_media_Delegate mediaPlayViewPop];
    
}
/**
 *  更多按钮
 *
 *  举报视频
 */
- (void)videoPlayReportTheVideo {
    [_media_Delegate mediaPlayReportTheVideo];
    
}

#pragma mark set方法
-(void)setIsAboveCell:(BOOL)isAboveCell {
    
    _isAboveCell = isAboveCell;
    [(BYC_View_MediaPlayerUI *)self.mediaPlayerTransport playerAboveCell:isAboveCell];
}

-(void)setString_Mp4Url:(NSString *)string_Mp4Url {
    
    _string_Mp4Url = string_Mp4Url;
    [QNWSNotificationCenter postNotificationName:@"CancelPlayOnCurrentCellNotification" object:nil userInfo:@{@"MP4Url":_string_Mp4Url}];
}

-(void)setControlPlayerStatus:(ENUM_OutControlPlayerStatus)controlPlayerStatus {
    
    _controlPlayerStatusDefult  = _controlPlayerStatus;
    _controlPlayerStatus = controlPlayerStatus;
    switch (_controlPlayerStatus) {
        case ENUM_ControlPlayerStatusPlay: {
            [self play];
            break;
        }
        case ENUM_ControlPlayerStatusPuse: {
            [self pause];
            break;
        }
        case ENUM_ControlPlayerStatusStop: {
            [self stop];
            break;
        }
    }
}

#pragma mark get方法
- (UIView *)view {
    QNWSLog(@"BYC_View_MediaPlayer==%@",NSStringFromCGRect(self.view_MediaPlayer.frame));
    return self.view_MediaPlayer;
}

- (AVPlayerItem *)playerItem {
    return self.playerItem_Instance;
}

- (AVPlayer *)player {
    return self.player_Instance;
}

- (void)dealloc {
    
    [self addObserverOrRemove:NO];
    [self releaseProperty];
}

@end
