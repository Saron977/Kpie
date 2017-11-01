//
//  WX_VoideDViewController.h
//  kpie
//
//  Created by 王傲擎 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_LeftMassegeModel.h"
#import "BYC_LeftLikeModel.h"

@interface WX_VoideDViewController : BYC_BaseViewController
@property (nonatomic, assign) BOOL  isVR;
/**
 *  YES---评论    NO-----默认转台
 */
@property (nonatomic, assign) BOOL isComment;

@property (nonatomic, assign) BOOL  isFromFocusVC; /**<    判断_是否来自动态界面(是才需要返回通知手动刷新关注信息) */
/// 0 --- 广告位跳转   1 --- 其他
-(void)receiveTheModelWith:(NSArray *)arrayModel WithNum:(NSInteger)num WithType:(NSInteger)type;

-(void)receiveFromLeftMessageWithModel:(BYC_LeftMassegeModel *)model;

-(void)receiveFromLeftLikeWithModel:(BYC_LeftLikeModel *)model;

@end
