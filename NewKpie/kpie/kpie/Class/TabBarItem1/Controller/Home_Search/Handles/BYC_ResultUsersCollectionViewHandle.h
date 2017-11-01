//
//  BYC_ResultUsersCollectionViewHandle.h
//  kpie
//
//  Created by 元朝 on 16/5/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultUsersDataCountBlock)(int count);

@interface BYC_ResultUsersCollectionViewHandle: NSObject

@property (nonatomic, strong, readonly)  UICollectionView  *collectionView;
/**搜索关键词*/
@property (nonatomic, copy)  NSString  *string_KeyWords;
/**登录重新刷新*/
@property (nonatomic, assign)  BOOL     isLoginReloadData;
/**
 *  本类的初始化方法
 */
- (instancetype)initResultUsersCollectionViewHandle:(ResultUsersDataCountBlock)dataCountBlock;

@end
