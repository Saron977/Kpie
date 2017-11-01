//
//  BYC_AusleseRecommendCollectionViewCell.h
//  kpie
//
//  Created by 元朝 on 16/7/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_BaseVideoModel.h"

@interface BYC_AusleseRecommendCollectionViewCell : UICollectionViewCell

/**精选的推荐数据*/
@property (nonatomic, strong) NSArray <BYC_BaseVideoModel    *> *arr_RecommendModels;

@end
