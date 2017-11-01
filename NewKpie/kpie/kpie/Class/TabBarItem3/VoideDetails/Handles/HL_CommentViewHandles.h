//
//  HL_CommentViewHandles.h
//  kpie
//
//  Created by sunheli on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WX_CommentsTableViewCell.h"
#import "BYC_HttpServers+FocusVC.h"
#import "BYC_HttpServers+HL_VideoPlayVC.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_MainNavigationController.h"
#import "BYC_LoginAndRigesterView.h"
#import "WX_CommentModel.h"


typedef void (^CommentBlock)(BYC_BaseVideoModel *model);

typedef void (^CommentDataBlock)(NSMutableArray *dataArray,NSMutableArray *userArray,NSMutableArray *teacherArray);

@interface HL_CommentViewHandles : NSObject

@property (nonatomic, strong) UIScrollView                                *videoScrollView;

@property (nonatomic, strong) UITableView                                 *commentTableView;

@property(nonatomic, strong) BYC_BaseVideoModel                           *focusListModel;

@property(nonatomic, strong) WX_CommentModel                              *deleteCommentModel;            /**< 需要删除的评论模型 */

@property(nonatomic, strong) NSMutableArray                               *dataArray;                   /**< 全部评论 */
@property(nonatomic, strong) NSMutableArray                               *userArray;                   /**< 用户评论 */
@property(nonatomic, strong) NSMutableArray                               *teacherArray;                /**< 名师评论 */

@property(nonatomic, assign) BOOL                                         isDelete;                         /**<  是否删除  */
/** 评论后返回新的数据模型*/
@property (nonatomic, copy) CommentBlock                                  commentBlock;
/** 评论数据*/
@property (nonatomic, copy) CommentDataBlock                              commentDataBlock;

@property (nonatomic, assign) CGFloat height_tableViewHeader;



-(void)commentsFromNetWithComList_Array:(NSMutableArray*)comList_Array TcList_Array:(NSMutableArray*)tcList_Array andWithModel:(BYC_BaseVideoModel *)focusListModel;

-(instancetype)initCommentViewHandles;
@end
