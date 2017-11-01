//
//  NSString+BYC_HaseCode.m
//  kpie
//
//  Created by 元朝 on 15/11/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "NSString+BYC_HaseCode.h"

@implementation NSString (BYC_HaseCode)
- (int)javaHashCode
{
    int h = 0;
    
    for (int i = 0; i < (int)self.length; i++) {
        h = (31 * h) + [self characterAtIndex:i];
    }
    
    return h;
}
/**
 * 生成文件在oss上存储的名字
 * * @param fileName 原文件名，带后缀名（无后缀名时直接使用guid做文件名）
 * @param intType 类型， 1视频节目，2视频素材，3节目图片，4用户头像，5素材图片, 6音频文件

 1、sz-kpie-jpg      图片
 
 videos  存入视频截图
 users   存入用户头像
 materials  存入素材视频截图
 
 2、sz-kpie-videos   视频、语音
 
 videos  存入视频
 voices  存入语音
 materials  存入素材视频
 
 3、sz-kpie-test   测试（图片、视频、语音文件）
 
 users   存入用户头像
 videos  存入视频、视频截图
 voices  存入语音
 materials  存入素材视频、素材视频截图
 * @return
 */
+ (NSString *)createFileName:(NSString *)fileName andType:(ENUM_ResourceType)resourceType {
    
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *rootPath;
    
    switch (resourceType) {
        case ENUM_ResourceTypeVideos: {
            rootPath = [NSString stringWithFormat:@"videos/%@/",strDate];
            break;
        }
        case ENUM_ResourceTypeVoices: {
            rootPath = [NSString stringWithFormat:@"voices/%@/",strDate];
            break;
        }
        case ENUM_ResourceTypeUsers: {
            rootPath = [NSString stringWithFormat:@"users/%@/",strDate];
            break;
        }
        case ENUM_ResourceTypeMaterials: {
            rootPath = [NSString stringWithFormat:@"materials/%@/",strDate];
            break;
        }
    }

    NSRange range2 = [fileName rangeOfString:@"."options:NSBackwardsSearch];
    NSString *fname;
    fname = [NSString stringWithFormat:@"%@%@",[[[NSUUID UUID] UUIDString] lowercaseString] , [fileName substringFromIndex:range2.location]];
    fname = [NSString stringWithFormat:@"%@%@",rootPath,fname];
    return fname;
    
}
/// YES 有输入  NO 没有输入
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    NSArray *arr = @[@"➋",@"➌",@"➍",@"➎",@"➏",@"➐",@"➑",@"➒"];
    
    for (NSString *str in arr) if ([string isEqualToString:str]) return  NO;

    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
