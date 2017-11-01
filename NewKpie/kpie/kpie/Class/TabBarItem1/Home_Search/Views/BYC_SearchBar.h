//
//  BYC_SearchBar.h
//  kpie
//
//  Created by 元朝 on 16/5/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYC_SearchBar;

typedef NS_ENUM(NSUInteger, ENUM_ShowInterfaceType) {

    /**搜索历史记录列表*/
    ENUM_ShowInterfaceTypeIsHistory,
    /**搜索字段列表*/
    ENUM_ShowInterfaceTypeIsSearchList,
    /**搜索结果列表*/
    ENUM_ShowInterfaceTypeIsResultList
};

@protocol BYC_SearchBarDelegate <NSObject>

- (void)searchBar:(BYC_SearchBar *)searchBar showInterfaceType:(ENUM_ShowInterfaceType)showInterfaceType;

@end

@interface BYC_SearchBar : UIView

@property (nonatomic, weak)  id<BYC_SearchBarDelegate>  delegate_SearchBar;

@end
