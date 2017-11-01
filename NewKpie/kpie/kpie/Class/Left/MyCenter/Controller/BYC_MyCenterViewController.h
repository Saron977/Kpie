//
//  BYC_MyCenterViewController.h
//  kpie
//
//  Created by 元朝 on 15/11/2.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"

typedef NS_ENUM(NSUInteger, BYC_MyCenterVCSelectedCollection) {
    BYC_MyCenterVCSelectedCollectionWorks = 0, //作品
    BYC_MyCenterVCSelectedCollectionFocus,     //关注
    BYC_MyCenterVCSelectedollectionFans,      //粉丝
};


typedef void(^AccountModelBlock)(BYC_AccountModel *accountModel);
@interface BYC_MyCenterViewController : BYC_BaseViewController

/**动态显示navigationBar,来自左侧点击头像*/
@property (nonatomic, assign)  BOOL  isFromLeftHeader;
/**动态显示navigationBar,来自左侧关注*/
@property (nonatomic, assign)  BOOL  isFromLeftFocus;

/**谁的个人中心 UserID*/
@property (nonatomic, strong) NSString  *userID;


@property (nonatomic, assign)  BYC_MyCenterVCSelectedCollection  myCenterVCSelectedCollection;

/**搜索列表的用户在个人中心进行关注与取消关注状态的一个回调block*/


@property (nonatomic, copy) AccountModelBlock         accountModelBlock;

@end
