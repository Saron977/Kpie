//
//  WX_ThemeModel.h
//  kpie
//
//  Created by 王傲擎 on 16/3/2.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_ThemeModel : NSObject

/* 是否添加话题 */
@property (nonatomic, assign) BOOL          isAddTheme;

/* 添加话题字符串 */
@property (nonatomic, strong) NSString      *themeStr;

/*
 ***
    添加话题的视频标题
    在创作界面中让cell有选中状态
 ***
*/
@property (nonatomic, strong) NSString      *themeTitle;

@end
