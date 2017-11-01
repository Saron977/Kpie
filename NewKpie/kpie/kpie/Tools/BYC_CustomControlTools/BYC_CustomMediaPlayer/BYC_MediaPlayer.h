//
//  BYC_MediaPlayer.h
//  kpie
//
//  Created by 元朝 on 16/3/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_MediaPlayerDelegate.h"
#import "BYC_View_MediaPlayerUI.h"


typedef NS_ENUM(NSUInteger, ENUM_OutControlPlayerStatus) {
    ENUM_ControlPlayerStatusPlay,
    ENUM_ControlPlayerStatusPuse,
    ENUM_ControlPlayerStatusStop
};

@class BYC_MediaPlayer;
@protocol WX_MediaPlayerDelegate <NSObject>
/**
 *  返回按钮,
 *
 *  返回上一级界面, 全屏时退出全屏,
 */
- (void)mediaPlayViewPop;
/**
 *  更多按钮
 *
 *  举报视频
 */
- (void)mediaPlayReportTheVideo;

@end

@interface BYC_MediaPlayer : NSObject
QNWSSingleton_interface(BYC_MediaPlayer)
/**视频播放视图*/
@property (strong, nonatomic, readonly)  UIView         *view;
/**构建媒体资源的动态视角数据模型*/
@property (strong, nonatomic, readonly)  AVPlayerItem   *playerItem;
/**管理流媒体数据播放的对象*/
@property (strong, nonatomic, readonly)  AVPlayer       *player;
/**外界控制播放的状态*/
@property (nonatomic, assign          ) ENUM_OutControlPlayerStatus controlPlayerStatus;
/**恢复到被外界控制播放之前的状态*/
@property (nonatomic, assign, readonly) ENUM_OutControlPlayerStatus controlPlayerStatusDefult;
/**屏幕状态*/
@property (nonatomic, assign) ENUM_ScreenOrientation   screen_Orientation;

/**
 *  播放器一些操作功能的代理
 */
@property (weak, nonatomic) id <BYC_MediaPlayerDelegate> delegate;
@property (weak, nonatomic) id <WX_MediaPlayerDelegate>  media_Delegate;
/**
 *  播放器在cell上
 */
@property (assign, nonatomic) BOOL isAboveCell;

@property (nonatomic, assign)NSInteger  index_cell;

/**
 *  初始化播放控制器
 *
 *  @param assetURLString 传入一个人视频地址字符串
 *  @param titleString    传入一个标题
 *  @return 播放控制器实例
 */
- (instancetype)initWithURLString:(NSString *)assetURLString TitleString:(NSString*)titleString;


/**
 *  结束所有播放
 */
- (void)stopPlayer;



@end
