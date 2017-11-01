//
//  WX_MusicModel.m
//  kpie
//
//  Created by 王傲擎 on 15/12/16.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_MusicModel.h"

@implementation WX_MusicModel

+(instancetype)initModelWithDic:(NSDictionary *)dic
{
    WX_MusicModel *model = [[self alloc]init];

    model.musicID           =   dic[@"musicid"];
    
    model.musicName         =   dic[@"musicname"];
    
    model.musicUrl          =   dic[@"musicurl"];
    
    model.pictureJPG        =   dic[@"picturejpg"];
    
    model.musicType         =   dic[@"musictype"];
    
    model.timeStamp         =   dic[@"uploadtime"];
    
    return model;
}
@end
