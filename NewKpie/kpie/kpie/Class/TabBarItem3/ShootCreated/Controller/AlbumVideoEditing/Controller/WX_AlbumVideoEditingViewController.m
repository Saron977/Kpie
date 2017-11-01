//
//  WX_AlbumVideoEditingViewController.m
//  kpie
//
//  Created by 王傲擎 on 16/1/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_AlbumVideoEditingViewController.h"
#import "WX_ShootCViewController.h"
#import "WX_RangeSlider.h"
#import "UIColor+CustomSliderColor.h"
#import "WX_Rect.h"
#import "WX_MediaInfoModel.h"
#import "NSDate+TimeInterval.h"
#import <AVFoundation/AVFoundation.h>
#import "WX_AVplayer.h"
#import "WX_AlbumEditModel.h"
#import "ffmpegutils.h"
#import "WX_FMDBManager.h"


@interface WX_AlbumVideoEditingViewController () <UIScrollViewDelegate>

/* 视频播放画布 */
@property(nonatomic, strong) UIView                                         *backView;
@property(nonatomic, strong) NSTimer                                        *timer;             // 播放条
@property(nonatomic, strong) NSMutableArray                                 *tileArray;

/* 视频画布,可以调整剪辑大小 */
@property(nonatomic, strong) UIScrollView                                   *playerScrollView;

/* 下方滑块添加在此视图上 */
@property(nonatomic, strong) UIScrollView                                   *scrollView;
@property(nonatomic, assign) CGFloat                                        leftValue;
@property(nonatomic, assign) CGFloat                                        rightValue;
@property(nonatomic, assign) NSInteger                                      arrayNum;           // 拖动视频

/* 存储相册视频信息 */
@property(nonatomic, strong) NSMutableArray                                 *albumMediaArray;

/* 调用ffmpeg 储存路径数组 */
@property(nonatomic, strong) NSMutableArray                                 *albumToSanboxArray;

/* 临时储存位置 */
@property(nonatomic, strong) NSString                                       *albumPath;

@property(nonatomic, strong) UISlider                                       *slider;
@property(nonatomic, strong) AVPlayer                                       *player;
@property(nonatomic, strong) AVPlayerItem                                   *item;
@property(nonatomic, strong) WX_AVplayer                                    *playView;
@property(nonatomic, assign) BOOL                                           isPlay;

@property(nonatomic, strong) WX_FMDBManager                                 *manager;

/* 是否转换完成 */
@property(nonatomic, assign) BOOL                                           isTransition;
@property(nonatomic, strong) NSFileManager                                  *fileManager;

/* 调用ffmpeg时 屏蔽界面 */
@property(nonatomic, strong) UIView                                         *coverView;

/* 视频序号 */
@property(nonatomic, assign) NSInteger                                      videoNum;

@property(nonatomic, assign) NSInteger                                      observerNum;


/* 视频标题 */
@property(nonatomic, strong) NSMutableArray                                 *mediaTitleArray;



@end

@implementation WX_AlbumVideoEditingViewController
@synthesize tileArray = _tileArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

    
    
    
    QNWSLog(@"self.assetArray == %@",self.assetArray);
    
    [self createNavigationItem];
  
    [self setUpViewComponents];
    
#if 1
    self.mediaTitleArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.assetArray.count; i++) {
        WX_MediaInfoModel *model_PhotoKit = self.assetArray[i];
//        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        Byte *buffer = (Byte *)malloc(rep.size);
//        NSInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
//        NSData *mediaData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
//        
//        NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path = [docArray objectAtIndex:0];
//        NSString *mediaPath = [path stringByAppendingPathComponent:@"Cache"];
//        self.albumPath = mediaPath;
//        
//        //        NSDate *ffmpegDate = [NSDate date];
//        //        NSDateFormatter *ffmpegDateFromatter = [[NSDateFormatter alloc]init];
//        //        [ffmpegDateFromatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
//        //        NSString *ffmpegDateStr = [ffmpegDateFromatter stringFromDate:ffmpegDate];
//        
//        self.fileManager = [NSFileManager defaultManager];
//        [self.fileManager createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
//        
//        NSArray *array = [[NSString stringWithFormat:@"%@.mp4",[asset valueForProperty:ALAssetPropertyDate]] componentsSeparatedByString:@"+"];
//        NSString *mediaTitle = [array firstObject];
//        mediaTitle = [mediaTitle stringByReplacingOccurrencesOfString:@" " withString:@"-"];
//        
//        // 存入沙盒
//        QNWSLog(@"%@",[array firstObject]);
//        NSString *outputFielPath=[mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",mediaTitle]];
//        [mediaData writeToFile:outputFielPath atomically:YES];
        
        WX_AlbumEditModel *editModel = self.albumToSanboxArray[i];
        editModel.albumWriteToSanboxPath = model_PhotoKit.mediaPath;
        editModel.videoTitle = model_PhotoKit.mediaTitle;
        
    }
