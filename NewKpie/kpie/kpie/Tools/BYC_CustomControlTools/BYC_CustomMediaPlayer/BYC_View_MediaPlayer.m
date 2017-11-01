//
//  BYC_View_MediaPlayer.m
//  kpie
//
//  Created by 元朝 on 16/3/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_View_MediaPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "BYC_View_MediaPlayerUI.h"

@interface BYC_View_MediaPlayer()

@property (strong, nonatomic)  BYC_View_MediaPlayerUI  *view_MediaPlayerUI;

@end

@implementation BYC_View_MediaPlayer
QNWSSingleton_implementation(BYC_View_MediaPlayer)

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithPlayer:(AVPlayer *)player TitleString:(NSString *)titleString
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [(AVPlayerLayer *) [self layer] setPlayer:player];
        if (!_view_MediaPlayerUI) {
            
            _view_MediaPlayerUI = [[BYC_View_MediaPlayerUI alloc] initWithFrame:CGRectZero];
            _view_MediaPlayerUI.label_Top_Title.text = titleString;
            
            [self addSubview:_view_MediaPlayerUI];
        }
        [_view_MediaPlayerUI playerAboveCell:NO];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.view_MediaPlayerUI.frame = self.bounds;
    QNWSLog(@"_view_MediaPlayerUI====%@",NSStringFromCGRect(self.bounds));
}

- (id <BYC_MediaPlayerTransport>)mediaPlayerTransport {
    return self.view_MediaPlayerUI;
}

@end
