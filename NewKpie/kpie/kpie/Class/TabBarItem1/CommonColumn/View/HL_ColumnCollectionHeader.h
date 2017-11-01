//
//  HL_ColumnCollectionHeader.h
//  kpie
//
//  Created by sunheli on 16/11/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_OtherViewControllerModel.h"
#import "BYC_ColumnCollectionHeader.h"
#import "HL_ColumnVideoSortModel.h"
#import "BYC_BannerControl.h"
#import "HL_ColumnGroupView.h"


typedef NS_ENUM(NSUInteger, Enum_SelectType) {
    /**最新*/
    Enum_SelectTypeNew = 1,
    /**最热*/
    Enum_SelectTypeHot,
};

typedef NS_ENUM(NSUInteger, Enum_ActionSelectType) {
    /**赛区看点*/
    Enum_ActionSelectTypeFocus = 3,
    /**热门选手*/
    Enum_ActionSelectTypeFavorite,
    /**精彩花絮*/
    Enum_ActionSelectTypeTitbits,
    
    Enum_ActionSelectTypeOther,
};

typedef NS_ENUM(NSUInteger, Enum_ShowHeaderType) {
    /**图片*/
    Enum_ShowHeaderTypeImage = 1,
    /**轮播图*/
    Enum_ShowHeaderTypeBanner,
    /**视频*/
    Enum_ShowHeaderTypeVideo,
};

typedef void(^HeaderButtonAction)(NSInteger flag);


@interface HL_ColumnCollectionHeader : UICollectionReusableView

@property (nonatomic, strong) UIView *view_Top;

@property (nonatomic, strong) UIView  *view_Banner;

@property (nonatomic, strong) BYC_BannerControl *bannerControl;

@property (nonatomic, strong) UITextView *textView_Description;

@property (nonatomic, strong) UIView *view_Group;

@property (nonatomic, strong) UIView *view_OtherGroup;

@property (nonatomic, strong) HL_ColumnGroupView *groupView_MT;

@property (nonatomic, strong) UIButton *button_Group1;

@property (nonatomic, strong) UIButton *button_Group2;

@property (nonatomic, strong) UIImageView *imageView_spric;


@property (nonatomic, strong)    UIView *view_Bottom;

@property (nonatomic, strong)    UIButton *button_New;

@property (nonatomic, strong)    UIButton *button_Hot;

@property (nonatomic, strong)    UIView   *view_New;

@property (nonatomic, strong)    UIView   *view_Hot;

@property (nonatomic, strong)    UIView   *view_BottomLine;


@property (nonatomic, strong)  BYC_OtherViewControllerModel  *model;
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

/**隐藏view_ChangeDataType*/
@property (nonatomic, assign)  BOOL  isHiddenView_ChangeDataType;

/** 隐藏比基尼的GroupView还是其他栏目的GrouView */
@property (nonatomic, assign) BOOL   isHiddenGroupView_ChangeColumnType;

@property (nonatomic, strong) NSArray <HL_ColumnVideoSortModel *> *array_SortModel;

/**banner数据*/
@property (nonatomic, strong)  NSArray <BYC_MTBannerModel *>*array_Banner;
/**组*/
@property (nonatomic, strong)  NSArray <BYC_MTVideoGroupModel *>*array_Group;

@end
