//
//  HL_TagTool.m
//  kpie
//
//  Created by sunheli on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_TagTool.h"

@implementation HL_TagTool

+(NSMutableArray *)parseTag:(NSString *)parseText{

    NSMutableArray *array_Topic = [NSMutableArray array];
        NSError *error;
        NSString *topic_expression = @"(#[^#]+#)";
        NSRegularExpression *topic_Regex = [NSRegularExpression regularExpressionWithPattern:topic_expression
                                                                                     options:NSRegularExpressionCaseInsensitive
                                                                                       error:&error];
        NSArray *topic_arrayOfAllMatchesr= [topic_Regex matchesInString:parseText options:0 range:NSMakeRange(0, [parseText length])];
        
        for (NSTextCheckingResult *match in topic_arrayOfAllMatchesr)
        {
            
           NSString *title = [parseText substringWithRange:match.range];
            [array_Topic addObject:title];
        }
    return array_Topic;
}


+(NSMutableArray *)parseUrlTag:(NSString *)parseText{
    NSMutableArray *array_Url = [NSMutableArray array];
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:parseText options:0 range:NSMakeRange(0, [parseText length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
       NSString *url_Str = [parseText substringWithRange:match.range];
        [array_Url addObject:url_Str];
    }

    return array_Url;
}

@end
