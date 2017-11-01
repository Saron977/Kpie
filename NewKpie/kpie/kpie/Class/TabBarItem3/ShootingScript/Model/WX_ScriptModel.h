//
//  WX_ScriptModel.h
//  kpie
//
//  Created by 王傲擎 on 16/3/31.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WX_ScriptInfoModel.h"

@interface WX_ScriptModel : BYC_BaseModel

//**  通过参数名获取数据：
@property (nonatomic, copy)     NSString            *channelid;                 /**<    所属剧本频道      */
@property (nonatomic, copy)     NSString            *createdate;                /**<    创建时间    */
@property (nonatomic, assign)   NSInteger           downloadcount;              /**<    下载量     */
@property (nonatomic, assign)   BOOL                elite;                      /**<    是否推荐 0否，1是  */
@property (nonatomic, copy)     NSString            *enddate;                   /**<    结束时间    */
@property (nonatomic, copy)     NSString            *scriptID;                   /**<    剧本编号    */
@property (nonatomic, assign)   NSInteger           isone;                      /**<    是否单人剧本  */
@property (nonatomic, copy)     NSString            *jpgurl;                    /**<    视频剧本封面图    */
@property (nonatomic, copy)     NSString            *onofftime;                 /**<    上架时间   */
@property (nonatomic, copy)     NSString            *scriptcontent;             /**<    剧本信息   */
@property (nonatomic, copy)     NSString            *scriptname;                /**<    剧本名称    */
@property (nonatomic, assign)   NSInteger           scripttype;                 /**<    脚本类型 __ 0文字版 1分镜头版 2视频版   */
@property (nonatomic, assign)   NSInteger           state;                      /**<    状态 0不发布 1发布   */
/****   
 *
 *      uInfo_
 */
//@property (nonatomic, copy)     NSString            *uInfo_city;                /**<    城市  */
//@property (nonatomic, copy)     NSString            *uInfo_emailaddres;         /**<    邮箱  */
//@property (nonatomic, copy)     NSString            *uInfo_facebook;            /**<    脸书  */
//@property (nonatomic, copy)     NSString            *uInfo_firstname;           /**<         */
//@property (nonatomic, copy)     NSString            *uInfo_headportrait;        /**<    发布者头像路径 */
//@property (nonatomic, copy)     NSString            *uInfo_lastname;            /**<         */
//@property (nonatomic, copy)     NSString            *uInfo_middlename;          /**<         */
//@property (nonatomic, copy)     NSString            *uInfo_mydescription;       /**<    个性签名    */
//@property (nonatomic, copy)     NSString            *uInfo_nationality;         /**<    国籍     */
//@property (nonatomic, copy)     NSString            *uInfo_nickname;            /**<    发布者昵称  */
/****
 *
 *      users_
 */
@property (nonatomic, assign)   BOOL                uInfo_users_sex;             /**<    性别（0男 1女）   */
@property (nonatomic, copy)     NSString            *uInfo_users_headportrait;   /**<    用户头像    */
@property (nonatomic, copy)     NSString            *uInfo_userid;               /**<    用户编号  */
@property (nonatomic, copy)     NSString            *uInfo_users_nickname;       /**<    用户昵称   */

@property (nonatomic, copy)     NSString            *userid;                     /**<    用户编号  */

/****
 *
 *      videoLen_镜头信息_数组
 *  
 *      存储 WX_ScriptInfoModel
 */

@property (nonatomic, strong)   NSMutableArray     *videoLenArray;               /**<   剧本镜头数组 */

