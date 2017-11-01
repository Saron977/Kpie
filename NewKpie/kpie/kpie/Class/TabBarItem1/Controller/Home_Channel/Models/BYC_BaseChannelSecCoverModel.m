//
//  BYC_BaseChannelSecCoverModel.m
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelSecCoverModel.h"

@implementation BYC_BaseChannelSecCoverModel

-(BYC_BaseVideoModel *)video {

    if (!_video) _video = [BYC_BaseVideoModel new];
    return _video;
}

@end
