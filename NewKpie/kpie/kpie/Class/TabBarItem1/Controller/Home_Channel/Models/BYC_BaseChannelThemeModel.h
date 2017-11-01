//
//  BYC_BaseChannelThemeModel.h
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//  话题数据模型

#import "BYC_BaseModel.h"

@interface BYC_BaseChannelThemeModel : BYC_BaseModel

@property (nonatomic, copy)  NSString  *themeid;

@property (nonatomic, copy)  NSString  *themename;

@property (nonatomic, copy)  NSString  *userid;

@property (nonatomic, assign)  NSInteger  views;

@property (nonatomic, assign)  NSInteger  createdate;

@property (nonatomic, assign)  NSInteger  elite;

@property (nonatomic, assign)  NSInteger  isshow;

@property (nonatomic, assign)  NSInteger  ishide;
@end
