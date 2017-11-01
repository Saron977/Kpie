//
//  BYC_BaseChannelDataModel.h
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//  频道数据模型

#import "BYC_BaseModel.h"

@interface BYC_BaseChannelDataModel : BYC_BaseModel

/**频道编号*/
@property (nonatomic, strong)  NSString  *channelid;
/**频道名称*/
@property (nonatomic, strong)  NSString  *channelname;
/**频道背景图*/
@property (nonatomic, strong)  NSString  *channelimg;
/**序号*/
@property (nonatomic, assign)  NSInteger  number;

@property (nonatomic, strong)  NSString  *channeldesc;

@property (nonatomic, strong)  NSString  *createdate;

@property (nonatomic, strong)  NSString  *motifid;
@end
