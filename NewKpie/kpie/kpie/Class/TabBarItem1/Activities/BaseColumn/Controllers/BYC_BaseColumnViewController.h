//
//  BYC_BaseColumnViewController.h
//  kpie
//
//  Created by 元朝 on 16/9/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_OtherViewControllerModel.h"
#import "BYC_BaseVideoModel.h"

@interface BYC_BaseColumnViewController : BYC_BaseViewController {

    @public
    BYC_OtherViewControllerModel  *_model;
}

/**YES:展示参加按钮*/
@property (nonatomic, assign)  BOOL  isShowJoinInStepButton;
/**YES:展示分享按钮*/
@property (nonatomic, assign)  BOOL  isShowShareButton;

@property (nonatomic, strong)  BYC_OtherViewControllerModel  *model;

/**
 *  有需要合拍的栏目在点击合拍按钮的时候，复写此方法做相应的操作。
 *
 *  @param button 合拍按钮
 */
- (void)clickJoinInStepAction:(UIButton *)button;
/**
 *  有需要分享的栏目在点击分享按钮的时候，复写此方法做相应的操作。
 *
 *  @param button 分享按钮
 */
- (void)clickShareAction:(UIButton *)button;
@end
