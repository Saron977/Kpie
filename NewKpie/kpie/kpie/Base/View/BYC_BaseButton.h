//
//  BYC_BaseButton.h
//  kpie
//
//  Created by 元朝 on 16/4/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYC_BaseButton : UIButton

/**
 *  生成高亮
 *
 *  @param buttonType 类型
 *  @param rect       高亮区域
 *
 *  @return 生成好的高亮button
 */
+(instancetype)buttonWithType:(UIButtonType)buttonType WithFrame:(CGRect)rect;
@end
