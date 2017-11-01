//
//  WX_VoideEditingViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_VoideEditingViewController.h"
#import "WX_UploadVideoViewController.h"
#import "WX_MusicEditingViewController.h"
#import "WX_MediaInfoModel.h"
#import "WX_AVplayer.h"
#import "WX_MusicModel.h"
#import "WX_RangeSlider.h"
#import "UIColor+CustomSliderColor.h"
#import "WX_Rect.h"
#import "WX_VideoEditedModel.h"
#import "ffmpegutils.h"
#import "WX_ProgressHUD.h"

@interface WX_VoideEditingViewController ()<AVAudioPlayerDelegate>
{
    /// 长按  视频位置交互
    BOOL                                contain;
    CGPoint                             startPoint;
    CGPoint                             originPoint;
    
    BOOL                                enUse;           /**< 第一次使用  */
}

/*  接受过来的视频数组
 使用 WX_MediaInfoModel 模型 */
@property(nonatomic, retain) NSMutableArray                                 *voideArray;

/* 滑块信息数组 */
@property(nonatomic, retain) NSMutableArray                                 *sliderItemArray;

/* 音乐模型 */
@property(nonatomic, retain) WX_MusicModel                                  *musicModel;

/* 合成后的视频模型 */
@property(nonatomic, retain) WX_MediaInfoModel                              *mediaModel;

/* 添加视频背景画布 */
@property(nonatomic, retain) UIView                                         *backView;

/* 添加音乐背景画布 */
@property(nonatomic, retain) UIView                                         *downBGView;
@property(nonatomic, retain) UISlider                                       *slider;
@property(nonatomic, retain) AVPlayer                                       *player;
@property(nonatomic, retain) AVPlayerItem                                   *item;
@property(nonatomic, retain) WX_AVplayer                                    *playView;
@property(nonatomic, assign) BOOL                                           isPlay;

/* 当前正在播放的视频模型 */
@property(nonatomic, retain) WX_MediaInfoModel                              *model;
@property(nonatomic, retain) NSTimer                                        *timer;
@property(nonatomic, retain) UIScrollView                                   *scrollSliderView;

@property(nonatomic, assign) CGFloat                                        maxValue;
@property(nonatomic, assign) CGFloat                                        leftValue;
@property(nonatomic, assign) CGFloat                                        rightValue;
@property(nonatomic, assign) NSInteger                                      lastTag;            /// 最后一个点击的视频

/*  存放需要编辑视频的编辑数据信息
 使用 WX_VideoEditedModel 模型   */
@property(nonatomic ,retain) NSMutableArray                                 *videoCountArray;
@property(nonatomic, retain) NSMutableArray                                 *sourcePathArray;   /// 视频路径
@property(nonatomic, retain) NSMutableArray                                 *startArray;
@property(nonatomic, retain) NSMutableArray                                 *endArray;
@property(nonatomic, retain) NSMutableArray                                 *exchangeArray;

@property(nonatomic, retain) NSString                                       *outPath;
@property(nonatomic, retain) NSString                                       *musicPath;
@property(nonatomic, assign) BOOL                                           enUseMusic;
@property(nonatomic, assign) BOOL                                           isTransformFinish;
@property(nonatomic, assign) CGFloat                                        float_SliderCenterY;    /**<   第一个双向滑块Y */

/*      如果设置播放endtime
 启动此定时器
 播放结束定时器      */
@property (nonatomic, strong) NSTimer                                       *endTimer;

/* 按下按钮后 遮蔽屏幕视图 */
@property(nonatomic, retain) UIView                                         *coverView;

/* 播放视频序号 */
@property(nonatomic, assign) NSInteger                                      videoNum;

/* 音频文件播放 */
@property (nonatomic,strong) AVAudioPlayer                                  *audioPlayer;

@property (nonatomic,assign) BOOL                                           isKVO;


@end

@implementation WX_VoideEditingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatUI];
    
    [self createAVPlayerWithNum:0];
    
    [self createSliderView];
    
    enUse = YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //监测到播放结束
    [QNWSNotificationCenter addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorBaseGreenNormal];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    QNWSLog(@"musicName == %@",self.musicModel.musicName);
    
    /// 判断是否有添加音乐
    if (self.musicModel) {
        [self audioPlayerWithModel:self.musicModel];
    }
    if (!self.player) {
        [self.sourcePathArray removeAllObjects];
        [self.startArray removeAllObjects];
        [self.endArray removeAllObjects];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isKVO) {
        
        [self.item removeObserver:self forKeyPath:@"status"];
    }
    
    [QNWSNotificationCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
#pragma mark ------- 销毁播放器
    [self.player pause];
    
    [self.audioPlayer pause];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.item = nil;
        
        self.playView = nil;
        
        self.player = nil;
        
        [self.timer invalidate];
        
        self.timer = nil;
        
        self.audioPlayer = nil;
        
    });
}

