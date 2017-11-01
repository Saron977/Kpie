//
//  BYC_BaseChannelFindMotifModel.h
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

typedef NS_ENUM(NSUInteger, ENUM_MotifMode) {
    /**旧版 --> 对应 BYC_ChannelViewController*/
    ENUM_MotifModeOld = 0,
    /**新版 --> 未知*/
    ENUM_MotifModeNew
};

typedef NS_ENUM(NSUInteger, ENUM_MotifBelongs) {
    /**所属首页*/
    ENUM_MotifBelongsToHome = 0,
    /**所属发现*/
    ENUM_MotifBelongsToDiscover
};


@interface BYC_MotifModel : BYC_BaseModel
//
///**主题编号*/
//@property (nonatomic, strong)  NSString  *motifID;
///**主题名称*/
//@property (nonatomic, strong)  NSString  *motifName;
///**主题风格0OLD 1NEW*/
//@property (nonatomic, assign)  ENUM_MotifMode  motifMode;
///**主题所属 0首页 1发现*/
//@property (nonatomic, assign)  ENUM_MotifBelongs  motifAsc;
//

/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/
/**主题编号*/
@property (nonatomic, strong)  NSString  *motifid;
/**主题名称*/
@property (nonatomic, strong)  NSString  *motifname;
/**主题风格0OLD 1NEW*/
@property (nonatomic, assign)  ENUM_MotifMode  motifmode;
/**主题所属 0首页 1发现*/
@property (nonatomic, assign)  ENUM_MotifBelongs  motifasc;
/***/
@property (nonatomic, assign)  NSInteger  number;

/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺新接口模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/

@end
