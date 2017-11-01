//
//  BYC_OtherViewControllerModel.m
//  kpie
//
//  Created by 元朝 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_OtherViewControllerModel.h"

@implementation BYC_OtherViewControllerModel
+ (instancetype)initModelWithArray:(NSArray *)array {
    

    BYC_OtherViewControllerModel *model = [[self alloc] init];
    model.columnid    = array[0];//栏目编号
    model.columnname  = array[1];//栏目名称
    model.firstcover  = array[2];//第一封面
    model.secondcover = array[3];//第二封面
    model.columndesc  = array[4];//栏目简介
    model.pubstate    = [(NSNumber *)array[5] integerValue];//是否上架
    model.uploadtime  = array[6];//上传时间
    model.onofftime   = array[7];//上架时间
    model.views       = [(NSNumber *)array[8] integerValue];//点击量
    model.themename   = array[9];//活动话题名称
    model.channelid   = array[10];//所属频道编号
    model.videomp4    = array[11];//视频播放地址
    model.isactive    = array[12];//是否为赛事栏目 0否 1是
    model.shareurl    = array[13];//是否为赛事栏目 0否 1是 2世纪樱花

    return model;
}

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_OtherViewControllerModel *model = [BYC_OtherViewControllerModel initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}
@end