#pragma mark ----------- 接受视频数组
-(void)receiveTheVoide:(NSMutableArray *)voideArray
{
    if (voideArray == nil) {
        voideArray = [[NSMutableArray alloc]init];
    }
    
    self.videoCountArray = [[NSMutableArray alloc]init];
    
    self.voideArray = voideArray;
    
    /// 存储视频信息
    for (NSInteger i = 0; i < self.voideArray.count; i++) {
        WX_MediaInfoModel *model = self.voideArray[i];
        
        WX_VideoEditedModel *videoModel = [[WX_VideoEditedModel alloc]init];
        videoModel.videoCount = i;
        videoModel.videoPath = model.mediaPath;
        if (model.isVR == 2) {
            videoModel.isVR = 2;
            videoModel.videoID = model.mediaID;
            videoModel.videoTitle = model.title_Replace;
        }else{
            videoModel.videoTitle = model.mediaTitle;
        }
        
//        NSInteger videoTime = [self getVideoTimeWithDurationStr:model.DurationStr];
//        videoModel.videoDuration = [NSString stringWithFormat:@"%zi",videoTime];
        
        NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *filePath = [docDir stringByAppendingPathComponent:@"Media"];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",videoModel.videoTitle]];

//        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:filePath]];
//        videoModel.videoDuration = [NSString stringWithFormat:@"%zi",item.asset.duration.value/item.asset.duration.timescale];
        
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
        videoModel.videoDuration = [NSString stringWithFormat:@"%zi",asset.duration.value/asset.duration.timescale];
        QNWSLog(@"videoModel.videoCount == %zi,videoModel.videoDuration == %@",videoModel.videoCount,videoModel.videoDuration);
        [self.videoCountArray addObject:videoModel];
    }
}

#pragma mark ------------ 页面布局
-(void)creatUI
{
    self.sourcePathArray = [[NSMutableArray alloc]init];
    self.startArray = [[NSMutableArray alloc]init];
    self.endArray = [[NSMutableArray alloc]init];
    self.exchangeArray = [[NSMutableArray alloc]init];
    
    self.title = @"编辑";
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickTheRigthButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
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
    
    // 添加视频___画布
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight*0.423)];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
    
    
    // 底部添加音乐
    self.downBGView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight-KHeightTabBar, screenWidth, KHeightTabBar)];
    [self.downBGView.layer addSublayer:[self shadowAsInverse]];
    self.downBGView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    [self.view addSubview:self.downBGView];
    
    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    musicButton.frame = CGRectMake(screenWidth/2-25, self.downBGView.frame.size.height/2-15, 60, 30);
    [musicButton setImage:[UIImage imageNamed:@"icon-yy-n"] forState:UIControlStateNormal];
    [musicButton setImage:[UIImage imageNamed:@"icon-yy-h"] forState:UIControlStateHighlighted];
    [musicButton addTarget:self action:@selector(musicEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.downBGView addSubview:musicButton];
    
    
}