#endif
    
    
    
    
    [self createAVPlayerWithNum:0];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    //监测到播放结束
    [QNWSNotificationCenter addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

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
    
    [self.item removeObserver:self forKeyPath:@"status"];
    
     self.item = nil;
    
    [QNWSNotificationCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self clearTheCacheFile];
    
    [self.fileManager removeItemAtPath:self.albumPath error:nil];
    
    [self.player pause];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.playView = nil;
        
        self.player = nil;
        
        [self.timer invalidate];
        
        self.timer = nil;
    });
    
    
}

#pragma mark ------------ UI布局
-(void)createNavigationItem
{
    if(!self.albumMediaArray){
        self.albumMediaArray = [[NSMutableArray alloc]init];
    }
    
    if (!self.albumToSanboxArray) {
        self.albumToSanboxArray = [[NSMutableArray alloc]init];
    }
    
    self.navigationItem.title = @"剪裁";
    
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
    
    // 画布
    self.playerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenWidth*3/4)];
    self.playerScrollView.backgroundColor = [UIColor clearColor];
    self.playerScrollView.delegate = self;
    self.playerScrollView.tag = 550;
    self.playerScrollView.bounces = NO;
    [self.view addSubview:self.playerScrollView];
}



#pragma mark - getter

- (NSMutableArray *)tileArray
{
    if (!_tileArray)
    {
        _tileArray = [[NSMutableArray alloc] init];
    }
    return _tileArray;
}


// 更改可拖动区域
//- (UIScrollView *)scrollView
//{
//    if (!_scrollView)
//    {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/5*2, self.view.frame.size.width, 460)];
//    }
//    return _scrollView;
//}


#pragma mark - UI

- (void)setUpViewComponents
{
    self.view.backgroundColor = KUIColorFromRGB(0xf0f0f0);
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0.021*screenHeight+self.playerScrollView.frame.size.height+self.playerScrollView.frame.origin.y +0.015*screenHeight, screenWidth, screenHeight -  0.021*screenHeight-self.playerScrollView.frame.size.height-self.playerScrollView.frame.origin.y -0.015*screenHeight)];
    self.scrollView.contentSize = CGSizeMake(screenWidth, self.assetArray.count*0.14*screenHeight);
//    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    
    for (int i = 0; i < self.assetArray.count; i++) {
        
        WX_MediaInfoModel *model_PhotoKit = self.assetArray[i];
        
        WX_MediaInfoModel *mediaModel = [[WX_MediaInfoModel alloc]init];
        mediaModel.mediaTitle = model_PhotoKit.mediaTitle;
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:model_PhotoKit.imageDataStr options:0];
        mediaModel.imageDataStr = model_PhotoKit.imageDataStr;
        mediaModel.DurationStr = model_PhotoKit.DurationStr;
        mediaModel.durationSecond = model_PhotoKit.durationSecond;
        mediaModel.createDate = model_PhotoKit.createDate;
        mediaModel.albumPath = model_PhotoKit.albumPath;
        
        [self.albumMediaArray addObject:mediaModel];
        
        
        /// 背景图_
        UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.14*screenHeight*i, screenWidth, 0.14*screenHeight)];
        customView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        customView.tag = 200 +i;
        self.scrollView.tag = 500;
        [self.scrollView addSubview:customView];
        
        /// 点击播放
