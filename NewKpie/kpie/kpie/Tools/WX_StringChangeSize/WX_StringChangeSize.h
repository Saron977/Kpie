//
//  WX_StringChangeSize.h
//  kpie
//
//  Created by 王傲擎 on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_StringChangeSize : NSObject


+(CGSize)changeSizeWithString:(NSString*)str FontOfSize:(CGFloat)fontNum;   /**<   传入字体大小, 长度返回 文字size */

@end
