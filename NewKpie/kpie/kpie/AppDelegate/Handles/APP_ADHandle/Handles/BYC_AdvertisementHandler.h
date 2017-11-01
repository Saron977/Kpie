//
//  BYC_HomeVCAdvertisementHandler.h
//  kpie
//
//  Created by 元朝 on 16/7/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_AdvertisementHandler : NSObject

/**
 *  处理广告
 */
+ (void)handleOfAdvertisement;

/**
 *  是否点击全屏广告之后再回到首页又继续展示卡片广告
 */
+ (void)viewWillAppearShowAD;
@end
