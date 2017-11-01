//
//  BYC_BaseChannelViewController.h
//  kpie
//
//  Created by 元朝 on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"

@interface BYC_BaseChannelViewController : BYC_BaseViewController

/**栏目编号*/
@property (nonatomic,strong) NSString *str_ChannelID;
/**悬浮的视图*/
@property (nonatomic, strong)  UIView  *view_Suspension;

//刷新数据
- (void)reloadData;
@end
