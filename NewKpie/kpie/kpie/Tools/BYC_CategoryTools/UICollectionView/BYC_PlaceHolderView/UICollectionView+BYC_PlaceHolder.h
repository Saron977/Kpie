//
//  UICollectionView+BYC_PlaceHolder.h
//  kpie
//
//  Created by 元朝 on 16/5/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  使用默认的占位视图时，不需要创建代理对象的协议。目的就是要通过协议实现下面的可选方法。确定统一的方法名，方便调用。
 */
@protocol BYC_CollectionViewPlaceHolderDelegate <NSObject>

@optional

/**
 *  创建无数据的时候展示的视图，可选方法，在没有实现此方法的时候，会自动创建一个默认的占位遮罩
 *
 *  @return 返回的占位视图
 */
- (UIView *)creatPlaceHolderView;
@end

@interface UICollectionView (BYC_PlaceHolder)

/**
 *  提供自定义的刷新接口，runtime方法交换会导致死循环，所以暂时没有想到如何直接用系统的刷新方法。
 */
- (void)byc_reloadData;

/**
 *  提供带提示字符的自定义的刷新接口。
 *
 *  @param promptText 提示字符（仅针对默认提供的视图）
 */
- (void)byc_reloadData:(NSString *)promptText;

/**
 *  提供带提示字符和视图位置的自定义的刷新接口。
 *
 *  @param promptText 提示字符（仅针对默认提供的视图）
 *  @param frame      视图位置（仅针对默认提供的视图）
 */
- (void)byc_reloadData:(NSString *)promptText frame:(CGRect)frame;
@end
