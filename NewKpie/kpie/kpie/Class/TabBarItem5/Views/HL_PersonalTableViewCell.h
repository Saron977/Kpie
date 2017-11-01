//
//  HL_PersonalTableViewCell.h
//  kpie
//
//  Created by sunheli on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HL_PersonalTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) UIView           *H_spiteLine;

@property (nonatomic, strong)NSString *personalStr;
@property (nonatomic, strong)NSString *personalIcoStr;

- (void)exeAddRedView;
- (void)exeRemoveRedView;
@end
