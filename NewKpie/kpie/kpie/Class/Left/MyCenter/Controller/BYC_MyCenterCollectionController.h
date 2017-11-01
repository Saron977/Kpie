//
//  BYC_MyCenterCollectionController.h
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_CustomCenterCollectionViewController.h"
#import "BYC_BaseModel.h"
#import "BYC_MyCenterHandler.h"

@interface BYC_MyCenterCollectionController : BYC_CustomCenterCollectionViewController

/**存储cell相关数据:0角标：代码当前页数 1、那种类型的cell 2、cell的高度*/
@property (nonatomic, strong)  NSArray  *arr_CellData;
/**个人中心数据*/
@property (nonatomic, strong)  BYC_MyCenterHandler *handle;
@end