#pragma mark ---------- 设置双向滑块
-(void)createSliderView
{
    self.sliderItemArray = [[NSMutableArray alloc]init];
    if (self.voideArray.count*0.087*screenHeight > screenHeight -self.downBGView.frame.size.height - self.slider.frame.origin.y - self.slider.frame.size.height) {
        self.scrollSliderView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.slider.frame.origin.y+self.slider.frame.size.height+10, screenWidth, screenHeight -self.downBGView.frame.size.height - self.slider.frame.origin.y - self.slider.frame.size.height -10)];
    }else{
        self.scrollSliderView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.slider.frame.origin.y+self.slider.frame.size.height+10, screenWidth, self.voideArray.count*0.087*screenHeight)];
    }
    
    self.scrollSliderView.contentSize = CGSizeMake(0, self.voideArray.count*0.087*screenHeight);
    self.scrollSliderView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollSliderView];
    
    //    for (NSInteger i = self.voideArray.count -1; i >= 0; i--) {
    //        WX_MediaInfoModel *model = self.voideArray[i];
    //        QNWSLog(@"CreateSliderView_______model.DurationStr[%zi] == %@",i,model.DurationStr);
    //    }
    
    for (NSInteger i = self.voideArray.count -1; i >= 0; i--) {
        
        WX_MediaInfoModel *model = self.voideArray[i];
        QNWSLog(@"i == %zi",i);
        QNWSLog(@"model == %@",model);
        QNWSLog(@"model.DurationStr == %@",model.DurationStr);
        //        self.model.DurationStr = model.DurationStr;
        
        WX_VideoEditedModel *editModel = self.videoCountArray[i];
        
        /// 背景图_
        UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.087*screenHeight*i, screenWidth, 0.087*screenHeight)];
        customView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        customView.userInteractionEnabled = YES;
        customView.tag = 100+i;
        //        UILongPressGestureRecognizer *longPressCustom = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didDeleted:)];
        UILongPressGestureRecognizer *longPressCustom = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressed:)];
        
        [customView addGestureRecognizer:longPressCustom];
        
        
        
        /// 点击播放
        //        UITapGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPlay:)];
        //        [customView addGestureRecognizer:tapPlay];
        [self.scrollSliderView addSubview:customView];
        [self.sliderItemArray addObject:customView];
        
        /// 视频图片_
        UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.032*screenWidth, 0.129*customView.frame.size.height, 0.115*screenWidth, 0.115*screenWidth)];
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:model.imageDataStr options:0];
        titleImgView.image = [UIImage imageWithData:imgData];
        titleImgView.layer.cornerRadius = titleImgView.frame.size.width/4;
        titleImgView.layer.masksToBounds = YES;
        titleImgView.tag = 200+i;
        titleImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapTitle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPlay:)];
        [titleImgView addGestureRecognizer:tapTitle];
        [customView addSubview:titleImgView];
        
        UIImageView *playImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        playImgView.center = CGPointMake(titleImgView.frame.size.width/2, titleImgView.frame.size.height/2);
        playImgView.image = [UIImage imageNamed:@"btn-play-h"];
        [titleImgView addSubview:playImgView];
        
        /// 双向滑杆_
        WX_RangeSlider *rangeSlider = [[WX_RangeSlider alloc] initWithFrame:CGRectMake(titleImgView.frame.origin.x +titleImgView.frame.size.width +10, titleImgView.frame.origin.y, 0.696*screenWidth, titleImgView.frame.size.height)];
        rangeSlider.backgroundColor = [UIColor backgroundColor];
        [rangeSlider addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
        
        //  设置滑杆最值
        rangeSlider.minimumValue = 0.0;
        rangeSlider.maximumValue = 0.9;
        
        
        //  设置滑杆起始位置
        rangeSlider.leftValue = 0.0;
        rangeSlider.rightValue = 0.9;
        
        //  设置滑杆最小差
        //        rangeSlider.minimumDistance = 3.00000/[editModel.videoDuration integerValue] - 0.1;
        
        CGFloat minDistance = 3.00000/[editModel.videoDuration integerValue] - 0.1;
        if (minDistance >= 0.3) {
            rangeSlider.minimumDistance = minDistance;
        }else{
            rangeSlider.minimumDistance = 0.3;
        }
        
        
        rangeSlider.tag = 400+i;
        rangeSlider.enabled = NO;
        
        //        QNWSLog(@"rangSlider == %@",rangeSlider);
        
        [self updateRangeTextRangeSlider:rangeSlider Label:nil];
        //
        [customView addSubview:rangeSlider];
        
        [self.scrollSliderView addSubview:customView];
        
        /// 点击滑动
        UIImageView *longImgView = [[UIImageView alloc]initWithFrame:CGRectMake(rangeSlider.frame.origin.x +rangeSlider.frame.size.width +10, (customView.frame.size.height-0.348*titleImgView.frame.size.height)/2, 0.064*customView.frame.size.width, 0.348*titleImgView.frame.size.height)];
        longImgView.userInteractionEnabled = YES;
        longImgView.tag = i;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressed:)];
        [longImgView addGestureRecognizer:longPress];
        longImgView.image = [UIImage imageNamed:@"icon-shunxu"];
        [customView addSubview:longImgView];
        
        if (_float_SliderCenterY < 1) {
            _float_SliderCenterY = titleImgView.center.y;
        }
        
    }
    
    
    /// 第一次进入默认播放, 显示滑块颜色
    WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:400];
    [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"icon-slider-thumb"]];
    rangeSlider.enabled = YES;
    
    
}


//  获取影片时长   00:00 s  ---- 转出 0s
-(NSInteger)getVideoTimeWithDurationStr:(NSString *)durationStr
{
    NSArray *durationArray = [durationStr componentsSeparatedByString:@":"];
    CGFloat durationNum = 0;
    for (int i = 0 ; i < durationArray.count ; i++ ) {
        NSString *str = durationArray[i];
        if (i == 0 && ![str isEqualToString:@"0"]) {
            CGFloat num = [str floatValue]*60;
            durationNum = durationNum+num;
        }else if(i == 0 && [str isEqualToString:@"0"]){
            CGFloat num = [str floatValue];
            durationNum = durationNum+num;
        }else if(i > 0){
            CGFloat num = [str floatValue];
            durationNum = durationNum+num;
        }
    }
    return durationNum;
}


- (void)rangeSliderValueDidChange:(WX_RangeSlider *)slider
{
    [self updateRangeTextRangeSlider:slider Label:nil];
}

