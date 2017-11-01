//
//  BYC_BaseChannelColumnModel.m
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelColumnModel.h"

@implementation BYC_BaseChannelColumnModel

+ (instancetype)initModelWithArray:(NSArray *)array {
    
    
    BYC_BaseChannelColumnModel *model = [[self alloc] init];
    model.columnid    = array[0];//栏目编号
    model.columnname  = array[1];//栏目名称
    model.columndesc  = array[2];//栏目简介
    model.isactive    = array[3];//是否为赛事栏目 0否 1是
    model.firstcover  = array[4];//第一封面
    model.secondcover = array[5];//第二封面
    model.shareurl    = array[6];//是否为赛事栏目 0否 1是 2世纪樱花
    model.themename   = array[7];
    return model;
}

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_BaseChannelColumnModel *model = [BYC_BaseChannelColumnModel initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}
@end
