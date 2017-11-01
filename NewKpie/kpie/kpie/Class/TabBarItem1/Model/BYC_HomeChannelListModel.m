//
//  BYC_HomeBannnerHeaderModel.m
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_HomeChannelListModel.h"

@implementation BYC_HomeChannelListModel

+ (instancetype)initModelWithArray:(NSArray *)array {
    
    BYC_HomeChannelListModel *model = [[self alloc] init];

    model.str_ChannelID  = array[0];
    model.str_Title = array[1];
    
    return model;
}


+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_HomeChannelListModel *model = [BYC_HomeChannelListModel initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}
@end
