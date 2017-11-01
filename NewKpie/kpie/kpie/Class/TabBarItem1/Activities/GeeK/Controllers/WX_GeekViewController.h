//
//  WX_GeekViewController.h
//  kpie
//
//  Created by 王傲擎 on 16/7/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_HomeViewControllerModel.h"
#import "WX_VoideDViewController.h"

@interface WX_GeekViewController : BYC_BaseViewController

/// 0 --- 广告位跳转   1 --- 其他
-(void)receiveTheModelWith:(NSArray *)arrayModel WithNum:(NSInteger)num WithType:(NSInteger)type;

-(void)receiveFromLeftMessageWithModel:(BYC_LeftMassegeModel *)model;

-(void)receiveFromLeftLikeWithModel:(BYC_LeftLikeModel *)model;

@end
