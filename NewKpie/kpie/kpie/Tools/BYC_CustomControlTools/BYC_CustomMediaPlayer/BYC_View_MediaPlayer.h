//
//  BYC_View_MediaPlayer.h
//  kpie
//
//  Created by 元朝 on 16/3/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MediaPlayerDelegate.h"
#import <UIKit/UIKit.h>
@class AVPlayer;
@class AVPlayerItem;

@interface BYC_View_MediaPlayer : UIView
QNWSSingleton_interface(BYC_View_MediaPlayer)
/**实现BYC_MediaPlayerTransport相关协议的对象*/
@property (weak, nonatomic) id <BYC_MediaPlayerTransport> mediaPlayerTransport;

/**
 *  初始化播放器界面
 *
 *  @param player 传入一个播放器实例
 *
 *  @return 返回播放器界面实例
 */
- (instancetype)initWithPlayer:(AVPlayer *)player TitleString:(NSString *)titleString;

@end
