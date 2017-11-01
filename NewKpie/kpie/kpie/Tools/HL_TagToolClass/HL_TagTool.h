//
//  HL_TagTool.h
//  kpie
//
//  Created by sunheli on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HL_TagTool : NSObject


/**
 解析@“##“的标签
 @param parseText 解析的文本

 @return 标签数
 */
+(NSMutableArray *)parseTag:(NSString *)parseText;


/**
 解析网址

 @param parseText 解析文本

 @return 网址数
 */
+(NSMutableArray *)parseUrlTag:(NSString *)parseText;
@end
