//
//  BYC_BackFocusListCellModel.h
//  kpie
//
//  Created by 元朝 on 15/12/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface BYC_BackFocusListCellModel : BYC_BaseModel

@property (nonatomic, assign)  BOOL  isOK;//0表示成功 1表示失败
@property (nonatomic, assign) NSInteger comments; //该视频的评论数
@property (nonatomic, assign) NSInteger favorites;//该视频的收藏量
@property (nonatomic, assign) NSInteger views;    //该视频的点击量
@property (nonatomic, assign) NSUInteger ct;      //0是没喜欢 1是已喜欢

@end
