//
//  BYC_LeftLikeModel.h
//  kpie
//
//  Created by 元朝 on 15/12/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface BYC_LeftLikeModel : BYC_BaseModel

@property (nonatomic, strong)  NSString  *videoID;          //视频编号
@property (nonatomic, strong)  NSString  *collectionTime;   //收藏时间
@property (nonatomic, strong)  NSString  *cateID;           //剧集编号
@property (nonatomic, assign)  NSInteger videoIndex;       //剧集号(第几集)
@property (nonatomic, strong)  NSString  *videoTitle;       //视频标题
@property (nonatomic, strong)  NSString  *pictureJPG;       //封面图片路径
@property (nonatomic, strong)  NSString  *videoMP4;         //视频播放路径
@property (nonatomic, strong)  NSString  *videoDescription;    //视频简介
@property (nonatomic, strong)  NSString  *userID;           //发布者编号
@property (nonatomic, assign)  NSInteger views;            //点击量
@property (nonatomic, strong)  NSString  *nickName;         //发布者昵称
@property (nonatomic, strong)  NSString  *headPortrait;     //发布者头像路径
@property (nonatomic, strong)  NSString  *scriptID;         //所属剧本编号

@property (nonatomic, assign)  BOOL      sex;            //性别
@property (nonatomic, strong)  NSString  *comments;         //评论数
@property (nonatomic, strong)  NSString  *favorites;     //收藏数
@property (nonatomic, assign)  int       isLike;         //判断是否已点赞
@property (nonatomic, assign)  NSInteger isVR;


@end
