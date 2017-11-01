//
//  BYC_KeyboardToolBar.h
//  自定义键盘
//
//  Created by 元朝 on 16/3/1.
//  Copyright © 2016年 BYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_KeyBoardTextView.h"

typedef NS_ENUM(NSUInteger, KeyboardStatus) {
    KeyboardStatusText,     //文本状态
    KeyboardStatusVoice,    //语音状态
    KeyboardStatusEmoji,    //表情状态
    KeyboardStatusSendMsg,  //发送文本
    KeyboardStatusSpeak,    //按住说话模式
};

@protocol BYC_KeyboardToolBarDelegate <NSObject>

/**
 *  点击对应事件进行相应的逻辑处理
 *
 *  @param status 状态
 */
- (void)clickActionWithStatus:(KeyboardStatus)status;
/**
 *  语音数据返回代理
 *
 *  @param voiceData 语音二进制数据
 *  @param duration  语音时长
 */
- (void)sendVoiceData:(NSData *)voiceData withVoiceDuration:(CGFloat)duration;
-(void)recordVoiceDataFail;
@end

@interface BYC_KeyboardToolBar : UIView

/**表情按钮(先给暴露出来，以后优化)*/
@property (nonatomic, strong) UIButton    *button_Emoji;

/**文本输入框*/
@property (nonatomic, strong) BYC_KeyBoardTextView    *textView_Content;

@property (nonatomic, assign) BOOL         isSmile;       /**< 是否是表情状态 */

@property (nonatomic, assign) BOOL         isVoice;       /**< 是否是语音 */

@property (nonatomic, weak)  id<BYC_KeyboardToolBarDelegate>  delegate_KeyboardToolBar;

@end
