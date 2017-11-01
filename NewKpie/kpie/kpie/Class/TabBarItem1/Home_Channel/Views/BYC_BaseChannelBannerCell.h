//
//  BYC_BaseChannelBannerCell.h
//  kpie
//
//  Created by 元朝 on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_BaseChannelBannerModel.h"
#import "BYC_OtherViewControllerModel.h"

@interface BYC_BaseChannelBannerCell : UICollectionViewCell

/**其他数据模型*/
@property (nonatomic, strong)  BYC_OtherViewControllerModel *model_Other;

/***/
@property (nonatomic, strong)  NSArray<BYC_BaseChannelBannerModel *> *arr_BannerModels;
@end
