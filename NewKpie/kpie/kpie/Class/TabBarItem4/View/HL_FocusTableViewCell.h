//
//  HL_FocusTableViewCell.h
//  kpie
//
//  Created by sunheli on 16/7/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_BaseVideoModel.h"
#import "BYC_BackFocusListCellModel.h"
#import "BYC_MediaPlayer.h"

typedef NS_ENUM(NSUInteger, HL_FocusTableViewCellSelected) {
    HL_FocusTableViewCellSelectedShoot = 1,  //合拍按钮
    HL_FocusTableViewCellSelectedPlay,       //播放按钮
    HL_FocusTableViewCellSelectedLike,      //点击的是喜欢button
    HL_FocusTableViewCellSelectedComment,   //点击的是评论button
    HL_FocusTableViewCellSelectedForward,     //点击的是转发button
};
typedef void (^ClickCellButtonBlock)(HL_FocusTableViewCellSelected selectButton ,BYC_BaseVideoModel *model);
typedef void (^ClickCellHeaderButtonBlock)(BYC_BaseVideoModel *model);
typedef void(^ClickPlayButtonBlock)(UIButton *);

@interface HL_FocusTableViewCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, strong, readonly) UIImageView   *imageV_userIcon;      /**<     用户头像*/
@property (nonatomic, strong, readonly) UIButton      *button_shoot;        /**<     合拍按钮*/
@property (nonatomic, strong, readonly) UIButton      *button_Focus;          /**<     添加按钮*/
@property (nonatomic, strong, readonly) UIView        *view_video;          /**<      视频栏*/
@property (nonatomic, strong, readonly) UIButton      *button_playVieo;      /**<     播放按钮*/
@property (nonatomic, strong, readonly) UIImageView   *imageV_videoImage;

@property (nonatomic, strong, readonly) UIButton      *button_forward;      /**<     转发*/
@property (nonatomic, strong, readonly) UIButton      *button_comment;      /**<     评论*/
@property (nonatomic, strong, readonly) UIButton      *button_like;         /**<     点赞*/

@property (nonatomic, strong)  BYC_BaseVideoModel            *model;
@property (nonatomic, strong)  ClickCellButtonBlock          selectButton;
@property (nonatomic, strong)  ClickCellHeaderButtonBlock    clickHeaderButtonBlock;
@property (nonatomic, strong)  ClickPlayButtonBlock          clickPlayButtonBlock;   /**<   点击播放按钮*/

@property(nonatomic, assign) CGRect imgRect;

+(CGFloat)returnCellHeightOfFocus:(BYC_BaseVideoModel *)model;

@end
