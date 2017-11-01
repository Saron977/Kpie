//
//  WX_UploadDisplay.h
//  kpie
//
//  Created by 王傲擎 on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ENUM_UploadDisplayDefault   =   0,  /**<   默认属性 */
    ENUM_UploadDisplayUploading =   1,  /**<   正在上传 */
    ENUM_UploadDisplayCompleted =   2,  /**<   上传完毕 */
}ENUM_UploadDisplayState;
@interface WX_UploadDisplay : UIView


/**
 创建视频上传进度
 */
+(void)createUploadDisplay;


/**
 设置进度

 @param value 进度值
 */
+(void)uploadValue:(CGFloat)value;



/**
 手动移除上传进度条,在视频上传失败时调用
 */
+(void)removeFromSuperview;


/**
 返回上传状态

 @return 返回状态
 */
+(ENUM_UploadDisplayState)returnUploadDisplayState;
@end
