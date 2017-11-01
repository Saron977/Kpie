//
//  BYC_MyCenterNavigationBar.h
//  kpie
//
//  Created by 元朝 on 16/9/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_MyCenterUserModel.h"

@protocol ShowSelectedBlackListDelegate <NSObject>

-(void)ShowSelectedBlackListDelegate:(BYC_MyCenterUserModel *)model;

@end
@interface BYC_MyCenterNavigationBar : UIView

@property (nonatomic, strong) UIButton *button_SelectedBlacklist;

/**个人中心数据*/
@property (nonatomic, strong)  BYC_MyCenterHandler *handle;


@property (nonatomic, weak) id <ShowSelectedBlackListDelegate> blackDelegate;

+ (UIView *)myCenterNavigationBar;
@end
