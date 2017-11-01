//
//  BYC_ColumnCollectionHeader.h
//  kpie
//
//  Created by 元朝 on 15/12/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_OtherViewControllerModel.h"
#import "BYC_MTBannerModel.h"
#import "BYC_MTVideoGroupModel.h"
typedef NS_ENUM(NSUInteger, BYC_TopHiddenViewSelectedButton) {
    BYC_TopHiddenViewSelectedButtonNew = 1,
    BYC_TopHiddenViewSelectedButtonHot,
};

typedef void(^HeaderButtonAction)(NSInteger flag);
@interface BYC_ColumnCollectionHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *imageV_BG;

@property (nonatomic, strong)  HeaderButtonAction  headerButtonAction;

@property (nonatomic, assign)   BYC_TopHiddenViewSelectedButton selectButton;

/**轮播数据*/
@property (nonatomic, strong)  NSArray <BYC_MTBannerModel     *> *array_Banner;
/**图片数据*/
@property (nonatomic, strong)  BYC_OtherViewControllerModel  *model;


/**是否是 世纪樱花类似活动 可后台制定 名称的数据*/
@property (nonatomic, strong) NSArray<BYC_MTVideoGroupModel *> *array_VideoGroup;
@end
