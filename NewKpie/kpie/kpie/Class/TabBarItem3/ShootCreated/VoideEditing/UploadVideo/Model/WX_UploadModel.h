//
//  WX_UploadModel.h
//  kpie
//
//  Created by 王傲擎 on 15/12/2.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_UploadModel : NSObject

@property(nonatomic,retain) NSString            *mediaPath;         // 视频路径
@property(nonatomic,retain) NSData              *mediaData;         // 视频数据
@property(nonatomic,retain) NSString            *imgPath;           // 截图路径
@property(nonatomic,retain) NSData              *imgData;           // 截图数据   二者选一个
@property(nonatomic,retain) NSString            *userID;            // 用户ID
@property(nonatomic,retain) NSString            *mediaTitle;        // 视频标题
@property(nonatomic,retain) NSString            *mediaContents;     // 视频内容
@property(nonatomic,retain) NSString            *longitude;         // 经度
@property(nonatomic,retain) NSString            *latitude;          // 纬度

@property(nonatomic,retain) NSString            *upVideoID;         // 上传videoID
@property(nonatomic,retain) NSString            *upVideoPath;       // 上传video路径
@property(nonatomic,retain) NSString            *upUserName;        // 用户名



@end
