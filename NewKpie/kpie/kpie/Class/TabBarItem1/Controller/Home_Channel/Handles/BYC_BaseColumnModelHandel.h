//
//  BYC_BaseColumnModelHandel.h
//  kpie
//
//  Created by 元朝 on 16/8/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_BaseChannelModels.h"

@interface BYC_BaseColumnModelHandel : NSObject
/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻栏目模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/


/**数据字典根据type标示设置以及获取*/
@property (nonatomic, strong) NSMutableDictionary <id , BYC_BaseChannelModels *> *mDic_ModelsWithType;

/**栏目专属模型*/
@property (nonatomic, strong) BYC_BaseChannelColumnModel         *models_Column;
/**栏目组数据模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelGroupModel    *> *arr_GroupModels;
/**标识*/
@property (nonatomic, assign) NSUInteger  type;
/**赋值标识*/
@property (nonatomic, assign) NSUInteger  type_Flag;
/**在没有视频数据的时候显示提示空数据cell:YES 需要显示 NO:不需要显示*/
@property (nonatomic, assign)  BOOL  isWhetherShowPromptWithNoMoreData;

/**是否已经上拉加载更多 加载完毕所有数据 YES:代表没有更多数据*/
@property (nonatomic, assign)  NSNumber  *isWhetherNoMoreData;
/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺栏目模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/

+ (instancetype)baseColumnModelHandel;

-(NSString *)getCurrentGroupId;
-(void)setIsWhetherNoMoreDataWithDifferentType:(NSInteger)type andNumber:(NSNumber *)num;
-(NSNumber *)getIsWhetherNoMoreDataWithDifferentType:(NSInteger)type;
@end
