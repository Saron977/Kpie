//
//  BYC_HomeBannnerHeaderModel.h
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BYC_BaseModel.h"

@interface BYC_HomeChannelListModel : BYC_BaseModel

/**
 *  栏目编号
 */
@property (nonatomic, copy)   NSString   *str_ChannelID;
/**
 *  栏目标题
 */
@property (nonatomic, copy)   NSString   *str_Title;


@end
