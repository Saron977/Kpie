//
//  WX_CommentsTableViewCell.h
//  kpie
//
//  Created by 王傲擎 on 15/12/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WX_CommentModel.h"

@interface WX_CommentsTableViewCell : UITableViewCell <AVAudioPlayerDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong) UIView           *view_headerIcon;
@property (nonatomic, strong) UIImageView      *imageV_userIcon;        /**< 用户头像 */
@property (nonatomic, strong) UIImageView      *imageV_signIcon;        /**< 名师的“T”标志*/
@property (nonatomic, strong) UILabel          *lable_userNickname;     /**< 用户昵称 */
@property (nonatomic, strong) UILabel          *lable_Comment;          /**< 文本评论内容 */
@property (nonatomic, strong) UIView           *view_voice;              /**< 语音 */
@property (nonatomic, strong) UIButton         *button_voice;               /**< 语音 */
@property (nonatomic, strong) UILabel          *lable_voiceComment;             /**< 秒数 */
@property (nonatomic, strong) UILabel          *lable_commentTime;      /**< 评论时间 */
@property (nonatomic, strong) UIImageView      *image_userSex;          /**< 用户性别 */

@property (nonatomic, strong) UIView           *tapView;                 /**< 增加触控区 */

@property (nonatomic, strong) WX_CommentModel  *commentModel;           /**<  评论模型 */

/// 名师不可回复, 只接收普通用户数组
@property(nonatomic, retain) NSMutableArray     *userArray;


///  普通用户只能听名师语音
@property(nonatomic, retain) NSMutableArray     *teachArray;


/// userType
//  用户类型: 0普通用户，10名师，1后台管理员
-(void)setCellWithModel:(WX_CommentModel *)model UserType:(NSInteger)UserType;

/// 语音暂停
-(void)stopVoiceAnimation;

/// 设置cell 自适应高度
+(CGFloat)cellHeightWithString:(WX_CommentModel *)commentModel;

@end
