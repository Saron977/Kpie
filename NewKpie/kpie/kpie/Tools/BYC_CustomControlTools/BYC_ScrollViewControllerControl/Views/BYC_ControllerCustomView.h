//
//  BYC_ControllerCustomView.h
//  kpie
//
//  Created by 元朝 on 16/7/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"

@interface BYC_ControllerCustomView: UIView

- (instancetype)initWithFrame:(CGRect)frame andNotificationObject:(id)object;

@property (nonatomic, strong)NSString *imageUrl;

@end
