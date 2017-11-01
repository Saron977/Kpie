//
//  BYC_HistoryKeywordsHandel.m
//  kpie
//
//  Created by 元朝 on 16/5/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HistoryKeywordsHandel.h"

#define BYC_HistoryKeywordsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"HistoryKeywords.data"]

@implementation BYC_HistoryKeywordsHandel

/**
 *  获取历史关键词数据
 *
 */
+ (NSMutableArray *)getHistoryKeyword {

    NSMutableArray *mArr_Keywords = [NSKeyedUnarchiver unarchiveObjectWithFile:BYC_HistoryKeywordsPath];
    return mArr_Keywords;
}
/**
 *  处理历史关键词数据
 *
 *  @param string_KeyWorks 关键词
 */
+ (void)handleHistoryKeyword:(NSString *)string_KeyWorks {
    
    NSMutableArray *mArr_Keywords = [NSKeyedUnarchiver unarchiveObjectWithFile:BYC_HistoryKeywordsPath];
    if (mArr_Keywords == nil) {
    
        mArr_Keywords = [NSMutableArray array];
        [mArr_Keywords insertObject:string_KeyWorks atIndex:0];
    } else {
    
        for (int i = 0; i < mArr_Keywords.count; i++) {
        
            NSString *str_KeyWorks = mArr_Keywords[i];
            if ([str_KeyWorks isEqualToString:string_KeyWorks]) [mArr_Keywords removeObject:mArr_Keywords[i]];
        }
        [mArr_Keywords insertObject:string_KeyWorks atIndex:0];
    }
    if (mArr_Keywords.count > 20) for (int i = 20; i < mArr_Keywords.count; i++)[mArr_Keywords removeObject:mArr_Keywords[i]];
    [NSKeyedArchiver archiveRootObject:mArr_Keywords toFile:BYC_HistoryKeywordsPath];
}

/**
 *  删除历史关键词
 *
 */
+ (void)clearHistoryKeyword {
    
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:BYC_HistoryKeywordsPath])
        [defaultManager removeItemAtPath:BYC_HistoryKeywordsPath error:nil];
}
@end
