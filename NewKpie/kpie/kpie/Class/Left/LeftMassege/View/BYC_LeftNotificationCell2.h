//
//  BYC_LeftNotificationCell2.h
//  kpie
//
//  Created by 元朝 on 16/1/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_LeftNotificationModel.h"

typedef void(^ClickHeaderActionBlock)(void);

@interface BYC_LeftNotificationCell2 : UICollectionViewCell

@property (nonatomic, strong)  BYC_LeftNotificationModel  *model;

@property (nonatomic, copy) ClickHeaderActionBlock  clickHeaderAction;
@end
