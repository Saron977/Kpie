//
//  HL_VideoPlayPageModel.h
//  kpie
//
//  Created by sunheli on 16/10/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseVideoModel.h"
#import "WX_CommentModel.h"

@interface HL_VideoPlayPageModel : NSObject

/**
 * 老师点评数据
 */
@property (nonatomic, strong) NSArray <WX_CommentModel *> *array_TcCommentModels;

/**
 * 普通用户评论数据
 */
@property (nonatomic, strong) NSArray <WX_CommentModel *> *array_OrdCommentModels;

/**
 * 是否关注
 */
@property (nonatomic, assign) NSInteger AttentionState;

/**
 * 点赞数据
 */
@property (nonatomic, strong) NSArray <BYC_AccountModel *> *array_FavorUserModels;

/**
 * 播放视频数据
 */
@property (nonatomic, strong) BYC_BaseVideoModel   *VideoModel;

/**
 *推荐视频数据
 */
@property (nonatomic, strong) NSArray <BYC_BaseVideoModel *> *array_RandVideoModels;




@end
