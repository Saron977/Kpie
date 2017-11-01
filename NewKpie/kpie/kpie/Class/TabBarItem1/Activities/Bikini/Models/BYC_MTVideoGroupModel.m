//
//  BYC_MTVideoGroupModel.m
//  kpie
//
//  Created by 元朝 on 16/4/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MTVideoGroupModel.h"

@implementation BYC_MTVideoGroupModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {

    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_MTVideoGroupModel *model = [[BYC_MTVideoGroupModel alloc] init];
        model.videoGroup_Id     = arr[0];
        model.videoGroup_Name   = arr[1];
        [mArray addObject:model];
    }
    return [mArray copy];
}
@end
