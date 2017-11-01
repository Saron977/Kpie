//
//  WX_GuideView.h
//  kpie
//
//  Created by 王傲擎 on 16/4/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WX_GuideView : UIView <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView            *scrollView;    /**<   scrollview */
@property(nonatomic, strong) UIPageControl           *pageControl;   /**<   页数 */



-(instancetype)initWithFrame:(CGRect)frame WithImgArray:(NSArray *)imgArray;   /**<  直接把view添加到keyWindow上, 无需设置图层添加,只需要设置视图图片数组就可以, 一句代码实现功能, 展示完成即从keyWindow上销毁 */
@end
