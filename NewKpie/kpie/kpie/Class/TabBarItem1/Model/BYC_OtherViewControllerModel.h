//
//  BYC_OtherViewControllerModel.h
//  kpie
//
//  Created by 元朝 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"
#import "HL_ColumnVideoThemeModel.h"
#import "BYC_MTBannerModel.h"
#import "BYC_MTVideoGroupModel.h"

@interface BYC_OtherViewControllerModel : BYC_BaseModel

///**栏目编号*/
//@property (nonatomic, copy  ) NSString  *columnID;
///**栏目名称*/
//@property (nonatomic, copy  ) NSString  *columnName;
///**第一封面*/
//@property (nonatomic, copy  ) NSString  *firstCover;
///**第二封面*/
//@property (nonatomic, copy  ) NSString  *secondCover;
///**栏目简介*/
//@property (nonatomic, copy  ) NSString  *columnDesc;
///**是否上架*/
//@property (nonatomic, assign) NSInteger pubstate;
///**上传时间*/
//@property (nonatomic, copy  ) NSString  *uploadTime;
///**上架时间*/
//@property (nonatomic, copy  ) NSString  *onOffTime;
///**点击量*/
//@property (nonatomic, assign) NSInteger views;
///**活动话题名称*/
//@property (nonatomic, copy  ) NSString  *theMeName;
///**所属频道编号*/
//@property (nonatomic, copy  ) NSString  *channelID;
///**视频播放地址*/
//@property (nonatomic, copy  ) NSString  *videoMP4;
///** 是否为赛事栏目 0否 1是  2世纪樱花活动栏目 3合拍 4怪咖*/
//@property (nonatomic, assign) NSNumber  *isActive;
///** 分享连接*/
//@property (nonatomic, copy)   NSString  *shareurl;

/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/
/**栏目编号*/
@property (nonatomic, copy  ) NSString  *columnid;
/**栏目名称*/
@property (nonatomic, copy  ) NSString  *columnname;
/**第一封面*/
@property (nonatomic, copy  ) NSString  *firstcover;
/**第二封面*/
@property (nonatomic, copy  ) NSString  *secondcover;
/**视频播放地址*/
@property (nonatomic, copy  ) NSString  *videomp4;
/**栏目简介*/
@property (nonatomic, copy  ) NSString  *columndesc;
/**是否上架*/
@property (nonatomic, assign) NSInteger pubstate;
/**上传时间*/
@property (nonatomic, copy  ) NSString  *uploadtime;
/**上架时间*/
@property (nonatomic, copy  ) NSString  *onofftime;
/**点击量*/
@property (nonatomic, assign) NSInteger views;
/**活动话题名称*/
@property (nonatomic, copy  ) NSString  *themename;
/**所属频道编号*/
@property (nonatomic, copy  ) NSString  *channelid;
/** 是否为赛事栏目 0否 1是  2世纪樱花活动栏目 3合拍 4怪咖*/
@property (nonatomic, assign) NSNumber  *isactive;

@property (nonatomic, strong) NSArray <HL_ColumnVideoThemeModel *>*arr_Area;

@property (nonatomic, strong) NSArray <BYC_MTVideoGroupModel *> *arr_SecCover;
@property (nonatomic, strong) NSArray <BYC_MTBannerModel *> *arr_VideoGroup;
/** 分享连接*/
@property (nonatomic, copy  ) NSString  *shareurl;
/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺新接口模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/

@end
