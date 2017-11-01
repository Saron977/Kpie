//
//  BYC_HomeVCBannerModel.m
//  kpie
//
//  Created by 元朝 on 16/1/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HomeVCBannerModel.h"

@implementation BYC_HomeVCBannerModel

+ (instancetype)initModelWithArray:(NSArray *)array {
    
    BYC_HomeVCBannerModel *model = [super initModelWithArray:array];
    switch ([(NSNumber *)array[19] intValue]) {
        case 0:
            model.modelType = HomeVCBannerModelTypeVedio;
            model.type      = ENUM_HomeVCBannerTypeNormal;
            break;
        case 1:
            model.modelType = HomeVCBannerModelTypeTeacher;
            model.type      = ENUM_HomeVCBannerTypeAction;
            break;
        case 2:
            model.modelType = HomeVCBannerModelTypeWeb;
            model.type      = ENUM_HomeVCBannerTypeNormal;
            break;
        case 3:
            model.modelType = HomeVCBannerModelTypeBikini;
            model.type      = ENUM_HomeVCBannerTypeAction;
            break;
        case 4:
            model.modelType = HomeVCBannerModelTypeSakura;
            model.type      = ENUM_HomeVCBannerTypeAction;
            break;
        case 5:
            model.modelType = HomeVCBannerModelTypeInStep;
            model.type      = ENUM_HomeVCBannerTypeAction;
            break;
        case 6:
            model.modelType = HomeVCBannerModelTypeMononoke;
            model.type      = ENUM_HomeVCBannerTypeAction;
            break;
        default:
            model.modelType = HomeVCBannerModelTypeImage;
            model.type      = ENUM_HomeVCBannerTypeNormal;
            break;
    }
     model.isvr = [(NSNumber *)array[20] integerValue];
    return model;//(0不是名师1是名声));
}

@end
