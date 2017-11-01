//
//  BYC_ChannelViewController.h
//  kpie
//
//  Created by 元朝 on 16/7/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ScrollViewController.h"
#import "BYC_HomeChannelListModel.h"
#import "BYC_MotifModel.h"
#import "BYC_BaseChannelDataModel.h"

@interface BYC_ChannelViewController : BYC_ScrollViewController

- (instancetype)initWithMotifModel:(BYC_MotifModel *)motifModel andWithChannelDataModel:(BYC_BaseChannelDataModel *)channelDataModel;

@end
