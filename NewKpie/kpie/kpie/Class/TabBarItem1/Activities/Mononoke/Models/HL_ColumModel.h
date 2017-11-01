//
//  HL_ColumModel.h
//  kpie
//
//  Created by sunheli on 16/10/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_MotifModel.h"
#import "BYC_BaseVideoModel.h"
#import "BYC_MTVideoGroupModel.h"
#import "HL_ColumnVideoThemeModel.h"
#import "HL_ColumnVideoChannelsModel.h"
#import "BYC_MTBannerModel.h"
#import "BYC_OtherViewControllerModel.h"
#import "HL_ColumnVideoSortModel.h"
#import "HL_ColumnVideoScriptModel.h"

@interface HL_ColumModel : NSObject

/**精选的头标主题数据*/
@property (nonatomic, strong) NSArray <BYC_MotifModel      *> *arr_MotifModels;

/** 活动分类数据 */
@property (nonatomic, strong) NSArray <BYC_MTVideoGroupModel  *> *arr_GroupModels;

/** Cell视频数据 */
@property (nonatomic, strong) NSArray <BYC_BaseVideoModel  *> *arr_VideoModels;

/**Theme数据*/
@property (nonatomic, strong) NSArray <HL_ColumnVideoThemeModel  *> *arr_ThemeModels;

/**精选视频数据*/
@property (nonatomic, strong) NSArray <HL_ColumnVideoChannelsModel  *> *arr_ChannelModels;

/** banner数据 */
@property (nonatomic, strong) NSArray <BYC_MTBannerModel      *>            *arr_BannerModel;

@property (nonatomic, strong) BYC_OtherViewControllerModel                  *columnModel;

@property (nonatomic, strong) NSArray <HL_ColumnVideoSortModel *>           *arr_ColumnVideoSortModel;

@property (nonatomic, strong) NSArray <HL_ColumnVideoScriptModel *>         *arr_ColumnVideoScriptModel;


@end
