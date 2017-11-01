//
//  WX_EditingShootingModel.h
//  kpie
//
//  Created by 王傲擎 on 16/7/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_MediaInfoModel.h"

@interface WX_EditingShootingModel : WX_MediaInfoModel

@property (nonatomic, copy  ) NSString                  *str_Replace;       /**<   替换文字 */
@property (nonatomic, copy  ) NSString                  *str_ImgPath;       /**<   图片路径 */
@property (nonatomic, assign) CGFloat                   offset_Label_X;     /**<   图片文字偏移__X */
@property (nonatomic, assign) CGFloat                   offset_Label_Y;     /**<   图片文字偏移__Y */
@property (nonatomic, assign) CGFloat                   label_Width;        /**<   图片文字宽 */
@property (nonatomic, assign) CGFloat                   label_Height;       /**<   图片文字高 */
@property (nonatomic, assign) CGRect                    rect_Label;         /**<   图片文字label size */
@property (nonatomic, assign) NSInteger                 templateNO;         /**<   效果编号 */
@property (nonatomic, assign) CGFloat                   time_Offset;        /**<   文字出现时间偏移值 */
@property (nonatomic, assign) CGFloat                   videoFadeIn;        /**<   文字淡入效果时长 */
@property (nonatomic, assign) CGFloat                   overlayMax;         /**<   隐藏文字时间点值 */
@property (nonatomic, assign) CGFloat                   font_StrSize;       /**<   合拍模板文字大小 */
@property (nonatomic, copy  ) NSString                  *font_Color;        /**<   字体颜色_16进制 */
@property (nonatomic, copy  ) NSString                  *path_OutFile;      /**<   文件输出路径 */


@end
