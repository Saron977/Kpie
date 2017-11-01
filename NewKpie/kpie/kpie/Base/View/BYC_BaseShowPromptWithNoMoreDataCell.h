//
//  BYC_BaseShowPromptWithNoMoreDataCell.h
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYC_BaseShowPromptWithNoMoreDataCell;

@protocol BaseShowPromptWithNoMoreDataCellDelegate <NSObject>

- (void)baseShowPromptWithNoMoreDataCellTouchBegin:(BYC_BaseShowPromptWithNoMoreDataCell *)cell;

@end

@interface BYC_BaseShowPromptWithNoMoreDataCell : UICollectionViewCell

/***/
@property (nonatomic, weak)  id<BaseShowPromptWithNoMoreDataCellDelegate>  delegate_BaseShowPromptWithNoMoreDataCell;

@end
