//
//  BYC_MTBannerModel.m
//  kpie
//
//  Created by 元朝 on 16/4/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MTBannerModel.h"

@implementation BYC_MTBannerModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
//    for (NSArray *arr in array) {
//        
//        BYC_MTBannerModel *model = [[BYC_MTBannerModel alloc] init];
        
        
//        model.secCover_Path    = arr[0];//跳转地址
//        model.secCover_Type    = arr[1];//封面类型 0图片 1 视频 2 网址
//        model.secCover_Url     = arr[2];//封面地址
//        model.videoID          = arr[3];//视频的id
//        model.videoTitle       = arr[4];//视频的标题
//        model.userID           = arr[5];//上传该视频的用户的id
//        model.videoMP4         = arr[6];//mp4的地址
//        model.GPSX             = [(NSNumber *)arr[7] doubleValue];//上传该视频的时候的用户地理坐标
//        model.GPSY             = [(NSNumber *)arr[8] doubleValue];//上传该视频的时候的用户地理坐标
//        model.pictureJPG       = arr[9];//视频的截图的地址
//        model.videoDescription = arr[10];//该视频的描述
//        model.upLoadTime       = arr[11];//该视频的上传时间
//        model.comments         = [(NSNumber *)arr[12] integerValue];//该视频的评论数
//        model.favorites        = [(NSNumber *)arr[13] integerValue];//该视频的收藏量
//        model.views            = [(NSNumber *)arr[14] integerValue];//该视频的点击量
//        model.cateID           = arr[15];//所属剧集的编号
//        model.videoIndex       = [(NSNumber *)arr[16] integerValue];//这个视频属于第几集
//        model.onOffTime        = arr[17];//视频的上架时间（也就是属于上传时间）
//        model.headPortrait     = arr[18];//上传该视频的用户头像的地址
//        model.nickName         = arr[19];//上传该视频的用户的昵称
//        model.sex              = [(NSNumber *)arr[20] boolValue];//上传该视频的用户的性别
//        model.scriptID         = arr[21];//上传的视频属于剧本就有这个id，不是剧本就没有。（播放界面的“我来拍”，就是用这个控
//
//
//        switch ([(NSNumber *)arr[1] intValue]) {
//            case 0:
//                model.modelType = HomeVCBannerModelTypeImage;
//                break;
//            case 1:
//                model.modelType = HomeVCBannerModelTypeVedio;
//                break;
//            case 2:
//                model.modelType = HomeVCBannerModelTypeWeb;
//                break;
//                
//            default:
//                break;
//        }
//        
//        [mArray addObject:model];
//    }
    return [mArray copy];
}
@end
