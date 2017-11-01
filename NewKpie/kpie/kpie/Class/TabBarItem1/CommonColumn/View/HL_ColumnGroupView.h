//
//  HL_ColumnGroupView.h
//  kpie
//
//  Created by sunheli on 16/11/14.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HL_ColumnGroupView : UIView



/**
 赛区看点
 */
@property (nonatomic, strong) UIButton *button_Group1;

/**
 热门选手
 */
@property (nonatomic, strong) UIButton *button_Group2;

/**
 精彩花絮
 */
@property (nonatomic, strong) UIButton *button_Group3;

@property (nonatomic, strong) UIImageView *imageView_Split1;

@property (nonatomic, strong) UIImageView *imageView_Split2;

@end
