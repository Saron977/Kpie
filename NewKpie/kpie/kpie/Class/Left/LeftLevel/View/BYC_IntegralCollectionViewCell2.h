//
//  BYC_IntegralCollectionViewCell2.h
//  kpie
//
//  Created by 元朝 on 16/1/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYC_MyLevelModel;

@interface BYC_IntegralCollectionViewCell2 : UICollectionViewCell

@property (nonatomic, strong)  NSIndexPath  *indexPath;

@property (nonatomic, strong)  BYC_MyLevelModel *model;
@end
