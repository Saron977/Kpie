//
//  BYC_BaseChannelScrollSubtitleCell.h
//  kpie
//
//  Created by 元朝 on 16/7/13.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYC_BaseChannelScrollSubtitleCell : UICollectionViewCell

/**
 *  创建悬浮视图
 *
 *  @param view          需要悬浮的视图
 *  @param defualtOffset 悬浮视图距离控制器的根视图的Y轴
 *  @param vc            cell所在的控制器
 *  @param collectionV   cell所在的collectionView视图
 */
- (void)creatView:(UIView **)view DefualtOffset:(CGFloat *)defualtOffset andVC:(UIViewController *)vc andCollectionV:(UICollectionView *)collectionV;
@end
