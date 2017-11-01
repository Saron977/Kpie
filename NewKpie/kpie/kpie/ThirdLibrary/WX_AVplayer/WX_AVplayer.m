//
//  WX_AVplayer.m
//  kpie
//
//  Created by 王傲擎 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_AVplayer.h"

@implementation WX_AVplayer

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}


- (AVPlayer *)player
{

    AVPlayerLayer *layer = (AVPlayerLayer *)[self layer];
    return layer.player;
}

- (void)setPlayer:(AVPlayer *)player
{
    AVPlayerLayer *layer = (AVPlayerLayer *)[self layer];
    layer.player = player;
    layer.videoGravity = AVLayerVideoGravityResize;
}



-(void)dealloc
{
    QNWSLog(@"%@ 死了",[self class]);
}


@end
