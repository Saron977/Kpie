//
//  BYC_BaseChannelDataModel.m
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelDataModel.h"

@implementation BYC_BaseChannelDataModel

+ (instancetype)initModelWithArray:(NSArray *)array {
    
    
    BYC_BaseChannelDataModel     *model = [[self alloc] init];
    
    model.channelid   = array[0];
    model.channelname = array[1];
    model.channelimg  = array[2];
    model.number      = [array[3] integerValue];

    return model;
}

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_BaseChannelDataModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}
@end
