//
//  WX_GeekModel.h
//  kpie
//
//  Created by 王傲擎 on 16/7/25.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface WX_GeekModel : BYC_BaseModel
@property (nonatomic, assign)   NSInteger           integer_Rank;           /**<  活动排行 */
@property (nonatomic, assign)   BOOL                bool_ShareDraw;         /**<  可分享抽奖 */
@property (nonatomic, assign)   BOOL                bool_VoteDraw;          /**<  可投票抽奖 */
@property (nonatomic, assign)   NSInteger           interger_Votes;        /**<  投票数 */
@property (nonatomic, copy  )   NSString            *userID;                /**<  用户id */
@property (nonatomic, copy  )   NSString            *str_phoneNum;          /**<  手机号输入,判断length */
/// prize 奖品
@property (nonatomic, copy  )   NSString            *prozeID;               /**<   奖品编号 */
@property (nonatomic, copy  )   NSString            *prizeName;             /**<   奖品名称 */
@property (nonatomic, copy  )   NSString            *appName;               /**<   app名称 */
@property (nonatomic, assign)   NSInteger           prizeType;              /**<   奖品 1实物 2兑换码 */
@property (nonatomic, assign)   CGFloat             winRate;                /**<   中奖率 */


@end
