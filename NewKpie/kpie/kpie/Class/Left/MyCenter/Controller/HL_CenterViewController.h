//
//  HL_CenterViewController.h
//  kpie
//
//  Created by sunheli on 16/9/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"

typedef void(^SearchUserListFocusStateBlock)(WhetherFocusForCell status);
@interface HL_CenterViewController : BYC_BaseViewController

/**谁的个人中心 UserID*/
@property (nonatomic, strong) NSString  *str_ToUserID;

/**搜索列表的用户在个人中心进行关注与取消关注状态的一个回调block*/
@property (nonatomic, strong)  SearchUserListFocusStateBlock  searchUserListFocusStateBlock;

@end
