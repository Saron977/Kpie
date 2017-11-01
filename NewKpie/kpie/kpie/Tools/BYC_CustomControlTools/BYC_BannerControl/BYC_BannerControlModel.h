//
//  BYC_BannerControlModel.h
//  kpie
//
//  Created by 元朝 on 16/7/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"


typedef NS_ENUM(NSUInteger, ENUM_BannerControlShowStyle) {
    
    /*展示纯图片*/
    ENUM_BannerControlShowStyleImage,
    /*展示视频*/
    ENUM_BannerControlShowStyleVideo,
};

@interface BYC_BannerControlModel : BYC_BaseModel

/**图片连接*/
@property (nonatomic, strong)  NSString  *str_ImageUrl;
/**标题*/
@property (nonatomic, strong)  NSString  *str_Title;
/**图片类型*/
@property (nonatomic, assign)  ENUM_BannerControlShowStyle  bannerControlShowStyle;
@end
