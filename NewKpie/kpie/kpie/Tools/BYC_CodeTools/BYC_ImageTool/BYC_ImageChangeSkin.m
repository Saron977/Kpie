//
//  BYC_ImageChangeSkin.m
//  kpie
//
//  Created by 元朝 on 16/2/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ImageChangeSkin.h"


#define DicCacheSkinZipPath(ImageName) [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"ThemePictures/SkinPictrue/%@",ImageName]]

@implementation BYC_ImageChangeSkin

+(UIImage *)getImageNamed:(NSString *)name {
    
    if([name rangeOfString:@".png"].location == NSNotFound)
        name = [NSString stringWithFormat:@"%@.png",name];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:DicCacheSkinZipPath(name)])
         return [UIImage imageWithContentsOfFile:DicCacheSkinZipPath(name)];
    else return [UIImage imageNamed:name];
}

/**
 *  换肤
 *
 *  @param name 图片的名字，注意后台必须和本地名字一样
 *
 *  @return 返回图片字典
 */
+(NSDictionary *)getDicImageNamed:(NSString *)name {

    if (![name isEqualToString:[NSString stringWithFormat:@"%@.png",name]])
        name = [NSString stringWithFormat:@"%@.png",name];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:DicCacheSkinZipPath(name)])
         return @{@"ImageName":name,@"Image":[UIImage imageWithContentsOfFile:DicCacheSkinZipPath(name)]};
    else return @{@"ImageName":name,@"Image":[UIImage imageNamed:name]};
}

@end
