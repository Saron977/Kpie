//
//  BYC_BaseViewController.h
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_ControllerCustomView.h"

@interface BYC_BaseViewController : UIViewController
/**遮罩视图,默认获取的是在控制器居中显示的遮罩提示*/
@property (nonatomic, strong)  UIView  *baseMaskView;

/**遮罩的默认提示语*/
@property (nonatomic, strong)  NSString  *contectText;

/**
 *  一个控制器使用这个方法只能创建多个遮罩,注意使用此方法要防止多次创建（需要自己在本类创建指针指向做是否已创建判断）
 *
 *  @param centerView 需要添加遮罩的视图
 *  @param text       遮罩中间的提示文本
 *
 *  @return 返回遮罩
 */
- (UIView *)createMaskViewInViewMore:(UIView *)centerView content:(NSString *)text;
@end
