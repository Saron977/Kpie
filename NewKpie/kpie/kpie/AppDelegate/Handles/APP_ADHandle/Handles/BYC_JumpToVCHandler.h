//
//  BYC_JumpToVCHandler.h
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_OtherViewControllerModel.h"

typedef NS_ENUM(NSUInteger, ENUM_JumpToVCHandelType) {
    /**广告跳转*/
    ENUM_JumpToVCHandelTypeAD,
    /**banner跳转*/
    ENUM_JumpToVCHandelTypeBanner,
    /**列表跳转*/
    ENUM_JumpToVCHandelTypeList,
};

@interface BYC_JumpToVCHandler: NSObject

/**
 
 跳转H5页面
 */
+ (void)jumpToWebWithUrl:(NSString *)url;


/**
 
 跳转到通用栏目

 @param columnId
 */
+(void)jumpToColumnWithColumnId:(NSString *)columnId;

@end
