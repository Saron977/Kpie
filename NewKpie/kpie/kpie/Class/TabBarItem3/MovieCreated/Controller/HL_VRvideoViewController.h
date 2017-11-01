//
//  HL_VRvideoViewController.h
//  kpie
//
//  Created by sunheli on 16/9/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_LeftMassegeModel.h"
#import "BYC_LeftLikeModel.h"

@interface HL_VRvideoViewController : BYC_BaseViewController

/// 0 --- 广告位跳转   1 --- 其他
-(void)receiveTheModelWith:(NSArray *)arrayModel WithNum:(NSInteger)num WithType:(NSInteger)type;

-(void)receiveFromLeftMessageWithModel:(BYC_LeftMassegeModel *)model;

-(void)receiveFromLeftLikeWithModel:(BYC_LeftLikeModel *)model;


@end
