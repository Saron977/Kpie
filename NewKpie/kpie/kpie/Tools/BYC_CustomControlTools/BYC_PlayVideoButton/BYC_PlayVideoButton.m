//
//  BYC_PlayVideoButton.m
//  kpie
//
//  Created by 元朝 on 16/1/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_PlayVideoButton.h"
#import <AVFoundation/AVFoundation.h>
#import "EMCDDeviceManager.h"
#import "NSString+BYC_MD5.h"
#import "EMAudioPlayerUtil.h"

#define VideoCommentID @"CurrentVideoCommentID"//当前播放是那个评论ID所属的cell
#define VideoUrlString @"CurrentVideoUrlString"//当前播放是那个评论ID所属的cell的音频链接
@interface BYC_PlayVideoButton()<AVAudioPlayerDelegate> {

    CGRect               _frame;
    NSString             *_filePath;//文件路径
    NSFileManager        *_fileManager;
    EMCDDeviceManager    *EMCDDeviceMananger;
}

@property (strong, nonatomic) UIButton      *playBtton;
@property (strong, nonatomic) UILabel       *playTime;
@property (nonatomic, strong) UIImageView   *imagePlay;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation BYC_PlayVideoButton



- (instancetype)initVideoTime:(NSTimeInterval)time videoUrl:(NSString *)urlString videoCommentID:(NSString *)videoCommentID frame:(CGRect)frame{
  
    if (frame.size.height == 0 && frame.size.width == 0) {
        frame = CGRectMake(0, 0, 45, 45);//给个默认值
    }
    
    //关闭所有音频播放动画通知
    [QNWSNotificationCenter addObserver:self selector:@selector(videoPlayerAction:) name:KNotification_LeftMassegeVCVideoPlayer object:nil];
    self = [super initWithFrame:frame];
    if (self) {
        
        _videoTime      = time;
        _videoUrlString = urlString;
        _videoCommentID = videoCommentID;
        _frame          = frame;
        [self initViews];
    }
    return self;
}

-(void)setVideoTime:(NSTimeInterval)videoTime {

    _videoTime = videoTime;
    _playTime.text = [NSString stringWithFormat:@"%.1fs",_videoTime];

}

-(void)setVideoUrlString:(NSString *)videoUrlString {

    _videoUrlString = videoUrlString;
    

}

