//
//  WX_ShareModel.h
//  kpie
//
//  Created by 王傲擎 on 16/9/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"


typedef NS_OPTIONS(NSInteger, ENUM_WX_ShareState) {
    ENUM_WX_ShareStateFailed = 0,       /**<   分享失败 */
    ENUM_WX_ShareStateSuccessed = 1,    /**<   分享成功 */
};

@interface WX_ShareModel : BYC_BaseModel

@property (nonatomic, copy  ) NSString              *share_VideoID;         /**<   分享_视频id */
@property (nonatomic, copy  ) NSString              *share_UserID;          /**<   分享_用户id */
@property (nonatomic, copy  ) NSString              *share_VideoTitle;      /**<   分享_视频标题 */
@property (nonatomic, copy  ) NSString              *share_ImageDataStr;    /**<   分享_封面 */

@property (nonatomic, assign) ENUM_WX_ShareState    ENUM_ShareState;        /**<   枚举_分享状态_在视频分享操作时调用 */

@end
