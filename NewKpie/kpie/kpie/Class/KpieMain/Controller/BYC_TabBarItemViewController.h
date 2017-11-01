//
//  BYC_TabBarItemViewController.h
//  kpie
//
//  Created by 元朝 on 16/7/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_CollectionView.h"
@class BYC_TabBarItemViewController;

@protocol BYC_TabBarItemViewControllerDelegate <NSObject>

- (void)tabBarItemViewController:(BYC_TabBarItemViewController *)tabBarItemViewController didSelectItemAtIndexPath:(int)index;

@end

@interface BYC_TabBarItemViewController : BYC_BaseViewController

/**内容包含collectionView*/
@property (nonatomic, strong)  BYC_CollectionView         *homecollectionView ;
/**包含的标题和控制器的字典数组，要求必须大于等于2*/
@property (nonatomic, strong)  NSArray <NSDictionary *> *arr_Items;

@property (nonatomic, weak)  id<BYC_TabBarItemViewControllerDelegate>  delegate;

/**YES:不显示自定义的导航条BYC~~~！20161223 应对新需求，活动栏，只有活动页面了。(以后有时间，需优化)*/
@property (nonatomic, assign)  BOOL  isNoCustomNavBar;



@end
