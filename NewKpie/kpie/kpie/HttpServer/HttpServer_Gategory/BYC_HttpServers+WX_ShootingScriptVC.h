//
//  BYC_HttpServers+WX_ShootingScriptVC.h
//  kpie
//
//  Created by 王傲擎 on 2016/10/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"

@interface BYC_HttpServers (WX_ShootingScriptVC)


/**
 剧本合拍界面,精选视频接口

 @param parameters 输入参数
 @param success    成功回调
 @param failure    失败回调
 */
+(void)WX_RequestScriptVC_GetEliteListVideoScriptWithParameters:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation *operation, NSMutableArray *array_Model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 剧本库界面
 
 @param parameters 传字符串@"null"_剧本分组 传channelid_获得视频
 @param success    成功回调
 @param failure    失败回调
 */
+(void)WX_RequestScriptLibraryVC_GetScriptListArrayWithParameters:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation *operation, NSMutableArray *array_Script, NSMutableArray *array_Channel, NSMutableArray *array_Section))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 获取剧本(传入channelid)
 
 @param parameters 传channelid
 @param array_Script  存储剧本数组(每一组视频存储为数组,整个数组为数组的集合)
 @param array_Channel 剧本分类数组
 @param array_Section 剧本组数组
 @param count 返回次数
 @param success    返回成功
 @param failure    返回失败
 */
+(void)WX_RequestScriptLibraryVC_GetScriptListVideoArrayWithParameters:(NSDictionary*)parameters Array_Script:(NSMutableArray*)array_Script Array_Channel:(NSMutableArray*)array_Channel Array_Section:(NSMutableArray*)array_Section Count:(NSInteger)count success:(void(^)(AFHTTPRequestOperation *operation, NSMutableArray *array_ScriptList, NSMutableArray *array_ChannelList, NSMutableArray *array_SectionList, NSInteger num))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
