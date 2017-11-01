//
//  BYC_SegmentSwitch.h
//  kpie
//
//  Created by 元朝 on 16/7/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYC_SegmentSwitch;

@protocol BYC_SegmentSwitchDelegate <NSObject>

- (void)segmentSwitch:(BYC_SegmentSwitch *)segmentSwitch didSelectItemAtIndexPath:(int)index;

@end

@interface BYC_SegmentSwitch : UIView

@property (nonatomic, weak)  id<BYC_SegmentSwitchDelegate>  delegate;

/**选中的颜色,默认白色*/
@property (nonatomic, strong)  UIColor *color_Selected;
/**背景颜色,默认灰色*/
@property (nonatomic, strong)  UIColor *color_Background;
/**选中标题的颜色,默认和视图背景色一致*/
@property (nonatomic, strong)  UIColor *color_Title_Selected;
/**未选中标题颜色,默认和选中的背景色一致*/
@property (nonatomic, strong)  UIColor *color_Title_Background;
/**间距*/
@property (nonatomic, assign)  CGFloat float_MarginInset;
/**上一次选中的下标*/
@property (nonatomic, assign)  int     int_SelectedLastIndex;
/**当前选中的下标*/
@property (nonatomic, assign)  int     int_SelectedCurrentIndex;
/**拖动距离*/
@property (nonatomic, assign)  CGFloat float_Progress;

- (instancetype)initWithConfigureItems:(NSArray <NSString *> *)items;
@end
