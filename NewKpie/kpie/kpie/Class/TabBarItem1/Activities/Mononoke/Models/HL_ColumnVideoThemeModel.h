//
//  HL_ColumnVideoThemeModel.h
//  kpie
//
//  Created by sunheli on 16/10/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface HL_ColumnVideoThemeModel : BYC_BaseModel

@property (nonatomic,assign) NSInteger createdate;

@property (nonatomic,assign) NSInteger elite;

@property (nonatomic,assign) NSInteger ishide;

@property (nonatomic,assign) NSInteger isshow;

@property (nonatomic,strong) NSString  *themeid;

@property (nonatomic,strong) NSString  *themename;

@property (nonatomic,strong) NSString  *userid;

@property (nonatomic,assign) NSInteger views;

@end
