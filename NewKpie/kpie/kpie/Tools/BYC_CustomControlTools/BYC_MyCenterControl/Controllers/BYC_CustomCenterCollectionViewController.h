//
//  BYC_CustomCenterCollectionViewController.h
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"

UIKIT_EXTERN const float flo_SegmentViewHeight;
UIKIT_EXTERN const float flo_HeadViewHeight;
UIKIT_EXTERN const float flo_DefaultOffSetY;

@class BYC_CustomCenterCollectionViewController;

@protocol CustomCenterCollectionViewControllerDelegate <NSObject>

- (void)customCenterCollectionViewController:(BYC_CustomCenterCollectionViewController *)vc scrollViewIsScrolling:(UIScrollView *)scrollView;
- (void)customCenterCollectionViewController:(BYC_CustomCenterCollectionViewController *)vc setupCollectionViewOffSetYWhenViewWillAppear:(UIScrollView *)scrollView;

@end

@interface BYC_CustomCenterCollectionViewController : BYC_BaseViewController

@property (nonatomic, weak)  id<CustomCenterCollectionViewControllerDelegate>  delegate;
@property (nonatomic, strong)  UICollectionView  *collectionView;


@end
