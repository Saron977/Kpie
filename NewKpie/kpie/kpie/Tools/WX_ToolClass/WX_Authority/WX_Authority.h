//
//  WX_Authority.h
//  Photo
//
//  Created by 王傲擎 on 2017/4/26.
//  Copyright © 2017年 王傲擎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_Authority : NSObject


/**
 摄像头_权限检测

 @param authority 返回 1_有权限 0_无权限(已做给提示的处理)
 */

+(void)WX_AuthorityVideoDetection:(void(^)(BOOL authority))authority;

/**
 麦克风_权限检测
 
 @param authority 返回 1_有权限 0_无权限(已做给提示的处理)
 */

+(void)WX_AuthorityAudioDetection:(void(^)(BOOL authorited))authorited;

/**
 相册_权限检测
 
 @param authority 返回 1_有权限 0_无权限(已做给提示的处理)
 */

+(void)WX_AuthorityPhotoDetection:(void(^)(BOOL authority))authority;

@end
