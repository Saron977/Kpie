//
//  BYC_MainTabBarController.h
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_HomeViewController.h"
#import "BYC_FocusViewController.h"
#import "BYC_DiscoverViewController.h"
#import "BYC_PersonalViewController.h"
@class BYC_ADModel;

@protocol BYC_MainTabBarControllerDelegate <NSObject>

- (void)openTheMyCenter;

@end

@interface BYC_MainTabBarController : UITabBarController
QNWSSingleton_interface(BYC_MainTabBarController)

@property (nonatomic, strong) BYC_HomeViewController           *homeViewController;
@property (nonatomic, strong) BYC_FocusViewController          *focusViewController;
@property (nonatomic, strong) BYC_DiscoverViewController  *tabBarItemTwoViewController;
@property (nonatomic, strong) BYC_PersonalViewController  *tabBarItemFiveViewController;
/**广告数据*/
@property (nonatomic, strong)  BYC_ADModel  *model_AD;
@property (nonatomic, weak)  id<BYC_MainTabBarControllerDelegate>  mainTabBarDelegate;

@end
