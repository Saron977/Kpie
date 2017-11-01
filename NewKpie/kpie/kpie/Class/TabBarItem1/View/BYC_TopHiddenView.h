//
//  BYC_TopHiddenView.h
//  kpie
//
//  Created by 元朝 on 15/12/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_ColumnCollectionHeader.h"
#import "HL_ColumnVideoSortModel.h"

typedef void(^ButtonAction)(NSInteger flag);

/**栏目类型*/
typedef NS_ENUM(NSUInteger, ENUM_CommentsType) {
    ENUM_CommentsTypeCustom = 1, //普通栏目
    ENUM_CommentsTypeTeacher     //名师点评
};
@interface BYC_TopHiddenView : UIView

/**栏目类型*/
@property (nonatomic, assign)  ENUM_CommentsType  commentsType;


@property (nonatomic, strong)  ButtonAction  buttonAction;

@property (nonatomic, assign)   BYC_TopHiddenViewSelectedButton selectButton;

/**是否是 世纪樱花类似活动 可后台制定 名称的数据*/
@property (nonatomic, strong) NSArray<BYC_MTVideoGroupModel *> *array_VideoGroup;

@property (nonatomic, strong)  NSArray <HL_ColumnVideoSortModel *>  *array_SortModel;


@end
