//
//  BYC_BaseNavigationController.h
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BYC_BaseNavigationControllerSelectNavgationBarStyle) {
    BYC_BaseNavigationControllerSelectNavgationBarStyleOne,
    BYC_BaseNavigationControllerSelectNavgationBarStyleTwo,
    BYC_BaseNavigationControllerSelectNavgationBarStyleThree,
};
@interface BYC_BaseNavigationController : UINavigationController

@property (nonatomic, assign)  BYC_BaseNavigationControllerSelectNavgationBarStyle  selectNavgationBarStyle;
/**左边的button(注:一般情况下是返回按钮)*/
@property (nonatomic, strong ,readonly)  UIButton *leftButton;
/**接收返回的方法SEL*/
@property (nonatomic, assign,readonly) SEL backActionSEL;
- (void)selectNavgationBar:(BYC_BaseNavigationControllerSelectNavgationBarStyle)NavgationBarStyle;


@end
