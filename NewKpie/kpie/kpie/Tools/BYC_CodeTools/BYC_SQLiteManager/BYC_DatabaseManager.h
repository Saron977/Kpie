//
//  BYC_DatabaseManager.h
//  kpie
//
//  Created by 元朝 on 16/5/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface BYC_DatabaseManager : NSObject
QNWSSingleton_interface(BYC_DatabaseManager)
/**
 *  打开数据库
 *
 *  @param databaseName 数据库的名字
 */
- (void)openDatabase:(NSString *)databaseName;

/**
 *  创建历史关键词表
 */
- (void)createHistoryKeyworksTable;
/**
 *  插入关键词数据
 *
 *  @param keywork 关键词
 */
- (void)insertHistoryKeyworksData:(NSString *)keywork;
@end
