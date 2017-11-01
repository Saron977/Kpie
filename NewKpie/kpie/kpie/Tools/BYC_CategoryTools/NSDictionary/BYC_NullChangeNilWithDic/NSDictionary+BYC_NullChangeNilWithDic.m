//
//  NSDictionary+BYC_NullChangeNilWithDic.m
//  kpie
//
//  Created by 元朝 on 15/12/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "NSDictionary+BYC_NullChangeNilWithDic.h"

@implementation NSDictionary (BYC_NullChangeNilWithDic)

#pragma mark - 私有方法
//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic {
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++) {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        if (obj) QNWSDictionarySetObjectForKey(resDic, obj, keyArr[i])//判断一下以避免大面积提示
    }
    return resDic;
}
//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr {
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++) {
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}
//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string {
    return string;
}
//将Null类型的项目转化成nil
+(id)nullTo_nil {
    return nil;
}
#pragma mark - 公有方法
//类型识别:将所有的NSNull类型转化成nil
+(id)changeType:(id)myObj {
    if ([myObj isKindOfClass:[NSDictionary class]]) return [self nullDic:myObj];
    else if([myObj isKindOfClass:[NSArray class]])  return [self nullArr:myObj];
    else if([myObj isKindOfClass:[NSString class]]) return [self stringToString:myObj];
    else if([myObj isKindOfClass:[NSNull class]])   return [self nullTo_nil];
    else return myObj;
}
@end
