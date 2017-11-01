//
//  HL_ColumnVideoScriptModel.m
//  kpie
//
//  Created by sunheli on 16/11/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_ColumnVideoScriptModel.h"

@implementation HL_ColumnVideoScriptModel
MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"script_id" : @"id"};
}
@end
