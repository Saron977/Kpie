//
//  HL_ColumnVideoSortModel.h
//  kpie
//
//  Created by sunheli on 16/11/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HL_ColumnVideoSortModel : BYC_BaseModel

@property (nonatomic, strong) NSString  *columnid;

@property (nonatomic, strong) NSNumber  *createdate;

@property (nonatomic, strong) NSString  *groupid;

/**
 
 */
@property (nonatomic, strong) NSNumber  *sortby;

@property (nonatomic, strong) NSString  *sortid;

@property (nonatomic, strong) NSString *sortname;

/**
 0---视频   1---剧本
 */
@property (nonatomic, strong) NSNumber  *sorttype ;

@end
