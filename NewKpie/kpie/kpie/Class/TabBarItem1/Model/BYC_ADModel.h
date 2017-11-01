//
//  BYC_ADModel.h
//  kpie
//
//  Created by 元朝 on 16/1/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"
#import "BYC_BaseVideoModel.h"
typedef NS_ENUM(NSUInteger, ADType) {
    ADTypeVideo,  //视频广告
    ADTypeColumn, //栏目广告
    ADTypeWeb,    //网站广告
};

@interface BYC_ADModel : BYC_BaseModel

//广告共有属性
/**广告编号*/
@property (nonatomic, copy  ) NSString  *advertID;
/**广告图片*/
//@property (nonatomic, copy  ) NSString  *advertImg;
/**广告类型：1 视频 2 栏目  3 网址 4比基尼类型广告 5 世纪樱花类型 6 合拍类型 7 怪咖类型 ,8 国庆栏目*/
@property (nonatomic, assign) NSInteger advertType;
/**广告地址（此为视频编号）*/
@property (nonatomic, copy  ) NSString  *advertUrl;
/**广告单日显示次数*/
//@property (nonatomic, assign) NSInteger opens;
// 栏目广告独私有属性
/**栏目编号*/
@property (nonatomic, copy  ) NSString  *columnID;
/**栏目名称*/
@property (nonatomic, copy  ) NSString  *columnName;
/**第二封面*/
@property (nonatomic, copy  ) NSString  *secondCover;
/**栏目简介*/
@property (nonatomic, copy  ) NSString  *columnDesc;
/**活动标签*/
@property (nonatomic, copy  ) NSString  *theMeName;
/**所属频道编号*/
@property (nonatomic, copy  ) NSString  *channelID;

/**
 *  广告模型
 *
 *  @param array  广告数据
 *  @param ADType 广告类型
 *
 *  @return 模型化数据
 */
+ (instancetype)initModelWithArray:(NSArray *)array type:(ADType)ADType;


/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/


/**全屏广告*/
@property (nonatomic, strong)  NSArray <BYC_ADModel *> *advertList1;
/**卡片广告*/
@property (nonatomic, strong)  NSArray <BYC_ADModel *> *advertList2;


/**
 * 广告编号
 */
@property (nonatomic, copy)  NSString  *advertid;

/**
 * 广告名称
 */
@property (nonatomic, copy)  NSString  *advertname;

/**
 * 广告图片
 */
@property (nonatomic, copy)  NSString  *advertimg;

/**
 * 开始日期
 */
@property (nonatomic, assign)  NSInteger starttime;


/**
 * 结束日期
 */
@property (nonatomic, assign)  NSInteger endtime;

/**
 * 广告类型 1视频 2栏目 3网址
 */
@property (nonatomic, assign)  NSInteger adverttype;

/**
 * 广告属性 1全屏 2卡片
 */
@property (nonatomic, assign)  NSInteger advertprop;

/**
 * 广告地址
 */
@property (nonatomic, copy)  NSString  *adverturl;

/**
 * 点击数
 */
@property (nonatomic, assign)  NSInteger clicks;

/**
 * 单日投放次数
 */
@property (nonatomic, assign)  NSInteger opens;

/**
 * 视频数据
 */
/***/
@property (nonatomic, strong)  BYC_BaseVideoModel  *video;

/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺新接口模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/


@end
