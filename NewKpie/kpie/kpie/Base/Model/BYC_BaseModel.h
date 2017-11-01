//
//  BYC_BaseModel.h
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_BaseModel : NSObject

/**
 *  类方法初始化一个本类对象
 *
 *  @param array 需要被转换的数组
 *
 *  @return 返回本类对象
 */
+ (instancetype)initModelWithArray:(NSArray *)array;

/**
 *  类方法初始化一个存储本类对象的数组
 *
 *  @param array 需要被转换的数组
 *
 *  @return 返回存储本类对象的数组
 */


+ (NSArray *)initModelsWithArray:(NSArray *)array;

/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/

/**
 *  类方法初始化一个本类对象
 *
 *  @param array 需要被转换的字典
 *
 *  @return 返回本类对象
 */
+ (instancetype)initModelWithDictionary:(NSDictionary *)dictionary;

/**
 *  类方法初始化一个存储本类对象的模型数组
 *
 *  @param array 需要被转换的字典数组
 *
 *  @return 返回存储本类对象的模型数组
 */
+ (NSArray *)initModelsWithArrayDic:(NSArray *)arrayDic;
/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺新接口模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/
@end