/// 显示滑条时间
- (void)updateRangeTextRangeSlider:(WX_RangeSlider *)rangeSlider Label:(UILabel *)label
{
    
    QNWSLog(@"%0.2f - %0.2f", rangeSlider.leftValue, rangeSlider.rightValue+0.1);
    
    
    
    /// 右滑块 结束时间
    
    CGFloat leftSliderNum = 0;
    CGFloat rightSliderNum = 0;
    /// 获取视频总时间
    if (self.maxValue) {

        
        if (self.maxValue > 10) {
            if (rangeSlider.leftValue >= 0.6) {
                leftSliderNum = self.maxValue -3;
            }else{
                leftSliderNum = (self.maxValue-3)/6*rangeSlider.leftValue*10;
            }
            
            /// 滑杆右边栏
            if (rangeSlider.rightValue <= 0.4 && rangeSlider.rightValue > 0) {
                rightSliderNum = 3;
            }else if(rangeSlider.rightValue > 0){
                rightSliderNum = (self.maxValue-3)/6*(rangeSlider.rightValue+0.1)*10;
            }

        }else{
            /// 滑杆左边栏
            leftSliderNum = self.maxValue * rangeSlider.leftValue;
            /// 滑杆右边栏
            rightSliderNum = self.maxValue/10 * (rangeSlider.rightValue+0.1);
        }
        
    }else{

        WX_VideoEditedModel *editModel = self.videoCountArray[rangeSlider.tag -400];
        
        CGFloat minDistance = 3.00000/[editModel.videoDuration integerValue] - 0.1;
        if (minDistance >= 0.3) {
            rangeSlider.minimumDistance = minDistance;
        }else{
            rangeSlider.minimumDistance = 0.3;
        }
        
        /**
         *   最后三秒
         */
        /// 滑杆左边栏
        
        if ([editModel.videoDuration integerValue] > 10) {
            if (rangeSlider.leftValue >= 0.6) {
                leftSliderNum = [editModel.videoDuration integerValue] -3;
            }else{
                leftSliderNum = ([editModel.videoDuration integerValue]-3)/6*rangeSlider.leftValue*10;
            }
            
            /// 滑杆右边栏
            if (rangeSlider.rightValue <= 0.4 && rangeSlider.rightValue > 0) {
                rightSliderNum = 3;
            }else if(rangeSlider.rightValue > 0){
                rightSliderNum = ([editModel.videoDuration integerValue]-3)/6*(rangeSlider.rightValue+0.1)*10;
            }
            
        }else{
            /// 滑杆左边栏
            leftSliderNum = [editModel.videoDuration integerValue] * rangeSlider.leftValue;
            /// 滑杆右边栏
            rightSliderNum = [editModel.videoDuration integerValue]/10 * (rangeSlider.rightValue+0.1);
        }

    }
    
    self.leftValue = leftSliderNum;
    self.rightValue = rightSliderNum;
    
    self.slider.value = leftSliderNum;
    [self change:self.slider];

    QNWSLog(@"调动滑块, rangeSlider.tag == %zi",rangeSlider.tag);
    WX_VideoEditedModel *videoModel = self.videoCountArray[rangeSlider.tag -400];
    videoModel.startTime = [NSNumber numberWithFloat:leftSliderNum];
    videoModel.endTime = [NSNumber numberWithFloat:rightSliderNum*10];
    
    QNWSLog(@"调动滑块, videoModel.startTime == %@",videoModel.startTime);
    QNWSLog(@"调动滑块, videoModel.endTime == %@",videoModel.endTime);
    QNWSLog(@"调动滑块, 视频总长度 == %@",videoModel.videoDuration);
    if (![self.audioPlayer play]) {
        
        [self.audioPlayer play];
    }
}

#pragma mark ---------- 点击手势 播放
-(void)tapToPlay:(UITapGestureRecognizer *)tap
{
    
    /// 结束原来播放
    CMTime time = self.item.currentTime;
    time.value = 0;
    [self.player seekToTime:time];
    /// 开启新的播放
    self.videoNum = tap.view.tag -200;
    QNWSLog(@"点击手势, tag == %zi",self.videoNum);
    
    [self createAVPlayerWithNum:self.videoNum];
    WX_VideoEditedModel *editModel = self.videoCountArray[self.videoNum];
    
    QNWSLog(@"点击手势, editModel.videoDuration == %@",editModel.videoDuration);
    QNWSLog(@"点击手势, editModel.startTime == %f",[editModel.startTime floatValue]);
    QNWSLog(@"点击手势, editModel.endTime == %f",[editModel.endTime floatValue]);
    
    //    for (int i = 0; i < self.voideArray.count-1 ;i++) {
    //        WX_MediaInfoModel *mediaModel = self.voideArray[i];
    //
    //        if ([mediaModel.mediaTitle isEqualToString:editModel.videoTitle]) {
    //            self.videoNum = i;
    //        }
    //    }
    
    //    self.model = self.voideArray[tap.view.tag-100];
    //
    
    //    for (WX_MediaInfoModel *model in self.voideArray) {
    //        QNWSLog(@"model == %@",model.DurationStr);
    //    }
    //    QNWSLog(@"DurationStr == %@",self.model.DurationStr);
    //    for (int i = 0; i < self.voideArray.count; i++) {
    //        WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:i+400];
    //        [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"img-dpan-n"]];
    //        rangeSlider.enabled = NO;
    //
    //    }
    
    
    
    //    WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:tap.view.tag +300];
    //    QNWSLog(@"rangSlider == %@",rangeSlider);
    //    [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"icon-slider-thumb"]];
    //    rangeSlider.enabled = YES;
    //    self.lastTag = tap.view.tag;
    //    NSArray *durationArray = [self.model.DurationStr componentsSeparatedByString:@":"];
    //    CGFloat durationNum = 0;
    //    for (int i = 0 ; i < durationArray.count ; i++ ) {
    //        NSString *str = durationArray[i];
    //        if (i == 0 && ![str isEqualToString:@"0"]) {
    //            CGFloat num = [str floatValue]*60;
    //            durationNum = durationNum+num;
    //        }else if(i == 0 && [str isEqualToString:@"0"]){
    //            CGFloat num = [str floatValue];
    //            durationNum = durationNum+num;
    //        }else if(i > 0){
    //            CGFloat num = [str floatValue];
    //            durationNum = durationNum+num;
    //        }
    //    }
    
    //     WX_VideoEditedModel *videoModel = self.videoCountArray[tap.view.tag -100];
    //    if (editModel.endTime == 0.00000) {
    //        editModel.endTime = [NSNumber numberWithFloat:[editModel.videoDuration floatValue]];
    //    }
    
    
#pragma mark --------------- /// 编辑界面,关闭跳转到剪辑时长的播放____需要关闭_____________以后修复
#if 0
    QNWSLog(@"手动跳转到 %f",[videoModel.startTime floatValue]);
    [self.player seekToTime:CMTimeMake([videoModel.startTime floatValue], 1)];
#endif
    
}


