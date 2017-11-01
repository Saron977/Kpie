//
//  BYC_CustomCenterControlColletionHandler.h
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseHandler.h"

@interface BYC_CustomCenterControlColletionHandler : BYC_BaseHandler


/***/
@property (nonatomic, strong, readonly)  UICollectionView *collectionView;
/**
 *  默认类构造方法
 *
 *  @param childVCs             创建好的子控制器
 *  @param parentViewController 控制器
 *
 *  @return 返回实例
 */
+ (instancetype)customCenterControlColletionHandlerWithParentViewController:(UIViewController *)parentViewController;

@end
