//
//  BYC_UpgradeStatusModel.h
//  kpie
//
//  Created by 元朝 on 16/10/24.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"
#import "BYC_UserLevel.h"
#import "BYC_AccountModel.h"

@interface BYC_UpgradeStatusModel : BYC_BaseModel


/***/
@property (nonatomic, copy)  NSString  *titlename;
/***/
@property (nonatomic, copy)  NSString  *titleimg;
/***/
@property (nonatomic, strong)  BYC_UserLevel  *userLevel;
/***/
@property (nonatomic, strong)  BYC_AccountModel  *users;
@end
