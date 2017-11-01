//
//  BYC_LeftNotificationCell.h
//  kpie
//
//  Created by 元朝 on 16/1/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_LeftNotificationModel.h"
typedef NS_ENUM(NSUInteger, ClickLeftNotificationCellButtonBlockType) {
    ClickLeftNotificationCellButtonBlockReply = 1,//点击查看详情
    ClickLeftNotificationCellButtonBlockHeader    //点击头像
};

typedef void (^ClickLeftNotificationCellButtonBlock)(ClickLeftNotificationCellButtonBlockType clickButtonBlockFlag ,BYC_LeftNotificationModel *model);

@interface BYC_LeftNotificationCell : UICollectionViewCell

@property (nonatomic, strong)  ClickLeftNotificationCellButtonBlock  clickLeftNotificationCellButtonBlock;
@property (nonatomic, strong)  BYC_LeftNotificationModel  *model;
@end
