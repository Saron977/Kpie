//
//  BYC_BaseChannelBannerCell.h
//  kpie
//
//  Created by 元朝 on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_OtherViewControllerModel.h"
#import "BYC_BaseChannelColumnModel.h"
#import "BYC_BaseChannelSecCoverModel.h"

@interface BYC_BaseChannelBannerCell : UICollectionViewCell

/**其他数据模型*/
@property (nonatomic, strong)  BYC_BaseChannelColumnModel *model_Other;

/***/
@property (nonatomic, strong)  NSArray<BYC_BaseChannelSecCoverModel *> *arr_BannerModels;
@end
