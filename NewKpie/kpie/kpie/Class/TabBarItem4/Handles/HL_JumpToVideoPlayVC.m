//
//  HL_JumpToVideoPlayVC.m
//  kpie
//
//  Created by sunheli on 16/8/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_JumpToVideoPlayVC.h"
#import "BYC_MainNavigationController.h"
#import "WX_JoinShootingViewController.h"
#import "WX_GeekViewController.h"
#import "WX_VoideDViewController.h"
#import "WX_ShootingScriptViewController.h"

@implementation HL_JumpToVideoPlayVC

+ (void)jumpToVCWithModel:(id)model andVideoTepy:(ENUM_VideoType)videoTepy andisComment:(BOOL)isComment andFromType:(ENUM_FromLeftLikeOrMessageOrOther)fromType{
    switch (videoTepy) {
        case ENUM_VideoType_NormalVideo:
            //普通视频
        {
            WX_VoideDViewController *videoVC = [[WX_VoideDViewController alloc]init];
            videoVC.isVR = NO;
            if (fromType == ENU_FromLeftLikeVideo) [videoVC receiveFromLeftLikeWithModel:model];
            else if (fromType == ENU_FromLeftMessageVideo) [videoVC receiveFromLeftMessageWithModel:model];
            else [videoVC receiveTheModelWith:@[model] WithNum:0 WithType:1];
            [KMainNavigationVC pushViewController:videoVC animated:YES];
        }
            break;
        case ENUM_VideoType_VRVideo:
            //VR视频
        {
            WX_VoideDViewController *videoVC = [[WX_VoideDViewController alloc]init];
            videoVC.isVR = YES;
            if (fromType == ENU_FromLeftLikeVideo) [videoVC receiveFromLeftLikeWithModel:model];
            else if (fromType == ENU_FromLeftMessageVideo) [videoVC receiveFromLeftMessageWithModel:model];
            else [videoVC receiveTheModelWith:@[model] WithNum:0 WithType:1];
            [KMainNavigationVC pushViewController:videoVC animated:YES];
            
        }
            break;
        case ENUM_VideoType_JoinShooting:
            // 合拍视频
        {
            if (isComment) {
                WX_VoideDViewController *videoVC = [[WX_VoideDViewController alloc]init];
                [videoVC receiveTheModelWith:@[model] WithNum:0 WithType:1];
                videoVC.isVR = NO;
                [KMainNavigationVC pushViewController:videoVC animated:YES];
            }
            else{
                WX_JoinShootingViewController *shootVC = [[WX_JoinShootingViewController alloc]init];
                [shootVC receiveModelWith:model];
                [KMainNavigationVC pushViewController:shootVC animated:YES];
            }

        }
            break;
        case ENUM_VideoType_GeekVideo:
            // 怪咖视频
        {
            WX_GeekViewController *geekVC = [[WX_GeekViewController alloc]init];
            if (fromType == ENU_FromLeftLikeVideo) [geekVC receiveFromLeftLikeWithModel:model];
            else if (fromType == ENU_FromLeftMessageVideo) [geekVC receiveFromLeftMessageWithModel:model];
            else [geekVC receiveTheModelWith:@[model] WithNum:0 WithType:1];
            [KMainNavigationVC pushViewController:geekVC animated:YES];
        }
            break;
        case ENUM_VideoType_Scripte:
            // 剧本合拍
        {
            WX_ShootingScriptViewController *scripteVC = [[WX_ShootingScriptViewController alloc]init];
            scripteVC.videoD_ScriptModel = model;
            [KMainNavigationVC pushViewController:scripteVC animated:YES];

        }
            break;
            
        default:
            break;
    }
    
}

@end
