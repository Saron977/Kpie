//
//  BYC_BaseChannelModelHandel.m
//  kpie
//
//  Created by 元朝 on 16/8/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelModelHandel.h"

@implementation BYC_BaseChannelModelHandel


+ (instancetype)baseChannelModelHandel {
    
    BYC_BaseChannelModelHandel *my_Self = [[BYC_BaseChannelModelHandel alloc] init];;
    return my_Self;
}

-(void)setArr_ColumnModels:(NSArray<BYC_BaseChannelColumnModel *> *)arr_ColumnModels {

    BYC_BaseChannelColumnModel *model = [BYC_BaseChannelColumnModel new];
    model.columnName = @"全部";
    
    NSMutableArray *mArr_ColumnModels = [arr_ColumnModels mutableCopy];
    [mArr_ColumnModels insertObject:model atIndex:0];
    _arr_ColumnModels = [mArr_ColumnModels copy];
}

-(NSMutableDictionary<id,BYC_BaseColumnModelHandel *> *)mDic_Models {
    
    if (!_mDic_Models) _mDic_Models = [NSMutableDictionary dictionary];
    return _mDic_Models;
}

-(BYC_BaseColumnModelHandel *)handel_ColumnModels {
    
    return [self getColumnModelsWithIndex:_indexPath_CurrentData.row];
}


-(BYC_BaseChannelModels *)models_Current {
    
    return [self getCurrentModelsWithIndex:_indexPath_CurrentData.row andType:self.handel_ColumnModels.type];
}

-(BYC_BaseColumnModelHandel *)getColumnModelsWithDifferentIndex:(NSInteger)index {
    
    return [self getColumnModelsWithIndex:index];
}
-(BYC_BaseChannelModels *)getCurrentModelsWithDifferentIndex:(NSInteger)Index andType:(NSUInteger)type {
    
    return [self getCurrentModelsWithIndex:Index andType:type];
}

-(BYC_BaseColumnModelHandel *)getColumnModelsWithIndex:(NSInteger)index {
    
    BYC_BaseColumnModelHandel *models_ColumnTemp = [self.mDic_Models objectForKey:@(index)];
    if (!models_ColumnTemp) {
        
        models_ColumnTemp = [BYC_BaseColumnModelHandel baseColumnModelHandel];
        [self.mDic_Models setObject:models_ColumnTemp forKey:@(index)];
    }
    models_ColumnTemp.models_Column = self.arr_ColumnModels[index];
    return models_ColumnTemp;
}

-(BYC_BaseChannelModels *)getCurrentModelsWithIndex:(NSInteger)Index andType:(NSUInteger)type{
    
    BYC_BaseChannelModels *models_CurrentTemp = [[self getColumnModelsWithIndex:Index].mDic_ModelsWithType objectForKey:@(type)];
    if (!models_CurrentTemp) {
        
        models_CurrentTemp = [BYC_BaseChannelModels baseChannelChildModel];
        [self.handel_ColumnModels.mDic_ModelsWithType setObject:models_CurrentTemp forKey:@(type)];
    }
    return models_CurrentTemp;
}

- (NSArray <BYC_BaseChannelVideoModel *> *)getVideoDataWithIndex:(NSInteger)Index andType:(NSUInteger)type_Flag {
    
    BYC_BaseColumnModelHandel *handel_ColumnModelTemp = [self getColumnModelsWithDifferentIndex:Index];
    NSUInteger type_Current = handel_ColumnModelTemp.type;
    handel_ColumnModelTemp.type = type_Flag;
    NSArray <BYC_BaseChannelVideoModel *> *arr_VideoModels = [self getCurrentModelsWithDifferentIndex:Index andType:type_Flag].arr_VideoModels;
    handel_ColumnModelTemp.type = type_Current;
    return arr_VideoModels;
}

@end
