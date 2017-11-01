//
//  BYC_BaseModel.m
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+MJKeyValue.h"

@implementation BYC_BaseModel

/**
 *  类方法初始化一个本类对象
 *
 *  @param array 需要被转换的字典
 *
 *  @return 返回本类对象
 */
+ (instancetype)initModelWithDictionary:(NSDictionary *)dictionary {

    if (!dictionary) return nil;
    @try {
        
        if (![dictionary isKindOfClass:[NSDictionary class]] && dictionary) {
            
#ifdef DEBUG // 调试异常情况
            NSString *str_Exception = [NSString stringWithFormat:@"%@这个类进行字典转模型出现问题，传入了非字典",[self class]];
            QNWSLog(@"%@",str_Exception);
            QNWSShowException(str_Exception);
#else // 发布情况下替换
            
#endif
            return nil;
        };
        
        return  [self mj_objectWithKeyValues:dictionary];
    } @catch (NSException *exception) {
        QNWSShowException(exception);
    }
}

/**
 *  类方法初始化一个存储本类对象的模型数组
 *
 *  @param array 需要被转换的字典数组
 *
 *  @return 返回存储本类对象的模型数组
 */
+ (NSArray *)initModelsWithArrayDic:(NSArray *)arrayDic {


    if (!arrayDic) return nil;
    @try {
        if (![arrayDic isKindOfClass:[NSArray class]] && arrayDic) {
            
#ifdef DEBUG // 调试异常情况
            NSString *str_Exception = [NSString stringWithFormat:@"%@这个类进行字典数组转模型数组时出现问题，传入了非字典数组",[self class]];
            QNWSLog(@"%@",str_Exception);
            QNWSShowException(str_Exception);
#else // 发布情况下替换
            
#endif
            return nil;
        }
        [arrayDic enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        }];
        
        return [[self mj_objectArrayWithKeyValuesArray:arrayDic] copy];
    } @catch (NSException *exception) {
        QNWSShowException(exception);
    }
}

//不能删，作用防止字典转模型崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

    
}

@end
