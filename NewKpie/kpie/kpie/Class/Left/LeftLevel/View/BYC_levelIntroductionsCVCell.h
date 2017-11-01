//
//  BYC_levelIntroductionsCVCell.h
//  kpie
//
//  Created by 元朝 on 16/1/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYC_UpgradeDescriptionModel;

@interface BYC_levelIntroductionsCVCell : UICollectionViewCell

@property (nonatomic, strong)  NSIndexPath  *indexPath;
/**
 MINLV      最小等级
 MAXLV		最大等级
 TITLEIMG	头衔图标
 TITLENAME	头衔名称
 MINGROWTH	最小成长值
 MAXGROWTH 	最大成长值
 */
@property (nonatomic, strong)  BYC_UpgradeDescriptionModel  *model;

@end
