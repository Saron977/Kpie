//
//  HL_CollectionViewVC.h
//  kpie
//
//  Created by sunheli on 16/9/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_BaseModel.h"
#import "BYC_MyCenterHandler.h"
@interface HL_CollectionViewVC : UIViewController

/**存储cell相关数据:0角标：代码当前页数 1、那种类型的cell 2、cell的高度*/
@property (nonatomic, strong)  NSArray  *arr_CellData;

@property (nonatomic, strong) UICollectionView *collectionView;

/**个人中心数据*/
@property (nonatomic, strong)  BYC_MyCenterHandler *handle;

@end