//        UITapGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPlay:)];
//        [customView addGestureRecognizer:tapPlay];
//        [self.tileArray addObject:customView];
        
        /// 头像_
        UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.032*screenWidth, 0.129*customView.frame.size.height, 0.115*screenWidth, 0.115*screenWidth)];
        titleImgView.image = [UIImage imageWithData:imgData];
        titleImgView.layer.cornerRadius = titleImgView.frame.size.width/4;
        titleImgView.layer.masksToBounds = YES;
        titleImgView.userInteractionEnabled = YES;
        titleImgView.tag = 200+i;
        UITapGestureRecognizer *tapTitle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPlay:)];
        [titleImgView addGestureRecognizer:tapTitle];
        [customView addSubview:titleImgView];
        
        UIImageView *playImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        playImgView.center = CGPointMake(titleImgView.frame.size.width/2, titleImgView.frame.size.height/2);
        playImgView.image = [UIImage imageNamed:@"btn-play-h"];
        [titleImgView addSubview:playImgView];
        
        // Init slider
        WX_RangeSlider *rangeSlider = [[WX_RangeSlider alloc] initWithFrame:CGRectMake(titleImgView.frame.size.width+titleImgView.frame.origin.x + screenWidth*0.06, titleImgView.frame.origin.y, 0.69*self.view.frame.size.width, 0.06*self.view.frame.size.height)];
        rangeSlider.backgroundColor = [UIColor backgroundColor];
        [rangeSlider addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
        
        // Text label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rangeSlider.frame.origin.x +(rangeSlider.frame.size.width -100)/2, rangeSlider.frame.origin.y +rangeSlider.frame.size.height +5, 100, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.textColor = [UIColor secondaryTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@ s",mediaModel.durationSecond];
        
        //  设置滑杆最值
        rangeSlider.minimumValue = 0.0;
        rangeSlider.maximumValue = 0.9;
        
        
        //  设置滑杆起始位置
        rangeSlider.leftValue = 0.0;
        rangeSlider.rightValue = 0.9;
        
        //  设置滑杆最小差

        CGFloat minDistance = 3.00000/[mediaModel.durationSecond floatValue] - 0.1;
        if (minDistance >= 0.3) {
            rangeSlider.minimumDistance = minDistance;
        }else{
            rangeSlider.minimumDistance = 0.3;
        }

        rangeSlider.tag = 400+i;
        label.tag = 100+i;
        
        rangeSlider.enabled = NO;
        
//        [self updateRangeTextRangeSlider:rangeSlider Label:label];
        //
        [customView addSubview:label];
        [customView addSubview:rangeSlider];
        [self.scrollView addSubview:customView];
        [self.tileArray addObject:customView];
        
        WX_AlbumEditModel *editModel = [[WX_AlbumEditModel alloc]init];
        editModel.videoDuration = [mediaModel.durationSecond integerValue];
        editModel.videoEndTime = editModel.videoDuration;
        [self.albumToSanboxArray addObject:editModel];
        
    }
    
    WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:400];
    rangeSlider.enabled = YES;
    [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"icon-slider-thumb"]];
}

#pragma mark ----------- 时长显示
- (void)rangeSliderValueDidChange:(WX_RangeSlider *)slider
{
    UILabel *label = [self.view viewWithTag:slider.tag -300];
    [self updateRangeTextRangeSlider:slider Label:label];
}

- (void)updateRangeTextRangeSlider:(WX_RangeSlider *)rangeSlider Label:(UILabel *)label
{
    
    WX_MediaInfoModel *model = self.albumMediaArray[label.tag -100];
    QNWSLog(@"durationSecond == %f",[model.durationSecond floatValue]*(rangeSlider.rightValue -rangeSlider.leftValue+0.1));
    
    label.text = [NSString stringWithFormat:@"%.0f s",  (rangeSlider.rightValue -rangeSlider.leftValue+0.1)*[model.durationSecond floatValue]];

    self.slider.value = rangeSlider.leftValue*[model.durationSecond floatValue];
    
    [self change:self.slider];
    
    WX_AlbumEditModel *editModel = self.albumToSanboxArray[label.tag -100];
    editModel.videoStartTime = rangeSlider.leftValue*[model.durationSecond floatValue];
    QNWSLog(@"editModel.videoStartTime == %zi",editModel.videoStartTime);
    editModel.videoEndTime = (rangeSlider.rightValue+0.1)*[model.durationSecond floatValue];
    QNWSLog(@"editModel.videoEndTime == %zi",editModel.videoEndTime);
    
    self.leftValue = editModel.videoStartTime;
    self.rightValue = editModel.videoEndTime;

}

