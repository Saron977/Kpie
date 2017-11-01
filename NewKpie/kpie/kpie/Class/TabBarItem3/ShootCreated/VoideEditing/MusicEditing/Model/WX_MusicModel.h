//
//  WX_MusicModel.h
//  kpie
//
//  Created by 王傲擎 on 15/12/16.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_MusicModel : NSObject

/// 0  MUSICID      String    音乐编号
@property(nonatomic,retain) NSString            *musicID;
/// 1  MUSICNAME    String    音乐名称
@property(nonatomic,retain) NSString            *musicName;
/// 2  MUSICURL     String    音乐下载路径
@property(nonatomic,retain) NSString            *musicUrl;
/// 3  PICTUREJPG   String    音乐背景图片
@property(nonatomic,retain) NSString            *pictureJPG;
/// 4  MUSICTYPE    String     音乐类型
@property(nonatomic,retain) NSString            *musicType;
/// 5  UPLOADTIME   TimeStamp  上传时间
@property(nonatomic,retain) NSString            *timeStamp;

///
@property(nonatomic,retain) NSString            *musicPath;

+(instancetype)initModelWithDic:(NSDictionary *)dic;

@end
