//
//  BYC_OtherViewController.h
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_MotifModel.h"

@interface BYC_OtherViewController : BYC_BaseViewController
@property (nonatomic,strong) NSString *parameter;

- (instancetype)initWithMotifModel:(BYC_MotifModel *)motifModel;
@end
