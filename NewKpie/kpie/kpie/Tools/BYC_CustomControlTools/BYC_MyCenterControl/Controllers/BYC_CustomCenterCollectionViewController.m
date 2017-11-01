//
//  BYC_CustomCenterCollectionViewController.m
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_CustomCenterCollectionViewController.h"

const float flo_SegmentViewHeight = 50;
const float flo_HeadViewHeight = 200;
const float flo_DefaultOffSetY = 250;

@interface BYC_CustomCenterCollectionViewController ()

@end

@implementation BYC_CustomCenterCollectionViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSAssert(self.delegate, @"请提前设置delegate对象");
    if (self.delegate && [self.delegate respondsToSelector:@selector(customCenterCollectionViewController:setupCollectionViewOffSetYWhenViewWillAppear:)])
    [self.delegate customCenterCollectionViewController:self setupCollectionViewOffSetYWhenViewWillAppear:self.collectionView];
}

@end