#pragma mark ---------- 创建播放器
-(void)createAVPlayerWithNum:(NSInteger)num
{
   
    
    /// 多个需要更改此处
    WX_MediaInfoModel *model = self.albumMediaArray[num];

    WX_MediaInfoModel *model_PhotoKit = self.assetArray[num];

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
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    NSString *mediaPath = [path stringByAppendingPathComponent:@"Cache"];
    NSString *mediaTitle = model_PhotoKit.mediaTitle;
    mediaPath = [mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",mediaTitle]];
    if (!self.item) {
        
        self.item = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:mediaPath]];
    }else{
        self.item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:mediaPath]];
    }

    
//    QNWSLog(@"self.item.presentationSize.width == %zi,self.item.presentationSize.height == %zi",self.item.presentationSize.width,self.item.presentationSize.height);
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
    
  
    if (!self.playView) {
        self.playView = [[WX_AVplayer alloc]init];
    }
    
    
    self.playView.frame = CGRectMake(0, 0, self.playerScrollView.frame.size.width, self.playerScrollView.frame.size.height);
    
    self.playView.player = self.player;
    
    [self.playerScrollView addSubview:self.playView];
    
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    if (self.slider) {
        [self.slider removeFromSuperview];
    }
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(0.032*screenWidth, 0.021*screenHeight+self.playerScrollView.frame.size.height+self.playerScrollView.frame.origin.y, screenWidth*(1-0.032*2),  0.015*screenHeight)];
    
    
    [self.slider setMaximumTrackTintColor:KUIColorFromRGB(0xececec)];
    [self.slider setMinimumTrackTintColor:KUIColorBaseGreenNormal];
    
    self.slider.maximumValue = [model.durationSecond floatValue];
    
    [self.view addSubview:self.slider];
    
    //起定时器来修改播放进度
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moviePlay) userInfo:nil repeats:YES];
    
    //拉动slider改变进度
    [self.slider addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    
    
    UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.playerScrollView.frame.size.width, self.playerScrollView.frame.size.height)];
    tapView.backgroundColor = [UIColor clearColor];
    tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paseVideo)];
    tapView.tag = 200;
    [tapView addGestureRecognizer:tap];
    [self.playerScrollView addSubview:tapView];
    
    if (self.player) {
        [self.player play];
    }
    
    for (int i = 0; i <self.albumToSanboxArray.count; i++) {
        WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:i+400];
        [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"img-dpan-n"]];
        rangeSlider.enabled = NO;
    }
    
    WX_RangeSlider *rangeSlider = (WX_RangeSlider *)[self.view viewWithTag:self.videoNum +400];
    QNWSLog(@"rangSlider == %@",rangeSlider);
    [rangeSlider changeSliderRangeImage:[UIImage imageNamed:@"icon-slider-thumb"]];
    rangeSlider.enabled = YES;
}


#pragma mark ---------- 点击手势 播放
-(void)tapToPlay:(UITapGestureRecognizer *)tap
{
    
    /// 结束原来播放
    CMTime time = self.item.currentTime;
    time.value = 0;

    self.videoNum = tap.view.tag -200;
    
//    time.value = editModel.videoStartTime;

    WX_AlbumEditModel *editModel = self.albumToSanboxArray[self.videoNum];
    
    QNWSLog(@"点击跳转到 %zi 秒",editModel.videoStartTime);
    
    /// 开启新的播放
    [self createAVPlayerWithNum:tap.view.tag-200];
    
    [self playVideoWithNum:self.videoNum];
    

    
//    [self.player seekToTime:CMTimeMake(editModel.videoStartTime, 1)];
    
//    [self.player seekToTime:time];
    
    QNWSLog(@"self.videoNum == %zi , tap.view.tag == %zi",self.videoNum,tap.view.tag);
    
    

}


