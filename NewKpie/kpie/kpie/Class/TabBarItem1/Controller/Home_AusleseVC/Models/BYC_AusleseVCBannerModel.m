//
//  BYC_AusleseVCBannerModel.m
//  kpie
//
//  Created by 元朝 on 16/8/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AusleseVCBannerModel.h"

@implementation BYC_AusleseVCBannerModel


+(instancetype)initModelWithArray:(NSArray *)array {

    BYC_AusleseVCBannerModel *model = [super initModelWithArray:array];


    model.elitetype        = [(NSNumber *)array[19] integerValue];
    model.isvr             = [(NSNumber *)array[20] integerValue];

    return model;
}

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_AusleseVCBannerModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}

@end