///****
// *
// *      videoLen_镜头信息_数据
// */
//@property (nonatomic, copy)     NSString            *videoLen_actioninfo;       /**<    动作信息    */
//@property (nonatomic, copy)     NSString            *videoLen_createdate;       /**<    创建时间    */
//@property (nonatomic, assign)   NSString            *videoLen_hasnum;           /**<    已拍摄      */
//@property (nonatomic, copy)     NSString            *videoLen_id;               /**<    镜头编号    */
//@property (nonatomic, assign)   NSInteger           videoLen_lensid;            /**<    镜头号      */
//@property (nonatomic, copy)     NSString            *videoLen_lensjpgurl;       /**<    视频镜头封面地址   */
//@property (nonatomic, copy)     NSString            *videoLen_lensurl;          /**<    视频镜头地址     */
//@property (nonatomic, copy)     NSString            *videoLen_sceneinfo;        /**<    景别信息      */
//@property (nonatomic, copy)     NSString            *videoLen_scriptid;         /**<    所属剧本编号    */
//@property (nonatomic, assign)   NSInteger           videoLen_shoots;            /**<    拍摄人数上限    */
//@property (nonatomic, copy)     NSString            *videoLen_talkinfo;         /**<    对话信息        */
//@property (nonatomic, copy)     NSString            *videoLen_timelength;       /**<    拍摄时长        */
///****
// *
// *      videoLen_镜头信息_数据
// */
//@property (nonatomic, copy)     NSString            *videoLen_A_actioninfo;       /**<    动作信息    */
//@property (nonatomic, copy)     NSString            *videoLen_A_createdate;       /**<    创建时间    */
//@property (nonatomic, assign)   NSString            *videoLen_A_hasnum;           /**<    已拍摄      */
//@property (nonatomic, copy)     NSString            *videoLen_A_id;               /**<    镜头编号    */
//@property (nonatomic, assign)   NSInteger           videoLen_A_lensid;            /**<    镜头号      */
//@property (nonatomic, copy)     NSString            *videoLen_A_lensjpgurl;       /**<    视频镜头封面地址   */
//@property (nonatomic, copy)     NSString            *videoLen_A_lensurl;          /**<    视频镜头地址     */
//@property (nonatomic, copy)     NSString            *videoLen_A_sceneinfo;        /**<    景别信息      */
//@property (nonatomic, copy)     NSString            *videoLen_A_scriptid;         /**<    所属剧本编号    */
//@property (nonatomic, assign)   NSInteger           videoLen_A_shoots;            /**<    拍摄人数上限    */
//@property (nonatomic, copy)     NSString            *videoLen_A_talkinfo;         /**<    对话信息        */
//@property (nonatomic, copy)     NSString            *videoLen_A_timelength;       /**<    拍摄时长        */

/****
 *
 *      videoLen_B
 */
//@property (nonatomic, copy)     NSString            *videoLen_B_actioninfo;       /**<    动作信息    */
//@property (nonatomic, copy)     NSString            *videoLen_B_createdate;       /**<    创建时间    */
//@property (nonatomic, assign)   NSString            *videoLen_B_hasnum;           /**<    已拍摄      */
//@property (nonatomic, copy)     NSString            *videoLen_B_id;               /**<    镜头编号    */
//@property (nonatomic, assign)   NSInteger           videoLen_B_lensid;            /**<    镜头号      */
//@property (nonatomic, copy)     NSString            *videoLen_B_lensjpgurl;       /**<    视频镜头封面地址   */
//@property (nonatomic, copy)     NSString            *videoLen_B_lensurl;          /**<    视频镜头地址     */
//@property (nonatomic, copy)     NSString            *videoLen_B_sceneinfo;        /**<    景别信息      */
//@property (nonatomic, copy)     NSString            *videoLen_B_scriptid;         /**<    所属剧本编号    */
//@property (nonatomic, assign)   NSInteger           videoLen_B_shoots;            /**<    拍摄人数上限    */
//@property (nonatomic, copy)     NSString            *videoLen_B_talkinfo;         /**<    对话信息        */
//@property (nonatomic, copy)     NSString            *videoLen_B_timelength;       /**<    拍摄时长        */


/****
 *
 *      替换剧本
 */
@property (nonatomic, assign)   BOOL                isFromShooting;                /**<   来自拍摄需要替换剧本 */
//@property (nonatomic, copy)     NSString            *isScriptAOrB;                 /**<   剧本A 或者 B : A__A剧本  B__B剧本*/
//@property (nonatomic, copy)     NSString            *shoot_A_Name;                 /**<   替换A视频名字 */
//@property (nonatomic, copy)     NSString            *shoot_B_Name;                 /**<   替换B视频名字  */
//@property (nonatomic, copy)     NSString            *img_A_DataStr;                /**<   A_图片数据 */
//@property (nonatomic, copy)     NSString            *img_B_DataStr;                /**<   B_图片数据 */

+ (instancetype)initModelWithDic:(NSMutableDictionary *)dic;                        /**< 数组转模型 */
@end
