//
//  BYC_BaseChannelModels.m
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelModels.h"


@implementation BYC_BaseChannelModels

+ (instancetype)baseChannelChildModel {
    
    BYC_BaseChannelModels *model = [BYC_BaseChannelModels new];
    return model;
}

- (void)baseChannelChildModelWithVideoModels:(NSArray <BYC_BaseChannelVideoModel *> *)arr_VideoModels themeModels:(NSArray <BYC_BaseChannelThemeModel *> *)arr_ThemeModels groupModels:(NSArray <BYC_BaseChannelGroupModel *> *)arr_GroupModels secCoverModels:(NSArray <BYC_BaseChannelSecCoverModel *> *)arr_SecCoverModels andShareUrl:(NSString *)shareUrl{

    if (arr_VideoModels.count > 0) self.arr_VideoModels       = arr_VideoModels;
    if (arr_ThemeModels.count > 0) self.arr_ThemeModels       = arr_ThemeModels;
    if (arr_GroupModels.count > 0) self.arr_GroupModels       = arr_GroupModels;
    if (arr_SecCoverModels.count > 0) self.arr_SecCoverModels = arr_SecCoverModels;
    if (shareUrl.length > 0) self.str_ShareUrl = shareUrl;
}
@end
