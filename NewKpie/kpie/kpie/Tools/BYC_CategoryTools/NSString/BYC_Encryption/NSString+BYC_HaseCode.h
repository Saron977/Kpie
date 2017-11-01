//
//  NSString+BYC_HaseCode.h
//  kpie
//
//  Created by 元朝 on 15/11/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ENUM_ResourceType) {
    /*
     1、图片                    sz-kpie-jpg   根目录下的子目录 :存入视频截图
     2、视频、语音               sz-kpie-videos根目录下的子目录 :存入视频
     3、测试(图片、视频、语音文件) sz-kpie-test   根目录下的子目录 : 存入视频、视频截图
     */
    ENUM_ResourceTypeVideos  = 1,
    /*
     1、图片                    sz-kpie-jpg   根目录下无此子目录
     2、视频、语音               sz-kpie-videos根目录下的子目录 :存入语音
     3、测试(图片、视频、语音文件) sz-kpie-test   根目录下的子目录 :存入语音
     */
    ENUM_ResourceTypeVoices,
    /*
     1、图片                    sz-kpie-jpg   根目录下的子目录 :存入用户头像
     2、视频、语音               sz-kpie-videos根目录无此子目录
     3、测试(图片、视频、语音文件) sz-kpie-test   根目录下的子目录 :存入用户头像
     */
    
    ENUM_ResourceTypeUsers,
    /*
     1、图片                    sz-kpie-jpg   根目录下的子目录 :存入素材视频截图
     2、视频、语音               sz-kpie-videos根目录下的子目录 :存入素材视频
     3、测试(图片、视频、语音文件) sz-kpie-test   根目录下的子目录 :存入素材视频、素材视频截图
     */
    ENUM_ResourceTypeMaterials,
};


@interface NSString (BYC_HaseCode)
/**
 *  javaHashCode
 *
 *  @return  javaHashCode
 */
- (int)javaHashCode;

+ (NSString *)createFileName:(NSString *)fileName andType:(ENUM_ResourceType)resourceType;

/**
 *  Emoji表情的判断
 *
 *  @param string 需要判断的字符串
 *
 *  @return 返回判断结果：YES包含Emoji表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;
@end
