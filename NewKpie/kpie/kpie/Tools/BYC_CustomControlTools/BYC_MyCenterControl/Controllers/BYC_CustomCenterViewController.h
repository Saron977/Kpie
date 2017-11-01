//
//  BYC_CustomCenterViewController.h
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_CustomCenterControlColletionHandler.h"
@interface BYC_CustomCenterViewController : BYC_BaseViewController

/**内容*/
@property (nonatomic, strong)  BYC_CustomCenterControlColletionHandler  *handler_Content;
//初始的默认偏移量
@property (nonatomic, assign)  CGFloat flo_OffSetY;
/**承载头视图的容器视图*/
@property (nonatomic, strong)  UIView  *view_Container;
@end
