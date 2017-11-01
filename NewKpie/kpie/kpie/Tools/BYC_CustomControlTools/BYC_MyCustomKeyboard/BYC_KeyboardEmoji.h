//
//  BYC_KeyboardEmoji.h
//  自定义键盘
//
//  Created by 元朝 on 16/3/1.
//  Copyright © 2016年 BYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_KeyboardEmoji.h"

/**
 *  回调Block
 *
 *  @param isWhetherDeleteEmoji YES:代表删除 NO:代表不删除
 *  @param NSString             不删除的时候,需展示的图片
 */
typedef void(^SelectEmojiBlock)(BOOL isWhetherDeleteEmoji, NSString *stringEmojiName);

@interface BYC_KeyboardEmoji : UIView

@property (nonatomic, copy) NSString *selectedFaceName; //记下选中表情的名称
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, copy) SelectEmojiBlock block;
@end
