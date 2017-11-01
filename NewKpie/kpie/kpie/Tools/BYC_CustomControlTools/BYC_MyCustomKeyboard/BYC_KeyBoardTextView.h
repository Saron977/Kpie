//
//  BYC_KeyBoardTextView.h
//  kpie
//
//  Created by 元朝 on 16/8/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYC_KeyBoardTextView : UITextView


/**textView最大行数*/
@property (nonatomic, assign) NSUInteger uInt_MaxNumberOfLines;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) void(^textHeightChangeBlock)(NSString *text,CGFloat textHeight);

/**设置圆角*/
@property (nonatomic, assign) NSUInteger cornerRadius;

/**占位文字*/
@property (nonatomic, strong) NSString *placeholder;

/**占位文字颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textDidChange;
@end