#pragma mark ---------- 长按手势 交换位置
- (void)LongPressed:(UILongPressGestureRecognizer *)sender
{
    // 设置共同触控, 只响应一次
    
    //    QNWSLog(@"交换位置");
    
    UIView *customView = (UIView *)sender.view;
    //    UIView *customView = [[UIView alloc]init];
    //    NSInteger num = -1;
    /// 数组交换
    
    [self pressStateChangeWithView:customView Enable:NO];
    
    enUse = NO;
    
    if (sender.view.tag < 100) {
        customView  = [self.view viewWithTag:sender.view.tag+100];
    }else{
        customView  =   [self.view viewWithTag:sender.view.tag];
    }
    
    if (sender.state == UIGestureRecognizerStateBegan){
        startPoint = [sender locationInView:sender.view];
        originPoint = customView .center;
        [UIView animateWithDuration:0.2f animations:^{
            customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            customView.alpha = 0.7;
        }];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        customView .center = CGPointMake(customView .center.x+deltaX,customView .center.y+deltaY);
        NSInteger index = [self indexOfPoint:customView .center withButton:customView];
        if (index<0){
            contain = NO;
            
        }else{
            [UIView animateWithDuration:0.2f  animations:^{
                CGPoint temp = CGPointZero;
                UIButton *button = self.sliderItemArray[index];
                temp = button.center;
                button.center = originPoint;
                customView .center = temp;
                originPoint = customView.center;
                contain = YES;
                
                UIView *view_Test = [self.view viewWithTag:101];
                NSNumber *start_Point = [NSNumber numberWithFloat:button.center.y/_float_SliderCenterY/2];
                NSNumber *end_Point = [NSNumber numberWithFloat:originPoint.y/_float_SliderCenterY/2];
                
                QNWSLog(@"view_Test.center.x == %f,view_Test.center.y == %f",view_Test.center.x,view_Test.center.y);
                QNWSLog(@"button.center == %f,temp == %f,customView.center == %f,customView.tag == %zi",button.center.y,temp.y,originPoint.y,customView.tag);
                [self.exchangeArray removeAllObjects];
                [self.exchangeArray addObject:start_Point];
                [self.exchangeArray addObject:end_Point];
                if (self.exchangeArray.count == 2) {
                    NSInteger indexFirstObj = [start_Point integerValue];
                    NSInteger indexLastObj = [end_Point integerValue];
                    QNWSLog(@"indexFirstObj == %zi,indexLastObj == %zi",indexFirstObj,indexLastObj);
                    [self.videoCountArray exchangeObjectAtIndex:indexFirstObj withObjectAtIndex:indexLastObj];
                    UIView *title1View = [self.view viewWithTag:200 +indexFirstObj];
                    UIView *title2View = [self.view viewWithTag:200 +indexLastObj];
                    title1View.tag = 200 +indexLastObj;
                    title2View.tag = 200 +indexFirstObj;
                }
            }];
        }
    }else if (sender.state == UIGestureRecognizerStateEnded){
        QNWSLog(@"手势结束");
        [UIView animateWithDuration:0.2f  animations:^{
            customView .transform = CGAffineTransformIdentity;
            customView .alpha = 1.0;
            if (!contain){
                customView .center = originPoint;
            }
            
            
        }];
        
        enUse = YES;
        [self pressStateChangeWithView:customView Enable:YES];
        
    }
}

