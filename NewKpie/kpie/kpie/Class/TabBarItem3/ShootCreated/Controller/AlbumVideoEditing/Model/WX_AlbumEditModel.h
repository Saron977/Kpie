//
//  WX_AlbumEditModel.h
//  kpie
//
//  Created by 王傲擎 on 16/1/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_AlbumEditModel : NSObject

/* 从相册写入沙盒 (调用ffmpeg 写入路径) */
@property(nonatomic,retain) NSString            *albumWriteToSanboxPath;

/* 调用ffmpeg 写出路径 */
@property(nonatomic,retain) NSString            *ffmpegWriteToSanboxPath;

/* 视频起始时间 */
@property(nonatomic,assign) NSInteger           videoStartTime;

/* 视频结束时间 */
@property(nonatomic,assign) NSInteger           videoEndTime;

/* 视频时长 */
@property(nonatomic,assign) NSInteger           videoDuration;

/* 视频高度 */
@property(nonatomic,assign) NSInteger           videoHeight;

/* 视频宽度 */
@property(nonatomic,assign) NSInteger           videoWidth;

/* 视频编辑方向  横向 剪辑宽度   */
@property(nonatomic,assign) BOOL                videoDirectionX;

/* 视频编辑方向  纵向 剪辑高度 */
@property(nonatomic,assign) BOOL                videoDirectionY;
/* 视频剪辑 _X */
@property(nonatomic,assign) NSInteger           videoOfSetX;

/* 视频剪辑 _Y */
@property(nonatomic,assign) NSInteger           videoOfSetY;

/* 视频名称 */
@property(nonatomic,strong) NSString            *videoTitle;

/**
 *  视频输出宽度
 */
@property(nonatomic, assign) NSInteger         OutputVideoWidth;
/**
 *  视频输出高度
 */
@property(nonatomic, assign)NSInteger           OutputVideoHeight;


@end
