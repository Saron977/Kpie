//
//  BYC_MTVideoThemeModel.m
//  kpie
//
//  Created by 元朝 on 16/4/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MTVideoThemeModel.h"

@implementation BYC_MTVideoThemeModel

+ (NSArray *)initModelsWithArray:(NSArray *)array {

    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_MTVideoThemeModel *model = [[BYC_MTVideoThemeModel alloc] init];
        model.theme_Id     = arr[0];
        model.theme_Name   = arr[1];
        
        model.theme_Name = [[model.theme_Name stringByReplacingOccurrencesOfString:@"#hide" withString:@""] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        [mArray addObject:model];
    }
    return [mArray copy];
}
@end