-(void)setVideoCommentID:(NSString *)videoCommentID {

    _videoCommentID = videoCommentID;

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)initViews {

    _playBtton          = [UIButton buttonWithType:UIButtonTypeCustom];
    _imagePlay          = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-shape3"]];
    [_playBtton addSubview:_imagePlay];
    _playBtton.frame    = CGRectMake(0, 0, 45, 25);
    [_playBtton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _imagePlay.korigin  = CGPointMake(10, (_playBtton.kheight - _imagePlay.kheight) / 2.0);
    [self addSubview:_playBtton];

    _playTime           = [[UILabel alloc] init];
    _playTime.font      = [UIFont systemFontOfSize:12];
    _playTime.textColor = KUIColorFromRGB(0x9BA0AA);
    _playTime.text      = [NSString stringWithFormat:@"%.1fs",_videoTime];
    [_playTime sizeToFit];
    _playTime.center    = self.center;
    _playTime.left      = _playBtton.right + 5;
    [self addSubview:_playTime];
}

- (void)buttonAction:(UIButton *)button {

    if([EMAudioPlayerUtil isPlaying]){

        [QNWSNotificationCenter postNotificationName:KNotification_LeftMassegeVCVideoPlayer object:nil];
        if ([[[[EMAudioPlayerUtil playingFilePath] lastPathComponent] stringByDeletingPathExtension] isEqualToString:[_videoUrlString getStringMD5]] && [QNWSUserDefaultsObjectForKey(VideoCommentID) isEqualToString: _videoCommentID]) {
            
            [EMAudioPlayerUtil stopCurrentPlaying];
            QNWSUserDefaultsSetObjectForKey(nil, VideoUrlString);
            QNWSUserDefaultsSetObjectForKey(nil, VideoCommentID);
            [QNWSUserDefaults synchronize];
            return;
        }
        
        [EMAudioPlayerUtil stopCurrentPlaying];
    }
    QNWSLog(@"播放");
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path    = [docArray objectAtIndex:0];
    _filePath         = [path stringByAppendingPathComponent:@"Voice"];
    _fileManager      = [NSFileManager defaultManager];
    [_fileManager createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil];
    _filePath         = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",[_videoUrlString getStringMD5]]];

    
    NSData   *data;
    NSError  *error = nil;
    if ([_fileManager fileExistsAtPath:_filePath]) {
        
        data = [_fileManager contentsAtPath:_filePath];
    }else {
    
        NSURL    *url         = [NSURL URLWithString:_videoUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        data                  = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        [data writeToFile:_filePath atomically:YES];
    }
    
    /* 下载的数据 */
    if (data != nil){
        
        [self startAnimationPlayer];
        QNWSUserDefaultsSetObjectForKey(_videoUrlString, VideoUrlString);
        QNWSUserDefaultsSetObjectForKey(_videoCommentID, VideoCommentID);
        [QNWSUserDefaults synchronize];
        [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:_filePath completion:^(NSError *error) {
            if (!error) {//播放完成

                QNWSUserDefaultsSetObjectForKey(nil, VideoUrlString);
                QNWSUserDefaultsSetObjectForKey(nil, VideoCommentID);
                [QNWSUserDefaults synchronize];
                [QNWSNotificationCenter postNotificationName:KNotification_LeftMassegeVCVideoPlayer object:nil];
            }else{
                [self showAndHideHUDWithTitle:@"文件损毁" WithState:BYC_MBProgressHUDHideProgress];
                [QNWSNotificationCenter postNotificationName:KNotification_LeftMassegeVCVideoPlayer object:nil];
            }
        }];
    } else {
        [self showAndHideHUDWithTitle:@"语音下载失败" WithState:BYC_MBProgressHUDHideProgress];
       [QNWSNotificationCenter postNotificationName:KNotification_LeftMassegeVCVideoPlayer object:nil];
    }
}

- (void)startAnimationPlayer {
    
    _imagePlay.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"img-shape1"],
                                             [UIImage imageNamed:@"img-shape2"],
                                             [UIImage imageNamed:@"img-shape3"], nil];
    
    _imagePlay.animationDuration = 1.0;
    _imagePlay.animationRepeatCount = 0;
    [_imagePlay startAnimating];
}

- (void)stopAnimationPlayer {

    [_imagePlay stopAnimating];
}


-(void)videoPlayerAction:(NSNotification *)notification {
    
    
    [self stopAnimationPlayer];
}


-(void)layoutSubviews{
    
    [super layoutSubviews];

    if (_videoTime <= 3)_playBtton.kwidth = 45;
    else if (_videoTime >= 15) _playBtton.kwidth = 105;
    else _playBtton.kwidth = _videoTime * 5 + 30;
    [_playTime sizeToFit];
    _playTime.left = _playBtton.right + 5;
    self.kwidth    = _playTime.right + 5;
    
    _playBtton.backgroundColor = [UIColor whiteColor];
    _playTime.backgroundColor  = [UIColor clearColor];
    self.backgroundColor       = [UIColor clearColor];
    
    if([EMAudioPlayerUtil isPlaying]){
        
        if ([[[[EMAudioPlayerUtil playingFilePath] lastPathComponent] stringByDeletingPathExtension] isEqualToString:[_videoUrlString getStringMD5]] && [QNWSUserDefaultsObjectForKey(VideoCommentID) isEqualToString: _videoCommentID])
            [self startAnimationPlayer];
        else [self stopAnimationPlayer];
    }
}

-(void)drawRect:(CGRect)rect {

    [super drawRect:rect];
    
    _playBtton.layer.cornerRadius = 5;
    _playBtton.layer.masksToBounds = YES;
}

-(void)dealloc {

    QNWSLog(@"释放掉语音播放");
    [EMAudioPlayerUtil stopCurrentPlaying];
}

@end
