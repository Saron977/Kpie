//
//  BYC_InStepCollectionViewCell.h
//  kpie
//
//  Created by 元朝 on 15/10/27.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_InStepCollectionViewCellModel.h"
#import "BYC_LeftLikeModel.h"

@interface BYC_InStepCollectionViewCell : UICollectionViewCell

/**
 *  数据
 */
@property (nonatomic, strong)   BYC_InStepCollectionViewCellModel *model;

/**
 *  数据
 */
@property (nonatomic, strong)   BYC_LeftLikeModel *leftLikeModel;
@end
