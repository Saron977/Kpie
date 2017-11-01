//
//  BYC_BaseChannelModels.h
//  kpie
//
//  Created by 元朝 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"
#import "BYC_BaseChannelVideoModel.h"
#import "BYC_BaseChannelThemeModel.h"
#import "BYC_BaseChannelGroupModel.h"
#import "BYC_BaseChannelSecCoverModel.h"
#import "BYC_BaseChannelColumnModel.h"
#import "BYC_BaseChannelDataModel.h"
#import "BYC_MotifModel.h"

@interface BYC_BaseChannelModels : BYC_BaseModel

/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻频道模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/

/**
*  频道模型
*/
@property (nonatomic, strong)  NSArray <BYC_BaseChannelDataModel   *> *arr_ChannelDataModels;
/***/
@property (nonatomic, strong)  BYC_MotifModel *model_Motif;
/**栏目数据模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelColumnModel   *> *arr_ColumnModels;


/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺频道模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/
/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻栏目模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/

/**视频模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelVideoModel    *> *arr_VideoModels;
/**话题数据模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelThemeModel    *> *arr_ThemeModels;
/**栏目组数据模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelGroupModel    *> *arr_GroupModels;
/**栏目封面数据模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelSecCoverModel *> *arr_SecCoverModels;
/**分享链接*/
@property (nonatomic, copy  ) NSString  *str_ShareUrl;
/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺栏目模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/

/**
 *  类方法默认初始化方法
 *
 *  @return 返回实例
 */
+ (instancetype)baseChannelChildModel;

/**
 *  实例方法给已有的实例赋值
 *
 *  @param otherModel         其他数据模型
 *  @param array_BannerModels anner模型数据数组
 *  @param array_VideoModels  视频模型数据数组
 *
 */
- (void)baseChannelChildModelWithVideoModels:(NSArray <BYC_BaseChannelVideoModel *> *)arr_VideoModels themeModels:(NSArray <BYC_BaseChannelThemeModel *> *)arr_ThemeModels groupModels:(NSArray <BYC_BaseChannelGroupModel *> *)arr_GroupModels secCoverModels:(NSArray <BYC_BaseChannelSecCoverModel *> *)arr_SecCoverModels andShareUrl:(NSString *)shareUrl;

@end


