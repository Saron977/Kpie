//
//  WX_StringChangeSize.m
//  kpie
//
//  Created by 王傲擎 on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_StringChangeSize.h"

@implementation WX_StringChangeSize

+(CGSize)changeSizeWithString:(NSString*)str FontOfSize:(CGFloat)fontNum
{

    NSDictionary *str_Attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontNum]};
    CGSize size = [str sizeWithAttributes:str_Attributes];
    
    return size;
}
@end
