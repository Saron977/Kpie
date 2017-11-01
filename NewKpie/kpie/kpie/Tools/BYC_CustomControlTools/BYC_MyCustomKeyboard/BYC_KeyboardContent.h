//
//  BYC_KeyboardContent.h
//  自定义键盘
//
//  Created by 元朝 on 16/3/2.
//  Copyright © 2016年 BYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_KeyboardEmoji.h"

@interface BYC_KeyboardContent : UIView<UIScrollViewDelegate>

@property (nonatomic, strong)  UIScrollView  *scrollView_Smilies;
@property (nonatomic, strong)  UIPageControl  *control_Page;
@property (nonatomic, strong)  BYC_KeyboardEmoji *view_Smilies;
- (id)initWithBlock:(SelectEmojiBlock)block;

@end