-(NSInteger)indexOfPoint:(CGPoint)point withButton:(UIView *)view
{
    for (NSInteger i = 0;i<self.sliderItemArray.count;i++)
    {
        UIView *customView = self.sliderItemArray[i];
        if (customView != view){
            if (CGRectContainsPoint(customView.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}



/// 设置长按手势, 只允许触发一次
-(void)pressStateChangeWithView:(UIView*)customView Enable:(BOOL)enable
{
    
    if (enUse) {
        for (UIView *view in self.scrollSliderView.subviews) {
            if ([view isKindOfClass:[UIView class]]) {
                for (int i = 0;  i < self.sliderItemArray.count; i++) {
                    if (view.tag < self.sliderItemArray.count +100 && view.tag != customView.tag ) {
                        view.userInteractionEnabled = enable;
                    }
                }
            }
        }
    }
    
}

#pragma mark ----------- 点击删除
-(void)didDeleted:(UILongPressGestureRecognizer *)press
{
    QNWSLog(@"该删除了");
}

#pragma mark ------------ 创建播放器   &&  视频进度条
-(void)createAVPlayerWithNum:(NSInteger)num
{
    /// 多个需要更改此处
    //    self.model = self.voideArray[num];
    WX_VideoEditedModel *editModel = self.videoCountArray[num];
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"Media"];
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",editModel.videoTitle]];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    
    [self.player pause];
    
    
    if (self.item) {
        
        [self.item removeObserver:self forKeyPath:@"status"];
        
        self.item = nil;
        
        [self.timer invalidate];
        
        self.timer = nil;
        
        self.isKVO = NO;
    }
    
    if (self.player) {
        self.player = nil;
        //        self.playView = nil;
    }
    if (self.playView) {
        [self.playView removeFromSuperview];
    }
    
    if (!self.playView) {
        
        self.playView = [[WX_AVplayer alloc]init];
    }
    
    self.item = [[AVPlayerItem alloc]initWithURL:url];
    
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
    
    self.playView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
    
    self.playView.player = self.player;
    
    [self.backView addSubview:self.playView];
    
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.isKVO = YES;
    
    
    if (self.slider) {
        [self.slider removeFromSuperview];
    }
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(0.032*screenWidth, 0.021*screenHeight+self.backView.frame.size.height+self.backView.frame.origin.y, screenWidth*(1-0.032*2),  0.015*screenHeight)];
    
    
    [self.slider setMaximumTrackTintColor:KUIColorFromRGB(0xececec)];
    [self.slider setMinimumTrackTintColor:KUIColorBaseGreenNormal];
    
    self.slider.maximumValue = [editModel.videoDuration floatValue];
    
    [self.view addSubview:self.slider];
    
    //起定时器来修改播放进度
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moviePlay) userInfo:nil repeats:YES];
    
    // 起定时器控制播放时长,如果有设置播放视频的endTime
    //    QNWSLog(@"editModel.endTime == %zi",[editModel.endTime floatValue]);
    
    
    
    //拉动slider改变进度
    [self.slider addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    
    UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height)];
    tapView.backgroundColor = [UIColor clearColor];
    tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paseVideo)];
    [tapView addGestureRecognizer:tap];
    [self.backView addSubview:tapView];
    
    
    for (int i = 0; i < self.voideArray.count; i++) {
        WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:i+400];
        [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"img-dpan-n"]];
        rangeSlider.enabled = NO;
    }
    
    WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:editModel.videoCount +400];
    //    QNWSLog(@"rangSlider == %@",rangeSlider);
    [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"icon-slider-thumb"]];
    rangeSlider.enabled = YES;

    
}

#pragma mark ------------ 播放状态
- (void)playVideo
{
    
    [self.player play];
    
    if (![self.audioPlayer play]) {
        
        [self.audioPlayer play];
    }
    
    self.isPlay = YES;
    //获取总时间
    long long timeLength = self.item.duration.value/self.item.duration.timescale;
    
    self.maxValue = timeLength;
    
#pragma mark --------------- 自动播放已编辑视频长度
    if ([NSString stringWithFormat:@"%zi",self.videoNum] == nil ) {
        self.videoNum = 0;
    }
    WX_VideoEditedModel *videoModel = self.videoCountArray[self.videoNum];
    if (videoModel.startTime != 0 && videoModel.startTime != nil) {
        /// 如果起始时间不为零, 且不为空,说明有设置 不做更改
        QNWSLog(@"自动播放跳转到 %f 秒",[videoModel.startTime floatValue]);
        
//                [self.player seekToTime:CMTimeMake([videoModel.startTime floatValue], 1)];
        [self.player seekToTime:CMTimeMake([videoModel.startTime floatValue], 1) toleranceBefore:CMTimeMake(1, 30) toleranceAfter:CMTimeMake(1, 30)];
    }else{
        /// 否则,则为第一次进入, 即初始时间为nil
        videoModel.startTime = 0;
    }
    
    
    if (videoModel.endTime != 0 && videoModel.endTime != nil) {
        /// 如果结束时间不为零, 且不为空,说明有设置 不做更改
    }else{
        /// 否则,则为第一次进入, 即结束时间为nil
        videoModel.endTime =  [NSNumber numberWithFloat:timeLength];
    }
    //设置slider最大值
    self.slider.maximumValue = timeLength;
    
}

-(void)paseVideo
{
    if (self.player) {
        self.isPlay = !self.isPlay;
        if (self.isPlay) {
            [self.player play];
            
            if ([self.audioPlayer play]) {
                [self.audioPlayer pause];
                
                [self.audioPlayer play];
            }
        }else{
            [self.audioPlayer pause];
            
            [self.player pause];
        }
    }
    
}

#pragma mark ------------ slider && video   播放联动
- (void)moviePlay
{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        //获取到当前时间
        long long timeValue = self.item.currentTime.value/self.item.currentTime.timescale;
        
        //设置当前播放时间
        [self.slider setValue:timeValue animated:YES];
        
        /// viedoNun 小于数组
        if (self.videoNum < self.videoCountArray.count) {
            
            /// 设置右边栏剪裁时长, 编辑后,结束时间和原有时长,即影片时长不等
            WX_VideoEditedModel *editModel = self.videoCountArray[self.videoNum];
            if ([editModel.endTime floatValue] != 0.0000 && ![[NSString stringWithFormat:@"%.0f",[editModel.endTime floatValue]] isEqualToString: editModel.videoDuration]) {
                NSString *timeStr = [NSString stringWithFormat:@"%.1f",[editModel.endTime floatValue]];
                NSInteger rightValue = [timeStr integerValue];
                if (timeValue == rightValue && rightValue != 0) {
                    [self playToEnd];
                }
            }
        }
        
    }
    
}