#pragma mark ------------ 播放状态
- (void)playVideoWithNum:(NSInteger )num
{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        self.isPlay = YES;
        long long timeLength = self.item.duration.value/self.item.duration.timescale;
        
        QNWSLog(@"item.presentationSize.height == %f",self.item.presentationSize.height);
        QNWSLog(@"item.presentationSize.width == %f",self.item.presentationSize.width);

        WX_AlbumEditModel *editModel = self.albumToSanboxArray[num];
        
        /// 高度小于宽度 _____ 剪辑 宽度
        if (self.item.presentationSize.width > self.item.presentationSize.height) {
            self.playView.kwidth = self.item.presentationSize.width /self.item.presentationSize.height *self.playView.kheight;
            self.playView.kheight = screenWidth*3/4;
            self.playerScrollView.contentSize = CGSizeMake(self.playView.kwidth, 0);
            editModel.videoOfSetY= 0;
            editModel.videoDirectionX = 1;
            
        }
        /// 高度大于宽度 _____ 剪辑 高度
        else if (self.item.presentationSize.height > self.item.presentationSize.width) {
            self.playView.kwidth = screenWidth;
            self.playView.kheight = self.item.presentationSize.height /self.item.presentationSize.width *self.playView.kwidth;
            self.playerScrollView.contentSize = CGSizeMake(0, self.playView.kheight);
            editModel.videoOfSetX = 0;
            editModel.videoDirectionY = 1;
        }
        // 高度等于宽度 ______ 剪辑 高度
        else if (self.item.presentationSize.height == self.item.presentationSize.width){
            self.playView.kheight = self.item.presentationSize.height /self.item.presentationSize.width *self.playView.kwidth;
            self.playView.kwidth = screenWidth;
            self.playerScrollView.contentSize = CGSizeMake(0, self.playView.kheight);
            editModel.videoOfSetX = 0;
            editModel.videoDirectionY = 1;
        }
        
        if (editModel.videoStartTime != 0 && [NSString stringWithFormat:@"%zi",editModel.videoStartTime]) {
            /// 如果起始时间不为零, 且不为空,说明有设置 不做更改
            //        [self.player seekToTime:CMTimeMake(editModel.videoStartTime, 1)];
            [self.player seekToTime:CMTimeMake(editModel.videoStartTime, 1) toleranceBefore:CMTimeMake(1, 30) toleranceAfter:CMTimeMake(1, 30)];
            
        }else{
            /// 否则,则为第一次进入, 即初始时间为nil
            editModel.videoStartTime = 0;
        }
        
        QNWSLog(@"自动播放跳转到 %zi 秒",editModel.videoStartTime);
        
        if (editModel.videoEndTime != 0 && [NSString stringWithFormat:@"%zi",editModel.videoEndTime]) {
            /// 如果结束时间不为零, 且不为空,说明有设置 不做更改
        }else{
            /// 否则,则为第一次进入, 即结束时间为nil
            editModel.videoEndTime = (int)timeLength;
        }
        //设置slider最大值
        self.slider.maximumValue = timeLength;
        //
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

#pragma mark ------------ slider && video   播放联动
- (void)moviePlay
{
    //获取到当前时间
    long long timeValue = self.item.currentTime.value/self.item.currentTime.timescale;
    
    //设置当前播放时间
    self.slider.value = timeValue;
    
    if (self.videoNum < self.albumToSanboxArray.count) {
        
        /// 设置右边栏剪裁时长
        WX_AlbumEditModel *editModel = self.albumToSanboxArray[self.videoNum];
        if (editModel.videoEndTime != 0.000 && editModel.videoDuration != editModel.videoEndTime) {
            if (timeValue == editModel.videoEndTime) {
                [self playToEnd];
            }
        }
    }
}

- (void)change:(UISlider *)slider
{
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

- (void)playToEnd
{
    QNWSLog(@"播放结束");
    

    self.videoNum++;
    
    if ( self.albumMediaArray.count >self.videoNum) {
        /// 继续播放
        [self createAVPlayerWithNum:self.videoNum];
        
        [self playVideoWithNum:self.videoNum];
        
    }else{
        /// 播放完左右一个视频 暂停
        //归零
        CMTime time = self.item.currentTime;
        time.value = 0;
        
        [self.player seekToTime:time];
        [self.player pause];
        self.isPlay = !self.isPlay;
    }
}


#pragma mark ---------- 返回按钮
-(void)dismiss
{
    //    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc]init];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------- 下一步按钮
-(void)clickTheRigthButton
{

    
    [self moveVideoFromAlbumToSanbox];
    
    [self useFFMpegExchangeVideo];
}

#pragma mark ------------ 把剪辑好的视频 导入沙盒
-(void)moveVideoFromAlbumToSanbox
{
     [self.player pause];
    
#if 0
    self.mediaTitleArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.assetArray.count; i++) {
        ALAsset *asset = self.assetArray[i];
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte *)malloc(rep.size);
        NSInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *mediaData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        
        NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [docArray objectAtIndex:0];
        NSString *mediaPath = [path stringByAppendingPathComponent:@"Cache"];
        self.albumPath = mediaPath;
        
        NSDate *ffmpegDate = [NSDate date];
        NSDateFormatter *ffmpegDateFromatter = [[NSDateFormatter alloc]init];
        [ffmpegDateFromatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
        NSString *ffmpegDateStr = [ffmpegDateFromatter stringFromDate:ffmpegDate];
        
        self.fileManager = [NSFileManager defaultManager];
        [self.fileManager createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        // 存入沙盒
        NSString *outputFielPath=[mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",ffmpegDateStr,i]];
        [mediaData writeToFile:outputFielPath atomically:YES];
        
        WX_AlbumEditModel *editModel = self.albumToSanboxArray[i];
        editModel.albumWriteToSanboxPath = outputFielPath;
    }
#endif
    
}


-(void)useFFMpegExchangeVideo
{
    self.isTransition = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [WX_ProgressHUD show:@"正在转码"];
        [self stateEnableOrUnableWithYesOrNo:YES];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < self.albumToSanboxArray.count; i++) {
            WX_AlbumEditModel *editModel = self.albumToSanboxArray[i];
            // 调用FFmpeg
            NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *ffPath = [docArray objectAtIndex:0];
            NSString *ffmpegPath = [ffPath stringByAppendingPathComponent:@"Media"];
             self.fileManager = [NSFileManager defaultManager];
            [self.fileManager createDirectoryAtPath:ffmpegPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            NSDate *ffmpegDate = [NSDate date];
            NSDateFormatter *ffmpegDateFromatter = [[NSDateFormatter alloc]init];
            [ffmpegDateFromatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
            NSString *ffmpegDateStr = [ffmpegDateFromatter stringFromDate:ffmpegDate];
            NSInteger second_Last = [[ffmpegDateStr substringFromIndex:17] integerValue];
            if (second_Last > 5) {
                ffmpegDateStr = [ffmpegDateStr substringToIndex:18];
                ffmpegDateStr = [NSString stringWithFormat:@"%@%zi",ffmpegDateStr,i+5];
            }else{
                ffmpegDateStr = [ffmpegDateStr substringToIndex:18];
                ffmpegDateStr = [NSString stringWithFormat:@"%@%zi",ffmpegDateStr,i];
            }
            NSString *outPath = [ffmpegPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",ffmpegDateStr]];
            QNWSLog(@"outPath == %@",outPath);
            editModel.ffmpegWriteToSanboxPath = outPath;
            
            
            NSString *videoPath = [ffPath stringByAppendingPathComponent:@"Cache"];
            videoPath = [videoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",editModel.videoTitle]];
      
#if 0
            NSURL *url = [[NSURL alloc]initFileURLWithPath:editModel.albumWriteToSanboxPath];
            AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
            if (player.currentItem == nil)
                break;
#endif
#pragma mark -------- ffmepg
#if KSimulatorRun

            ffmpegutils *ffmpeg = [ffmpegutils new];
            ffmpeg.isDebug=YES;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *debugOutPath = [paths objectAtIndex:0];                       //Documents目录
            NSString *logPath = [debugOutPath stringByAppendingPathComponent:@"log.txt"];
            char *clog = (char*)alloca(1024);
            strcpy(clog, [logPath cStringUsingEncoding:NSUTF8StringEncoding]);
            ffmpeg.logPath=clog;
            
            NSMutableArray *videoSizeArray = [ffmpeg getVideoInfo:editModel.albumWriteToSanboxPath];

            editModel.videoHeight = [videoSizeArray[1] integerValue];
            
            editModel.videoWidth = [videoSizeArray[0] integerValue];
            if (editModel.videoWidth == editModel.videoHeight) {
//                continue;
            }else{
                
                editModel.videoWidth  = editModel.videoHeight*4/3;
            }
            
            if ([[videoSizeArray lastObject] integerValue] > 0) {
                /// 拍摄方向 竖  宽---->>高 高---->>宽
                NSInteger sort = editModel.videoWidth;
                editModel.videoWidth = editModel.videoHeight;
                editModel.videoHeight = sort;

            }else if ([[videoSizeArray lastObject] integerValue] == 0){
                /// 拍摄方向  横 正常 不变
//                continue;
                
            }
            
//            editModel.OutputVideoWidth = editModel.videoWidth>editModel.videoHeight ? 480 :360;
//            editModel.OutputVideoHeight = editModel.videoWidth>editModel.videoHeight ? 360 :480;
            
            QNWSLog(@"videoPath == %@",videoPath);
            QNWSLog(@"albumWriteToSanboxPath == %@",editModel.albumWriteToSanboxPath);
            QNWSLog(@"ffmpegWriteToSanboxPath == %@",editModel.ffmpegWriteToSanboxPath);
            QNWSLog(@"videoHeight == %zi",editModel.videoHeight);
            QNWSLog(@"videoWidth == %zi",editModel.videoWidth);
            QNWSLog(@"editModel.videoOfSexX == %zi",editModel.videoOfSetX);
            QNWSLog(@"editModel.videoOfSexY == %zi",editModel.videoOfSetY);
            QNWSLog(@"videoStartTime == %zi",editModel.videoStartTime);
            QNWSLog(@"videoEndTime == %zi",editModel.videoEndTime);
            QNWSLog(@"OutputVideoWidth == %zi",editModel.OutputVideoWidth);
            QNWSLog(@"OutputVideoHeight == %zi",editModel.OutputVideoHeight);
            
            int result = [ffmpeg importVideo:videoPath InVideoWidth:(int)editModel.videoWidth AndHeight:(int)editModel.videoHeight AtOffsetX:(int)editModel.videoOfSetX AndOffsetY:(int)editModel.videoOfSetY OutputVideoWidth:480 AndHeigth:360 WithStart:(int)editModel.videoStartTime AndWithEnd:(int)editModel.videoEndTime AndRotate:-1 AndOutputVideoPath:editModel.ffmpegWriteToSanboxPath];
            if (!result) {
                QNWSLog(@"视频成功");
            }

            NSString *mediaTitle = ffmpegDateStr;
            NSString *createdDate = mediaTitle;
            
            WX_MediaInfoModel *mediaModel = self.albumMediaArray[i];
            if (editModel.videoEndTime == 0.00000) {
                /// 剪辑时长 就为短片时长
                NSString *timeSecond = [NSString stringWithFormat:@"%zi",[mediaModel.durationSecond integerValue] - editModel.videoStartTime];
                if (timeSecond.length == 1) {
                    mediaModel.DurationStr = [NSString stringWithFormat:@"0:0%@",timeSecond];
                }else if (timeSecond.length == 2 && [timeSecond integerValue] <= 659){
                    if ([timeSecond floatValue] < 60) {
                        mediaModel.DurationStr = [NSString stringWithFormat:@"0:%@",timeSecond];
                    }else{
                        if ([timeSecond integerValue]%60 <= 9 ) {
                            NSString *str = [NSString stringWithFormat:@"%.0zi",[timeSecond integerValue]%60];
                            mediaModel.DurationStr = [NSString stringWithFormat:@"%zi:0%@",[timeSecond integerValue]/60,str];
                        }else if ([timeSecond integerValue]%60 >= 10){
                            mediaModel.DurationStr = [NSString stringWithFormat:@"%zi:%zi",[timeSecond integerValue]/60,[timeSecond integerValue]%60];
                        }
                        
                    }
                    
                }
                
            }else if (editModel.videoEndTime != 0.00000){
                /// 拖动右边栏,长度变更
                NSString *endTimeStr = [NSString stringWithFormat:@"%zi",editModel.videoEndTime - editModel.videoStartTime];
                
                if (endTimeStr.length == 1) {
                    mediaModel.DurationStr = [NSString stringWithFormat:@"0:0%@",endTimeStr];
                }else if (endTimeStr.length == 2 && [endTimeStr integerValue] <= 659){
                    if ([endTimeStr floatValue] < 60) {
                        mediaModel.DurationStr = [NSString stringWithFormat:@"0:%@",endTimeStr];
                    }else{
                        if ([endTimeStr integerValue]%60 <= 9 ) {
                            NSString *str = [NSString stringWithFormat:@"%.0ld",[endTimeStr integerValue]%60];
                            mediaModel.DurationStr = [NSString stringWithFormat:@"%zi:0%@",[endTimeStr integerValue]/60,str];
                        }else if ([endTimeStr integerValue]%60 >= 10){
                             mediaModel.DurationStr = [NSString stringWithFormat:@"%zi:%zi",[endTimeStr integerValue]/60,[endTimeStr integerValue]%60];
                        }
                       
                    }
                
                }
            }
            QNWSLog(@"DurationStr == %@",mediaModel.DurationStr);
            self.manager = [WX_FMDBManager sharedWX_FMDBManager];
            if (![self.manager.dataBase executeUpdate:@"insert into KPieMedia(title,duration,createdDate,imageData,mediaPath,albumPath) values(?,?,?,?,?,?)",mediaTitle,mediaModel.DurationStr,createdDate,mediaModel.imageDataStr,editModel.ffmpegWriteToSanboxPath,mediaModel.albumPath]) {
                QNWSLog(@"视频拍摄数据库信息----- 插入失败");
            }
            
            [self.mediaTitleArray addObject:mediaTitle];
#endif
        }
        
        self.isTransition = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            //通知主线程刷新
            [self addObserver:self forKeyPath:@"isTransition" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
            
        });
        
    });

   
    

}

#pragma mark ------------- KVO
/// KVO
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([keyPath isEqualToString:@"isTransition"]) {
        if (self.isTransition) {
            
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            QNWSLog(@"转换完啦");
            
            [WX_ProgressHUD dismiss];
            
            [self stateEnableOrUnableWithYesOrNo:NO];
            
/// 发送通知
            
            [QNWSNotificationCenter postNotificationName:@"saveThemeModel" object:self.mediaTitleArray ];
            
            for (UIViewController *controllers in self.navigationController.viewControllers) {
                if ([[controllers class] isSubclassOfClass:[WX_ShootCViewController class]]) {
                    [self.navigationController popToViewController:controllers animated:YES];
                    break;
                }
            }
            
        }
        
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self playVideoWithNum:self.videoNum];
            self.leftValue = 0.00000;
            self.rightValue = 0.00000;
        }
    }

}

#pragma mark ----------- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 550) {
        QNWSLog(@"滑动时,视频编号为 %zi",self.videoNum);
        QNWSLog(@"scrollView.contentOffset.x == %f,scrollView.contentOffset.y == %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
        

        /**
         ****** 播放完最后一个时,视频停止播放, 这是 self.videoNum 的值 等于 数组个数,需要减一 ******
         */

        if (self.videoNum == self.albumToSanboxArray.count) {
            self.videoNum = self.albumToSanboxArray.count -1;
        }
        if (self.videoNum < self.albumToSanboxArray.count) {
            
            WX_AlbumEditModel *editModel = self.albumToSanboxArray[self.videoNum];
            
            // 0 _ 剪辑宽度  1 _ 剪辑高度
            if (editModel.videoDirectionX) {
                
                CGFloat float_Multi_X = scrollView.contentOffset.x/self.playView.kwidth;
                
                editModel.videoOfSetX = self.item.presentationSize.width*float_Multi_X;


            }else if(editModel.videoDirectionY) {
                CGFloat float_Multi_Y = scrollView.contentOffset.y/self.playView.kheight;

                editModel.videoOfSetY = self.item.presentationSize.height*float_Multi_Y;
            }
            
            QNWSLog(@"editModel.videoOfSetX == %zi,videoOfSetY == %zi",editModel.videoOfSetX,editModel.videoOfSetY);
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

-(void)clearTheCacheFile
{
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:@"Cache"];
    self.fileManager = [NSFileManager defaultManager];
    [self.fileManager removeItemAtPath:cachePath error:nil];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil) {
        self.view = nil;
        [self.player pause];
        self.item = nil;
        self.player = nil;
    }
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
