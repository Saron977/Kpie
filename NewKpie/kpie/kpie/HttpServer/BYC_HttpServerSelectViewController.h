//
//  BYC_HttpServerSelectViewController.h
//  kpie
//
//  Created by 元朝 on 16/6/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//


@interface BYC_HttpServerSelectViewController : UIViewController

/**
 *  确定按钮回调
 */
@property (nonatomic, copy) void (^makeSure)();
@end
