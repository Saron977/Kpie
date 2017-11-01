//
//  BYC_DatabaseManager.m
//  kpie
//
//  Created by 元朝 on 16/5/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_DatabaseManager.h"

@interface BYC_DatabaseManager()

/**数据库队列*/
@property (nonatomic, strong)  FMDatabaseQueue  *databaseQueue;

@end

@implementation BYC_DatabaseManager
QNWSSingleton_implementation(BYC_DatabaseManager)
- (void)openDatabase:(NSString *)databaseName {

    NSString *database_Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"QNWSDatabase/%@",databaseName]];
    
    
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:database_Path];
    

    [self createHistoryKeyworksTable];
}


#pragma  mark - 历史关键词
- (void)createHistoryKeyworksTable {

     NSString  *createTableSQL = @"CREATE TABLE IF NOT EXISTS t_HistoryKeyworks ('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'keyworks' TEXT);";
    
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([db executeUpdate:createTableSQL]) {
            QNWSLog(@"创建历史关键词表成功");
        }else QNWSLog(@"创建历史关键词表失败");
    }];
}

- (void)insertHistoryKeyworksData:(NSString *)keywork {

    NSString  *insertSQL = @"INSERT INTO t_HistoryKeyworks (keyworks) VALUES (?);";

    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([db executeUpdate:insertSQL withArgumentsInArray:@[keywork]]) {
            QNWSLog(@"插入历史关键词数据成功");
        }else QNWSLog(@"插入历史关键词数据失败");
    }];
}

- (void)deleteHistoryKeyworksData:(NSString *)keywork {
    
    NSString  *deleteSQL = @"DELETE FROM t_status WHERE id = 20;";
    
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([db executeUpdate:deleteSQL withArgumentsInArray:@[keywork]]) {
            QNWSLog(@"插入历史关键词数据成功");
        }else QNWSLog(@"插入历史关键词数据失败");
    }];
}
@end
