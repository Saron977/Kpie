//
//  BYC_BaseChannelChildModel.h
//  kpie
//
//  Created by 元朝 on 16/7/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"
#import "BYC_BaseChannelBannerModel.h"
#import "BYC_OtherViewControllerModel.h"

typedef NS_ENUM(NSUInteger, ENUM_BaseChannelChildModelType) {
    ENUM_BaseChannelChildModelTypeNew,
    ENUM_BaseChannelChildModelTypeHot,
};

@interface BYC_BaseChannelChildModel : BYC_BaseModel

/**其他数据模型*/
@property (nonatomic, strong)  BYC_OtherViewControllerModel *model_Other;
/**banner模型数据数组*/
@property (nonatomic, strong)  NSArray<BYC_BaseChannelBannerModel *> *arr_BannerModels;
/**视频模型数据数组*/
@property (nonatomic, strong)  NSArray<BYC_HomeViewControllerModel *> *arr_VideoModels;
/**标识*/
@property (nonatomic, assign)  ENUM_BaseChannelChildModelType  type;
/**赋值标识*/
@property (nonatomic, assign)  ENUM_BaseChannelChildModelType  type_Flag;

/**最新是否已经上拉加载更多 加载完毕所有数据 YES:代表没有更多数据*/
@property (nonatomic, assign)  BOOL  isNewWhetherNoMoreData;
/**最热是否已经上拉加载更多 加载完毕所有数据 YES:代表没有更多数据*/
@property (nonatomic, assign)  BOOL  isHotWhetherNoMoreData;

/**
 *  类方法默认初始化方法
 *
 *  @param otherModel         其他数据模型
 *  @param array_BannerModels anner模型数据数组
 *  @param array_VideoModels  视频模型数据数组
 *
 *  @return 返回实例
 */
+ (instancetype)baseChannelChildModelWithOtherModel:(BYC_OtherViewControllerModel *)otherModel arr_BannerModels:(NSArray<BYC_BaseChannelBannerModel *> *)arr_BannerModels arr_VideoModels:(NSArray<BYC_HomeViewControllerModel *> *)arr_VideoModels;

/**
 *  实例方法默认初始化方法
 *
 *  @param otherModel         其他数据模型
 *  @param array_BannerModels anner模型数据数组
 *  @param array_VideoModels  视频模型数据数组
 *
 *  @return 返回实例
 */
- (void)baseChannelChildModelWithOtherModel:(BYC_OtherViewControllerModel *)otherModel arr_BannerModels:(NSArray<BYC_BaseChannelBannerModel *> *)arr_BannerModels arr_VideoModels:(NSArray<BYC_HomeViewControllerModel *> *)arr_VideoModels type:(ENUM_BaseChannelChildModelType)type_Flag;

/**
 *  获取根据type_Flag标识要求的视频数据数组(本想mutableCopy 一个对象处理，然而需要把此类的模型都要归档化代价有点大，只能将就着用这个方式处理🙄)
 *
 *  @param type_Flag 标识
 *
 *  @return 返回通过type_Flag标识要求的视频数据数组
 */
- (NSArray<BYC_HomeViewControllerModel *> *)getVideoDataWithType:(ENUM_BaseChannelChildModelType)type_Flag;
@end
