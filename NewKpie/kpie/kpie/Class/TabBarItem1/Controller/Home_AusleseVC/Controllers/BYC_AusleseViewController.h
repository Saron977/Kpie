//
//  BYC_AusleseViewController.h
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"

@class BYC_MotifModel;

typedef void(^setupHeaderMotifBlock)(NSArray <BYC_MotifModel *> *arr_MotifModels);

@interface BYC_AusleseViewController : BYC_BaseViewController

/**记录导航栏上面的栏目个数，有的时候网络不好只有一个，所以在dataNaviBannerCount == 1 的时候，再次刷新的时候需要继续请求*/
@property (nonatomic, assign)  NSInteger  dataNaviBannerCount;

/**
 *  默认带block的初始化方法
 *
 *  @param block 需要设置一个block用来通知HomeVC去设置主题
 *
 *  @return 返回实例
 */
- (instancetype)initWithBlock:(setupHeaderMotifBlock)block;

/**
 *  设置主题
 *
 *  @param arr_MotifModels 主题模型数组
 */
- (void)setupMotif:(NSArray <BYC_MotifModel *> *)arr_MotifModels;
@end
