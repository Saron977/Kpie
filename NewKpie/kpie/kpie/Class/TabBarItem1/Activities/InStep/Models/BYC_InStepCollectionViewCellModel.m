//
//  BYC_InStepCollectionViewCellModel.m
//  kpie
//
//  Created by 元朝 on 16/7/16.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_InStepCollectionViewCellModel.h"

@implementation BYC_InStepCollectionViewCellModel

//数组转模型
+ (instancetype)initModelWithArray:(NSArray *)array {

    BYC_InStepCollectionViewCellModel *model = [super initModelWithArray:array];
    
//    if (model.isVR == 2) {
//        /// 栏目合拍需要
//        model.media_Parameter = array[20];
//        model.templets = [(NSNumber*)array[21] integerValue];
//    }
    
    return model;
}

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_InStepCollectionViewCellModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}
@end
