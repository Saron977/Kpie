//
//  WX_ToolClass.h
//  kpie
//
//  Created by 王傲擎 on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ENUM_BoldSystem         =   0,  /**<   加粗 */
    ENUM_NormalSystem       =   1,  /**<   正常 */
}WX_FontSystem;

@interface WX_ToolClass : NSObject

@property (nonatomic, assign) NSInteger     num_Dispath;        /**<   监听数值变化 */
@property (nonatomic, assign) BOOL          bool_Dispath;       /**<   监听数值变化 */

+(CGSize)changeSizeWithString:(NSString*)str FontOfSize:(CGFloat)fontNum bold:(WX_FontSystem)fontSystem;       /**<   传入字体大小, 长度返回 文字size */

+(NSString*)TimeformatFromSeconds:(NSInteger)seconds;                           /**<   传入秒数,返回 00:00 格式 */

+(UIImage*)convertViewToImage:(UIView*)image;                                   /**<   传入view,返回image */

+(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;   /**<   传入图片,尺寸, 返回想要的尺寸 */

+(NSString*)getDateWithType:(NSInteger)type;        /**<   获取当前时间 */


/**
 返回时间_时间戳

 @param dateFormatter 时间戳

 @return 返回时间
 */
+(NSString*)getDateWithFormatter:(NSString*)dateFormatter;

/**
 *  16进制颜色转换
 *
 *  @param color 16进制颜色(NSString)
 *
 *  @return 返回颜色UIColor
 */
+(UIColor *)colorWithHexString:(NSString *)color;


/**
 *  获取视频某一帧
 *
 *  @param videoURL 视频地址(本地/网络
 *  @param time     第N帧
 *
 *  @return 返回图片 image
 */
+(UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(CMTime)time; /**<   获取视频某一帧图片image(单个) 按帧数fps  */


/**
 *  获取视频帧数图片image
 *
 *  @param fileUrl        本地视频文件URL
 *  @param fps            拆分时按此帧率进行拆分
 *  @param completedBlock 所有帧被拆完成后回调
 */
+ (void)splitVideo:(NSURL *)fileUrl fps:(float)fps completedBlock:(void(^)(NSMutableArray *array_Cover))completedBlock; /**<   获取视频帧数图片image(多个) 按帧数fps */


/**
 *  获取视频帧数图片image
 *
 *  @param fileUrl        本地视频文件URL
 *  @param totalFrames    按需要获取到图片数量拆分
 *  @param completedBlock 所有帧被拆完成后回调
 */
+ (void)splitVideo:(NSURL *)fileUrl photosCount:(Float64)photosCount completedBlock:(void(^)(NSMutableArray *array_Cover))completedBlock; /**<   获取视频帧数图片image(多个) 按需要获取到图片数量拆分photosCount */


/**
 *  把视频文件拆成图片保存在沙盒中
 *
 *  @param fileUrl        本地视频文件URL
 *  @param fps            拆分时按此帧率进行拆分
 *  @param completedBlock 所有帧被拆完成后回调
 */
+ (void)splitVideoSaveToSanBoxWithFileUrl:(NSURL *)fileUrl fps:(float)fps completedBlock:(void(^)(NSMutableArray *array_Cover))completedBlock; /**<   获取视频帧数图片image(多个) 并保存到沙盒 按帧数fps */

/**
 *  图片转换data
 *
 *  @param image 传入图片
 *
 *  @return 返回图片data
 */
+(NSData*)achieveDataWithImage:(UIImage*)image;  /**<   传入图片,返回图片data */


/**
 获取当前控制器

 @return 获取当前界面控制器
 */
+ (UIViewController *)getCurrentVC; /**<   获取当前界面控制器 */


/**
 确认相册权限

 @return 1__允许访问, 0__不需访问
 */
+(BOOL)ConfirmedForPhotoAlbumPermissions;



@end
