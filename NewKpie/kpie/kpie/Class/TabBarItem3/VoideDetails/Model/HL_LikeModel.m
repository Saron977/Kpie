//
//  HL_LikeModel.m
//  kpie
//
//  Created by sunheli on 16/8/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_LikeModel.h"

@implementation HL_LikeModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        HL_LikeModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}

+ (instancetype)initModelWithArray:(NSArray *)array {
    HL_LikeModel  *model = [[self alloc] init];
    model.userid                  = array[0];//用户编号
    model.headportrait            = array[1];//头像
    model.nickname                = array[2];//昵称
    return model;
}


@end
