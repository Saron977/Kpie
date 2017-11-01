//
//  BYC_UserInfoModel.h
//  kpie
//
//  Created by 元朝 on 16/10/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface BYC_UserInfoModel : BYC_BaseModel

/** 用户编号 */
@property (nonatomic, copy) NSString  *userid;

/** 用户名 */
@property (nonatomic, copy) NSString  *username;

/** 国籍 */
@property (nonatomic, copy) NSString  *nationality;

/** 城市 */
@property (nonatomic, copy) NSString  *city;

/** 联系方式（手机号码） */
@property (nonatomic, copy) NSString  *contact;

/** 邮箱地址 */
@property (nonatomic, copy) NSString  *emailaddress;

/** 微信 */
@property (nonatomic, copy) NSString  *wechat;

/** FACEBOOK */
@property (nonatomic, copy) NSString  *facebook;

/** 个人简介 */
@property (nonatomic, copy) NSString  *mydescription;

/** 发布视频数 */
@property (nonatomic, assign) NSInteger  videos;

/** 粉丝数 */
@property (nonatomic, assign) NSInteger  fans;

/** 关注数 */
@property (nonatomic, assign) NSInteger  focus;

/** 金币数 */
@property (nonatomic, assign) NSInteger  gold;

/** 人民币 */
@property (nonatomic, assign) NSInteger  rmb;

/** 上传时间 */
@property (nonatomic, copy) NSString  *updatetime;
@end
