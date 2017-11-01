//
//  NSDate+WX_TimeInterval.h
//  Album
//
//  Created by 王傲擎 on 16/8/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WX_TimeInterval)
+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)timeDescriptionOfTimeIntervalForSecond:(NSTimeInterval)timeInterval;

//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date;
//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string;
@end
