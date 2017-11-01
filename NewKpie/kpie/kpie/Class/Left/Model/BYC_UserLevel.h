//
//  BYC_UserLevel.h
//  kpie
//
//  Created by 元朝 on 16/10/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface BYC_UserLevel : BYC_BaseModel

@property (nonatomic, copy) NSString *levelid;

@property (nonatomic, assign) NSInteger levelname;

@property (nonatomic, assign) NSInteger mingrowth;

@property (nonatomic, assign) NSInteger maxgrowth;

@property (nonatomic, copy) NSString *levelimg;

@property (nonatomic, copy) NSString *titleid;
@end
