//
//  BYC_HistoryCollectionReusableView.h
//  kpie
//
//  Created by 元朝 on 16/5/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearRecodBlock)();

@interface BYC_HistoryCollectionReusableView : UICollectionReusableView

/**数据*/
@property (nonatomic, copy)  NSDictionary  *dic_Data;
/**清空历史关键词Block*/
@property (nonatomic, strong)  ClearRecodBlock  clearRecodBlock;
@end
