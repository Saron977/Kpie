//
//  BYC_BaseVideoModel.h
//  kpie
//
//  Created by 元朝 on 16/8/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"
#import "NSObject+MJCoding.h"

@interface BYC_BaseVideoModel : BYC_BaseModel
///**视频的id*/
//@property (nonatomic, copy    ) NSString  *videoID;
///**视频的标题*/
//@property (nonatomic, copy    ) NSString  *videoTitle;
///**上传该视频的用户的id*/
//@property (nonatomic, copy    ) NSString  *userID;
///**mp4的地址*/
//@property (nonatomic, copy    ) NSString  *videoMP4;
///**上传该视频的时候的用户地理坐标 经度*/
//@property (nonatomic, assign  ) double    GPSX;
///**上传该视频的时候的用户地理坐标 纬度*/
//@property (nonatomic, assign  ) double    GPSY;
///**视频的截图的地址*/
//@property (nonatomic, copy    ) NSString  *pictureJPG;
///**该视频的描述*/
//@property (nonatomic, copy    ) NSString  *videoDescription;
///**该视频的上传时间*/
//@property (nonatomic, copy    ) NSString  *upLoadTime;
///**该视频的评论数*/
//@property (nonatomic, assign  ) NSInteger comments;
///**该视频的收藏量*/
//@property (nonatomic, assign  ) NSInteger favorites;
///**该视频的点击量*/
//@property (nonatomic, assign  ) NSInteger views;
///**所属剧集的编号*/
//@property (nonatomic, copy    ) NSString  *cateID;
///**这个视频属于第几集*/
//@property (nonatomic, assign  ) NSInteger videoIndex;
///**视频的上架时间（也就是属于上传时间）*/
//@property (nonatomic, copy    ) NSString  *onOffTime;
///**上传该视频的用户头像的地址*/
//@property (nonatomic, copy    ) NSString  *headPortrait;
///**上传该视频的用户的昵称*/
//@property (nonatomic, copy    ) NSString  *nickName;
///**上传该视频的用户的性别(0男1女)*/
//@property (nonatomic, assign  ) BOOL      sex;
///**上传的视频属于剧本就有这个id，不是剧本就没有。（播放界面的“我来拍”，就是用这个控制的）*/
//@property (nonatomic, copy    ) NSString  *scriptID;
//
///*🔺🔺🔺🔺🔺🔺上面的属性顺序固定，下面的属性不固定，继承的时候需要自己确定下标之后在赋值🔺🔺🔺🔺🔺🔺*/
///**（3怪咖 2---合拍  1---VR  0---不是VR）*/
//@property (nonatomic, assign  ) NSInteger isVR;


/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/




/**
 * 视频编号
 */
@property (nonatomic, copy) NSString *videoid;

/**
 * 视频标题
 */
@property (nonatomic, copy) NSString *videotitle;

/**
 * 发布者编号（用户编号）
 */
@property (nonatomic, copy) NSString *userid;

/**
 * 视频资源地址
 */
@property (nonatomic, copy) NSString *videomp4;

/**
 * 音频资源地址
 */
@property (nonatomic, copy) NSString *soundmp3;

/**
 * 经度
 */
@property (nonatomic, assign) NSInteger gpsx;

/**
 * 纬度
 */
@property (nonatomic, assign) NSInteger gpsy;

/**
 * 视频封面资源地址
 */
@property (nonatomic, copy) NSString *picturejpg;

/**
 * 视频简介
 */
@property (nonatomic, copy) NSString *video_Description;

/**
 * 上传时间
 */
@property (nonatomic, copy) NSString *uploadtime;

/**
 * 评论数
 */
@property (nonatomic, assign) NSInteger comments;

/**
 * 收藏数
 */
@property (nonatomic, assign) NSInteger favorites;

/**
 * 视频类型 1发现 2精选
 */
@property (nonatomic, assign) NSInteger videotype;

/**
 * 喜欢数
 */
@property (nonatomic, assign) NSInteger likes;

/**
 * 播放数
 */
@property (nonatomic, assign) NSInteger views;

/**
 * 是否上架 0否 1是
 */
@property (nonatomic, assign) NSInteger pubstate;

/**
 * 是否推荐 0否 1是
 */
@property (nonatomic, assign) NSInteger elite;

/**
 * 是否看拍推荐 0否 1是
 */
@property (nonatomic, assign) NSInteger kpieelite;

/**
 * 所属剧集编号
 */
@property (nonatomic, copy) NSString *cateid;

/**
 * 剧集号
 */
@property (nonatomic, assign) NSInteger videoindex;

/**
 * 上/下架时间
 */
@property (nonatomic, copy) NSString *onofftime;

/**
 * 是否删除 0否 1是
 */
@property (nonatomic, assign) NSInteger deletestate;

/**
 * 上/下架时间（精确）
 */
@property (nonatomic, copy) NSString *onmstime;

/**
 * 是否上官网 0否 1是
 */
@property (nonatomic, assign) BOOL onsitestate;

/**
 * 初始播放数
 */
@property (nonatomic, assign) NSInteger initviews;

/**
 * 真实播放数
 */
@property (nonatomic, assign) NSInteger realviews;

/**
 * 分享数
 */
@property (nonatomic, assign) NSInteger shares;

/**
 * 是否申请名师点评 0否 1是
 */
@property (nonatomic, assign) BOOL isapply;

/**
 * 名师是否点评 0否 1是
 */
@property (nonatomic, assign) BOOL reviews;

/**
 * 推荐类型  0推荐视频 1推荐普通栏目 2推荐网址 3推荐比基尼型栏目 4推荐世纪樱花型栏目 5推荐合拍SHOW型栏目 6推荐寻找怪咖型栏目 7推荐国庆栏目
 */
@property (nonatomic, assign) NSInteger elitetype;

/**
 * 审核状态 0未审核 1已审核
 */
@property (nonatomic, assign) NSInteger procestate;

/**
 * 审核时间
 */
@property (nonatomic, copy) NSString *procetime;

/**
 * 视频内容类别 0普通 1VR 2合拍模板 3怪咖
 */
@property (nonatomic, assign) NSInteger isvr;

/**
 * 合拍模板制作数
 */
@property (nonatomic, assign) NSInteger templets;

/**
 * 投票数
 */
@property (nonatomic, assign) NSInteger votes;

/**
 * 所属剧本编号
 */
@property (nonatomic, copy) NSString *scriptid;


/**
 * 是否收藏 0否 1是
 */
@property (nonatomic, assign) BOOL isfavor;


/**
 * 上传者个人信息
 */
@property (nonatomic, strong) BYC_AccountModel *users;

/*🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺新接口模型🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺*/


@end
