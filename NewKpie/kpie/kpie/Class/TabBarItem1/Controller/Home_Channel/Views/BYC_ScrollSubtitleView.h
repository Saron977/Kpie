//
//  BYC_ScrollSubtitleView.h
//  kpie
//
//  Created by 元朝 on 16/7/13.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_OtherViewControllerModel.h"
#import "BYC_BaseChannelColumnModel.h"
#import "BYC_BaseChannelGroupModel.h"

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
- (void)scrollSubtitleView:(BYC_ScrollSubtitleView *)scrollSubtitleView didSelectType:(NSUInteger)type;
@end

@interface BYC_ScrollSubtitleView: UIView

@property (nonatomic, weak)  id<BYC_ScrollSubtitleViewDelegate>  delegate;
/**栏目数据模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelColumnModel   *> *arr_ColumnModels;
/**栏目组数据模型数组*/
@property (nonatomic, strong) NSArray <BYC_BaseChannelGroupModel    *> *arr_GroupModels;
/***/
@property (nonatomic, assign)  NSUInteger  type;

@end
