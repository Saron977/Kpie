
//
//  BYC_BaseChannelScrollSubtitleCell.m
//  kpie
//
//  Created by 元朝 on 16/7/13.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelScrollSubtitleCell.h"
#import "BYC_ScrollSubtitleView.h"

@implementation BYC_BaseChannelScrollSubtitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {

    _viewCell = [[BYC_ScrollSubtitleView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:_viewCell];
}
@end
