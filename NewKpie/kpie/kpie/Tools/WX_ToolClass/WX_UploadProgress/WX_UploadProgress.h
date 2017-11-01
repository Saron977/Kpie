//
//  WX_UploadProgress.h
//  kpie
//
//  Created by 王傲擎 on 16/9/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASProgressPopUpView.h"

typedef enum{
    ENUM_ProgressAddWithView    = 1,    /**<   在添加到View上 */
    ENUM_ProgressAddWithWindows = 2,    /**<   添加到Windows上 */
}ProgressType;

typedef void(^blockProgressValue)(CGFloat value);

@interface WX_UploadProgress : UIView

@property (nonatomic, copy  ) blockProgressValue    blockProgressVale;      /**<   block回调 */

/**
 *  添加进度条
 *
 *  @param type         类型
 *  @param view         需要添加view上, 若添加到window上 ,则给nil
 *  @param frame        需要给出frame
 *  @param schedules    任务数量,多个任务合成一个进度条显示出来
 */
+(void)createProgressWithType:(ProgressType)type View:(UIView*)view Frame:(CGRect)frame Schedules:(int)schedules;



+(void)createUploadProgress;
/**
 *  设置progress 的值
 *
 *  @param progressVale progress 的值
 */
+(void)setProgressVale:(CGFloat)progressVale;

+(void)removeProgress;
@end
