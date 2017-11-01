//
//  BYC_FocusCollectionViewCell.h
//  kpie
//
//  Created by 元朝 on 15/10/27.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_FocusListModel.h"
#import "BYC_BackFocusListCellModel.h"

typedef NS_ENUM(NSUInteger, BYC_FocusCollectionViewCellSelected) {
    BYC_FocusCollectionViewCellSelectedLike = 1,  //点击的是喜欢button
    BYC_FocusCollectionViewCellSelectedComment,   //点击的是评论button
    BYC_FocusCollectionViewCellSelectedShare,     //点击的是分享button
};

typedef void(^PlayBtnCallBackBlock)(UIButton *);
typedef BYC_BackFocusListCellModel *(^ClickButtonBlock)(BYC_FocusCollectionViewCellSelected selectButton ,BYC_FocusListModel *model);
typedef void (^ClickHeaderButtonBlock)(BOOL clickHeaderButtonFlag ,BYC_FocusListModel *model);
@interface BYC_FocusCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *nickBackView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, strong)  BYC_FocusListModel  *model;
@property (nonatomic, strong)  ClickButtonBlock  selectButton;
@property (nonatomic, strong)  ClickHeaderButtonBlock  clickHeaderButtonBlock;
@property(nonatomic, assign) CGRect imgRect;
/** 播放按钮block */
@property (nonatomic, copy  ) PlayBtnCallBackBlock playBlock;
@end
