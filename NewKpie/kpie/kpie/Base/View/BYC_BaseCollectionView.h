//
//  BYC_BaseCollectionView.h
//  kpie
//
//  Created by 元朝 on 16/7/9.
//  Copyright © 2016年 QNWS. All rights reserved.
// 准备把项目所有collectionView抽一个基类

#import <UIKit/UIKit.h>

@interface BYC_BaseCollectionView : UICollectionView

typedef void (^MJRefreshComponentRefreshingBlock)();
/**
 *  类初始化方法
 *
 *  @param vc 需要添加上的视图
 *
 *  @return 返回实例
 */
//+ (instancetype)initBaseChannelCollectionViewHandle:(UIView *)view;
@end
