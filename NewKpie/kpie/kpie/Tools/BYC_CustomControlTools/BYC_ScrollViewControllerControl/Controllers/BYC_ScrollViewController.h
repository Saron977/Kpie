//
//  BYC_ScrollViewController.h
//  kpie
//
//  Created by 元朝 on 16/7/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_BaseViewController.h"

@interface BYC_ScrollViewController : BYC_BaseViewController

/**这是是因为本控制器的viewWillAppear不调用，导致子视图未能成功布局，所以需要自己手动调用，重置子视图布局，在调用之前，必须先确定所有的子控制器*/
- (void)resetSubViews;

/**根据角标，选中对应的控制器*/
@property (nonatomic, assign) NSInteger selectIndex;


@end
