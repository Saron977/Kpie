//
//  WX_VideoEditedModel.h
//  kpie
//
//  Created by 王傲擎 on 15/12/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_VideoEditedModel : NSObject

/// 视频编号
@property(nonatomic, assign) NSInteger      videoCount; /**<   视频编号 */

/// 视频编辑  开始时间
@property(nonatomic ,retain) NSNumber       *startTime; /**<   视频编辑  开始时间 */

/// 视频编辑  结束时间   (结束时间无修改,取值0)
@property(nonatomic, retain) NSNumber       *endTime; /**<   视频编辑  结束时间   (结束时间无修改,取值0) */

/// 视频路径
@property(nonatomic, retain) NSString       *videoPath; /**<   视频路径 */

/// 视频名称
@property(nonatomic, retain) NSString       *videoTitle; /**<   视频名称 */

/// 视频长度
@property(nonatomic, strong) NSString       *videoDuration; /**<   视频长度 */

/// 2_合拍栏目跳转
@property(nonatomic, assign) NSInteger      isVR;   /**<   2_合拍栏目跳转 */

/// 合拍视频id
@property(nonatomic, copy) NSString         *videoID;   /**<   合拍视频id */

@property(nonatomic, assign) BOOL           isEndTime;  /**<   修改过时间 */



@end
