//
//  BYC_HistoryCollectionViewHandle.h
//  kpie
//
//  Created by 元朝 on 16/5/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_HistoryCollectionViewHandle : NSObject

@property (nonatomic, strong, readonly)  UICollectionView  *collectionView;

/**
 *  本类的初始化方法
 */
- (instancetype)initHistoryCollectionViewHandle;

@end
