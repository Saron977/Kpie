//
//  WX_AlbumModel.h
//  kpie
//
//  Created by 王傲擎 on 16/3/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_AlbumModel : NSObject

@property(nonatomic, strong) NSString       *albumTitle;        /**<  相片名 (不带后缀)*/
@property(nonatomic, strong) NSString       *imageDataStr;      /**<  图片信息 */
@property(nonatomic, assign) NSInteger      videoDuration;      /**<   视频时长 */

@end
