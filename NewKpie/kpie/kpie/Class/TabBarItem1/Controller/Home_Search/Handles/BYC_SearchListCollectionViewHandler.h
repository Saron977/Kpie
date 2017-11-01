//
//  BYC_SearchListCollectionViewHandler.h
//  kpie
//
//  Created by 元朝 on 16/5/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseHandler.h"

@interface BYC_SearchListCollectionViewHandler : BYC_BaseHandler

@property (nonatomic, strong, readonly)  UICollectionView  *collectionView;
/**数据*/
@property (nonatomic, strong)  NSArray  *array_Data;

/**
 *  本类的初始化方法
 */
- (instancetype)initSearchListCollectionViewHandle;
@end
