//
//  BYC_BannerControl.h
//  kpie
//
//  Created by 元朝 on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BYC_BannerControlModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ENUM_PageControlShowStyle) {
    
    ENUM_PageControlShowStyleNone,
    ENUM_PageControlShowStyleBottomLeft,
    ENUM_PageControlShowStyleCenter,
    ENUM_PageControlShowStyleBottomRight,
    ENUM_PageControlShowStyleTopLeft,
    ENUM_PageControlShowStyleTopRight,
};

@interface BYC_BannerControl : UIView

typedef void(^Block_TapCallBack)(NSInteger index);

/**PageControl的位置*/
@property (assign, nonatomic) ENUM_PageControlShowStyle   pageControlShowStyle;
/***/
@property (nonatomic, strong) NSArray <BYC_BannerControlModel *>  *__nullable arr_BannerControlModels;
/**
 *  创建一个BannerControl
 *
 *  @param frame                frame
 *  @param imageURLArray        要展示的图片链接和类型的模型数组
 *  @param placeHolder          未加载完成时的替代图片
 *  @param pageControlShowStyle PageControl的显示位置
 *
 *  @return BYC_BannerControl
 */
+ (instancetype)bannerControlWithFrame:(CGRect)frame bannerControlModels:(NSArray <BYC_BannerControlModel *> *)bannerControlModels placeHolderImage:(nullable NSString *)placeHolder pageControlShowStyle:(ENUM_PageControlShowStyle)pageControlShowStyle tapCallBackBlock:(nullable Block_TapCallBack)block_CallBack;

- (void)bannerControlWithModels:(NSArray <BYC_BannerControlModel *> *)bannerControlModels placeHolderImage:(nullable NSString *)placeHolder pageControlShowStyle:(ENUM_PageControlShowStyle)pageControlShowStyle tapCallBackBlock:(nullable Block_TapCallBack)block_CallBack;
NS_ASSUME_NONNULL_END
@end
