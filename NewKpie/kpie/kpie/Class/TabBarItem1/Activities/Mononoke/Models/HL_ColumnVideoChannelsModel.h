//
//  HL_ColumnVideoChannelsModel.h
//  kpie
//
//  Created by sunheli on 16/10/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface HL_ColumnVideoChannelsModel : BYC_BaseModel

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, copy) NSString *motifid;

@property (nonatomic, assign) NSInteger createdate;

@property (nonatomic, copy) NSString *channeldesc;

@property (nonatomic, copy) NSString *channelimg;

@property (nonatomic, copy) NSString *channelid;

@property (nonatomic, copy) NSString *channelname;

@end
