//
//  BYC_MTColumnCollectionHeader.h
//  kpie
//
//  Created by 元朝 on 15/12/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_OtherViewControllerModel.h"
#import "BYC_InStepColumnCollectionHeader.h"

//typedef NS_ENUM(NSUInteger, Enum_SelectType) {
//     /**最新*/
//    Enum_SelectTypeNew = 1,
//     /**最热*/
//    Enum_SelectTypeHot,
//};

//typedef NS_ENUM(NSUInteger, Enum_ActionSelectType) {
//    /**赛区看点*/
//    Enum_ActionSelectTypeFocus = 3,
//    /**热门选手*/
//    Enum_ActionSelectTypeFavorite,
//    /**精彩花絮*/
//    Enum_ActionSelectTypeTitbits,
//};
//
//typedef NS_ENUM(NSUInteger, Enum_ShowHeaderType) {
//    /**图片*/
//    Enum_ShowHeaderTypeImage = 1,
//    /**轮播图*/
//    Enum_ShowHeaderTypeBanner,
//    /**视频*/
//    Enum_ShowHeaderTypeVideo,
//};

typedef void(^HeaderButtonAction)(NSInteger flag);
@interface BYC_MTColumnCollectionHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *imageV_BG;
//@property (nonatomic, strong)  BYC_OtherViewControllerModel  *model;
/***/
@property (nonatomic, strong)  NSDictionary  *dic_Data;


@property (nonatomic, strong)  HeaderButtonAction  headerButtonAction;

@property (nonatomic, assign)   BYC_TopHiddenViewSelectedButton selectButton;

/**点击的类型*/
@property (nonatomic, assign)  Enum_SelectType        type_Select;
/**选中的活动类型*/
@property (nonatomic, assign)  Enum_ActionSelectType  type_SelectAction;
/**选中的活动类型*/
@property (nonatomic, assign)  Enum_ShowHeaderType    type_ShowHeader;

@end
