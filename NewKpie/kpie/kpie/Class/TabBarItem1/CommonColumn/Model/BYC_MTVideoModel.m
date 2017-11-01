//
//  BYC_MTVideoModel.m
//  kpie
//
//  Created by 元朝 on 16/4/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MTVideoModel.h"

@implementation BYC_MTVideoModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {

    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_MTVideoModel *model = [super initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}
@end
