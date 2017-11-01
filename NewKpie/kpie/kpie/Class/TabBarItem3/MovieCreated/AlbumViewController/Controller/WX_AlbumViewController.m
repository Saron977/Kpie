//
//  WX_AlbumViewController.m
//  kpie
//
//  Created by 王傲擎 on 16/3/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_AlbumViewController.h"
#import "UIColor+CustomSliderColor.h"
#import "WX_MusicEditingViewController.h"
#import "WX_RangeSlider.h"
#import "WX_MusicModel.h"
#import "WX_AVplayer.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WX_AlbumViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSFileManager     *fileManager;           /**<  文件管理 */
@property (nonatomic, strong) NSString          *albumPath;             /**<  到Cache文件夹为止的路径 */
@property (nonatomic, strong) NSTimer           *timer;                 /**<  播放条 */
@property (nonatomic, strong) NSMutableArray    *albumArray;            /**<  存储 WX_AlbumModel 模型数组 */
@property (nonatomic, strong) UIView            *addMusicView;          /**<  添加音乐底部view */
@property (nonatomic, assign) BOOL              isPlay;                 /**<  判断是否在播放  */
@property (nonatomic, strong) UISlider          *slider;                /**<  视频进度条 */
@property (nonatomic, strong) UIView            *playerBackView;        /**<  添加音乐背景图层  */
@property (nonatomic, strong) WX_AVplayer       *playView;              /**<  添加播放器图层  */
@property (nonatomic, strong) AVPlayer          *player;                /**<  添加播放器  */
@property (nonatomic, strong) AVPlayerItem      *item;                  /**<  添加播放器item  */
@property (nonatomic, assign) BOOL              isUseMusic;             /**<  是否添加音乐  */
@property (nonatomic, strong) WX_MusicModel     *musicModel;            /**<  音乐模型  */
@property (nonatomic, strong) AVAudioPlayer     *audioPlayer;           /**<  播放音频文件  */



@end

@implementation WX_AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavigationItem];
    
    [self createUI];
    
    [self createAVplayer];
    
    [self createRangeSlider];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    /// 判断是否有添加音乐
    if (self.musicModel) {
//        [self audioPlayerWithModel:self.musicModel];
        QNWSLog(@"musicModel.musicName == %@",self.musicModel.musicName);
    }

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
     self.timer = nil;
    [self.item removeObserver:self forKeyPath:@"status" context:nil];
    
}

#pragma mark ----- 创建
-(void)createNavigationItem
{
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"相册影集";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickTheRigthButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}



#pragma mark ------ 添加底部音乐栏
-(void)createUI
{
    self.playerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight*0.423)];
    self.playerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.playerBackView];
    
    self.addMusicView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - KHeightTabBar, screenWidth, KHeightTabBar)];
    self.addMusicView.backgroundColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    [self.view addSubview:self.addMusicView];
    
    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    musicButton.frame = CGRectMake(screenWidth/2-25, self.addMusicView.frame.size.height/2-15, 60, 30);
    [musicButton setImage:[UIImage imageNamed:@"icon-yy-n"] forState:UIControlStateNormal];
    [musicButton setImage:[UIImage imageNamed:@"icon-yy-h"] forState:UIControlStateHighlighted];
    [musicButton addTarget:self action:@selector(musicEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.addMusicView addSubview:musicButton];
    
}


-(void)createAVplayer
{

    
//    WX_MediaInfoModel *model = self.albumMediaArray[num];
//    
//    ALAsset *asset = self.assetArray[num];
    
    [self.player pause];
    
    
    
    if (self.item) {
        [self.item removeObserver:self forKeyPath:@"status"];
        //        self.item = nil;
        [self.timer invalidate];
        self.timer = nil;
        //        [self.item removeObserver:self forKeyPath:@"status"];
        
    }
    if (self.player) {
        self.player = nil;
        
    }
    
    if (self.playView) {
        [self.playView removeFromSuperview];
    }
#if 1
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    NSString *mediaPath = [path stringByAppendingPathComponent:@"Media"];
    
//    NSArray *array = [[NSString stringWithFormat:@"%@.mp4",[asset valueForProperty:ALAssetPropertyDate]] componentsSeparatedByString:@"+"];
//    NSString *mediaTitle = [array firstObject];
//    mediaTitle = [mediaTitle stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    mediaPath = [mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",_albumModel.albumTitle]];
    if (!self.item) {
        
        self.item = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:mediaPath]];
    }else{
        self.item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:mediaPath]];
    }
#else
    self.item = [[AVPlayerItem alloc]initWithURL:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:@"com.apple.quicktime-movie"]];
