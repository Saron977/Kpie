//
//  WX_ShootModel.h
//  kpie
//
//  Created by 王傲擎 on 15/12/21.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_ShootModel : NSObject

/* 录制时长  格式__ 00:00 */
@property(nonatomic, assign) CGFloat         videoDuration;

/* 视频标题 */
@property(nonatomic, retain) NSString        *videoTitle;

/* 输出路径 */
@property(nonatomic, retain) NSString        *outputFielPath;



@end
