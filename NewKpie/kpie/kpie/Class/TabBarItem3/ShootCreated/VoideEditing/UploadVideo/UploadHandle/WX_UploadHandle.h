//
//  WX_UploadHandle.h
//  kpie
//
//  Created by 王傲擎 on 16/9/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WX_UploadVideoViewController.h"
#import "WX_UploadHandleModel.h"
#import "WX_DBBoxModel.h"
#import "WX_ShareModel.h"
#import "WX_ShareHandle.h"

@protocol WX_UploadHandleDelegate <NSObject>


@end

typedef enum {
    ENUM_WriteSuccess   =   0,  /**<   写入成功 */
    ENUM_UpdataSuccess  =   1,  /**<   更新成功 */
    ENUM_AlreadyExisted =   2,  /**<   文件已存在 */
}ENUM_WriteToDBoxType;

@interface WX_UploadHandle : NSObject 

QNWSSingleton_interface(WX_UploadHandle)


@property (nonatomic, weak  ) id<WX_UploadHandleDelegate>     delegate;         /**<   代理 */

@property (nonatomic, assign) BOOL                             isUploading;      /**<   视频是否正在上传 */

+(void)uploadVideoWithModel:(WX_UploadHandleModel*)model;   /**<   上传视频 */

+(void)writeToDraftBoxModel:(WX_DBBoxModel*)model Compeleted:(void(^)(ENUM_WriteToDBoxType type))complete;     /**<   存入草稿箱 */

/**
 分享
 
 @param model           分享模型
 @param counts          分享次数
 @param isShareQQ       是否分享到qq
 @param isShareWeChat   是否分享到微信
 @param isWeChatMonents 是否分享到朋友圈
 @param isShareWeiBo    是否分享到微博
 */

+(void)WX_ShareVideoWithModel:(WX_ShareModel*)model NeedShareCounts:(NSInteger)counts ShareQQ:(BOOL)isShareQQ ShareWeChat:(BOOL)isShareWeChat ShareWeChatMonents:(BOOL)isWeChatMonents ShareWeiBo:(BOOL)isShareWeiBo;
@end
