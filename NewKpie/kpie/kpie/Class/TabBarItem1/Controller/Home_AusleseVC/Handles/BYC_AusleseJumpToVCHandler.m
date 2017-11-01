//
//  BYC_AusleseJumpToVCHandler.m
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AusleseJumpToVCHandler.h"
#import "BYC_OtherViewControllerModel.h"
#import "BYC_HTML5ViewController.h"
#import "BYC_MTColumnViewcontroller.h"
#import "BYC_JumpToVCHandler.h"
#import "BYC_MainNavigationController.h"
#import "HL_JumpToVideoPlayVC.h"

@implementation BYC_AusleseJumpToVCHandler

+ (void)jumpToVCWithModel:(BYC_BaseVideoModel *)model{
    
    BYC_OtherViewControllerModel *otherModel;
    if (model.elitetype != 0 && model.elitetype != 2) {//非视频和网址
        
        otherModel             = [[BYC_OtherViewControllerModel alloc] init];
        otherModel.columnname  = model.videotitle;
        otherModel.secondcover = [model.picturejpg componentsSeparatedByString:@","][0];
        otherModel.columndesc  = model.video_Description;
        otherModel.columnid    = model.videomp4;
        if (model.elitetype < 2) otherModel.isactive    = [NSNumber numberWithInteger:model.elitetype - 1];
        else otherModel.isactive    = [NSNumber numberWithInteger:model.elitetype - 2];
    }
    
    switch (model.elitetype) {
        case 0://跳转到视频
            [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
            break;
        case 1://跳转到名师点评
            [BYC_JumpToVCHandler jumpToColumnWithColumnId:otherModel.columnid];
            break;
        case 2://跳转到网址
            [BYC_JumpToVCHandler jumpToWebWithUrl:model.videomp4];
            break;
        case 3://跳转到比基尼大赛
        case 4://跳转到世纪樱花
        case 5://跳转到合拍
        case 6://跳转到怪咖
        case 7://跳转到国庆
            [BYC_JumpToVCHandler jumpToColumnWithColumnId:otherModel.columnid];
            break;
            
        default://纯展示图片
            break;
    }
}
@end
