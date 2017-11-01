//
//  BYC_TabBar.h
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYC_TabBar;

@protocol BYC_TabBarDelegate <NSObject>

/**
 *  点击加号按钮的时候调用
 *
 */
- (void)tabBarDidClickCameraButton:(BYC_TabBar *)tabBar;

@end
@interface BYC_TabBar : UIView
/**
 *  items:保存每一个按钮对应tabBarItem模型
 */
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<BYC_TabBarDelegate> delegate;
@end
