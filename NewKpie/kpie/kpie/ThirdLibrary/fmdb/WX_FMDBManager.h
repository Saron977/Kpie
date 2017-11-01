//
//  WX_FMDBManager.h
//  kpie
//
//  Created by 王傲擎 on 15/11/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface WX_FMDBManager : NSObject
QNWSSingleton_interface(WX_FMDBManager)
@property(nonatomic, strong) FMDatabase *dataBase;



//+(instancetype)shareInstance;


+(BOOL)selectWithTable:(NSString *)table;   /**<   查询是否存在 table 表 */

//+(NSMutableArray*)selectTableWithTable:(NSString *)table Array:(NSArray*)array;  /**<   查询表是否存在, 传入表元素,返回模型数组 */

+(BOOL)createTable:(NSString *)table WithArray:(NSArray *)array;    /**<   创建table 表, array存储创建的元素(均为 NSString 类型) YES_创建成功, NO_创建失败 */

+(BOOL)deleteWithTable:(NSString*)table;    /**<   删除 table 表 */

@end
