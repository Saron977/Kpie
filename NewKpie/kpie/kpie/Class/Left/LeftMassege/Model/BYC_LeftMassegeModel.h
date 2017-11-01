//
//  BYC_LeftMassegeModel.h
//  kpie
//
//  Created by 元朝 on 15/12/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"
#import "BYC_BaseVideoModel.h"

@interface BYC_LeftMassegeModel : BYC_BaseModel

@property (nonatomic, strong)  NSString  *commentID;     //评论编号
@property (nonatomic, strong)  NSString  *userID;        //评论人编号
//@property (nonatomic, strong)  NSString  *content;       //评论内容
@property (nonatomic, strong)  NSString  *nickName;      //评论人昵称
@property (nonatomic, strong)  NSString  *headPortrait;  //评论人头像路径
@property (nonatomic, strong)  NSString  *toUserID;      //回复人编号
@property (nonatomic, strong)  NSString  *toNickName;    //回复人昵称
@property (nonatomic, strong)  NSString  *toHeadPortrait;//回复人头像路径
@property (nonatomic, strong)  NSString  *toContent;     //回复内容
@property (nonatomic, strong)  NSString  *postDateTime;  //评论时间
@property (nonatomic, strong)  NSString  *videoID;       //视频编号
@property (nonatomic, strong)  NSString  *cateID;        //所属剧集编号
@property (nonatomic, strong)  NSString  *videoTitle;    //视频标题
@property (nonatomic, strong)  NSString  *myDescription; //视频简介
@property (nonatomic, strong)  NSString  *videoMP4;      //视频路径
@property (nonatomic, strong)  NSString  *puUserID;      //发布者编号
//@property (nonatomic, assign)  NSInteger state;          //读取状态(0未读 1已读)
@property (nonatomic, assign)  NSInteger views;          //点击量
@property (nonatomic, strong)  NSString  *pictureJPG;    //视频封面路径
@property (nonatomic, strong)  NSString  *vNickName;     //发布者昵称
@property (nonatomic, strong)  NSString  *vHeadPortrait; //发布者头像路径
@property (nonatomic, strong)  NSString  *vUserID;       //发布者编号
@property (nonatomic, strong)  NSString  *scriptID;      //所属剧本编号
@property (nonatomic, assign)  BOOL      sex;            //评论人性别(0男1女)
@property (nonatomic, assign)  BOOL      toSex;          //回复人性别(0男1女)
@property (nonatomic, assign)  BOOL      vSex;           //发布者性别(0男1女)

@property (nonatomic, assign)  BOOL     isVideo;
@property (nonatomic, assign)  CGFloat  isVideoTime;
@property (nonatomic, assign)  BOOL     isToVideo;
@property (nonatomic, assign)  CGFloat  isToVideoTime;

@property (nonatomic, assign)  NSInteger  userType;
@property (nonatomic, assign)  NSInteger  toUserType;
//
@property (nonatomic, assign)  CGFloat  label_CommentContentHeight;
@property (nonatomic, assign)  CGFloat  label_CommentToContentHeight;
@property (nonatomic, assign)  NSInteger isVR;

/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/

@property (nonatomic, strong)  NSString  *commentid;        //评论编号

@property (nonatomic, strong) NSString   *tocommentid;

@property (nonatomic, strong)  NSString  *content;          //评论内容/通知内容

@property (nonatomic, assign)  BOOL      isvoice;           //是否是声音评论

@property (nonatomic, strong)  NSString  *postdatetime;     //评论时间

@property (nonatomic, strong)  NSNumber  *seconds;         //声音评论的时长

@property (nonatomic, assign)  NSInteger state;            //消息读取状态(0未读 1已读)

@property (nonatomic, strong)  NSString  *userid;           //评论人编号

@property (nonatomic, strong)  BYC_AccountModel  *users;  //评论人信息

@property (nonatomic, strong)  BYC_BaseVideoModel  *video; //视频信息

@property (nonatomic, strong)  NSString  *videoid;         //视频编号 、 栏目编号

@property (nonatomic, strong) NSNumber   *isread;          //通知读取状态(0未读 1已读)

@property (nonatomic,assign) NSInteger   type;             //0--系统 1--视频 2--剧本 3--名师  4---活动

@property (nonatomic, strong) NSNumber   *displaytype;          //()

@property (nonatomic, strong) NSString   *title;           //通知标题

@property (nonatomic, strong) NSNumber   *createdate;      //创建时间




/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/
@end
