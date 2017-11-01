//
//  BYC_AusleseVCMainCollectionViewHandel.h
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseCollectionView.h"
#import "BYC_AusleseViewController.h"

@interface BYC_AusleseVCMainCollectionViewHandel: NSObject


@property (nonatomic, strong)  BYC_BaseCollectionView                  *collectionView;

/**
 *  本类的初始化方法
 */
+ (instancetype)initAusleseVCMainCollectionViewHandel:(BYC_AusleseViewController *)vc;
@end
