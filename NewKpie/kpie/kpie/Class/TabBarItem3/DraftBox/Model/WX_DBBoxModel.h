//
//  WX_DBBoxModel.h
//  kpie
//
//  Created by 王傲擎 on 15/12/4.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_DBBoxModel : NSObject

@property(nonatomic, retain) NSString           *title;
@property(nonatomic, retain) NSString           *imgDataStr;
@property(nonatomic, retain) NSString           *mediaPath;
@property(nonatomic, retain) NSString           *mediaTitle;
@property(nonatomic, retain) NSString           *contents;
@property(nonatomic, retain) NSString           *location;
@property(nonatomic, assign) NSInteger          media_Type; /**<   视频类型 */
@property(nonatomic, copy)   NSString           *videoID;   /**<   视频ID */
@end
