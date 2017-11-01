//
//  HL_PersonalView.h
//  kpie
//
//  Created by sunheli on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_AccountModel.h"


@protocol personalViewButtonActionDelegate <NSObject>

-(void)personalButtonAction:(id)sender;

@end

@interface HL_PersonalView : UIView

@property (nonatomic, strong ,readonly) UIImageView *imageV_userIcon;            /**<     个人头像 */
@property (nonatomic, strong,readonly) UIButton    *button_Edit;            /**<     编辑资料btn */
@property (nonatomic, strong, readonly) UIButton    *button_myCenter;        /**<      我的个人主页btn*/
@property (nonatomic, strong, readonly) UIButton    *button_more;

@property (nonatomic, strong, readonly) UIButton    *button_Work;            /**<     作品btn */
@property (nonatomic, strong, readonly) UIButton    *button_Forward;         /**<     转发btn */
@property (nonatomic, strong, readonly) UIButton    *button_Follow;          /**<     关注btn */
@property (nonatomic, strong, readonly) UIButton    *button_Fans;            /**<     粉丝btn */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tap;           //**<     点击头像*/

@property (nonatomic, strong)           BYC_AccountModel  *userInfoModel;

@property (nonatomic, weak) id <personalViewButtonActionDelegate> delegate;

@end
