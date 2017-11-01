//
//  BYC_SearchAccountModel.m
//  kpie
//
//  Created by 元朝 on 16/5/24.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_SearchAccountModel.h"

@implementation BYC_SearchAccountModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {

    NSMutableArray *mArray = [NSMutableArray array];
//    for (NSArray *arr in array) {
//        
//        BYC_SearchAccountModel *model = [[BYC_SearchAccountModel alloc] init];
//        model.userid        = arr[0];
//        model.headportrait  = arr[1];
//        model.nickname      = arr[2];
//        model.mydescription = arr[3];
//        model.sex           = [arr[4] integerValue];
//        model.hsa           = [arr[5] integerValue];
//        model.ha            = [arr[6] integerValue];
//        
//        if (![arr[4] isEqual:[NSNull null]]) model.sex  = [arr[4] integerValue];//性别
//        if (![arr[5] isEqual:[NSNull null]]) model.hsa  = [arr[5] integerValue];//是否关注 1关注0未关注
//        if (![arr[6] isEqual:[NSNull null]]) model.ha   = [arr[6] integerValue];//是否互为关注 1是0否  注意：先获取HA的值，若值为0，再取HAS判断是否关注状态；否则状态为互相关注
//        if (model.ha) model.whetherFocusForCell = WhetherFocusForCellHXFocus;//互相关注
//        else if (model.hsa) model.whetherFocusForCell = WhetherFocusForCellYES;//已关注
//        else model.whetherFocusForCell = WhetherFocusForCellNO;//没关注
//        
//        [mArray addObject:model];
//    }
    return [mArray copy];
}
@end
