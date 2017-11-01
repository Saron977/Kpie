//
//  BYC_HttpServers+WX_ShootingScriptVC.m
//  kpie
//
//  Created by 王傲擎 on 2016/10/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+WX_ShootingScriptVC.h"
#import "WX_ScriptModel.h"
#import "WX_ChannelModel.h"
#import "WX_ToolClass.h"

@implementation BYC_HttpServers (WX_ShootingScriptVC)


/**
 剧本合拍界面,精选视频接口
 
 @param parameters 输入参数
 @param success    成功回调
 @param failure    失败回调
 */
+(void)WX_RequestScriptVC_GetEliteListVideoScriptWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, NSMutableArray *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableArray *array_Model = [[NSMutableArray alloc]init];
    
    [BYC_HttpServers Get:KQNWS_GetEliteListVideoScript parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *rowsArray = responseObject[@"data"];
        for (NSMutableDictionary *rowsDic in rowsArray) {
            WX_ScriptModel *scriptModel = [WX_ScriptModel initModelWithDic:rowsDic];
            [array_Model addObject:scriptModel];
        }
        BOOL is_Success = [responseObject[@"success"] boolValue];
        NSString *str_Message = responseObject[@"msg"];
        
        if (is_Success) {
            success(operation,array_Model);
        }else{
            [[UIView alloc]showAndHideHUDWithTitle:str_Message WithState:BYC_MBProgressHUDHideProgress];
             success(operation,array_Model);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSLog(@"剧本合拍接口请求失败");
        failure(operation,error);
    }];
}



/**
 剧本库界面
 
 @param parameters 传字符串@"null"_剧本分组 传channelid_获得视频
 @param success    成功回调
 @param failure    失败回调
 */
+(void)WX_RequestScriptLibraryVC_GetScriptListArrayWithParameters:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation *operation, NSMutableArray *array_Script, NSMutableArray *array_Channel, NSMutableArray *array_Section))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    // 剧本
    NSMutableArray *array_Script    =   [[NSMutableArray alloc]init];
    // 剧本分类
    NSMutableArray *array_Channel   =   [[NSMutableArray alloc]init];
    // 剧本组
    NSMutableArray *array_Section   =   [[NSMutableArray alloc]init];
    
    
    [BYC_HttpServers Get:[NSString stringWithFormat:@"%@/null",KQNWS_GetChannelListVideoScript] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data_Dic = responseObject[@"data"];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];

        
        // 获取剧本分组
        NSArray *array_ScriptChannel = data_Dic[@"ScriptChannelData"];
        
