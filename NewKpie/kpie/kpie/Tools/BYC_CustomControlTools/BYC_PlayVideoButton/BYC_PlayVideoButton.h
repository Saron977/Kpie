//
//  BYC_PlayVideoButton.h
//  kpie
//
//  Created by 元朝 on 16/1/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BYC_PlayVideoButton : UIView

/**语音对应的评论ID,作为标记使用*/ //videoCommentID需要最后赋值，排在 videoTime videoUrlString 赋值之后
@property (nonatomic, copy)  NSString  *videoCommentID;
/**语音时长*/
@property (nonatomic, assign)  NSTimeInterval videoTime;
/**语音连接*/
@property (nonatomic, copy)    NSString *videoUrlString;
/**这个数组需要三个值，依次是（语音对应的评论ID,作为标记使用、语音时长、语音连接）*/
@property (nonatomic, strong)  NSArray  *arrayParameterDic;
/**
 *  初始化播放音频button
 *
 *  @param time     音频时长
 *  @param urlString 音频连接
 *  @param frame    控件frame（可以传CGRectZero，有默认大小）
 */
- (instancetype)initVideoTime:(NSTimeInterval)time videoUrl:(NSString *)urlString videoCommentID:(NSString *)videoCommentID frame:(CGRect)frame;

@end
