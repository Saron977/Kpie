//
//  BYC_HttpServers+HL_VideoPlayVC.m
//  kpie
//
//  Created by sunheli on 16/8/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+HL_VideoPlayVC.h"
#import "WX_VideoEditedModel.h"
#import "HL_AttentionStateModel.h"


@implementation BYC_HttpServers (HL_VideoPlayVC)

+(void)requestVideoPlayInfoWithWithParameters:(NSDictionary *)parameters success:(void (^)(HL_VideoPlayPageModel *videoPlayPageModel))success failure:(void (^)(NSError *error))failure{
    [BYC_HttpServers Post:KQNWS_GetAllListUserComments parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_Data = (NSDictionary *)responseObject[@"data"];
        HL_VideoPlayPageModel *videoPlayPageModel = [[HL_VideoPlayPageModel alloc]init];
        videoPlayPageModel.AttentionState = [dic_Data[@"AttentionState"] integerValue];
        videoPlayPageModel.array_FavorUserModels = [BYC_AccountModel initModelsWithArrayDic:dic_Data[@"FavorUserData"]];
        videoPlayPageModel.array_OrdCommentModels = [WX_CommentModel initModelsWithArrayDic:dic_Data[@"OrdCommentData"]];
        videoPlayPageModel.array_TcCommentModels  = [WX_CommentModel initModelsWithArrayDic:dic_Data[@"TcCommentData"]];
        videoPlayPageModel.VideoModel             = [BYC_BaseVideoModel initModelWithDictionary:dic_Data[@"VideoData"]];
        videoPlayPageModel.array_RandVideoModels  = [BYC_BaseVideoModel initModelsWithArrayDic:dic_Data[@"RandVideoData"]];
        QNWSBlockSafe(success,videoPlayPageModel);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
    }];

}

+(void)requestVideoPlayVCscriptModelOnNetWithParameters:(id)parameters success:(void (^)(WX_ScriptModel *scriptModel))success failure:(void (^)(NSError *))failure{
    [BYC_HttpServers Get:KQNWS_GetOneVideoScript parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WX_ScriptModel *scriptModel = [[WX_ScriptModel alloc]init];
        scriptModel = [WX_ScriptModel initModelWithDic:responseObject[@"data"]];
        QNWSBlockSafe(success,scriptModel);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSBlockSafe(failure,error);
        QNWSLog(@"剧本信息获取错误, error == %@",error);
    }];

}

+(void)requestVideoPlayVCDeletCommentsWithParameters:(id)parameters success:(void (^)(BOOL isDeletSuccess))success failure:(void (^)(NSError *))failure{
    [BYC_HttpServers Get:KQNWS_DeletePhoneUserComments parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"success"] isEqualToNumber:@1]) {
            QNWSBlockSafe(success,YES);
        }
        else{
        QNWSBlockSafe(success,NO);
        }
         [[UIView alloc] showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIView alloc] showAndHideHUDWithTitle:@"删除失败" WithState:BYC_MBProgressHUDHideProgress];
        QNWSLog(@"删除失败,error == %@",error);
 
    }];
}

+(void)requestVideoPlayVCReportWithParameters:(NSDictionary *)parameters{
    [BYC_HttpServers Post:KQNWS_SaveUserReport parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QNWSLog(@"responseObject == %@",responseObject);
            [[UIView alloc] showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIView alloc] showAndHideHUDWithTitle:@"举报失败" WithState:BYC_MBProgressHUDHideProgress];
        QNWSLog(@"举报失败,error == %@",error);
    }];
}

/**
 *  视频点击量
 */
+(void)requestVideoPlayVCPlayedCountWithParameters:(id)parameters Success:(void(^)(void))success failure:(void (^)(void))failure{
    [BYC_HttpServers Get:KQNWS_SaveViewsVideo parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QNWSLog(@"responseObject == %@",responseObject);
        QNWSBlockSafe(success);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSLog(@"点击量接口获取数据失败 ,error == %@",error);
        QNWSBlockSafe(failure);
    }];
}

+(void)requestVideoPlayVCUploadCommentWithParameters:(NSDictionary *)parameters Success:(void (^)(BOOL isUploadSuccess))success failure:(void (^)(NSError *error))failure{
    [BYC_HttpServers Post:KQNWS_SaveUserComments parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] isEqualToNumber:@1]) {
            QNWSBlockSafe(success,YES);
        }else{
           QNWSBlockSafe(success,NO);
        }
        [[UIView alloc]showAndHideHUDWithTitle:responseObject[@"msg"] WithState:BYC_MBProgressHUDHideProgress];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIView alloc] showAndHideHUDWithTitle:@"评论失败" WithState:BYC_MBProgressHUDHideProgress];
        QNWSLog(@"回复评论接口信息发送失败,error == %@",error);
        
    }];

}

@end
