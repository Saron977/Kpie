//
//  HL_VideoDetailBottomView.h
//  kpie
//
//  Created by sunheli on 16/7/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_BaseVideoModel.h"

@protocol ClickVideodetailBottomViewButtonDelegate <NSObject>

-(void)clickBottomButton:(UIButton *)sender;

@end

@interface HL_VideoDetailBottomView : UIView

@property (nonatomic, strong) UIView         *view_script;
/** 写评论 */
@property (nonatomic, strong) UIButton       *button_writeComment;
/** 评论 */
@property (nonatomic, strong) UIButton       *button_comment;
/** 点赞 */
@property (nonatomic, strong) UIButton       *button_like;
/** 转发 */
@property (nonatomic, strong) UIButton       *button_forward;

@property (nonatomic, strong) UILabel        *lable_commentCount;
@property (nonatomic, strong) UILabel        *lable_likeCount;

@property (nonatomic, strong) BYC_BaseVideoModel *focusListModel;

@property (nonatomic, weak) id <ClickVideodetailBottomViewButtonDelegate> buttonDelegate;

@end
