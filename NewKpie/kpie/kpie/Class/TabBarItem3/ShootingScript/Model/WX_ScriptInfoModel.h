//
//  WX_ScriptInfoModel.h
//  kpie
//
//  Created by 王傲擎 on 16/5/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_ScriptInfoModel : NSObject

/****
 *
 *      videoLen_镜头信息_数据
 */
@property (nonatomic, copy)     NSString            *videoLen_actioninfo;       /**<    动作信息    */
@property (nonatomic, copy)     NSString            *videoLen_createdate;       /**<    创建时间    */
@property (nonatomic, assign)   NSString            *videoLen_hasnum;           /**<    已拍摄      */
@property (nonatomic, copy)     NSString            *videoLen_id;               /**<    镜头编号    */
@property (nonatomic, assign)   NSInteger           videoLen_lensid;            /**<    镜头号      */
@property (nonatomic, copy)     NSString            *videoLen_lensjpgurl;       /**<    视频镜头封面地址   */
@property (nonatomic, copy)     NSString            *videoLen_lensurl;          /**<    视频镜头地址     */
@property (nonatomic, copy)     NSString            *videoLen_sceneinfo;        /**<    景别信息      */
@property (nonatomic, copy)     NSString            *videoLen_scriptid;         /**<    所属剧本编号    */
@property (nonatomic, assign)   NSInteger           videoLen_shoots;            /**<    拍摄人数上限    */
@property (nonatomic, copy)     NSString            *videoLen_talkinfo;         /**<    对话信息        */
@property (nonatomic, copy)     NSString            *videoLen_timelength;       /**<    拍摄时长        */

/****
 *
 *      自定义剧本信息
 */
@property (nonatomic, assign)   BOOL                isScriptShoot;              /**<    是否替换镜头    */
@property (nonatomic, copy)     NSString            *replace_ImgData;           /**<    替换图片    */
/*  剧本名 同意格式 剧本名1 剧本名2  */
@property (nonatomic, copy)     NSString            *videoLen_ShootName;        /**<    剧本名    */
/*  拍摄后都存在同一个目录下, 不需要路径, 只提供存储名就好 */
@property (nonatomic, copy)     NSString            *replace_ShootName;         /**<    替换名字    */
@property (nonatomic, copy)     NSString            *replace_ShootDuration;     /**<    替换时长    */


@end
