//
//  BYC_MTColumnCollectionHeader.h
//  kpie
//
//  Created by 元朝 on 15/12/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_OtherViewControllerModel.h"
#import "HL_ColumnCollectionHeader.h"

typedef void(^HeaderButtonAction)(NSInteger flag);
@interface BYC_MTColumnCollectionHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *imageV_BG;

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

@property (nonatomic, strong)  BYC_OtherViewControllerModel  *model;

/**banner数据*/
@property (nonatomic, strong)  NSArray <BYC_MTBannerModel *>*array_Banner;
/**组*/
@property (nonatomic, strong)  NSArray <BYC_MTVideoGroupModel *>*array_Group;

@end
