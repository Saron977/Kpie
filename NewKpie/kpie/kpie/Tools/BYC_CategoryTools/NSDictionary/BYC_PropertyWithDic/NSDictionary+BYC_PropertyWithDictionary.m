//
//  NSDictionary+BYC_PropertyWithDictionary.m
//  kpie
//
//  Created by 元朝 on 16/10/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "NSDictionary+BYC_PropertyWithDictionary.h"

@implementation NSDictionary (BYC_PropertyWithDictionary)

- (void)createPropertyCode
{
    
    [self exeCreateProperty:self];
}

- (void)exeCreateProperty:(NSDictionary *)dict {

    NSMutableString *strM_Temp = [NSMutableString string];
    // 遍历字典
    [dict enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *code;
        if ([obj isKindOfClass:[NSString class]]) code = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        else if ([obj isKindOfClass:[NSNumber class]]) code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        else if ([obj isKindOfClass:[NSArray class]]) {
        
            QNWSLog(@"---------------------------字典里%@数组的华丽分割▼▼▼---------------------------",key)
             code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
            [obj enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    
                    QNWSLog(@"字典里的数组包含了字典▼▼▼ %zi",idx);
                    [obj exeCreateProperty:obj];
                    QNWSLog(@"字典里的数组包含了字典▲▲▲ %zi",idx);
                }
            }];
            QNWSLog(@"---------------------------字典里%@数组的华丽分割▲▲▲---------------------------",key)
        } else if ([obj isKindOfClass:[NSDictionary class]]){
            QNWSLog(@"---------------------------字典里%@字典的华丽分割▼▼▼---------------------------",key)
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
            QNWSLog(@"字典里面有字典%@ ▼▼▼",key);
            [obj exeCreateProperty:obj];
            QNWSLog(@"字典里面有字典%@ ▲▲▲",key);
            QNWSLog(@"---------------------------字典里%@字典的华丽分割▲▲▲---------------------------",key)
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        [strM_Temp appendFormat:@"\n%@\n",code];
    }];
    NSLog(@"%@",strM_Temp);
}

@end
