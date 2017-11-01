//
//  WX_MusicEditingViewController.h
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "WX_MusicModel.h"

typedef void(^musicBlock) (WX_MusicModel *model);
@interface WX_MusicEditingViewController : BYC_BaseViewController 

@property(nonatomic,copy) musicBlock block;
@end
