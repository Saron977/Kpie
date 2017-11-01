//
//  BYC_BaseChnnelCollectionViewHandel.h
//  kpie
//
//  Created by 元朝 on 16/7/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseChannelViewController.h"
#import "BYC_BaseCollectionView.h"
#import "BYC_OtherViewControllerModel.h"

@interface BYC_BaseChannelCollectionViewHandel : NSObject

/**数据*/
@property (nonatomic, strong)  NSArray<BYC_OtherViewControllerModel *> *arr_Models;
@property (nonatomic, strong)  BYC_BaseCollectionView                  *collectionView;

/**
 *  本类的初始化方法
 */
+ (instancetype)initBaseChannelCollectionViewHandle:(BYC_BaseChannelViewController *)vc;
@end