- (void)change:(UISlider *)slider
{
    //时间的计算
    CMTime time = self.item.currentTime;
    time.value = slider.value *time.timescale;
    if (self.player.status == AVPlayerStatusReadyToPlay) {

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

- (void)playToEnd
{
    QNWSLog(@"播放结束");
    
    
#pragma mark --------------- 自动连播有问题, 暂时关闭
#if KFLOAT_LockAutoPlayVideo
    /// 关闭自动联播
    
    CMTime time = self.item.currentTime;
    time.value = 0;
    [self.player seekToTime:time];
    self.isPlay = !self.isPlay;
    [self.audioPlayer pause];
    
    
#else
    /// 开启自动连播
    self.videoNum++;
    if (self.videoNum < self.voideArray.count) {
        
        [self createAVPlayerWithNum:self.videoNum];
        
        //        [self playVideo];
        
        QNWSLog(@"自动连播视频编号 == %zi",self.videoNum);
        
    }else{
        //归零
        //        self.videoNum = 0;
        CMTime time = self.item.currentTime;
        time.value = 0;
        //        [self createAVPlayerWithNum:self.videoNum];
        [self.player seekToTime:time];
        
        [self.player pause];
        
        self.isPlay = NO;
        
        if ([self.audioPlayer play]) {
            
            [self.audioPlayer pause];
        }
    }
#endif
    
}


#pragma mark --------- 进入音乐编辑界面
// 进入音乐编辑界面
-(void)musicEditing
{
    self.enUseMusic = NO;
    WX_MusicEditingViewController *musicVC = [[WX_MusicEditingViewController alloc]init];
    musicVC.block = ^(WX_MusicModel *model){
        self.musicModel = model;
        self.enUseMusic = YES;
    };
    [self.player pause];
    [self.slider setValue:0.00000 animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.item = nil;
        
        self.playView = nil;
        
        self.player = nil;
        
        [self.timer invalidate];
        
        self.timer = nil;
        QNWSLog(@"都释放完了,累死了");
    });
    [self.navigationController pushViewController:musicVC animated:YES];
}


#pragma mark ----------- 进入上传界面 调用FFMpeg 合成视频/ 音乐
// 进入上传界面
-(void)clickTheRigthButton
{
    QNWSLog(@"下一步,进入上传界面");
    
    [self CreateArrayWithVideoInfo];
    
    [self UseFFMpegCompositeVideo];
    
}

#pragma mark ---------- 返回按钮
-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)CreateArrayWithVideoInfo
{
    /// 禁用所有按钮
    [self.player pause];
    if ([self.audioPlayer play]) {
        [self.audioPlayer pause];
    }
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSString *createDateStr = [dateFormatter stringFromDate:currentDate];
    
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ffPath = [docArray objectAtIndex:0];
    NSString *ffmpegPath = [ffPath stringByAppendingPathComponent:@"Media"];
    NSString *musicPath = [ffPath stringByAppendingPathComponent:@"Music"];
    NSFileManager *ffFilemanager = [NSFileManager defaultManager];
    [ffFilemanager createDirectoryAtPath:ffmpegPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    self.musicPath = [musicPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.musicModel.musicName]];
    self.outPath = [ffmpegPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",createDateStr]];
    
    NSInteger isVR= 0;
    NSString *videoID = @"";
    for (int i = 0; i < self.videoCountArray.count; i++) {
        WX_VideoEditedModel *editModel = self.videoCountArray[i];
        if (editModel.isVR == 2 && !isVR) {
            isVR = editModel.isVR;
            videoID = editModel.videoID;
        }
        if(!editModel.startTime){
            editModel.startTime = [NSNumber numberWithFloat:0.00000];
        }
        if (!editModel.endTime) {
            editModel.endTime = [NSNumber numberWithFloat:0.00000];
        }
        if ([editModel.startTime integerValue]!= 0.0000) {
            
        }
        
        
        
        if ([editModel.startTime floatValue] == 0.00000 && [editModel.endTime floatValue] == 0.00000) {
            CGFloat durationNum = [editModel.videoDuration floatValue];
            [self.startArray addObject:[NSNumber numberWithFloat:durationNum]];
            QNWSLog(@"[model.startTime floatValue] == %f",[editModel.startTime floatValue]);
        }else{
            [self.startArray addObject:editModel.startTime];
        }
        
        if (editModel.endTime.integerValue < 3) {
            editModel.endTime = [NSNumber numberWithInteger:0];
        }
        if ([editModel.endTime floatValue]>10 && !editModel.isEndTime) {
            editModel.endTime=[NSNumber numberWithInteger:[editModel.endTime floatValue]/10];
            editModel.isEndTime = YES;
        }
        [self.endArray addObject:editModel.endTime];
        
        QNWSLog(@"model.videoPath == %@",editModel.videoPath);
        NSString *videoPath = [ffmpegPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",editModel.videoTitle]];
        
        [self.sourcePathArray addObject:videoPath];
        
        QNWSLog(@"model.startTime == %f",[editModel.startTime floatValue]);
        QNWSLog(@"model.endTime == %f",[editModel.endTime floatValue]);
        QNWSLog(@"model.videoTitle == %@",editModel.videoTitle);
    }
    
    
    self.mediaModel = [[WX_MediaInfoModel alloc]init];
    self.mediaModel.mediaTitle = createDateStr;
    self.mediaModel.mediaPath = self.outPath;
    if (isVR) {
        self.mediaModel.isVR = isVR;
        self.mediaModel.mediaID = videoID;
    }
}

#pragma mark ---------- 调用FFMpeg 合成视频/ 音乐
-(void)UseFFMpegCompositeVideo
{
    
#pragma mark --- ffmpeg
#if KSimulatorRun
    
    [WX_ProgressHUD show:@"正在转码"];
    self.isTransformFinish = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self stateEnableOrUnableWithYesOrNo:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        ffmpegutils *ffmpeg = [ffmpegutils new];
        ffmpeg.isDebug=YES;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *outPath = [paths objectAtIndex:0];//Documents目录
        NSString *logPath = [outPath stringByAppendingPathComponent:@"log.txt"];
        
        NSString *concatFilePath = [outPath stringByAppendingString:@"/concat.txt"];
        QNWSLog(@"concatFilePath=%@", concatFilePath);
        char *clog = (char*)alloca(1024);
        strcpy(clog, [logPath cStringUsingEncoding:NSUTF8StringEncoding]);
        
        ffmpeg.logPath=clog;
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon-nan-xiao@3x" ofType:@"png"];
        NSString *musicPath = nil;
        if (self.enUseMusic) {
            musicPath = self.musicPath;
        }else{
            musicPath = nil;
        }

        int result = [ffmpeg createVideo:self.sourcePathArray WithStart:self.startArray AndEnd:self.endArray DisableSound:self.enUseMusic HasMusicPath:musicPath LogoPath:imagePath ToPath:self.outPath];
        
        /// 获取视频缩略图
        NSURL *outUrl = [NSURL fileURLWithPath:self.outPath];
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:outUrl];
        NSString *encodeImgStr = [self creatThumbWith:item.asset];
        self.mediaModel.imageDataStr = encodeImgStr;
        
        if (!result) {
            QNWSLog(@"视频编辑成功");
            self.isTransformFinish = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 通知主线程刷新
            [self addObserver:self forKeyPath:@"isTransformFinish" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        });
        
    });
    
    
    
