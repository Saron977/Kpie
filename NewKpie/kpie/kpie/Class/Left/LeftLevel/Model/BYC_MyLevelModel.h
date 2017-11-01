//
//  BYC_UpgradeDescriptionModel.h
//  kpie
//
//  Created by 元朝 on 16/10/24.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface BYC_MyLevelModel : BYC_BaseModel

/**每日最大可获得积分*/
@property (nonatomic, copy)  NSString  *daylimit;
/**积分名称*/
@property (nonatomic, copy)  NSString  *eventname;
/***/
@property (nonatomic, copy)  NSString  *growth;
/***/
@property (nonatomic, copy)  NSString  *score;

@end
