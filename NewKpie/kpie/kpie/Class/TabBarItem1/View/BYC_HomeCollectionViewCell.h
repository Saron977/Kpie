//
//  BYC_HomeCollectionViewCell.h
//  kpie
//
//  Created by 元朝 on 15/10/27.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_HomeViewControllerModel.h"
#import "BYC_LeftLikeModel.h"
#import "BYC_BaseVideoModel.h"
#import "HL_ColumnVideoScriptModel.h"

@interface BYC_HomeCollectionViewCell : UICollectionViewCell

/**
 *  数据
 */
@property (nonatomic, strong)   BYC_BaseVideoModel *model;

@property (nonatomic, strong)   HL_ColumnVideoScriptModel *scriptModel;


@end
