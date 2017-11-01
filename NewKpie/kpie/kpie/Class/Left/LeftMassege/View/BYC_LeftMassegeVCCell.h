//
//  BYC_LeftMassegeVCCell.h
//  kpie
//
//  Created by 元朝 on 15/12/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_LeftMassegeModel.h"

typedef NS_ENUM(NSUInteger, ClickButtonBlockType) {
    ClickButtonBlockReply = 1,//点击回复
    ClickButtonBlockHeader,    //点击头像
    ClickButtonBlockLook    //点击查看
};


@interface BYC_LeftMassegeVCCell : UICollectionViewCell
typedef void (^ClickButtonBlock)(ClickButtonBlockType clickButtonBlockFlag ,BYC_LeftMassegeModel *model);
@property (nonatomic, strong)  BYC_LeftMassegeModel  *model;
@property (nonatomic, strong)  ClickButtonBlock  clickButtonBlock;
@end
