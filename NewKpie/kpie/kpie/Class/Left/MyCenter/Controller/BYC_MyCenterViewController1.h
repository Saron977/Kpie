//
//  BYC_MyCenterViewController1.h
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_CustomCenterViewController.h"

typedef void(^SearchUserListFocusStateBlock)(WhetherFocusForCell status);
@interface BYC_MyCenterViewController1 : BYC_CustomCenterViewController

/**谁的个人中心 UserID*/
@property (nonatomic, strong) NSString  *str_ToUserID;

/**搜索列表的用户在个人中心进行关注与取消关注状态的一个回调block*/
@property (nonatomic, strong)  SearchUserListFocusStateBlock  searchUserListFocusStateBlock;
@end
