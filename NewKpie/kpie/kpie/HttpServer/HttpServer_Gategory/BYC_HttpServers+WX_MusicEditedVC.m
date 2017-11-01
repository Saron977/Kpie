//
//  BYC_HttpServers+WX_MusicEditedVC.m
//  kpie
//
//  Created by 王傲擎 on 2016/10/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+WX_MusicEditedVC.h"
#import "WX_MusicModel.h"

@implementation BYC_HttpServers (WX_MusicEditedVC)

+(void)WX_RequestScriptVC_GetMusicWithParameters:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation *operation, NSMutableArray *array_Model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSMutableArray *array_Model = [[NSMutableArray alloc]init];
    
    [BYC_HttpServers Get:KQNWS_GetMusic parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)  {
        NSArray *array_Data = responseObject[@"data"];
        if (array_Data.count > 0) {
            
            //cell数据
            for (NSDictionary *dic_Model in array_Data) {
                
                WX_MusicModel *model = [WX_MusicModel initModelWithDic:dic_Model];
                [array_Model addObject:model];
            }
        }
        
        BOOL is_Success = [responseObject[@"success"] boolValue];
        NSString *str_Message = responseObject[@"msg"];
        
        if (is_Success) {
            success(operation,array_Model);
        }else{
            [[UIView alloc]showAndHideHUDWithTitle:str_Message WithState:BYC_MBProgressHUDHideProgress];
            success(operation,array_Model);
        }

        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSLog(@"添加音乐接口请求失败");
        failure(operation,error);
    }];
    
}

@end
