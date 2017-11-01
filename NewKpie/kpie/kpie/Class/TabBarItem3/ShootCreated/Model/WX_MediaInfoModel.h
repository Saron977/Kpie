//
//  WX_MediaInfoModel.h
//  kpie
//
//  Created by 王傲擎 on 15/11/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_MediaInfoModel : BYC_BaseModel

@property(nonatomic, copy)   NSString       *title_Replace;    /**<   视频名,替换合拍栏目 */
@property(nonatomic, strong) NSString       *mediaTitle;
@property(nonatomic, strong) NSString       *createDate;
@property(nonatomic, strong) NSString       *imageDataStr;
@property(nonatomic, strong) NSString       *mediaPath;
@property(nonatomic, strong) NSString       *DurationStr;
@property(nonatomic, strong) NSString       *albumPath;

@property(nonatomic, strong) NSString       *mediaID;
@property(nonatomic, strong) NSString       *mediaUrl;
@property(nonatomic, strong) NSString       *pictureJPGUrl;

@property(nonatomic, strong) NSString       *durationSecond; /**< 时长 (秒)*/

@property(nonatomic, strong) NSString       *themeStr; /**< 添加话题 */
@property(nonatomic, assign) NSInteger      isVR;   /**<   是否合拍栏目视频  2__合拍栏目*/
@property(nonatomic, copy)   NSString       *media_Parameter;   /**<   合拍参数 */



@end
