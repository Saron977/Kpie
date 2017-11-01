//
//  BYC_HomeVCBannerModel.h
//  kpie
//
//  Created by 元朝 on 16/1/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseVideoModel.h"

typedef NS_ENUM(NSUInteger, HomeVCBannerModelType) {
    HomeVCBannerModelTypeVedio, //跳转到视频
    HomeVCBannerModelTypeTeacher, //跳转到名师点评
    HomeVCBannerModelTypeWeb, //跳转到网址
    HomeVCBannerModelTypeBikini, //跳转到比基尼大赛
    HomeVCBannerModelTypeSakura, //跳转到樱花栏目
    HomeVCBannerModelTypeInStep,//跳转到合拍
    HomeVCBannerModelTypeMononoke,//跳转到怪咖
    HomeVCBannerModelTypeImage, //纯展示图片
};

typedef NS_ENUM(NSUInteger, ENUM_HomeVCBannerType) {
    
    /*正常栏目*/
    ENUM_HomeVCBannerTypeNormal,
    /*活动栏目*/
    ENUM_HomeVCBannerTypeAction
};

@interface BYC_HomeVCBannerModel : BYC_BaseVideoModel

@property (nonatomic, assign) HomeVCBannerModelType  modelType;
/*是普通栏目 还是 活动栏目*/
@property (nonatomic, assign) ENUM_HomeVCBannerType   type;

@end
