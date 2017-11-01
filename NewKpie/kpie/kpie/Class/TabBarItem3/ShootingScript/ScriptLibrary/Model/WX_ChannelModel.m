//
//  WX_ChannelModel.m
//  kpie
//
//  Created by 王傲擎 on 16/4/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ChannelModel.h"
#import "WX_ToolClass.h"
@implementation WX_ChannelModel

+(instancetype)initModelWithDic:(NSDictionary *)dic
{
    WX_ChannelModel *model = [[self alloc]init];
    
    model.channelID = dic[@"channelid"];
    
    model.channelName = dic[@"channelname"];
    
    model.channelDesc = dic[@"channeldesc"];
    
    model.onOffTime = [WX_ToolClass getDateWithFormatter:dic[@"onofftime"]];
    
    model.CTNum = [NSString stringWithFormat:@"%zi",[(NSNumber *)dic[@"scripts"] integerValue]];
    
    return model;
}

@end
