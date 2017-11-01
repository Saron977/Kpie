//
//  BYC_PlaceHolderView.h
//  kpie
//
//  Created by 元朝 on 16/5/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYC_PlaceHolderView : UIView

/**
 *  默认提供提示字符的初始化方法
 *
 *  @param promptText 提示字符
 *  @param frame 提示视图大小
 *  @return 实例
 */
- (instancetype)initWithPromptText:(NSString *)promptText frame:(CGRect)frame;

@end
