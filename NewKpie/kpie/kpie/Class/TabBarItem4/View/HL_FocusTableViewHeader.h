//
//  HL_FocusTableViewHeader.h
//  kpie
//
//  Created by sunheli on 16/7/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_HomeViewControllerModel.h"
#import "BYC_FocusListModel.h"

@interface HL_FocusTableViewHeader : UIView

//@property (nonatomic, strong) UIImageView *imageV_userIcon;
//@property (nonatomic, strong) UILabel     *lable_userName;
//@property (nonatomic, strong) UIImageView *imageV_userSex;
//@property (nonatomic, strong) UIButton    *button_Forward;
//@property (nonatomic, strong) UILabel     *lable_time;
//@property (nonatomic, strong) UILabel     *lable_descrip;
@property (nonatomic, strong) BYC_BaseVideoModel     *model;

+(CGFloat)returnHeightOfFocusHeaderView:(BYC_BaseVideoModel *)model;

@end
