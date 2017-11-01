//
//  WX_PhotoSelectedViewController.h
//  Album
//
//  Created by 王傲擎 on 16/8/16.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_BaseViewController.h"

typedef enum {
    ENUM_Photo = 0,         /**<   照片 */
    ENUM_Video = 1          /**<   视频 */
}PhtotKitType;

@interface WX_PhotoSelectedViewController : BYC_BaseViewController


-(void)parmsFromPhotoKitWith:(PhtotKitType)photoType;  /**<   设置选取类型 */


@end
