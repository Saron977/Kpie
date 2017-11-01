//
//  BYC_LeftNotificationModel.h
//  kpie
//
//  Created by 元朝 on 16/1/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_LeftMassegeModel.h"

@interface BYC_LeftNotificationModel : BYC_LeftMassegeModel
 
@property (nonatomic, assign) BOOL     isRead;//是否已读(0未读 1已读)
@property (nonatomic, copy  ) NSString *GPSX;//经度
@property (nonatomic, copy  ) NSString *GPSY;//经度
@property (nonatomic, copy  ) NSString *upLoadTime;//上传时间
@property (nonatomic, copy  ) NSString *comments;//评论数
@property (nonatomic, copy  ) NSString *favorites;//评论数
@property (nonatomic, copy  ) NSString *videoIndex;//剧集编号
@property (nonatomic, copy  ) NSString *onOffTime;//上架时间
@end
