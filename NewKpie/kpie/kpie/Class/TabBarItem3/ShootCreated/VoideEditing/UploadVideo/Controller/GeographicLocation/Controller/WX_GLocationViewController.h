//
//  WX_GLocationViewController.h
//  kpie
//
//  Created by 王傲擎 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "WX_GlocationModel.h"

typedef void(^blockAddress) (WX_GlocationModel *model);
@interface WX_GLocationViewController : BYC_BaseViewController

@property(nonatomic, copy)blockAddress block;


@end
