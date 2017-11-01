//
//  WX_RandomVideoModel.m
//  kpie
//
//  Created by 王傲擎 on 16/1/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_RandomVideoModel.h"

@implementation WX_RandomVideoModel


//+(instancetype)initModelWithArray:(NSArray *)array
//{
//    WX_RandomVideoModel *model = [[self alloc] init];
//    
//    model.videoID           =           array[0];
//    model.videoTitle        =           array[1];
//    model.userID            =           array[2];
//    model.videoMP4          =           array[3];
//    model.GPSX              =           [(NSNumber *)array[4] doubleValue];
//    model.GPSY              =           [(NSNumber *)array[5] doubleValue];
//    model.pictureJPG        =           array[6];
//    model.videoDescription  =           array[7];
//    model.upLoadTime        =           array[8];
//    model.comments          =           [(NSNumber *)array[9] integerValue];
//    model.favorites         =           [(NSNumber *)array[10] integerValue];
//    model.views             =           [(NSNumber *)array[11] integerValue];
//    model.cateID            =           array[12];
//    model.videoIndex        =           [(NSNumber *)array[13] integerValue];
//    model.onOffTime         =           array[14];
//    model.headPortrait      =           array[15];
//    model.nickName          =           array[16];
//    model.sex               =           [(NSNumber *)array[17] boolValue];
//    model.scriptID          =           array[18];
//    model.isVR              =           [(NSNumber *)array[19] integerValue];
//    
//    
//    
//    return model;
//    
//    
//    
//}
+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        WX_RandomVideoModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}

+(instancetype)initModelWithArray:(NSArray *)array {
    
    WX_RandomVideoModel *model = [super initModelWithArray:array];
//    model.isVR  = [(NSNumber *)array[19] integerValue];//上传该视频的用户的性别
//    model.isVR    = [(NSNumber *)array[20] integerValue];
    return model;
}

@end
