//
//  BYC_BaseChannelModelHandler.m
//  kpie
//
//  Created by 元朝 on 16/8/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelModelHandler.h"

@implementation BYC_BaseChannelModelHandler


+ (instancetype)baseChannelModelHandel {
    
    BYC_BaseChannelModelHandler *my_Self = [[BYC_BaseChannelModelHandler alloc] init];;
    return my_Self;
}

-(void)setArr_ColumnModels:(NSArray<BYC_BaseChannelColumnModel *> *)arr_ColumnModels {

    BYC_BaseChannelColumnModel *model = [BYC_BaseChannelColumnModel new];
    model.columnname = @"全部";
    if(_model_ChannelData && _model_ChannelData.channeldesc.length>0)
        model.columndesc = _model_ChannelData.channeldesc;
    NSMutableArray *mArr_ColumnModels = [arr_ColumnModels mutableCopy];
    [mArr_ColumnModels insertObject:model atIndex:0];
    _arr_ColumnModels = [mArr_ColumnModels copy];
}

-(NSMutableDictionary<id,BYC_BaseColumnModelHandler *> *)mDic_Models {
    
    if (!_mDic_Models) _mDic_Models = [NSMutableDictionary dictionary];
    return _mDic_Models;
}

-(BYC_BaseColumnModelHandler *)handel_ColumnModels {
    
    return [self getColumnModelsWithIndex:_indexPath_CurrentData.row];
}

-(BYC_BaseChannelModels *)models_Current {
    
    return [self getCurrentModelsWithIndex:_indexPath_CurrentData.row andType:self.handel_ColumnModels.type];
}

-(BYC_BaseColumnModelHandler *)getColumnModelsWithDifferentIndex:(NSInteger)index {
    
    return [self getColumnModelsWithIndex:index];
}
-(BYC_BaseChannelModels *)getCurrentModelsWithDifferentIndex:(NSInteger)Index andType:(NSUInteger)type {
    
    return [self getCurrentModelsWithIndex:Index andType:type];
}

-(BYC_BaseColumnModelHandler *)getColumnModelsWithIndex:(NSInteger)index {
    
    BYC_BaseColumnModelHandler *models_ColumnTemp = [self.mDic_Models objectForKey:@(index)];
    if (!models_ColumnTemp) {
        
        models_ColumnTemp = [BYC_BaseColumnModelHandler baseColumnModelHandel];
        QNWSDictionarySetObjectForKey(self.mDic_Models, models_ColumnTemp, @(index))
    }
    models_ColumnTemp.models_Column = self.arr_ColumnModels[index];
    return models_ColumnTemp;
}

-(BYC_BaseChannelModels *)getCurrentModelsWithIndex:(NSInteger)Index andType:(NSUInteger)type{
    
    BYC_BaseChannelModels *models_CurrentTemp = [[self getColumnModelsWithIndex:Index].mDic_ModelsWithType objectForKey:@(type)];
    if (!models_CurrentTemp) {
        
        models_CurrentTemp = [BYC_BaseChannelModels baseChannelChildModel];
        QNWSDictionarySetObjectForKey(self.handel_ColumnModels.mDic_ModelsWithType, models_CurrentTemp, @(type))
    }
    return models_CurrentTemp;
}

- (NSArray <BYC_BaseChannelVideoModel *> *)getVideoDataWithIndex:(NSInteger)Index andType:(NSUInteger)type_Flag {
    
    BYC_BaseColumnModelHandler *handel_ColumnModelTemp = [self getColumnModelsWithDifferentIndex:Index];
    NSUInteger type_Current = handel_ColumnModelTemp.type;
    handel_ColumnModelTemp.type = type_Flag;
    NSArray <BYC_BaseChannelVideoModel *> *arr_VideoModels = [self getCurrentModelsWithDifferentIndex:Index andType:type_Flag].arr_VideoModels;
    handel_ColumnModelTemp.type = type_Current;
    return arr_VideoModels;
}

@end
