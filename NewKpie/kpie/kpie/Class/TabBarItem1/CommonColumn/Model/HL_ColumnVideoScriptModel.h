//
//  HL_ColumnVideoScriptModel.h
//  kpie
//
//  Created by sunheli on 16/11/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJCoding.h"

@interface HL_ColumnVideoScriptModel : BYC_BaseModel


/** 剧本下载次数 */
@property (nonatomic, assign) NSInteger downloadcount;

/** 剧本id */
@property (nonatomic, strong) NSString  *script_id;

@property (nonatomic, strong) NSString  *jpgurl;

/** 剧本名 */
@property (nonatomic, strong) NSString  *scriptname;

@property (nonatomic, strong) NSString  *userid;

@property (nonatomic, strong) BYC_AccountModel *users;

@end
