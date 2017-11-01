//
//  BYC_BackHomeVC.m
//  kpie
//
//  Created by 元朝 on 15/12/22.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BackHomeVC.h"
#import "BYC_MainNavigationController.h"
#import "BYC_AccountTool.h"
#import "BYC_LoginAndRigesterView.h"
#import "BYC_MainTabBarController.h"

@implementation BYC_BackHomeVC


//+ (void)cleanUserInfoAndBackHomeVC {//这个是体验比较好的方式，但是有BUG存在的可能，在用户在动态和我的页面触发这个方法的时候，用户不登录那么就会有问题，以后处理之后，在这样写。
//    
//    [BYC_AccountTool clearUserAccount];//清除旧数据
//    [KMainNavigationVC.view showAndHideHUDWithDetailsTitle:@"您的账户在别的设备上登录过，需要重新登录" WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
//        if (KMainNavigationVC.viewControllers.count > 1) [BYC_LoginAndRigesterView shareLoginAndRigesterView];
//    }];
//}

+ (void)cleanUserInfoAndBackHomeVC {
    
    
    [BYC_AccountTool clearUserAccount];//清除旧数据
    [KMainNavigationVC.view showAndHideHUDWithDetailsTitle:@"您的账户已在别处登录，请重新登录" WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
        
        
        if (KMainNavigationVC.viewControllers.count > 1) {
            
            
            [KMainNavigationVC popToRootViewControllerAnimated:YES];
//            for (UIViewController *vc in KMainNavigationVC.viewControllers)
//                if (![vc isMemberOfClass:NSClassFromString(@"BYC_MainTabBarController")]) [vc removeFromParentViewController];
//            return;
        }
        KMainTabBarVC.selectedIndex = 0;
        [BYC_LoginAndRigesterView shareLoginAndRigesterViewSuccess:nil failure:nil];
    }];
}

@end
