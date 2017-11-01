//
//  BYC_LeftLikeModel.m
//  kpie
//
//  Created by 元朝 on 15/12/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LeftLikeModel.h"

@implementation BYC_LeftLikeModel

+ (instancetype)initModelWithArray:(NSArray *)array {

    BYC_LeftLikeModel *model = [[self alloc] init];
    model.videoID            = array[0];
    model.collectionTime     = array[1];
    model.cateID             = array[2];
    model.videoIndex         = [(NSNumber *)array[3] doubleValue];
    model.videoTitle         = array[4];
    model.pictureJPG         = array[5];
    model.videoMP4           = array[6];
    model.videoDescription      = array[7];
    model.userID             = array[8];
    model.views              = [(NSNumber *)array[9] integerValue];
    model.nickName           = array[10];
    model.headPortrait       = array[11];
    model.scriptID           = array[12];
    model.sex                = [(NSNumber *)array[13] integerValue];
    model.comments           = array[14];
    model.favorites          = array[15];
    model.isLike             = [array[16] intValue];
    model.isVR               = [(NSNumber *)array[17] integerValue];
    return model;
}


@end
