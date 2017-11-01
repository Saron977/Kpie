//
//  BYC_BaseChannelGroupModel.h
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//  栏目组数据模型

#import "BYC_BaseModel.h"


@interface BYC_BaseChannelGroupModel : BYC_BaseModel

@property (nonatomic, strong)  NSString  *groupid;

@property (nonatomic, strong)  NSString  *groupname;

@property (nonatomic, assign)  NSInteger createdate;

@property (nonatomic, strong)  NSString  *memo;

@property (nonatomic, assign)  NSInteger isshow;
@end
