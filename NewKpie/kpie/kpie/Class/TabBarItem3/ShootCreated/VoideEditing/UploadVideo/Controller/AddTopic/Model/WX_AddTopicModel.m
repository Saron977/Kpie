//
//  WX_AddTopicModel.m
//  kpie
//
//  Created by 王傲擎 on 15/11/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_AddTopicModel.h"
#import "WX_ToolClass.h"

@implementation WX_AddTopicModel


-(void)saveDataWithDic:(NSDictionary *)topicDic
{

    self.themeID         =       topicDic[@"themeid"];
    self.themeName       =       topicDic[@"themename"];
    self.views           =       topicDic[@"views"];
    self.createDate      =       [WX_ToolClass getDateWithFormatter:topicDic[@"createdate"]];
}

@end
