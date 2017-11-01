//
//  WX_AddTopicViewController.h
//  kpie
//
//  Created by 王傲擎 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "WX_AddTopicModel.h"

typedef void(^blockTopic) (WX_AddTopicModel *model);
@interface WX_AddTopicViewController : BYC_BaseViewController

@property(nonatomic, copy)blockTopic block;

@end
