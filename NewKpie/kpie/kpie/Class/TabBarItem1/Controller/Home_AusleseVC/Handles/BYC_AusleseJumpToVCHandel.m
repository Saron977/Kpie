//
//  BYC_AusleseJumpToVCHandel.m
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AusleseJumpToVCHandel.h"
#import "BYC_OtherViewControllerModel.h"
#import "WX_VoideDViewController.h"
#import "BYC_ColumnViewcontroller.h"
#import "BYC_HTML5ViewController.h"
#import "BYC_MTColumnViewcontroller.h"
#import "BYC_SJYHColumnViewcontroller.h"
#import "BYC_InStepViewcontroller.h"
#import "BYC_MononokeViewcontroller.h"
#import "BYC_HomeJumpToVCHandel.h"
#import "BYC_MainNavigationController.h"

@implementation BYC_AusleseJumpToVCHandel

+ (void)jumpToVCWithModel:(BYC_AusleseVCBannerModel *)model{
    
    BYC_OtherViewControllerModel *otherModel;
    if (model.eliteType != 0 && model.eliteType != 2) {//非视频
        
        otherModel             = [[BYC_OtherViewControllerModel alloc] init];
        otherModel.columnName  = [model.pictureJPG componentsSeparatedByString:@","][2];
        otherModel.secondCover = [model.pictureJPG componentsSeparatedByString:@","][1];
        otherModel.columnDesc  = model.videoDescription;
        otherModel.columnID    = model.videoMP4;
    }
    
    switch (model.eliteType) {
        case 0://跳转到视频
        {
            WX_VoideDViewController *videoVC = [[WX_VoideDViewController alloc] init];
            [videoVC receiveTheModelWith:@[model] WithNum:0 WithType:1];
            if (model.isVR == 1) videoVC.isVR = YES;
            else videoVC.isVR = NO;
            [KMainNavigationVC pushViewController:videoVC animated:YES];
        }
            break;
        case 1://跳转到名师点评
            [BYC_HomeJumpToVCHandel jumpToVCWithVCClass:[BYC_ColumnViewcontroller class] model:otherModel andType:ENUM_JumpToVCHandelTypeBanner];
            break;
        case 2://跳转到网址
            [BYC_HomeJumpToVCHandel jumpToVCWithVCClass:[BYC_HTML5ViewController class] model:otherModel andType:ENUM_JumpToVCHandelTypeBanner];
            break;
        case 3://跳转到比基尼大赛
            [BYC_HomeJumpToVCHandel jumpToVCWithVCClass:[BYC_MTColumnViewcontroller class] model:otherModel andType:ENUM_JumpToVCHandelTypeBanner];
            break;
        case 4://跳转到世纪樱花
            [BYC_HomeJumpToVCHandel jumpToVCWithVCClass:[BYC_SJYHColumnViewcontroller class] model:otherModel andType:ENUM_JumpToVCHandelTypeBanner];
            break;
        case 5://跳转到合拍
            [BYC_HomeJumpToVCHandel jumpToVCWithVCClass:[BYC_InStepViewcontroller class] model:otherModel andType:ENUM_JumpToVCHandelTypeBanner];
            break;
        case 6://跳转到怪咖
            [BYC_HomeJumpToVCHandel jumpToVCWithVCClass:[BYC_MononokeViewcontroller class] model:otherModel andType:ENUM_JumpToVCHandelTypeBanner];
            break;
            
        default://纯展示图片
            break;
    }
}
@end
