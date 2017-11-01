//
//  BYC_AliyunOSSUpload.h
//  kpie
//
//  Created by 元朝 on 15/12/2.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    resourceTypeImage = 1,//图片
    resourceTypeVideo,    //视频 和 语音
}ResourceType;

@interface BYC_AliyunOSSUpload : NSObject

/**
*  阿里云上传数据
*
*  @param objectKey  上传阿里云的文件路径
*  @param data       上传数据
*  @param resourceType 数据类型
*  @param completion 成功或者失败的回调
*/
+ (void)uploadWithObjectKey:(NSString *)objectKey Data:(NSData *)data andType:(ResourceType)resourceType completion:(void (^)(BOOL finished))completion;


/**
 *  阿里云上传数据 (带上传进度回调)
 *
 *  @param objectKey    上传阿里云的文件路径
 *  @param data         上传数据
 *  @param resourceType 数据类型
 *  @param completion   成功或者失败的回调
 *  @param progressVale 上传进度
 */
+ (void)uploadWithProgressObjectKey:(NSString *)objectKey Data:(NSData *)data andType:(ResourceType)resourceType completion:(void (^)(BOOL finished))completion progressVale:(void(^)(CGFloat progressVale))progressVale;

@end
