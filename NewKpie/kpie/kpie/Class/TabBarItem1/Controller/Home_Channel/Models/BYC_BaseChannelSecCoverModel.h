//
//  BYC_BaseChannelSecCoverModel.h
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//  栏目封面数据模型

#import "BYC_BaseModel.h"
#import "BYC_BaseVideoModel.h"

@interface BYC_BaseChannelSecCoverModel : BYC_BaseModel


@property (nonatomic, copy)  NSString  *secondcoverid;

@property (nonatomic, copy)  NSString  *secondcoverpath;

@property (nonatomic, copy)  NSString  *secondcovertype;

@property (nonatomic, copy)  NSString  *columnid;

@property (nonatomic, copy)  NSString  *secondcover;

@property (nonatomic, strong)  BYC_BaseVideoModel  *video;

@end
