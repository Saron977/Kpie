//
//  WX_UploadProgress.m
//  kpie
//
//  Created by 王傲擎 on 16/9/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_UploadProgress.h"

static WX_UploadProgress    *progressView;

@interface WX_UploadProgress()
<ASProgressPopUpViewDataSource>

@property (nonatomic, strong) ASProgressPopUpView       *progress_Upload;   /**<   进读条 */
@property (nonatomic, assign) NSInteger                 schedules;          /**<   任务数量 */
@property (nonatomic, assign) BOOL                      isNeedShow;         /**<   判断是否需要进度条 */
@property (nonatomic, assign) NSInteger                 completeUploadNum;  /**<   上传完成数量 */
@end

@implementation WX_UploadProgress

+(void)createProgressWithType:(ProgressType)type View:(UIView *)view Frame:(CGRect)frame Schedules:(int)schedules
{
    if (!progressView) {
        
        progressView = [[WX_UploadProgress alloc]init];
    }
    progressView.isNeedShow = YES;
    progressView.completeUploadNum = 0;
    [progressView progressWithType:type View:view Frame:frame Schedules:schedules];
}


-(void)progressWithType:(ProgressType)type View:(UIView *)view Frame:(CGRect)frame Schedules:(int)schedules
{
    /**
     *  设置任务数量
     */

    progressView.schedules = schedules;
    
    switch (type) {
            /**
             *  给出视图,则添加到视图上
             */
            
        case ENUM_ProgressAddWithView:
        {
            [view addSubview:progressView];

            [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(frame.origin.x);
                make.top.mas_equalTo(frame.origin.y);
                make.height.mas_equalTo(frame.size.height);
                make.width.mas_equalTo(frame.size.width);
            }];
        }
            break;
            
            
            /**
             *  按照给的frame 添加到 window 上
             */
        case ENUM_ProgressAddWithWindows:
        {
            [[UIApplication sharedApplication].keyWindow addSubview:progressView];
            
            [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(frame.origin.x);
                make.top.mas_equalTo(frame.origin.y);
                make.height.mas_equalTo(frame.size.height);
                make.width.mas_equalTo(frame.size.width);
            }];

        }
            break;
            
        default:
            break;
    }
    
    /**
     设置进度条
     */
    _progress_Upload = [[ASProgressPopUpView alloc]init];
    _progress_Upload.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
    _progress_Upload.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    [_progress_Upload showPopUpViewAnimated:YES];
    _progress_Upload.dataSource = self;

    [progressView addSubview:_progress_Upload];
    
    [_progress_Upload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(progressView);
    }];
}



+(void)setProgressVale:(CGFloat)progressVale
{
    if (progressView && progressView.isNeedShow) {
//        CGFloat completedVale = progressView.completeUploadNum*1/progressView.schedules;
//        CGFloat vale = progressVale/progressView.schedules+completedVale;
        CGFloat vale = progressVale;
        [progressView.progress_Upload setProgress:vale animated:YES];
//        QNWSLog(@"总共%zi, 已完成%zi, 可以累加的 %f, 完成%f",progressView.schedules,progressView.completeUploadNum,completedVale,vale);
        if (progressVale == 1.00) {
            progressView.completeUploadNum ++;
        }
        if (progressView.isNeedShow == progressView.completeUploadNum) {
            progressView.isNeedShow = NO;
        }
    }
}

+(void)createUploadProgress
{
    if (!progressView) {
        progressView = [[WX_UploadProgress alloc]init];
    }
    progressView.isNeedShow = YES;

}

+(void)removeProgress
{
    [progressView removeProgressFromSuperview];
}

-(void)removeProgressFromSuperview
{
    [progressView removeFromSuperview];
    progressView = nil;
}
/// 进度条
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *str = nil;
//    if (progress < 0.2) {
//        str = @"开始上传";
//    } else if (progress >= 1.0) {
//        str = @"上传完成";
//    }
    if (progressView.progress >= 1.0) {
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(removeProgressFromSuperview) userInfo:nil repeats:NO];
    }
    return str;
}

@end
