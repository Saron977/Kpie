//
//  NSString+BYC_Tools.m
//  kpie
//
//  Created by 元朝 on 16/2/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "NSString+BYC_Tools.h"

@implementation NSString (BYC_Tools)

-(CGSize)sizeWithfont:(NSInteger)font boundingRectWithSize:(CGSize)size {
        
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paragraphStyle.copy};
    size = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

+ (NSString *)getDateStr:(NSString *)time {

    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[time longLongValue] / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str_Date = [dateFormatter stringFromDate: detaildate];
    return str_Date;
}


@end
