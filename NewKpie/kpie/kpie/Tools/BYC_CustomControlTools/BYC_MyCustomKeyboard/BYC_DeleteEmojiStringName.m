//
//  BYC_DeleteEmojiStringName.m
//  自定义键盘
//
//  Created by 元朝 on 16/3/8.
//  Copyright © 2016年 BYC. All rights reserved.
//

#import "BYC_DeleteEmojiStringName.h"

#define Emoji_Max_Length 5



@implementation BYC_DeleteEmojiStringName
/**
 *  有缺点，待优化。目前这个表情包就这么写吧。只要表情名字不大于5
 *
 *  @param inputString 需要进行删除的表情字符串
 *
 *  @return 已经删除之后的表情字符串
 */
+ (NSString *)deleteEmojiStringAction:(NSString *)inputString{
 
        return  inputString.length > 0 ? [inputString substringToIndex:inputString.length - 1] : inputString;
//    if (inputString.length) {
//        
//        NSString *string = nil;
//        NSInteger stringLength = inputString.length;
//        if (stringLength - Emoji_Max_Length > 0)
//            string = [inputString substringFromIndex:stringLength - Emoji_Max_Length];
//        else string = inputString;
//        NSRange range;
//        int count = -1;
//        do {
//            count++;
//            range = [string rangeOfString:@"["];
//            string = [string substringFromIndex:range.location];
//        } while (range.location != 0);
//
//        inputString = [inputString substringToIndex:stringLength - Emoji_Max_Length + count];
//        
//    }
//    return inputString.length == 0 ? @"" : inputString;
}
@end
