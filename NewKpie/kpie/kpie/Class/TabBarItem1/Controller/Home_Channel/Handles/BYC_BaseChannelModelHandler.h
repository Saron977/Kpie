//
//  BYC_BaseChannelModelHandler.h
//  kpie
//
//  Created by 元朝 on 16/8/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseChannelModels.h"
#import "BYC_BaseColumnModelHandler.h"

@interface BYC_BaseChannelModelHandler : NSObject

/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻频道模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/

/**主题专属模型,每个频道都会赋值相同的主题模型*/
@property (nonatomic, strong)  BYC_MotifModel *model_Motif;
/**频道模型*/
@property (nonatomic, strong)  BYC_BaseChannelDataModel *model_ChannelData;
/**频道所在下标*/
@property (nonatomic, assign)  NSUInteger  index;
/**栏目条数据模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelColumnModel   *> *arr_ColumnModels;
/**数据字典*/
@property (nonatomic, strong) NSMutableDictionary <id , BYC_BaseColumnModelHandler *> *mDic_Models;
/**数据下标*/
@property (nonatomic, strong) NSIndexPath            *indexPath_CurrentData;


/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺频道模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/

/**当前展示的models*/
@property (nonatomic, strong)  BYC_BaseChannelModels  *models_Current;
/**当前选中的栏目模型处理类*/
@property (nonatomic, strong)  BYC_BaseColumnModelHandler  *handel_ColumnModels;

/**
 *  本类的初始化方法
 */
+ (instancetype)baseChannelModelHandel;

/**
 *  获取根据type_Flag标识要求的视频数据数组(本想mutableCopy 一个对象处理，然而需要把此类的模型都要归档化代价有点大，只能将就着用这个方式处理🙄)
 *
 *  @param type_Flag 标识
 *
 *  @return 返回通过type_Flag标识要求的视频数据数组
 */
- (NSArray <BYC_BaseChannelVideoModel *> *)getVideoDataWithIndex:(NSInteger)Index andType:(NSUInteger)type_Flag;

-(BYC_BaseColumnModelHandler *)getColumnModelsWithDifferentIndex:(NSInteger)index;
-(BYC_BaseChannelModels *)getCurrentModelsWithDifferentIndex:(NSInteger)Index andType:(NSUInteger)type;
@end
