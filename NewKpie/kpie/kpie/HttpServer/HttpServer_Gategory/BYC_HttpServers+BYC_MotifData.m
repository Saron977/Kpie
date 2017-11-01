//
//  BYC_HttpServers+BYC_MotifData.m
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//
#import "BYC_HttpServers+BYC_MotifData.h"

@implementation BYC_HttpServers (BYC_MotifData)

+ (void)requestMotifDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSArray <BYC_MotifModel *> *arr_MotifModels, BYC_BaseChannelModels *models))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers Post:KQNWS_GetDataMotif parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dictionary    = (NSDictionary *)responseObject[@"data"];
        NSArray <BYC_MotifModel *> *arrT_MotifModels = [BYC_MotifModel initModelsWithArrayDic:dictionary[@"FindMotifData"]];
        
        BYC_BaseChannelModels *models = [BYC_BaseChannelModels baseChannelChildModel];
        models.arr_ChannelDataModels  = [BYC_BaseChannelDataModel initModelsWithArrayDic:dictionary[@"VideoChannelsData"]];
        models.arr_VideoModels    = [BYC_BaseChannelVideoModel initModelsWithArrayDic:dictionary[@"VideoData"]];
        models.arr_ColumnModels   = [BYC_BaseChannelColumnModel initModelsWithArrayDic:dictionary[@"VideoColumnData"]];
        models.arr_ThemeModels    = [BYC_BaseChannelThemeModel initModelsWithArrayDic:dictionary[@"VideoThemeData"]];
        models.arr_GroupModels    = [BYC_BaseChannelGroupModel initModelsWithArrayDic:dictionary[@"VideoGroupData"]];
        models.arr_SecCoverModels = [BYC_BaseChannelSecCoverModel initModelsWithArrayDic:dictionary[@"SecCoverData"]];
        {//这里传过来的ShareUrl字段的值可能是数组也可能是字符串。后台没有处理好,前台先处理一下吧。
            
            if ([dictionary[@"ShareUrl"] isKindOfClass:[NSArray class]]) {
                NSArray *arr_ShareUrl = ((NSArray *)dictionary[@"ShareUrl"]);
                if(arr_ShareUrl.count > 0) models.str_ShareUrl = arr_ShareUrl[0];
            }else models.str_ShareUrl = dictionary[@"ShareUrl"];
        }
        QNWSBlockSafe(success, operation,arrT_MotifModels, models);

    } failure:failure];
}
@end
