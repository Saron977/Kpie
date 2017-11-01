//
//  BYC_HomeViewCntrollerModel.m
//  kpie
//
//  Created by 元朝 on 15/11/2.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_HomeViewControllerModel.h"

@implementation BYC_HomeViewControllerModel

+ (instancetype)initModelWithArray:(NSArray *)array {

    BYC_HomeViewControllerModel *model = [super initModelWithArray:array];
//    model.isVR             = [(NSNumber *)array[19] integerValue];
//    if ([(NSNumber *)array[19] integerValue] == 2 && array.count>=22) {
//        model.media_Parameter = array[array.count-2];
//        model.templets = [(NSNumber *)[array lastObject] integerValue];
//    }
    return model;
}

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_HomeViewControllerModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}

@end
