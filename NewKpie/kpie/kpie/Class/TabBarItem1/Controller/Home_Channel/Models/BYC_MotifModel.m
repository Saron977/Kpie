//
//  BYC_BaseChannelFindMotifModel.m
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MotifModel.h"

@implementation BYC_MotifModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
//    for (NSArray *arr in array) {
//        
//        BYC_MotifModel *model = [[BYC_MotifModel alloc] init];
//        model.motifID     = arr[0];
//        model.motifName   = arr[1];
//        model.motifMode   = [arr[2] unsignedIntegerValue];
//        model.motifAsc    = [arr[3] unsignedIntegerValue];
//        
//        [mArray addObject:model];
//    }
    return [mArray copy];
}
@end
