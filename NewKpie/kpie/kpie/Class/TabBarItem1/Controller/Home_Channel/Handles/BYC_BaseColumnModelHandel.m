//
//  BYC_BaseColumnModelHandel.m
//  kpie
//
//  Created by 元朝 on 16/8/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseColumnModelHandel.h"

@interface BYC_BaseColumnModelHandel()

/**1:代表没有更多数据*/
@property (nonatomic, strong)  NSMutableArray  <NSNumber *> *arr_IsWhetherNoMoreData;
@end

@implementation BYC_BaseColumnModelHandel

+ (instancetype)baseColumnModelHandel {
    
    BYC_BaseColumnModelHandel *my_Self = [BYC_BaseColumnModelHandel new];
    if (my_Self) {
        
        my_Self.type = 0;//默认0
    }
    return my_Self;
}

-(NSMutableDictionary<id,BYC_BaseChannelModels *> *)mDic_ModelsWithType {
    
    if (!_mDic_ModelsWithType) _mDic_ModelsWithType = [NSMutableDictionary dictionary];
    return _mDic_ModelsWithType;
}

-(void)setArr_GroupModels:(NSArray<BYC_BaseChannelGroupModel *> *)arr_GroupModels {

    _arr_GroupModels = arr_GroupModels;
    if (_arr_GroupModels.count == 0) {
        
        BYC_BaseChannelGroupModel *model_New = [[BYC_BaseChannelGroupModel alloc] init];
        BYC_BaseChannelGroupModel *model_Old = [[BYC_BaseChannelGroupModel alloc] init];
#warning 在为空的情况下使用此数组，注意判断ID为空。防止出错
        model_New.videoGroup_Name = @"最新";model_Old.videoGroup_Name = @"最热";
        _arr_GroupModels = @[model_New,model_Old];
    }
    for (int i = 0; i < _arr_GroupModels.count; i++)
        [self.arr_IsWhetherNoMoreData addObject:@0];
}

-(NSMutableArray<NSNumber *> *)arr_IsWhetherNoMoreData {

    if (!_arr_IsWhetherNoMoreData) _arr_IsWhetherNoMoreData = [NSMutableArray array];
    return _arr_IsWhetherNoMoreData;
}

-(void)setIsWhetherNoMoreData:(NSNumber *)isWhetherNoMoreData {

    [_arr_IsWhetherNoMoreData replaceObjectAtIndex:_type withObject:isWhetherNoMoreData];
}

-(NSNumber *)isWhetherNoMoreData {

    return _arr_IsWhetherNoMoreData[_type];
}

-(void)setIsWhetherNoMoreDataWithDifferentType:(NSInteger)type andNumber:(NSNumber *)num{

    [_arr_IsWhetherNoMoreData replaceObjectAtIndex:type withObject:num];
}
-(NSNumber *)getIsWhetherNoMoreDataWithDifferentType:(NSInteger)type {

    return _arr_IsWhetherNoMoreData[type];
}

-(NSString *)getCurrentGroupId {

    return self.arr_GroupModels[_type].videoGroup_Id;
}
@end
