//
//  BYC_HttpServers+HL_VideoPlayVC.h
//  kpie
//
//  Created by sunheli on 16/8/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers.h"
#import "BYC_BackFocusListCellModel.h"
#import "HL_VideoPlayPageModel.h"
#import "WX_ScriptModel.h"


@interface BYC_HttpServers (HL_VideoPlayVC)

/**   视频播放界面信息 */
+(void)requestVideoPlayInfoWithWithParameters:(NSDictionary *)parameters success:(void (^)(HL_VideoPlayPageModel *videoPlayPageModel))success failure:(void (^)(NSError *error))failure;

/** 查询剧本信息 */
+(void)requestVideoPlayVCscriptModelOnNetWithParameters:(id)parameters success:(void (^)(WX_ScriptModel *scriptModel))success failure:(void (^)(NSError *error))failure;

/** 删除评论 */
+(void)requestVideoPlayVCDeletCommentsWithParameters:(id)parameters success:(void (^)(BOOL isDeletSuccess))success failure:(void (^)(NSError *error))failure;

/**  举报 */
 +(void)requestVideoPlayVCReportWithParameters:(NSDictionary *)parameters;

/**
 *  视频点击量
 */
+(void)requestVideoPlayVCPlayedCountWithParameters:(id)parameters Success:(void(^)(void))success failure:(void (^)(void))failure;

/**
 *  上传评论
 */
+(void)requestVideoPlayVCUploadCommentWithParameters:(NSDictionary *)parameters Success:(void (^)(BOOL isUploadSuccess))success failure:(void (^)(NSError *error))failure;

@end
