//
//  HL_PersonalModel.h
//  kpie
//
//  Created by sunheli on 16/10/14.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseVideoModel.h"

@interface HL_PersonalModel : NSObject

@property (nonatomic, strong) NSArray <BYC_AccountModel *> *arr_FansUserData;

@property (nonatomic, strong) NSArray <BYC_BaseVideoModel *> *arr_UserVideoData;

@property (nonatomic, strong) BYC_AccountModel *dic_Users;

@property (nonatomic, strong) NSArray <BYC_AccountModel *> *arr_FocusUserData;


@end
