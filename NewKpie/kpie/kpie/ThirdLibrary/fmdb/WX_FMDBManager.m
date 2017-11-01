//
//  WX_FMDBManager.m
//  kpie
//
//  Created by 王傲擎 on 15/11/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_FMDBManager.h"
#import "BYC_BaseModel.h"


@implementation WX_FMDBManager
QNWSSingleton_implementation(WX_FMDBManager)

-(instancetype)init
{
    self = [super init];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/KPie.db"];
    QNWSLog(@"数据库创建路径为  %@",filePath);
    self.dataBase = [FMDatabase databaseWithPath:filePath];
    if (![self.dataBase open]) {
        QNWSLog(@"数据库打开失败");
    }
    return self;
}

/// 查询表是否存在
+(BOOL)selectWithTable:(NSString *)table
{
    WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    FMResultSet *dataResult = [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from %@",table]];
    if (dataResult == nil) {
        
        return NO;
    }else{
        
        return YES;
    }
}

/////   查询表是否存在, 传入表元素,返回模型数组
//+(NSMutableArray*)selectTableWithTable:(NSString *)table Array:(NSArray*)array
//{
//    NSMutableArray *array_Result = [[NSMutableArray alloc]init];
//    
//    WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];
//    
//    FMResultSet *dataResult = [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from %@",table]];
//    if (dataResult == nil) {
//        
//        return nil;
//    }else{
//        
//        while ([dataResult next]) {
//                BYC_BaseModel
//                        
//        }
//
//    }
//}



/// 创建table 表, array存储创建的元素
+(BOOL)createTable:(NSString *)table WithArray:(NSArray *)array
{
    WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];

    NSString *str_Create = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoincrement",table];

    for (int i = 0; i < array.count; i++) {
        NSString *str = array[i];
        if (i == array.count -1) {
            str_Create = [NSString stringWithFormat:@"%@,%@ text)",str_Create,str];
        }else{
            str_Create = [NSString stringWithFormat:@"%@,%@ text",str_Create,str];
        }
        
    }
    
    if (![manager.dataBase executeUpdate:str_Create]) {
        QNWSLog(@"数据库---%@ 表创建失败",table);
        return NO;
    }else{
        QNWSLog(@"数据库---%@ 表创建成功",table);
        return YES;
    }

}

// 删除 table 表
+(BOOL)deleteWithTable:(NSString*)table
{
    WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", table];
    if (![manager.dataBase executeUpdate:sqlstr])
    {
        QNWSLog(@"删除表失败 %@",table);
        return NO;
    }else{
        QNWSLog(@"删除表成功 %@",table);
        return YES;
    }
}

@end
