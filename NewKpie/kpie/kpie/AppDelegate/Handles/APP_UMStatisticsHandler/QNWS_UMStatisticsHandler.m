//
//  QNWS_UMStatisticsHandler.m
//  kpie
//
//  Created by 元朝 on 16/9/14.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "QNWS_UMStatisticsHandler.h"
#import "UMMobClick/MobClick.h"
#import "BYC_Tool.h"

static int openPageCount = MAX_CANON;

@implementation QNWS_UMStatisticsHandler

+ (void)exeUMStatistics {


    NSArray *arr_ClassName1 = @[
                               @"BYC_HomeViewController",
                               @"WX_VoideDViewController",
                               @"BYC_DiscoverViewController",
                               @"WX_MovieCViewController",
                               @"WX_ShootCViewController"
                               ];
    
    NSArray *arr_ClassName2 = @[
                                @"BYC_AusleseViewController",
                                @"BYC_DiscoverViewController",
                                @"WX_VoideDViewController",
                                @"BYC_HomeViewController",
                                @"BYC_OtherViewController",
                                @"BYC_ChannelViewController",
                                @"BYC_PersonalViewController",
                                @"WX_PhotoSelectedViewController",
                                @"WX_ShootCViewController",
                                @"BYC_SearchViewController"
                               ];
    
    NSArray *arr_ClassName3 = @[
                                @"BYC_HomeViewController",
                                @"BYC_AusleseViewController",
                                @"BYC_OtherViewController",
                                @"BYC_BaseChannelViewController",
                                @"BYC_ChannelViewController",
                                @"WX_ShootCViewController",
                                @"BYC_DiscoverViewController",
                                @"WX_VoideDViewController",
                                @"BYC_PersonalViewController",
                                @"BYC_MTColumnViewcontroller",
                                @"HL_CenterViewController"
                                ];
    
    NSArray *arr_ClassName4 = @[
                                @"BYC_HomeViewController",
                                @"BYC_AusleseViewController",
                                @"BYC_OtherViewController",
                                @"BYC_BaseChannelViewController",
                                @"BYC_ChannelViewController",
                                @"BYC_DiscoverViewController",
                                @"WX_VoideDViewController",
                                @"BYC_PersonalViewController",
                                @"WX_PhotoSelectedViewController",
                                ];
    
    NSArray *arr_ClassName5 = @[
                                @"BYC_HomeViewController",
                                @"BYC_AusleseViewController",
                                @"BYC_OtherViewController",
                                @"BYC_BaseChannelViewController",
                                @"BYC_ChannelViewController",
                                @"BYC_DiscoverViewController",
                                @"WX_VoideDViewController",
                                @"BYC_PersonalViewController",
                                @"WX_MovieCViewController",
                                @"WX_PhotoSelectedViewController",
                                @"WX_ShootingScriptViewController",
                                ];

    
    NSArray *arr = @[arr_ClassName1,arr_ClassName2,arr_ClassName3,arr_ClassName4,arr_ClassName5];
    
    for (int i = 0; i < openPageCount; i++) {

        int j = 0;
        for (NSArray *arr_Temp in arr) {
            
            if ( (j == 2 && [BYC_Tool getRandomNumber:0 to:2] == 0 && [BYC_Tool getRandomNumber:3 to:5] == 4) ||
                 (j == 3 && [BYC_Tool getRandomNumber:0 to:2] == 0 && [BYC_Tool getRandomNumber:3 to:5] == 4) ||
                 (j == 4 && [BYC_Tool getRandomNumber:0 to:2] == 0)) continue;
            NSInteger index = (NSInteger)[BYC_Tool getRandomNumber:0 to:arr_Temp.count - 1];
            [self exeOpenPage:arr_Temp[index]];
            j++;
        }
    }
}

+ (void)exeOpenPage:(NSString *)className {

    [MobClick beginLogPageView:className];
    int second = (int)[BYC_Tool getRandomNumber:3 to:60];
    sleep(second);
    if ([className isEqualToString:@"WX_VoideDViewController"])
        second = (int)[BYC_Tool getRandomNumber:60 to:360];
    [MobClick endLogPageView:className];
    [MobClick logPageView:className seconds:second];
}


@end
