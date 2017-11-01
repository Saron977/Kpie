//
//  BYC_DeleteEmojiStringName.h
//  自定义键盘
//
//  Created by 元朝 on 16/3/8.
//  Copyright © 2016年 BYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_DeleteEmojiStringName : NSObject
/**
 *  有缺点，待优化。目前这个表情包就这么写吧。只要表情名字不大于5
 *
 *  @param inputString 需要进行删除的表情字符串
 *
 *  @return 已经删除之后的表情字符串
 */
+ (NSString *)deleteEmojiStringAction:(NSString *)inputString;
@end
