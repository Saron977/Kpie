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


@interface BYC_BaseChannelCollectionViewHandel : NSObject

/**主题专属模型*/
@property (nonatomic, strong) BYC_BaseChannelModels         *models_Motif;
@property (nonatomic, strong)  BYC_BaseCollectionView       *collectionView;

/**
 *  本类的初始化方法
 */
+ (instancetype)initBaseChannelCollectionViewHandle:(BYC_BaseChannelViewController *)vc;

- (void)setMotifModels:(BYC_BaseChannelModels *)models_Motif index:(NSUInteger)index;
@end