//        dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
        
        for (int i = 0; i < array_ScriptChannel.count; i++) {
            NSDictionary *dic_ScriptChannel = array_ScriptChannel[i];
            WX_ChannelModel *channelModel = [WX_ChannelModel initModelWithDic:dic_ScriptChannel];
            [array_Channel addObject:channelModel];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            [parameters setValue:channelModel.channelID forKey:@"channelid"];
            
            if (!i) {
                // 最近剧本
                NSArray *array_NearlyScript = data_Dic[@"ScriptData"];
                for (NSMutableDictionary *dic in array_NearlyScript) {
                    WX_ScriptModel *model_Script = [WX_ScriptModel initModelWithDic:dic];
                    [array addObject:model_Script];
                }
                [array_Script addObject:array];
                [array_Section addObject:channelModel];
                QNWSLog(@"只执行一次");
                QNWSLog(@"channelModel.channelName == %@",channelModel.channelName);
                
            }else{
                
            }
//            dispatch_async(serialQueue, ^{
            
                //                    // 剧本
                //                     NSMutableArray *array_ScriptVideoList    =   [[NSMutableArray alloc]init];
                //                    // 剧本分类
                //                     NSMutableArray *array_ChannelVideoList   =   [[NSMutableArray alloc]init];
                //                    // 剧本组
                //                     NSMutableArray *array_SectionVideoList   =   [[NSMutableArray alloc]init];
                
//                NSInteger count = 0;
//                
//                [self WX_RequestScriptLibraryVC_GetScriptListVideoArrayWithParameters:parameters Array_Script:array_Script Array_Channel:array_Channel Array_Section:array_Section Count:count success:^(AFHTTPRequestOperation *operation, NSMutableArray *array_ScriptList, NSMutableArray *array_ChannelList, NSMutableArray *array_SectionList, NSInteger num) {
//                    [array_Script removeAllObjects];
//                    [array_Channel removeAllObjects];
//                    [array_Section removeAllObjects];
//                    
//                    [array_Script addObjectsFromArray:array_ScriptList];
//                    [array_Channel addObjectsFromArray:array_ChannelList];
//                    [array_Section addObjectsFromArray:array_SectionList];
//                    //                        count = 2;
//                    if (count == array_ScriptChannel.count) {
//                        QNWSLog(@"返回模型啦");
//                        
//                    }
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
//            });
        }
        
        success(operation,array_Script,array_Channel,array_Section);

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


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
+(void)WX_RequestScriptLibraryVC_GetScriptListVideoArrayWithParameters:(NSDictionary*)parameters Array_Script:(NSMutableArray*)array_Script Array_Channel:(NSMutableArray*)array_Channel Array_Section:(NSMutableArray*)array_Section Count:(NSInteger)count success:(void(^)(AFHTTPRequestOperation *operation, NSMutableArray *array_ScriptList, NSMutableArray *array_ChannelList, NSMutableArray *array_SectionList, NSInteger num))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [BYC_HttpServers Get:[NSString stringWithFormat:@"%@/%@",KQNWS_GetChannelListVideoScript,parameters[@"channelid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSDictionary *dic_Data = responseObject[@"data"];
        NSArray *array_ScriptData = dic_Data[@"ScriptData"];
        
        for (NSMutableDictionary *dic in array_ScriptData) {
            
            WX_ScriptModel *scriptModel = [WX_ScriptModel initModelWithDic:dic];
            [array addObject:scriptModel];
        }
        

            
        for (WX_ChannelModel *model in array_Channel) {
            if ([model.channelID isEqualToString:parameters[@"channelId"]]) {
                QNWSLog(@"获取组头名 %@",model.channelName);
                [array_Section addObject:model];
            }
        }
     
        /// 优化视频排序
        
        if(array_Script.count >0) {
            
            if (array_Channel.count == array_Section.count) {
                
                for (int i = 0; i < array_Channel.count ; i++) {
                    WX_ChannelModel *sorceModel = array_Channel[i];
                    
                    for (int j = 0; j < array_Section.count; j++) {
                        WX_ChannelModel *channelModel = array_Section[j];
                        if ([sorceModel.channelName isEqualToString:channelModel.channelName]) {
                            
                            [array_Section exchangeObjectAtIndex:i withObjectAtIndex:j];
                            
                            //                            [self.scriptArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                        }
                    }
                }
                
                for (int i = 0; i < array_Channel.count; i++) {
                    
                    WX_ChannelModel *channelModel = array_Channel[i];
                    NSArray *array = array_Script[i];
                    if ([channelModel.CTNum integerValue] != array.count) {
                        
                        for (int j = 0; j < array_Script.count; j++) {
                            NSArray *scriptArray = array_Script[j];
                            
                            if ([channelModel.CTNum integerValue] == scriptArray.count) {
                                [array_Script exchangeObjectAtIndex:i withObjectAtIndex:j];
                                break;
                            }
                        }
                    }
                    
                }
                
                for (int i = 0; i < array_Channel.count; i++) {
                    WX_ChannelModel *channelModel = array_Channel[i];
                    NSArray *array = array_Script[i];
                    QNWSLog(@"channelModel.CTNum == %@",channelModel.CTNum);
                    QNWSLog(@"array.count = %zi",array.count);
                }
                
                
                
            }
            
            for (int i = 0; i < array_Section.count; i++) {
                WX_ChannelModel *model = array_Section[i];
                if ([model.channelName isEqualToString:@"其他"]) {
                    
                    [array_Section exchangeObjectAtIndex:i withObjectAtIndex:array_Section.count-1];
                    
                    [array_Script exchangeObjectAtIndex:i withObjectAtIndex:array_Script.count-1];
                }
            }
            
            
        }
        NSInteger num = count+1;
        QNWSLog(@"第%zi次",num);
        success(operation,array_Script,array_Channel,array_Section,num);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}



@end
