//
//  BYC_ResultDynamicCollectionViewHandler.h
//  kpie
//  Created by 元朝 on 16/5/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_FocusListModel.h"
#import "ZFPlayer.h"
#import "BYC_BaseHandler.h"

typedef void(^ResultDynamicDataCountBlock)(NSInteger count);

@interface BYC_ResultDynamicCollectionViewHandler: BYC_BaseHandler

@property (nonatomic, strong, readonly)  UITableView  *tableView;
/**搜索关键词*/
@property (nonatomic, copy)  NSString  *string_KeyWords;
/**登录重新刷新*/
@property (nonatomic, assign)  BOOL     isLoginReloadData;

/** ZF播放器 */
@property (nonatomic, strong) ZFPlayerView          *playerView;
/**
 *  本类的初始化方法
 */
- (instancetype)initResultDynamicCollectionViewHandle:(ResultDynamicDataCountBlock)dataCountBlock;

@end