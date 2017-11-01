//
//  BYC_SelecteItemView.h
//  kpie
//
//  Created by 元朝 on 16/5/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYC_SelecteItemView;

@protocol BYC_SelecteItemViewDelegate <NSObject>

- (void)selecteItemView:(BYC_SelecteItemView *)selecteItemView selectedIndex:(NSUInteger)index;

@end

@interface BYC_SelecteItemView : UIView

/**标题接口数组*/
@property (nonatomic, strong)  NSArray <NSString *>  *array_Titles;
@property (nonatomic, weak)  id<BYC_SelecteItemViewDelegate>  delegate_SelecteItemView;

- (void)bottomViewScrollOffset:(CGFloat)offset;
@end
