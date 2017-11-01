//
//  HL_JumpToVideoPlayVC.h
//  kpie
//
//  Created by sunheli on 16/8/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ENUM_FromLeftLikeOrMessageOrOther){
    ENU_FromLeftLikeVideo,
    ENU_FromLeftMessageVideo,
    ENU_FromOtherVideo,
};

typedef NS_ENUM(NSInteger,ENUM_FromRecommendVideo){
    ENUM_FromVideoDViewController,
    ENUM_FromOtherViewController
};

typedef NS_ENUM(NSInteger,ENUM_VideoType) {
    ENUM_VideoType_NormalVideo      =   0,  /**<   普通视频 */
    ENUM_VideoType_VRVideo          =   1,  /**<   VR视频 */
    ENUM_VideoType_JoinShooting     =   2,  /**<   合拍视频 */
    ENUM_VideoType_GeekVideo        =   3,  /**<   怪咖视频 */
    ENUM_VideoType_Scripte          =   4,  /**<   剧本合拍 */
};
@interface HL_JumpToVideoPlayVC : NSObject
/**
* 根据videoTepy跳转到不同的视频播放页
*
*  @param model           model 数据模型
*  @param videoTepy       videoTepy 0--普通视频，1--VR视频，2--合拍，3--怪咖
*  @param isComment       isComment 是否评论
*  @param fromType        fromType 是否从喜欢和消息进
*  @param fromVideoVCType fromVideoVCType 是否来自AV、VR视频混合界面
*/
+ (void)jumpToVCWithModel:(id)model andVideoTepy:(ENUM_VideoType)videoTepy andisComment:(BOOL)isComment andFromType:(ENUM_FromLeftLikeOrMessageOrOther)fromType;

@end
