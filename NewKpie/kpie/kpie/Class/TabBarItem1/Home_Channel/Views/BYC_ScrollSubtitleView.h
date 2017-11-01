//
//  BYC_ScrollSubtitleView.h
//  kpie
//
//  Created by 元朝 on 16/7/13.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_OtherViewControllerModel.h"

typedef NS_ENUM(NSUInteger, ENUM_SelectStatue) {
    /**最新*/
    ENUM_SelectStatueNew,
    /**最热*/
    ENUM_SelectStatueOld
};

@class BYC_ScrollSubtitleView;

@protocol BYC_ScrollSubtitleViewDelegate <NSObject>

/**
 *  选中子标题
 *
 *  @param scrollSubtitleView 自身视图
 *  @param indexPath          下标
 */
- (void)scrollSubtitleView:(BYC_ScrollSubtitleView *)scrollSubtitleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  选中子标题
 *
 *  @param scrollSubtitleView 自身视图
 *  @param indexPath          最新最热切换
 */
- (void)scrollSubtitleView:(BYC_ScrollSubtitleView *)scrollSubtitleView didSelectStatue:(ENUM_SelectStatue)statue;
@end

@interface BYC_ScrollSubtitleView: UIView

@property (nonatomic, weak)  id<BYC_ScrollSubtitleViewDelegate>  delegate;
/**数据*/
@property (nonatomic, strong)  NSArray<BYC_OtherViewControllerModel *> *arr_Models;

/***/
@property (nonatomic, assign)  ENUM_SelectStatue  selectStatue;

@end
