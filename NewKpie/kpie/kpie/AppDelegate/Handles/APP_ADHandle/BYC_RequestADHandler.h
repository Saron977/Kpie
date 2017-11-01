//
//  BYC_RequestADHandler.h
//  kpie
//
//  Created by 元朝 on 16/8/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_ADModel.h"

@interface BYC_RequestADHandler : NSObject

/** 广告数据*/
//@property (nonatomic, strong)  NSDictionary *respondDataDic;
/** 广告数据*/
@property (nonatomic, strong)  BYC_ADModel *model_AD;
+ (instancetype)requestADHandlerWithBlock:(void(^)())block;

@end
