
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


- (void)creatView:(UIView **)view DefualtOffset:(CGFloat *)defualtOffset andVC:(UIViewController *)vc andCollectionV:(UICollectionView *)collectionV{
    
    float top = CGRectGetMinY(self.frame);
    float insetTop = collectionV.contentInset.top;
    *defualtOffset = top + insetTop;
    *view = [[BYC_ScrollSubtitleView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:*view];
}

@end
