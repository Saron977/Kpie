//
//  DateFormatting.m
//  Demo
//
//  Created by seeko on 15/9/9.
//  Copyright (c) 2015年 SZMG. All rights reserved.
//
//  日期格式 YYYY-MM-dd HH:mm:ss and YYYY-MM-dd HH:mm:ss SSS

#import "DateFormatting.h"

@implementation DateFormatting
-(NSString*)YesterdayToday:(NSString*)strDate
{
    
    if (strDate==nil||[strDate isEqualToString:@""]) {
        return @"";
    }
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    //    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    if (strDate!=nil&& strDate.length==23) {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    }else if(strDate!=nil&& strDate.length==19)
    {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }else
    {
        QNWSLog(@"解析日期格式不正确");
    }
    NSDate *date=[formatter dateFromString:strDate];
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        //今天
        return [NSString stringWithFormat:@"%@",[self showTheDayDate:date]];
        
    } else if ([dateString isEqualToString:yesterdayString])
    {
        //昨天
        return [NSString stringWithFormat:@"昨天 %@",[self morningAndAfternoon:date]];
    }
    else
    {
        //其他日期
        NSDate *toDayDate=[NSDate date];
        [formatter setDateFormat:@"YYYY"];
        NSInteger toDayYear=[[formatter stringFromDate:toDayDate] intValue];
//        NSInteger dateYear=[[formatter stringFromDate:date] intValue]; //2015-12-29 13:50:06这个日期获得的dateYear = 2016，原因不明。所以使用下面的方法获取年份
        NSInteger dateYear=[[strDate substringToIndex:4] intValue];
        if (toDayYear!=dateYear) {  //不同年
            
            return [NSString stringWithFormat:@"%@ %@",dateString,[self morningAndAfternoon:date]];
        }else{
            //今年
            NSTimeInterval time=[toDayDate timeIntervalSinceDate:date];
            NSInteger days=((NSInteger)time)/(3600*24);
            if (days>7) { //判断本周
                [formatter setDateFormat:@"MM-dd"];

                return [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:date],[self morningAndAfternoon:date]];
                
            }else{
                
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
                NSString *toDayString=[formatter stringFromDate:toDayDate];
                NSInteger toDayWeek=[self getWeakTime:toDayString];
                NSInteger dateWeek=[self getWeakTime:strDate];
                if (toDayWeek<dateWeek) {
                    NSString * strWeek=[self getweek:dateWeek];

                    return [NSString stringWithFormat:@"%@ %@",strWeek,[self morningAndAfternoon:date]];
                }
                else{
                    [formatter setDateFormat:@"MM-dd"];

                    return [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:date],[self morningAndAfternoon:date]];
                }
            }
        }
    }
}
//今天日期显示
-(NSString *)showTheDayDate:(NSDate*)date
{
    NSDate *nowDate=[NSDate date];
    int dValue=[nowDate timeIntervalSinceDate:date];
//    NSLog(@"%@",[NSString stringWithFormat:@"%d", (int)dValue]);
    NSString *strDate=nil;
    if (dValue<61) {
        strDate=@"刚刚";
    }else if (dValue>60&&dValue<601)
    {
        strDate=@"1分钟前";
    }else if (dValue>600&&dValue<3001)
    {
        strDate=@"10分钟前";
    }else
    {
        strDate =[NSString stringWithFormat:@"%@",[self morningAndAfternoon:date]];

    }
    
    return strDate;
}
//判断上午－下午
-(NSString *)morningAndAfternoon:(NSDate*)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"HH"];
    NSArray *languages = [NSLocale preferredLanguages];
    //地区时间格式化
    NSString *currentLanguage = [languages objectAtIndex:0];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage]];
    NSString *strDate=nil;
    
    [inputFormatter setDateFormat:@"HH:mm"];
    strDate=[NSString stringWithFormat:@"%@",[inputFormatter stringFromDate:date]];
    /*
     //上下午显示
    int hour=[[inputFormatter stringFromDate:date]intValue];
    [inputFormatter setDateFormat:@"hh:mm"];
    if (hour>12) {
        strDate=[NSString stringWithFormat:@"下午%@",[inputFormatter stringFromDate:date]];
    }else
    {
        strDate=[NSString stringWithFormat:@"上午%@",[inputFormatter stringFromDate:date]];
    }
     */
    return strDate;
}

///根据时间字符串获得当前星期几
-(NSInteger)getWeakTime:(NSString*)strDate
{
    //根据字符串转换成一种时间格式 供下面解析
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    if (strDate!=nil&& strDate.length==23) {
        [inputFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    }else if(strDate!=nil&& strDate.length==19)
    {
        [inputFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }else
    {
        NSLog(@"解析日期格式不正确");
    }
    NSDate* inputDate = [inputFormatter dateFromString:strDate];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:inputDate];
    NSInteger week = [comps weekday];
    return week;
}

-(NSString*)getweek:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=@"周日";
    }else if(week==2){
        weekStr=@"周一";
        
    }else if(week==3){
        weekStr=@"周二";
        
    }else if(week==4){
        weekStr=@"周三";
        
    }else if(week==5){
        weekStr=@"周四";
        
    }else if(week==6){
        weekStr=@"周五";
        
    }else if(week==7){
        weekStr=@"周六";
        
    }
    return weekStr;
}
@end
