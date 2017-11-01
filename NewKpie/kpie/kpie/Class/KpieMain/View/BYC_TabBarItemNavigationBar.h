//
//  BYC_TabBarItemNavigationBar.h
//  kpie
//
//  Created by 元朝 on 16/7/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseNavigationBar.h"

@class BYC_TabBarItemNavigationBar;

@protocol BYC_TabBarItemNavigationBarDelegate <NSObject>

- (void)tabBarItemNavigationBar:(BYC_TabBarItemNavigationBar *)tabBarItemNavigationBar didSelectItemAtIndexPath:(int)index;

@end

@interface BYC_TabBarItemNavigationBar : BYC_BaseNavigationBar

@property (nonatomic, weak)  id<BYC_TabBarItemNavigationBarDelegate>  delegate;

/**包含的标题数组*/
@property (nonatomic, strong)  NSArray <NSString *> *arr_Items;

/**拖动距离*/
@property (nonatomic, assign)  CGFloat float_Progress;
/**
 *  默认一个带标题数组的构造器
 *
 *  @param items 标题数组
 *
 *  @return 返回导航栏实例
 */
+ (instancetype)initTabBarItemNavigationBarWithItems:(NSArray <NSString *> *)items;

@end
