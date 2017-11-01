//
//  HL_AddFocusHandles.h
//  kpie
//
//  Created by sunheli on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HL_SearchBar.h"

@interface HL_AddFocusHandles : NSObject <SearchBarDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView    *view_AddFocus;//容器视图

@property (nonatomic, strong)  HL_SearchBar     *seachBar;//搜索框

@property (nonatomic, strong, readonly)  UICollectionView  *collectionView;

/**搜索关键词*/
@property (nonatomic, copy)  NSString  *string_KeyWords;

/**登录重新刷新*/
@property (nonatomic, assign)  BOOL     isLoginReloadData;

/**记录点击的index*/
@property (nonatomic, strong)  NSIndexPath  *indexPath;


/**
 *  本类的初始化方法
 */
- (instancetype)initAddFocusListCollectionViewHandle;

@end
