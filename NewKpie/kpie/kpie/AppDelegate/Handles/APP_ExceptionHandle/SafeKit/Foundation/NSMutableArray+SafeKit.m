//
//  NSMutableArray+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-13.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSMutableArray+SafeKit.h"
#import "NSObject+swizzle.h"

@implementation NSMutableArray (SafeKit)

- (void)safe_addObject:(id)anObject {
    if (!anObject) {
        QNWSLog(@"大哥你的数组存了一个空对象:%@",self);
        QNWSShowException(@"大哥你的数组存了一个空对象");
        return;
    }
    [self safe_addObject:anObject];
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count]) {
        QNWSLog(@"数组:%@,越界下标:%zd,数组存储数量:%luz",self,index,(unsigned long)self.count);
        QNWSShowException(@"大哥你的数组越界了");
        return;
    }
    if (!anObject) {
        QNWSLog(@"大哥你的数组存了一个空对象:%@",self);
        QNWSShowException(@"大哥你的数组存了一个空对象");
        return;
    }
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        QNWSLog(@"数组:%@,越界下标:%zd,数组存储数量:%luz",self,index,(unsigned long)self.count);
        QNWSShowException(@"大哥你的数组越界了");
        return;
    }
    
    return [self safe_removeObjectAtIndex:index];
}
- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count]) {
        QNWSLog(@"数组:%@,越界下标:%zd,数组存储数量:%luz",self,index,(unsigned long)self.count);
        QNWSShowException(@"大哥你的数组越界了");
        return;
    }
    if (!anObject) {
        QNWSLog(@"大哥你的数组存了一个空对象:%@",self);
        QNWSShowException(@"大哥你的数组存了一个空对象");
        return;
    }
    [self safe_replaceObjectAtIndex:index withObject:anObject];
}

#ifdef DEBUG // 调试异常情况

#else // 发布情况下替换
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self safe_swizzleMethod:@selector(safe_addObject:) tarClass:@"__NSArrayM" tarSel:@selector(addObject:)];
        [self safe_swizzleMethod:@selector(safe_insertObject:atIndex:) tarClass:@"__NSArrayM" tarSel:@selector(insertObject:atIndex:)];
        [self safe_swizzleMethod:@selector(safe_removeObjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(removeObjectAtIndex:)];
        [self safe_swizzleMethod:@selector(safe_replaceObjectAtIndex:withObject:) tarClass:@"__NSArrayM" tarSel:@selector(replaceObjectAtIndex:withObject:)];
    });
}

#endif

@end
