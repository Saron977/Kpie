//
//  HL_MyCenterheaderView.h
//  kpie
//
//  Created by sunheli on 16/9/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_MyCenterNavigationBar.h"


typedef void(^SendWorksAndFocusAndFansCountBlock)(NSArray *ArrayCount);
@interface HL_MyCenterheaderView : UIImageView

/** 返回按钮、标题 */
@property (nonatomic, strong) UIView      *View_Top;

/**模糊背景*/
//@property (nonatomic, strong)  UIImageView *imgV_BlurBackground;
/**头像*/
@property (nonatomic, strong)  UIImageView *imgV_Header;
/**昵称*/
@property (nonatomic, strong)  UILabel *lab_Nickname;
/**性别*/
@property (nonatomic, strong)  UIImageView *imgV_Sex;
/**等级图*/
@property (nonatomic, strong)  UIImageView *imgV_Level;
/**等级图标*/
@property (nonatomic, strong)  UIImageView *imgV_LevelIcon;
/**等级名称*/
@property (nonatomic, strong)  UILabel *lab_LevelName;
/**个人描述*/
@property (nonatomic, strong)  UILabel *lab_Description;
/**底部滑动的view*/
@property (nonatomic, strong)  UIView *view_ScrollPage;

@property (nonatomic, strong)  UIView *view_Middle;

@property (nonatomic, strong)  UIButton *btn_Focus;

/**个人中心数据*/
@property (nonatomic, strong)  BYC_MyCenterHandler *handle;

@property (nonatomic, copy) SendWorksAndFocusAndFansCountBlock sendWorksAndFocusAndFansCountBlock;

@end
