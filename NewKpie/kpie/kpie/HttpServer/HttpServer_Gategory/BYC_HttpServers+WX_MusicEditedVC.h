//
//  BYC_HttpServers+WX_MusicEditedVC.h
//  kpie
//
//  Created by 王傲擎 on 2016/10/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"

@interface BYC_HttpServers (WX_MusicEditedVC)


/**
 添加音乐界面,获取音乐
 
 @param parameters 输入参数
 @param success    成功回调
 @param failure    失败回调
 */
+(void)WX_RequestScriptVC_GetMusicWithParameters:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation *operation, NSMutableArray *array_Model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
