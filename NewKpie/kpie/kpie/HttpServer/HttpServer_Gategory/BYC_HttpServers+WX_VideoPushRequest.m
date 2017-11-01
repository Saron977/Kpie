//
//  BYC_HttpServers+WX_VideoPushRequest.m
//  kpie
//
//  Created by 王傲擎 on 2017/6/28.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+WX_VideoPushRequest.h"
#import "WX_ScriptModel.h"

@implementation BYC_HttpServers (WX_VideoPushRequest)
+ (void)WX_RequestVideoPushWithVideoID:(NSArray *)videoID ENUM_PushType:(ENUM_PushType)type success:(void (^)(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *video_Model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    switch (type) {
        case ENUM_VideoPushType_Video:
            // 普通视频
        {
                [BYC_HttpServers Get:KQNWS_VideoPush parameters:videoID success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSArray *arr_Videos = [NSArray array];
                    arr_Videos = [BYC_BaseVideoModel initModelsWithArrayDic:responseObject[@"data"]];
                    QNWSBlockSafe(success,operation,arr_Videos);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    QNWSLog(@"推送视频信息获取错误, error == %@",error);
                }];
            
        }
            break;
            case  ENUM_VideoPushType_Script:
            // 剧本合拍
        {
            [BYC_HttpServers Get:KQNWS_GetOneVideoScript parameters:videoID success:^(AFHTTPRequestOperation *operation, id responseObject) {
                WX_ScriptModel *scriptModel = [[WX_ScriptModel alloc]init];
                scriptModel = [WX_ScriptModel initModelWithDic:responseObject[@"data"]];
                QNWSBlockSafe(success,operation,@[scriptModel]);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                QNWSLog(@"剧本信息获取错误, error == %@",error);
            }];
            
//            [BYC_HttpServers Get:KQNWS_GetOneVideoScript parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                WX_ScriptModel *scriptModel = [[WX_ScriptModel alloc]init];
//                scriptModel = [WX_ScriptModel initModelWithDic:responseObject[@"data"]];
//                QNWSBlockSafe(success,scriptModel);
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                QNWSBlockSafe(failure,error);
//                QNWSLog(@"剧本信息获取错误, error == %@",error);
//            }];

        }
            
        default:
            break;
    }

    


}

@end
