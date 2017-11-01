//
//  WX_UploadHandleModel.h
//  kpie
//
//  Created by 王傲擎 on 16/9/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    ENUM_UploadDefault          =   0,  /**< 上传默认,开始上传*/
    ENUM_AliyunVideoSuccess     =   1,  /**< 阿里云视频上传成功*/
    ENUM_AliyunVideoFail        =   2,  /**< 阿里云视频上传失败*/
    
    ENUM_AliyunImageSuccess     =   3,  /**< 阿里云封面上传成功*/
    ENUM_AliyunImageFail        =   4,  /**< 阿里云封面上传失败*/
    
    ENUM_KpieSuccess            =   5,  /**< 看拍上传成功*/
    ENUM_KpieFail               =   6,  /**< 看拍上传失败*/
    
}ENUM_UploadType;

@interface WX_UploadHandleModel : BYC_BaseModel
@property (nonatomic, copy  ) NSString              *key_Video;         /**<   阿里云上传,视频key */
@property (nonatomic, copy  ) NSString              *key_Image;         /**<   阿里云上传,封面key */
@property (nonatomic, strong) NSData                *data_Video;        /**<   视频数据,上传阿里云 */
@property (nonatomic, strong) NSData                *data_Image;        /**<   封面数据,长传阿里云 */
@property (nonatomic ,copy  ) NSString              *path_Video;        /**<   视频上传路径(上传阿里云成功后,次路径有效) */
@property (nonatomic, copy  ) NSString              *path_Image;        /**<   封面上传路径(上传阿里云成功后,次路径有效) */
@property (nonatomic, copy  ) NSString              *title_Video;       /**<   视频标题(现在传空,nil) */
@property (nonatomic, copy  ) NSString              *userID_Video;      /**<   视频上传用户 */
@property (nonatomic, copy  ) NSString              *strID_Video;       /**<   剧本id(没有传nil) */
@property (nonatomic, copy  ) NSString              *gpsX_Video;        /**<   经度 */
@property (nonatomic, copy  ) NSString              *gpsY_Video;        /**<   纬度 */
@property (nonatomic, copy  ) NSString              *themeid_Video;     /**<   话题 */
@property (nonatomic, copy  ) NSString              *description_video; /**<   视频描述 */
@property (nonatomic, copy  ) NSString              *token_User;        /**<   用户token */
@property (nonatomic, copy  ) NSString              *userID_User;       /**<   用户id */
@property (nonatomic, copy  ) NSString              *teachApply;        /**<   类型(名师点评) */
@property (nonatomic, assign) NSInteger             videoId_VideoType;  /**<   类型(2_合拍) */
@property (nonatomic, copy  ) NSString              *videoID_Activity;  /**<   视频id(活动) */

@property (nonatomic, copy  ) NSString              *loaction;          /**<   位置信息 */
@property (nonatomic, copy  ) NSString              *str_ImageData;     /**<   图片数据 */
@property (nonatomic, assign) BOOL                  isFromDraftBox;     /**<   是否来自草稿箱 */
@property (nonatomic, copy  ) NSString              *title_DraftBox;    /**<   存储在草稿箱中名字(上传成功后,删除) */

@property (nonatomic, assign) ENUM_UploadType       ENUM_UploadType;      /**<   阿里云上传视频成功 */

@end
