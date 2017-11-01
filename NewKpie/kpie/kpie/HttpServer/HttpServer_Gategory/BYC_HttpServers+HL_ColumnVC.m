//
//  BYC_HttpServers+HL_ColumnVC.m
//  kpie
//
//  Created by sunheli on 16/10/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_ColumnVC.h"

@implementation BYC_HttpServers (HL_ColumnVC)


+(void)requestColumnDataWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, HL_ColumModel *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    [BYC_HttpServers Post:KQNWS_GetGroupAllJsonArrayListVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HL_ColumModel *models = [[HL_ColumModel alloc] init];
        NSMutableArray <HL_ColumnVideoThemeModel *>*arr_Area = [NSMutableArray array];
        NSDictionary *dictionary    = (NSDictionary *)responseObject[@"data"];
        models.arr_MotifModels      = [BYC_MotifModel initModelsWithArrayDic:dictionary[@"FindMotifData"]];
        models.arr_GroupModels      = [BYC_MTVideoGroupModel initModelsWithArrayDic:dictionary[@"VideoGroupData"]];
        models.arr_VideoModels      = [BYC_BaseVideoModel initModelsWithArrayDic:dictionary[@"VideoData"]];
        arr_Area = [[HL_ColumnVideoThemeModel initModelsWithArrayDic:dictionary[@"VideoThemeData"]] mutableCopy];
        for (NSInteger i =0;i < arr_Area.count;i++) {
            HL_ColumnVideoThemeModel *model = arr_Area[i];
            if ([model.themename rangeOfString:@"hide"].location == NSNotFound) {
                [arr_Area removeObjectAtIndex:i];
            }
        }        
        models.arr_ThemeModels      = [arr_Area copy];
        models.arr_ChannelModels    = [HL_ColumnVideoChannelsModel initModelsWithArrayDic:dictionary[@"VideoChannelsData"]];
        models.arr_BannerModel      = [BYC_MTBannerModel initModelsWithArrayDic:dictionary[@"SecCoverData"]];
        models.columnModel          = [BYC_OtherViewControllerModel initModelWithDictionary:dictionary[@"VideoColumn"]];
        models.arr_ColumnVideoSortModel = [HL_ColumnVideoSortModel initModelsWithArrayDic:dictionary[@"VideoSortData"]];
        models.arr_ColumnVideoScriptModel = [HL_ColumnVideoScriptModel initModelsWithArrayDic:dictionary[@"VideoScriptData"]];
        
        
        models.columnModel.arr_Area          = models.arr_ThemeModels;
        models.columnModel.arr_SecCover      = [BYC_MTBannerModel initModelsWithArrayDic:dictionary[@"SecCoverData"]];
        models.columnModel.arr_VideoGroup    = [BYC_MTVideoGroupModel initModelsWithArrayDic:dictionary[@"VideoGroupData"]];
        
        QNWSBlockSafe(success, operation,models);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIView alloc] showAndHideHUDWithTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress];
        QNWSBlockSafe(failure, operation, error);
    }];

}
@end
