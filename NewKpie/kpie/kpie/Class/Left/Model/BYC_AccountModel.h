//
//  BYC_AccountModel.h
//  kpie
//
//  Created by 元朝 on 15/11/9.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_UserInfoModel.h"
#import "BYC_UserTitle.h"
#import "BYC_UserLevel.h"

@class BYC_MyCenterHandler;

//所有能看见的用户相对于当前登录的用户是一个什么样的状态
//1互相关注 2已关注 3被关注 4未关注
typedef NS_ENUM(NSUInteger, WhetherFocusForCell) {
    WhetherFocusForCellHXFocus = 1,//互相关注
    WhetherFocusForCellYES,        //已关注
    WhetherFocusForCellFocused,    //被关注
    WhetherFocusForCellNO,         //没有关注
    
};
@interface BYC_AccountModel : BYC_BaseModel<NSCoding> {

    WhetherFocusForCell _whetherFocusForCell;
}

//@property (nonatomic, copy  ) NSString  *cellphonenumber;//手机号码
//@property (nonatomic, copy  ) NSString  *devicetokens;//设备唯一标识符
//@property (nonatomic, assign) NSInteger fans;//粉丝
//@property (nonatomic, assign) NSInteger focus;//关注
//@property (nonatomic, assign) NSInteger gold;//金币数
//@property (nonatomic, assign) BOOL      islock;//是否锁定, 0否，1是
//@property (nonatomic, copy  ) NSString  *lastloginip;//最后登录IP
//@property (nonatomic, copy  ) NSString  *lastlogintime;//最后登录时间
//@property (nonatomic, copy  ) NSString  *regdate;//注册日期
//@property (nonatomic, assign) NSInteger rmb;//帐号金额
//@property (nonatomic, copy  ) NSString  *token;//登录成功标识
//@property (nonatomic, copy  ) NSString  *city;//城市
//@property (nonatomic, copy  ) NSString  *emailaddress;//电子邮箱地址
//@property (nonatomic, copy  ) NSString  *facebook;
//@property (nonatomic, copy  ) NSString  *firstname;
//@property (nonatomic, copy  ) NSString  *headportrait;//头像连接
//@property (nonatomic, copy  ) NSString  *lastname;
//@property (nonatomic, copy  ) NSString  *middlename;
//@property (nonatomic, copy  ) NSString  *mydescription;//个性描述
//@property (nonatomic, copy  ) NSString  *nationality;//国籍
//@property (nonatomic, copy  ) NSString  *nickname;//昵称
//@property (nonatomic, assign) NSInteger sex;//性别
//@property (nonatomic, copy  ) NSString  *user;
//@property (nonatomic, copy  ) NSString  *userid;//用户编号
//@property (nonatomic, copy  ) NSString  *wechat;
//@property (nonatomic, assign) NSInteger usertype;//用户类型
//@property (nonatomic, assign) NSInteger videos;//视频数
//@property (nonatomic, copy  ) NSString *contact;//用户手机号

/*🔻为个人中心的getUser接口增加的字段，按理应该成为用户模型的固有属性才对🔻*/
/**等级图标*/
@property (nonatomic, copy  ) NSString *levelImg;
/**头衔图标*/
@property (nonatomic, copy  ) NSString *titleImg;
/**头衔名*/
@property (nonatomic, copy  ) NSString *titleName;
/**相对于我，是否被我拉黑（0 : 否 1 : 是）*/
@property (nonatomic, assign) NSInteger blacks;//
/*🔺为个人中心的getUser接口增加的字段，按理应该成为用户模型的固有属性才对🔺*/

/*🔻为登录用户的个人中心增加的个人中心操作类属性🔻*/

/**为登录用户的个人中心增加的个人中心操作类属性*/
@property (nonatomic, strong)  BYC_MyCenterHandler *handler;

/*🔺为登录用户的个人中心增加的个人中心操作类属性🔺*/

//*********自己增加关注属性
@property (nonatomic, copy  ) NSString            *attentionTime;//关注时间（自己账户获取不到自己关注自己的时间，后台没有返回）
@property (nonatomic, assign) NSInteger           hsa;//是否关注 1关注0未关注
@property (nonatomic, assign) NSInteger           ha;//是否互为关注 1是0否  注意：先获取HA的值，若值为0，再取HAS判断是否关注状态；否则状态为互相关注

@property (nonatomic, assign) WhetherFocusForCell whetherFocusForCell;


/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/

/** 用户编号 */
@property (nonatomic, copy) NSString *userid;

/** 密码 */
@property (nonatomic, copy) NSString *password;

/** 手机号 */
@property (nonatomic, copy) NSString *cellphonenumber;

/** 头像 */
@property (nonatomic, copy) NSString *headportrait;

/** 昵称 */
@property (nonatomic, copy) NSString *nickname;

/** 性别 0男true 1女false*/
@property (nonatomic, assign) BOOL sex;

/** 是否锁定 0否 1是 */
@property (nonatomic, assign) BOOL islock;

/** 登录标识 */
@property (nonatomic, copy) NSString *token;

/** 注册时间 */
@property (nonatomic, copy) NSString  *regdate;

/** 最后登录时间 */
@property (nonatomic, copy) NSString *lastlogintime;

/** 最后登录IP */
@property (nonatomic, copy) NSString *lastloginip;

/** 用户类型 0普通用户 10专家 1后台管理员 2超级管理员 */
@property (nonatomic, assign) NSInteger  usertype;

/** 设备标识 */
@property (nonatomic, copy) NSString *devicetokens;

/** 成长值 */
@property (nonatomic, assign) NSInteger  growth;

/** 唯一ID */
@property (nonatomic, copy) NSString *uninum;

/** 审核状态 0未审核 1已审核 */
@property (nonatomic, assign) NSInteger  procestate;

/** 审核时间 */
@property (nonatomic, assign) NSInteger  procetime;

/** 平台(Android/iOS) */
@property (nonatomic, copy) NSString *platform;

/** 渠道来源 */
@property (nonatomic, copy) NSString *channel;

/** 是否自生成 0否 1是 */
@property (nonatomic, assign) BOOL isauto;

/** 用户信息 */
/***/
@property (nonatomic, strong)  BYC_UserInfoModel  *userInfo;

/** 用户头衔 */
@property (nonatomic, strong)  BYC_UserTitle  *userTitle;

/** 用户等级 */
@property (nonatomic, strong)  BYC_UserLevel *userLevel;

/** 是否被拉黑 0否 1是 */
@property (nonatomic, assign) BOOL isblack;

/** 关注状态 1互相关注 2已关注 3被关注 4未关注 */
@property (nonatomic, assign) NSInteger  attentionstate;

/** 关注时间 */
@property (nonatomic, copy) NSString *attentiontime;


/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺新接口模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/

@property(nonatomic, assign) NSInteger  flag_Btn;

@end
