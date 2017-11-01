//
//  BYC_FocusAndFansModel.m
//  kpie
//
//  Created by 元朝 on 15/12/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_FocusAndFansModel.h"

@implementation BYC_FocusAndFansModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {

    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_FocusAndFansModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}

+ (instancetype)initModelWithArray:(NSArray *)array {
    
    BYC_FocusAndFansModel  *model = [[self alloc] init];    
    return model;
}

@end
