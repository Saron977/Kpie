//
//  WX_ToolClass.m
//  kpie
//
//  Created by 王傲擎 on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ToolClass.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation WX_ToolClass

+(CGSize)changeSizeWithString:(NSString*)str FontOfSize:(CGFloat)fontNum bold:(WX_FontSystem)fontSystem
{

    switch (fontSystem) {
        case ENUM_BoldSystem:
        {
            NSDictionary *str_Attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontNum]};
            CGSize size = [str sizeWithAttributes:str_Attributes];
            return size;

        }
            break;
            
        case ENUM_NormalSystem:
        {
            NSDictionary *str_Attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontNum]};
            CGSize size = [str sizeWithAttributes:str_Attributes];
            return size;
            
        }
            break;
            
        default:
            break;
    }

}


+(NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    /// 分钟
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    /// 秒
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    /// 换算时间
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}


+(UIImage*)convertViewToImage:(UIView*)image
{
    CGSize size = image.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image_Result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image_Result;
}

+(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSString*)getDateWithType:(NSInteger)type
{
    NSString *str_date = @"";
    switch (type) {
        case 0:
        {
            //获取当前时间，日期
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
            str_date = [dateFormatter stringFromDate:currentDate];
        }
            break;
            
        case 1:
        {
            //获取当前时间，日期
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd-HH-mm-ss"];
            str_date = [dateFormatter stringFromDate:currentDate];
        }
            break;
            
        default:
            break;
    }

    
    return str_date;
}


+(NSString*)getDateWithFormatter:(NSString*)dateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:([dateFormatter doubleValue]/1000)];
    NSString *str_Date = [formatter stringFromDate:confromTimesp];
    
    return str_Date;
}
/**
 *  16进制颜色转换
 *
 *  @param color 16进制颜色(NSString)
 *
 *  @return 返回颜色UIColor
 */
+(UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(CMTime)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
//    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:time actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        QNWSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

+ (void)splitVideo:(NSURL *)fileUrl fps:(float)fps completedBlock:(void(^)(NSMutableArray *array_Cover))completedBlock
{
    if (!fileUrl) {
        return;
    }
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    QNWSLog(@"------- start");
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;

    NSInteger timesCount = [times count];
    NSMutableArray *array_Cover = [[NSMutableArray alloc]init];
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        printf("current-----: %lld\n", requestedTime.value);
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                QNWSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                QNWSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {

                [array_Cover addObject:[UIImage imageWithCGImage:image]];
                
                if (requestedTime.value == timesCount) {
                    QNWSLog(@"completed");
                    if (completedBlock) {
                        completedBlock(array_Cover);
                    }
                }
            }
                break;
        }
    }];
}


+ (void)splitVideo:(NSURL *)fileUrl photosCount:(Float64)photosCount completedBlock:(void(^)(NSMutableArray *array_Cover))completedBlock
{
    if (!fileUrl) {
        return;
    }
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    CMTime timeFrame;
    for (int i = 1; i <= photosCount; i++) {
        timeFrame = CMTimeMake(durationSeconds/(photosCount+1)*i, 1); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    QNWSLog(@"------- start");
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
    imgGenerator.maximumSize = CGSizeMake(480, 640);
    //防止时间出现偏差
    imgGenerator.appliesPreferredTrackTransform = YES;
    imgGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    NSInteger timesCount = [times count];
    NSMutableArray *array_Cover = [[NSMutableArray alloc]init];
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        QNWSLog("current-----: %lld\n", requestedTime.value);
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                QNWSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                QNWSLog(@"Failed with error: %@", [error localizedDescription]);
                QNWSLog(@"Failed");
                if (completedBlock) {
                    completedBlock(nil);
                }
                break;
            case AVAssetImageGeneratorSucceeded: {
                
                [array_Cover addObject:[UIImage imageWithCGImage:image]];
                
                if (array_Cover.count > 0 && array_Cover.count == timesCount) {
                    QNWSLog(@"completed");
                    if (completedBlock) {
                        completedBlock(array_Cover);
                    }
                }
            }
                break;
        }
    }];
    
}


/**
 *  把视频文件拆成图片保存在沙盒中
 *
 *  @param fileUrl        本地视频文件URL
 *  @param fps            拆分时按此帧率进行拆分
 *  @param completedBlock 所有帧被拆完成后回调
 */
+ (void)splitVideoSaveToSanBoxWithFileUrl:(NSURL *)fileUrl fps:(float)fps completedBlock:(void(^)(NSMutableArray *array_Cover))completedBlock
{
    if (!fileUrl) {
        return;
    }
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    QNWSLog(@"------- start");
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSInteger timesCount = [times count];
    NSMutableArray *array_Cover = [[NSMutableArray alloc]init];
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        printf("current-----: %lld\n", requestedTime.value);
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                QNWSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                QNWSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%lld.png",requestedTime.value]];
                NSData *imgData = UIImagePNGRepresentation([UIImage imageWithCGImage:image]);
                [imgData writeToFile:filePath atomically:YES];
                [array_Cover addObject:[UIImage imageWithCGImage:image]];
                if (requestedTime.value == timesCount) {
                    QNWSLog(@"completed");
                    
                    if (array_Cover.count > 0 && array_Cover.count == timesCount) {
                        QNWSLog(@"completed");
                        if (completedBlock) {
                            completedBlock(array_Cover);
                        }
                    }
                }
            }
                break;
        }
    }];
}

+(NSData*)achieveDataWithImage:(UIImage*)image
{
    NSData *data_Image;
    if (UIImagePNGRepresentation(image) == nil) {
        
        data_Image = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        data_Image = UIImagePNGRepresentation(image);
    }

    return data_Image;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+(BOOL)ConfirmedForPhotoAlbumPermissions
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    return YES;
    
}
@end
