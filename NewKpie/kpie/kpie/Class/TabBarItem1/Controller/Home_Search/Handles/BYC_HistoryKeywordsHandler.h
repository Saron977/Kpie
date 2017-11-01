//
//  BYC_HistoryKeywordsHandler.h
//  kpie
//
//  Created by 元朝 on 16/5/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseHandler.h"

@interface BYC_HistoryKeywordsHandler : BYC_BaseHandler

/**
 *  获取历史关键词数据
 *
 */
+ (NSMutableArray *)getHistoryKeyword;

/**
 *  处理历史关键词数据
 *
 *  @param string_KeyWorks 关键词
 */
+ (void)handleHistoryKeyword:(NSString *)string_KeyWorks;

/**
 *  删除历史关键词
 *
 */
+ (void)clearHistoryKeyword;
@end

