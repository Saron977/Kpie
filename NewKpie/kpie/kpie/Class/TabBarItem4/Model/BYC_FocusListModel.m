//
//  BYC_FocusListModel.m
//  kpie
//
//  Created by 元朝 on 15/12/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_FocusListModel.h"
#import "NSObject+MJCoding.h"

@implementation BYC_FocusListModel

+(instancetype)initModelWithArray:(NSArray *)array {

   BYC_FocusListModel *model = [super initModelWithArray:array];
//    model.isLike  = [(NSNumber *)array[19] boolValue];//上传该视频的用户的性别
//    model.isVR    = [(NSNumber *)array[20] integerValue];
//    if (model.isVR == 2) {
//        /// 栏目合拍需要
//        model.media_Parameter = array[21];
//        model.templets = [(NSNumber*)array[22] integerValue];
//    }

    return model;
}

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        
        BYC_FocusListModel *model = [self initModelWithArray:arr];
        [mArray addObject:model];
    }
    return [mArray copy];
}

@end