#endif
    
    //    QNWSLog(@"self.item.presentationSize.width == %zi,self.item.presentationSize.height == %zi",self.item.presentationSize.width,self.item.presentationSize.height);
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
    
    
    if (!self.playView) {
        self.playView = [[WX_AVplayer alloc]init];
    }
    
    
    self.playView.frame = CGRectMake(0, 0, self.playerBackView.kwidth, self.playerBackView.kheight);
    
    self.playView.player = self.player;
    
    [self.playerBackView addSubview:self.playView];
    
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    if (self.slider) {
        [self.slider removeFromSuperview];
    }
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(0.032*screenWidth, 0.021*screenHeight+self.playerBackView.bottom, screenWidth*(1-0.032*2),  0.015*screenHeight)];
    
    
    [self.slider setMaximumTrackTintColor:KUIColorFromRGB(0xececec)];
    [self.slider setMinimumTrackTintColor:KUIColorBaseGreenNormal];
    
    self.slider.maximumValue = self.albumModel.videoDuration;
    
    [self.view addSubview:self.slider];
    
    //起定时器来修改播放进度
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moviePlay) userInfo:nil repeats:YES];
    
    //拉动slider改变进度
    [self.slider addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    
    
    UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.playerBackView.kwidth, self.playerBackView.kheight)];
    tapView.backgroundColor = [UIColor clearColor];
    tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paseVideo)];
    tapView.tag = 200;
    [tapView addGestureRecognizer:tap];
    [self.playerBackView addSubview:tapView];

    
    WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:400];
    [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"icon-slider-thumb"]];
    rangeSlider.enabled = YES;

    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self playVideo];
        
        }
    }
    
}

-(void)playVideo
{
    self.isPlay = YES;
    
    [self.player play];
}
-(void)moviePlay
{
    
    //获取到当前时间
    long long timeValue = self.item.currentTime.value/self.item.currentTime.timescale;
    
    //设置当前播放时间
    self.slider.value = timeValue;
    
    if (timeValue == self.albumModel.videoDuration) {
        [self playToEnd];
    }
}

#pragma mark ----------- 视频暂停
-(void)paseVideo
{
    if (self.player) {
        self.isPlay = !self.isPlay;
        if (self.isPlay) {
            [self.player play];
        }else{
            
            [self.player pause];
        }
    }
}

- (void)playToEnd
{
    QNWSLog(@"播放结束");
    
    
//    self.videoNum++;
//    
//    if ( self.albumMediaArray.count >self.videoNum) {
//        /// 继续播放
//        [self createAVPlayerWithNum:self.videoNum];
//        
//        [self playVideoWithNum:self.videoNum];
//        
//    }else{
        /// 播放完左右一个视频 暂停
        //归零
        CMTime time = self.item.currentTime;
        time.value = 0;
        
        [self.player seekToTime:time];
        [self.player pause];
        self.isPlay = !self.isPlay;
    
    [self.timer invalidate];
//    }
}

-(void)createRangeSlider
{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.021*screenHeight+self.playerBackView.kheight+self.playerBackView.korigin.y +0.015*screenHeight, screenWidth, screenHeight -  0.021*screenHeight-self.playerBackView.kheight-self.playerBackView.korigin.y -0.015*screenHeight -KHeightTabBar)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    
    /// 背景图_
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.08*screenHeight, screenWidth, 0.14*screenHeight)];
    customView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    
    /// 视频图片_
    UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.032*screenWidth, 0.129*customView.frame.size.height, 0.115*screenWidth, 0.115*screenWidth)];
    NSData *imgData = [[NSData alloc]initWithBase64EncodedString:self.albumModel.imageDataStr options:0];
    titleImgView.image = [UIImage imageWithData:imgData];
    titleImgView.backgroundColor = [UIColor purpleColor];
    titleImgView.layer.cornerRadius = titleImgView.frame.size.width/4;
    titleImgView.layer.masksToBounds = YES;
    titleImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapTitle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPlay:)];
    [titleImgView addGestureRecognizer:tapTitle];
    [customView addSubview:titleImgView];
    
    UIImageView *playImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    playImgView.center = CGPointMake(titleImgView.frame.size.width/2, titleImgView.frame.size.height/2);
    playImgView.image = [UIImage imageNamed:@"btn-play-h"];
    [titleImgView addSubview:playImgView];
    
    WX_RangeSlider *rangeSlider = [[WX_RangeSlider alloc] initWithFrame:CGRectMake(titleImgView.frame.size.width+titleImgView.frame.origin.x + screenWidth*0.06, titleImgView.frame.origin.y, 0.69*self.view.frame.size.width, 0.06*self.view.frame.size.height)];
    rangeSlider.backgroundColor = [UIColor backgroundColor];
    rangeSlider.tag = 400;
    [rangeSlider addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // Text label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rangeSlider.frame.origin.x +(rangeSlider.frame.size.width -100)/2, rangeSlider.frame.origin.y +rangeSlider.frame.size.height +5, 100, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.textColor = [UIColor secondaryTextColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"0.0 s";
//    label.text = [NSString stringWithFormat:@"%@ s",mediaModel.durationSecond];
    
    //  设置滑杆最值
    rangeSlider.minimumValue = 0.0;
    rangeSlider.maximumValue = 0.9;
    
    
    //  设置滑杆起始位置
    rangeSlider.leftValue = 0.0;
    rangeSlider.rightValue = 0.9;
    
    //  设置滑杆最小差
//    rangeSlider.minimumDistance = 3.00000/[mediaModel.durationSecond floatValue] - 0.1;
    rangeSlider.minimumDistance = 0.3;
    
//    rangeSlider.enabled = NO;
    
    [self updateRangeTextRangeSlider:rangeSlider Label:label];
    //
    [customView addSubview:label];
    [customView addSubview:rangeSlider];
    [backView addSubview:customView];
    
    [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"icon-slider-thumb"]];

}

