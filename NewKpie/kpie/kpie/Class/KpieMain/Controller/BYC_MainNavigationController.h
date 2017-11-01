//
//  BYC_MainNavigationController.h
//  kpie
//
//  Created by 元朝 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseNavigationController.h"

@interface BYC_MainNavigationController : BYC_BaseNavigationController
@property (nonatomic, assign)  BOOL  isVR;
QNWSSingleton_interface(BYC_MainNavigationController)

-(void)setChildrenOrientationSupport;                           /**<   设置子视图屏幕旋转 */
@end
