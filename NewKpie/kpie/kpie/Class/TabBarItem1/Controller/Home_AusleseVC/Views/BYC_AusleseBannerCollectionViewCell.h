//
//  BYC_AusleseBannerCollectionViewCell.h
//  kpie
//
//  Created by 元朝 on 16/7/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_AusleseVCBannerModel.h"

typedef NS_ENUM(NSUInteger, ENUM_AusleseBannerModelType) {
    ENUM_AusleseBannerModelTypeVedio, //跳转到视频
    ENUM_AusleseBannerModelTypeTeacher, //跳转到名师点评
    ENUM_AusleseBannerModelTypeWeb, //跳转到网址
    ENUM_AusleseBannerModelTypeBikini, //跳转到比基尼大赛
    ENUM_AusleseBannerModelTypeSakura,//跳转到世纪樱花
    ENUM_AusleseBannerModelTypeInStep,//跳转到世纪樱花
    ENUM_AusleseBannerModelTypeImage, //纯展示图片
};

@interface BYC_AusleseBannerCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) ENUM_AusleseBannerModelType   modelType;

/**精选的banner数据*/
@property (nonatomic, strong) NSArray <BYC_BaseVideoModel    *> *arr_BannerModels;
@end
