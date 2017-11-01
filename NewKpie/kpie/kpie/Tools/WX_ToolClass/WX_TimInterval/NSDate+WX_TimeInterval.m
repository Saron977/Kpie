//
//  NSDate+WX_TimeInterval.m
//  Album
//
//  Created by 王傲擎 on 16/8/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "NSDate+WX_TimeInterval.h"

@implementation NSDate (WX_TimeInterval)
+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour |
    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    
    if (components.hour > 0)
    {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)components.second];
    }
    
    else
    {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)components.second];
    }
}

+ (NSString *)timeDescriptionOfTimeIntervalForSecond:(NSTimeInterval)timeInterval
{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    
    return [NSString stringWithFormat:@"%ld",(components.hour*60+components.minute)*60+components.second];
    
}

//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    //输出currentDateString
    NSLog(@"%@",currentDateString);
    return currentDateString;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string
{
    //需要转换的字符串
    NSString *dateString = @"2015-06-26 08:08:08";
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

@end
