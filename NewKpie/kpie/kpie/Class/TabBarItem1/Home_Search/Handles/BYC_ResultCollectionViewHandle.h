//
//  BYC_ResultCollectionViewHandle.h
//  kpie
//
//  Created by 元朝 on 16/5/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_ResultDynamicCollectionViewHandle.h"

@interface BYC_ResultCollectionViewHandle : NSObject

/**搜索关键词*/
@property (nonatomic, copy)  NSString  *string_KeyWords;
/**
 *  容器视图
 */
@property (nonatomic, strong, readonly)  UIView  *view_Container;

/**搜索动态列表*/
@property (nonatomic, strong)  BYC_ResultDynamicCollectionViewHandle  *handle_ResultDynamicCollectionView;

/**
 *  本类的初始化方法
 */
- (instancetype)initResultCollectionViewHandle;
@end
