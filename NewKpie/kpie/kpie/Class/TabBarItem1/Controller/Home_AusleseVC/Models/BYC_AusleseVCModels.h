//
//  BYC_AusleseVCModels.h
//  kpie
//
//  Created by 元朝 on 16/8/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseVideoModel.h"
#import "BYC_MotifModel.h"


@interface BYC_AusleseVCModels : NSObject

/**精选的头标主题数据*/
@property (nonatomic, strong) NSArray <BYC_MotifModel      *> *arr_MotifModels;
/**精选的banner数据*/
@property (nonatomic, strong) NSArray <BYC_BaseVideoModel  *> *arr_BannerModels;
/**精选的推荐数据*/
@property (nonatomic, strong) NSArray <BYC_BaseVideoModel  *> *arr_RecommendModels;
/**精选视频数据*/
@property (nonatomic, strong) NSArray <BYC_BaseVideoModel  *> *arr_VideoModels;
@end