- (void)rangeSliderValueDidChange:(WX_RangeSlider *)slider
{
    UILabel *label = [self.view viewWithTag:slider.tag -300];
    
    [self updateRangeTextRangeSlider:slider Label:label];
}

- (void)updateRangeTextRangeSlider:(WX_RangeSlider *)rangeSlider Label:(UILabel *)label
{
    
    
//    WX_MediaInfoModel *model = self.albumMediaArray[label.tag -100];
//    QNWSLog(@"durationSecond == %f",[model.durationSecond floatValue]*(rangeSlider.rightValue -rangeSlider.leftValue+0.1));
//    
//    label.text = [NSString stringWithFormat:@"%.0f s",  (rangeSlider.rightValue -rangeSlider.leftValue+0.1)*[model.durationSecond floatValue]];
//    
//    self.slider.value = rangeSlider.leftValue*[model.durationSecond floatValue];
    self.slider.value = rangeSlider.leftValue*10;
    
    label.text = [NSString stringWithFormat:@"%.0f s", (rangeSlider.rightValue - rangeSlider.leftValue+0.1)*10];
    
//
    [self change:self.slider];
//
//    WX_AlbumEditModel *editModel = self.albumToSanboxArray[label.tag -100];
//    editModel.videoStartTime = rangeSlider.leftValue*[model.durationSecond floatValue];
//    QNWSLog(@"editModel.videoStartTime == %zi",editModel.videoStartTime);
//    editModel.videoEndTime = (rangeSlider.rightValue+0.1)*[model.durationSecond floatValue];
//    QNWSLog(@"editModel.videoEndTime == %zi",editModel.videoEndTime);
//    
//    self.leftValue = editModel.videoStartTime;
//    self.rightValue = editModel.videoEndTime;
    
}

#pragma mark ------ 点击播放
-(void)tapToPlay:(UITapGestureRecognizer *)tap
{
    [self createAVplayer];
    
}

#pragma  mark ---- 拖动改变进度条时间
- (void)change:(UISlider *)slider
{
    if (self.item) {
        //时间的计算
        CMTime time = self.item.currentTime;
        time.value = slider.value *time.timescale;
        
        //跳转到对应的时间
        if (self.isPlay) {
            [self.player seekToTime:time toleranceBefore:CMTimeMake(1, 30) toleranceAfter:CMTimeMake(1, 30) completionHandler:^(BOOL finished) {
                if (self.isPlay) {
                    [self.player play];
                }
            }];
        }
    }
    
}

-(void)musicEditing
{
    self.isUseMusic = NO;
    WX_MusicEditingViewController *musicVC = [[WX_MusicEditingViewController alloc]init];
    musicVC.block = ^(WX_MusicModel *model){
        self.musicModel = model;
        self.isUseMusic = YES;
    };
    [self.player pause];
    [self.slider setValue:0.00000 animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.item = nil;
        
        self.playView = nil;
        
        self.player = nil;
        
//        [self.timer invalidate];
//        
//        self.timer = nil;
        QNWSLog(@"都释放完了,累死了");
    });
    [self.navigationController pushViewController:musicVC animated:YES];

}


#pragma mark ------- 退出
-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self clearTheCacheFile];

}

#pragma mark ------ 进入上传界面
-(void)clickTheRigthButton
{
    QNWSLog(@"要进入上传界面了啊,注意");
}

#pragma  amrk ---- 清除缓存文件夹 Cache目录
-(void)clearTheCacheFile
{
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:@"Cache"];
    if (self.fileManager == nil) {
        self.fileManager = [NSFileManager defaultManager];
    }
    [self.fileManager removeItemAtPath:cachePath error:nil];
}

#if 0

#pragma mark -------- 创建音频播放 测试音乐使用,可屏蔽

/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
-(AVAudioPlayer *)audioPlayerWithModel:(WX_MusicModel *)model
{
    if (!_audioPlayer) {
        
        NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *filePath = [docDir stringByAppendingPathComponent:@"Music"];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp3",model.musicName]];
        NSError *error=nil;
        //初始化播放器
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=9999;//设置为0不循环
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            QNWSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

#pragma matk ----------------- AVAudioPlayerDelegate
#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    QNWSLog(@"音乐播放完成...");
}
#endif


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
