//
//  WX_Authority.m
//  Photo
//
//  Created by 王傲擎 on 2017/4/26.
//  Copyright © 2017年 王傲擎. All rights reserved.
//

#import "WX_Authority.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_OPTIONS(NSInteger, ENUM_WX_Authority) {
    ENUM_WX_Authority_Video         =   0,      /**<   枚举_权限_摄像头 */
    ENUM_WX_Authority_Audio         =   1,      /**<   枚举_权限_麦克风 */
    ENUM_WX_Authority_Photo         =   2,      /**<   枚举_权限_相册 */
};

typedef void(^block_Authority)(BOOL authority);

@interface WX_Authority()<UIAlertViewDelegate>
@property (nonatomic, strong) WX_Authority             *authority_Camer;   /**<   相机权限 */
@property (nonatomic, strong) block_Authority          block;
@end

@implementation WX_Authority

/// 摄像头
+(void)WX_AuthorityVideoDetection:(void(^)(BOOL authority))authority
{
    [WX_Authority camerAuthorityWithENUM_Authority:ENUM_WX_Authority_Video Detection:^(BOOL detection) {
        authority(detection);
    }];
}

/// 麦克风
+(void)WX_AuthorityAudioDetection:(void(^)(BOOL authorited))authorited
{
    [WX_Authority camerAuthorityWithENUM_Authority:ENUM_WX_Authority_Audio Detection:^(BOOL detection) {
        authorited(detection);
    }];
}

/// 相册
+(void)WX_AuthorityPhotoDetection:(void(^)(BOOL authority))authority
{
    [WX_Authority photoAuthorityWithENUM_Authority:ENUM_WX_Authority_Audio Detection:^(BOOL detection) {
        authority(detection);
    }];
}


/// 摄像头/ 麦克风___权限
+(void)camerAuthorityWithENUM_Authority:(ENUM_WX_Authority)ENUM_Authority Detection:(void (^)(BOOL detection))detection
{
    /// 检测权限类型
    NSString *string_MediaType;
    /// 提示权限文字
    NSString *string_alert;
    switch (ENUM_Authority) {
        case ENUM_WX_Authority_Video:
        {
            string_alert     = @"没有摄像头使用权限 \n可在设置中开启";
            string_MediaType = AVMediaTypeVideo;
        }
            break;
        case ENUM_WX_Authority_Audio:
        {
            string_alert     = @"没有麦克风使用权限 \n可在设置中开启";
            string_MediaType = AVMediaTypeAudio;
        }
            break;
            
        default:
            break;
    }
    

    /// 检测摄像头权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:string_MediaType];
    
    switch (authStatus) {
        case AVAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string_alert delegate:self cancelButtonTitle:@"设置" otherButtonTitles:@"好", nil];
            WX_Authority *authority_Camer = [[WX_Authority alloc]init];
            alert.delegate = authority_Camer.authority_Camer;
            alert.tag = ENUM_WX_Authority_Video;
            [alert show];
            
            authority_Camer.block = ^(BOOL authority) {
                detection(authority);
            };
        }
            break;
        case AVAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string_alert delegate:self cancelButtonTitle:@"设置" otherButtonTitles:@"好", nil];
            WX_Authority *authority_Camer = [[WX_Authority alloc]init];
            alert.delegate = authority_Camer.authority_Camer;
            alert.tag = ENUM_WX_Authority_Video;
            [alert show];
            
            authority_Camer.block = ^(BOOL authority) {
                detection(authority);
            };
        }
            break;
            
        case AVAuthorizationStatusAuthorized:
        {
            detection(YES);
        }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:string_MediaType completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(granted) detection(YES);
                    else detection(NO);
                });
            }];
        }
            break;
            
        default:
        {
            detection(NO);
        }
            break;
    }

}

/// 相册权限
+(void)photoAuthorityWithENUM_Authority:(ENUM_WX_Authority)ENUM_Authority Detection:(void (^)(BOOL detection))detection
{
    
    /// 提示权限文字
    NSString *string_alert = @"没有相册使用权限 \n可在设置中开启";
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                dispatch_async(dispatch_get_main_queue(), ^{
                    switch (status) {
                        case PHAuthorizationStatusAuthorized:
                        {
                            detection(YES);
                            break;
                        }
                        default:
                        {
                            detection(NO);
                            break;
                        }
                    }
                });
            }];
            break;
        }
        case PHAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string_alert delegate:self cancelButtonTitle:@"设置" otherButtonTitles:@"好", nil];
            WX_Authority *authority_Camer = [[WX_Authority alloc]init];
            alert.delegate = authority_Camer.authority_Camer;
            alert.tag = ENUM_WX_Authority_Photo;
            [alert show];
            
            authority_Camer.block = ^(BOOL authority) {
                detection(authority);
            };

        }
            break;
        case PHAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string_alert delegate:self cancelButtonTitle:@"设置" otherButtonTitles:@"好", nil];
            WX_Authority *authority_Camer = [[WX_Authority alloc]init];
            alert.delegate = authority_Camer.authority_Camer;
            alert.tag = ENUM_WX_Authority_Photo;
            [alert show];
            authority_Camer.block = ^(BOOL authority) {
                detection(authority);
            };
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default:
        {
            detection(YES);
            break;
        }
    }
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        _authority_Camer = self;
    }
    return _authority_Camer;
}

#pragma mark ----- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ENUM_WX_Authority_Video:
        {
            /// 摄像头权限
            if (!buttonIndex) {
                NSURL *set_Url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if ([[UIApplication sharedApplication] canOpenURL:set_Url]) {
                    [[UIApplication sharedApplication] openURL:set_Url];
                }

            }
        }
            break;
            
        case ENUM_WX_Authority_Audio:
        {
            /// 麦克风权限
            if (!buttonIndex) {
                NSURL *set_Url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if ([[UIApplication sharedApplication] canOpenURL:set_Url]) {
                    [[UIApplication sharedApplication] openURL:set_Url];
                }
                
            }
        }
            break;
            
        case ENUM_WX_Authority_Photo:
        {
            /// 麦克风权限
            if (!buttonIndex) {
                NSURL *set_Url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if ([[UIApplication sharedApplication] canOpenURL:set_Url]) {
                    [[UIApplication sharedApplication] openURL:set_Url];
                }
                
            }
        }
            break;

        default:
            break;
    }
    
    self.block(NO);
//    
//    switch (buttonIndex) {
//        case 1:
//        {
//            /// 取消
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
}


-(void)dealloc
{
    NSLog(@"%s 掉了",__func__);
}

@end
