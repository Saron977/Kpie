//
//  BYC_MyCenterUserModel.m
//  kpie
//
//  Created by 元朝 on 16/9/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MyCenterUserModel.h"

@implementation BYC_MyCenterUserModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_MyCenterUserModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}

+ (instancetype)initModelWithArray:(NSArray *)array {
    
    BYC_MyCenterUserModel  *model = [[self alloc] init];
//    model.userid        = array[0];//用户编号
//    model.nickname      = array[1];//昵称
//    model.headportrait  = array[2];//头像
//    model.mydescription = array[3];//个性简介
//    model.sex           = [array[4] integerValue];//关注时间
//    model.videos        = [array[5] integerValue];//关注时间
//    model.fans          = [array[6] integerValue];//关注时间
//    model.focus         = [array[7] integerValue];//关注时间
//    model.levelImg      = array[8];
//    model.titleImg      = array[9];
//    model.titleName     = array[10];
//    model.blacks        = [array[11] intValue];
    return model;
}

@end
