//
//  WX_CommentModel.h
//  kpie
//
//  Created by 王傲擎 on 15/12/10.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_CommentModel : BYC_BaseModel
///          视频编号
@property(nonatomic,retain) NSString                *videoID;

 ///         评论编号
@property(nonatomic,retain) NSString                *commentID;

 ///         评论内容
//@property(nonatomic,retain) NSString                *content;

///         评论人编号
@property(nonatomic,retain) NSString                *userID;

///         评论人昵称
@property(nonatomic,retain) NSString                *nickName;

 ///         评论人头像路径
@property(nonatomic,retain) NSString                *headportrait;

 ///         回复评论编号
@property(nonatomic,retain) NSString                *tocommentID;

///         回复人昵称
@property(nonatomic,retain) NSString                *tonickName;

///         评论人头像路径
@property(nonatomic,retain) NSString                *toheadportrait;

 ///         评论时间
@property(nonatomic,retain) NSString                *postDateTime;

///         用户类型: 0普通用户，10名师，1后台管理员
@property(nonatomic,assign) NSInteger               userType;

///         性别: 0_男   1_女
@property(nonatomic,assign) BOOL                    sex;

///         评论类型: 0_文字   1_语音
@property(nonatomic,assign) BOOL                    voiceType;

///         获取音频时长
@property(nonatomic,assign) NSInteger               voiceLength;




/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺新接口模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/
///          视频编号
@property(nonatomic,retain) NSString                *videoid;

///         评论编号
@property(nonatomic,retain) NSString                *commentid;

///         评论内容
@property(nonatomic,retain) NSString                *content;

///         评论人编号
@property(nonatomic,retain) NSString                *userid;

/////         评论人昵称
//@property(nonatomic,retain) NSString                *nickName;
//
/////         评论人头像路径
//@property(nonatomic,retain) NSString                *headportrait;
//
/////         回复评论编号
//@property(nonatomic,retain) NSString                *tocommentID;
//
/////         回复人昵称
//@property(nonatomic,retain) NSString                *tonickName;
//
/////         评论人头像路径
//@property(nonatomic,retain) NSString                *toheadportrait;

///         评论时间
@property(nonatomic,retain) NSString                *postdatetime;

@property (nonatomic, strong) BYC_AccountModel      *users;

///         评论类型: 0_文字   1_语音
@property(nonatomic,assign) BOOL                    isvoice;

///         获取音频时长
@property(nonatomic,assign) NSInteger               seconds;

@property (nonatomic, assign) NSInteger             state;


/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺新接口模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/

+(instancetype)initModelWithArray:(NSArray *)array;



@end
