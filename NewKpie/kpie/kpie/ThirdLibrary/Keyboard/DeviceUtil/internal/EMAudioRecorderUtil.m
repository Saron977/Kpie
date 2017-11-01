/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "EMAudioRecorderUtil.h"

#define MIN_DB -60.0f
#define TABLE_SIZE 300

static EMAudioRecorderUtil *audioRecorderUtil = nil;

@interface EMAudioRecorderUtil () <AVAudioRecorderDelegate> {
    NSDate *_startDate;
    NSDate *_endDate;
    float _scaleFactor;
    NSMutableArray *_meterTable;
    void (^recordFinish)(NSString *recordPath);
}
@property (strong, nonatomic) CADisplayLink *levelTimer;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSDictionary *recordSetting;

@end

@implementation EMAudioRecorderUtil

#pragma mark - Public
// 当前是否正在录音
+(BOOL)isRecording{
    return [[EMAudioRecorderUtil sharedInstance] isRecording];
}

// 开始录音
+ (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                                completion:(void(^)(NSError *error))completion{
    [[EMAudioRecorderUtil sharedInstance] asyncStartRecordingWithPreparePath:aFilePath
                                                                  completion:completion];
}

// 停止录音
+(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion{
    [[EMAudioRecorderUtil sharedInstance] asyncStopRecordingWithCompletion:completion];
}

// 取消录音
+(void)cancelCurrentRecording{
    [[EMAudioRecorderUtil sharedInstance] cancelCurrentRecording];
}

+(AVAudioRecorder *)recorder{
    return [EMAudioRecorderUtil sharedInstance].recorder;
}

#pragma mark - getter
- (NSDictionary *)recordSetting
{
    if (!_recordSetting) {
        _recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                          [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                          [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                          [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                          nil];
    }
    
    return _recordSetting;
}

#pragma mark - Private
+(EMAudioRecorderUtil *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioRecorderUtil = [[self alloc] init];
    });
    
    return audioRecorderUtil;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initLevel];
    }
    
    return self;
}

-(void)dealloc{
    if (_recorder) {
        _recorder.delegate = nil;
        [_recorder stop];
        [_recorder deleteRecording];
        _recorder = nil;
    }
    recordFinish = nil;
}

-(BOOL)isRecording{
    return !!_recorder;
}

// 开始录音，文件放到aFilePath下
- (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                                completion:(void(^)(NSError *error))completion
{
    NSError *error = nil;
    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension]
                             stringByAppendingPathExtension:@"wav"];
    NSURL *wavUrl = [[NSURL alloc] initFileURLWithPath:wavFilePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:wavUrl
                                            settings:self.recordSetting
                                               error:&error];
    if(!_recorder || error)
    {
        _recorder = nil;
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error.initRecorderFail", @"Failed to initialize AVAudioRecorder")
                                        code:0
                                    userInfo:nil];
            completion(error);
        }
        return ;
    }
    _startDate = [NSDate date];
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    
    [self startMeterTimer];
    [_recorder record];
    if (completion) {
        completion(error);
    }
}

- (void)startMeterTimer {
    [self.levelTimer invalidate];
    self.levelTimer = [CADisplayLink displayLinkWithTarget:self
                                                  selector:@selector(reloadRecord)];
    self.levelTimer.frameInterval = 5;
    [self.levelTimer addToRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSRunLoopCommonModes];
}

- (void)reloadRecord {
    
    [self.recorder updateMeters];
    float avgPower = [self.recorder averagePowerForChannel:0];
    
    if (self.delegateEMAudioRecorderUtil && [self.delegateEMAudioRecorderUtil respondsToSelector:@selector(refreshRecordData:)]) {
        
        [self.delegateEMAudioRecorderUtil refreshRecordData:[self valueForPower:avgPower]];
    }
}
- (void)stopMeterTimer {
    [self.levelTimer invalidate];
    self.levelTimer = nil;
}

- (float)valueForPower:(float)power {
    if (power < MIN_DB) {
        return 0.0f;
    } else if (power >= 0.0f) {
        return 1.0f;
    } else {
        int index = (int) (power * _scaleFactor);
        return [_meterTable[index] floatValue];
    }
}

- (void)initLevel {

        float dbResolution = MIN_DB / (TABLE_SIZE - 1);
        _meterTable = [NSMutableArray arrayWithCapacity:TABLE_SIZE];
        _scaleFactor = 1.0f / dbResolution;
        float minAmp = dbToAmp(MIN_DB);
        float ampRange = 1.0 - minAmp;
        float invAmpRange = 1.0 / ampRange;
        
        for (int i = 0; i < TABLE_SIZE; i++) {
            float decibels = i * dbResolution;
            float amp = dbToAmp(decibels);
            float adjAmp = (amp - minAmp) * invAmpRange;
            _meterTable[i] = @(adjAmp);
    }
}

float dbToAmp(float dB) {
    return powf(10.0f, 0.05f * dB);
}

// 停止录音
-(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion{
    recordFinish = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->_recorder stop];
    });
     [self stopMeterTimer];
}

// 取消录音
- (void)cancelCurrentRecording
{
    _recorder.delegate = nil;
    if (_recorder.recording) {
        [_recorder stop];
    }
    _recorder = nil;
    recordFinish = nil;
}


#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag
{
    NSString *recordPath = [[_recorder url] path];
    if (recordFinish) {
        if (!flag) {
            recordPath = nil;
        }
        recordFinish(recordPath);
    }
    _recorder = nil;
    recordFinish = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
                                   error:(NSError *)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur");
}
@end