#endif
    
    
}

#pragma mark ---------- KVO
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([keyPath isEqualToString:@"isTransformFinish"]) {
        if (self.isTransformFinish) {
            
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            
            [WX_ProgressHUD dismiss];
            
            /// 开启所有按钮
            [self stateEnableOrUnableWithYesOrNo:NO];
            
            /// 页面跳转
            WX_UploadVideoViewController *uploadVC = [[WX_UploadVideoViewController alloc]init];
            [uploadVC setMediaWithModel:self.mediaModel];
            if (self.themeModel.isAddTheme) {
                uploadVC.themeModel = self.themeModel;
            }
            [self.slider setValue:0.00000 animated:YES];
            
            if (self.scriptStrid) {
                uploadVC.scriptStrid = self.scriptStrid;
                uploadVC.scriptName = self.scriptName;
            }
            [self.navigationController pushViewController:uploadVC animated:YES];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            
            [self playVideo];
            
            self.leftValue = 0.00000;
            self.rightValue = 0.00000;
   
        }
    }
    
}

#pragma mark ----------- 改变按钮状态
-(void)stateEnableOrUnableWithYesOrNo:(BOOL)choose;
{
    if (!self.coverView) {
        self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.coverView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.coverView];
    }
    if (choose) {
        [self.view bringSubviewToFront:self.coverView];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    }else{
        [self.view sendSubviewToBack:self.coverView];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }
}

#pragma mark ------------ 获取视频截图
-(NSString *)creatThumbWith:(AVAsset *)asset
{
    // 获取截图
     UIGraphicsPopContext();
    AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
    imgGenerator.appliesPreferredTrackTransform = YES;
    imgGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    NSInteger videoTime = asset.duration.value / asset.duration.timescale;
    QNWSLog(@"视频时长 ==  %zi",videoTime);
    
    CFTimeInterval thumbnailImageTime = 2;
    NSError *thumbnailImageError = nil;
    CGImageRef thumbnailImageRef = nil;
    thumbnailImageRef = [imgGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 10) actualTime:nil error:&thumbnailImageError];
    UIImage *image = [UIImage imageWithCGImage:thumbnailImageRef];
    
    CGImageRelease(thumbnailImageRef);
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(image);
    NSString *encodeImgStr = [imgData base64EncodedStringWithOptions:0];
    
    if (!thumbnailImageRef) {
        QNWSLog(@"图片为空");
        QNWSLog(@"thumbnailImageError == %@",thumbnailImageError.localizedDescription);
    }
    return encodeImgStr;
}

#pragma mark -------- 创建音频播放

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



- (CAGradientLayer *)shadowAsInverse
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = CGRectMake(0, screenHeight-KHeightTabBar, screenWidth, KHeightTabBar); // 和分享View.frame 一致
    //添加渐变的颜色组合（颜色透明度的改变）
    NSMutableArray *colors = [NSMutableArray array];
    UIColor *color1 = KUIColorFromRGBA(0x080808, 0.8);
    UIColor *color2 = KUIColorFromRGBA(0x1E1E1E, 0.8);
    [colors addObject:(id)[color1 CGColor]];
    [colors addObject:(id)[color2 CGColor]];
    newShadow.colors = colors;
    
    return newShadow;
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
