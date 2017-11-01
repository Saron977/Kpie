//
//  BYC_ServerPort.h
//  kpie
//
//  Created by 元朝 on 16/2/23.
//  Copyright © 2016年 QNWS. All rights reserved.
//



/*****************************服务器接口**************************/

/**正式地址*/
UIKIT_EXTERN NSString * const KQNWS_KPIE_MAIN_URL;
/**添加话题*/
UIKIT_EXTERN NSString * const KQNWS_GetEliteListVideoThemeUrl;
/**上传 - 发布*/
UIKIT_EXTERN NSString * const KQNWS_PostUploadVideoUrl ;
/**精选数据*/
UIKIT_EXTERN NSString * const KQNWS_GetChoicenessList1VideoUrl;
/**栏目标题数据*/
UIKIT_EXTERN NSString * const KQNWS_GetListVideoChannelsUrl;
/**注册发送验证码*/
UIKIT_EXTERN NSString * const KQNWS_SendSmsUrl;
/**注册*/
UIKIT_EXTERN NSString * const KQNWS_RegisterUserUrl;
/**完善资料*/
UIKIT_EXTERN NSString * const KQNWS_SaveUserInfoUrl;
/**登录*/
UIKIT_EXTERN NSString * const KQNWS_Login1UserUrl;
//退出登录
UIKIT_EXTERN NSString * const KQNWS_LogoutUrl;
/**第三方登录*/
UIKIT_EXTERN NSString * const KQNWS_WQWThirdLoginUserUrl;
/**栏目视频*/
UIKIT_EXTERN NSString * const KQNWS_GetColumnAllJsonArrayListVideoUrl;
/**比基尼大赛第一次进*/
UIKIT_EXTERN NSString * const KQNWS_GetGroupAllJsonArrayListVideoUrl;
/**比基尼大赛*/
UIKIT_EXTERN NSString * const KQNWS_GetGroupJsonArrayListVideoUrl;
/**大片*/
UIKIT_EXTERN NSString * const KQNWS_GetMineVideoUrl;
/**忘记密码*/
UIKIT_EXTERN NSString * const KQNWS_ForgetPasswordUserUrl;
/**修改密码*/
UIKIT_EXTERN NSString * const KQNWS_ModifyPasswordUserUrl;
/**阿里云加签*/
UIKIT_EXTERN NSString * const KQNWS_OssUrl;
/**举报接口*/
UIKIT_EXTERN NSString * const KQNWS_SaveUserReport;
/**添加关注接口*/
UIKIT_EXTERN NSString * const KQNWS_SaveFriendsUserUrl;
/**取消关注接口*/
UIKIT_EXTERN NSString * const KQNWS_RemoveFriendsUserUrl;
/**判断是否关注接口*/
UIKIT_EXTERN NSString * const KQNWS_IsSaveUserUrl;
/**评论展示接口*/
UIKIT_EXTERN NSString * const KQNWS_GetComments;
/**发表评论接口*/
UIKIT_EXTERN NSString * const KQNWS_SaveUserComments;
/**获取点击量接口*/
UIKIT_EXTERN NSString * const KQNWS_SaveViewsVideo;
/**喜欢接口*/
UIKIT_EXTERN NSString * const KQNWS_IsSaveUserFavorites;
/**添加喜欢*/
UIKIT_EXTERN NSString * const KQNWS_SaveUserFavorites;
/**取消喜欢*/
UIKIT_EXTERN NSString * const KQNWS_RemoveUserFavorites;
/**获取音乐*/
UIKIT_EXTERN NSString * const KQNWS_GetMusic;
/**相关视频*/
UIKIT_EXTERN NSString * const KQNWS_GetRandomListVideo;
/**评论删除*/
UIKIT_EXTERN NSString * const KQNWS_DeletePhoneUserComments;
/**作品删除*/
UIKIT_EXTERN NSString * const KQNWS_DeletePhoneVideo;
/**上传界面名师点评接口*/
UIKIT_EXTERN NSString * const KQNWS_IsApplyVideo;
/**个人中心关注数量的接口*/
UIKIT_EXTERN NSString * const KQNWS_GetFocusUserUrl;
/**个人中心粉丝数量的接口*/
UIKIT_EXTERN NSString * const KQNWS_GetFansUserUrl;
/**个人中心刷新用户信息的接口*/
UIKIT_EXTERN NSString * const KQNWS_GetUserUrl;
/**个人中心刷新用户信息的接口*/
UIKIT_EXTERN NSString * const KQNWS_IsSaveUserUrl;
/**个人中心拉黑*/
UIKIT_EXTERN NSString * const KQNWS_UpdateBlackListUserUrl;
/**开机启动广告*/
UIKIT_EXTERN NSString * const KQNWS_GetListAdvertUrl;
/**icon皮肤*/
UIKIT_EXTERN NSString * const KQNWS_GetListSkin;
/**个人中心刷新用户信息的接口*/
UIKIT_EXTERN NSString * const KQNWS_GetFriendsJsonArrayList2VideoUrl;
/**左侧栏的关注列表*/
UIKIT_EXTERN NSString * const KQNWS_GetListUserFavoritesUrl;
/**左侧栏的消息列表*/
UIKIT_EXTERN NSString * const KQNWS_GetMineList1UserCommentsUrl;
/**用户使用反馈*/
UIKIT_EXTERN NSString * const KQNWS_SaveUserFeedbackUrl;
/**左侧栏的通知列表*/
UIKIT_EXTERN NSString * const KQNWS_GetListCast1PushMsgUrl;
/**左侧栏的消息列表全部已读*/
UIKIT_EXTERN NSString * const KQNWS_ModifyStateUserCommentsUrl;
/**左侧栏的已读通知列表*/
UIKIT_EXTERN NSString * const KQNWS_GetListCast1PushMsgReadUrl;
/**邀请好友获取积分*/
UIKIT_EXTERN NSString * const KQNWS_InvitUserUrl;
/**分享视频获取积分*/
UIKIT_EXTERN NSString * const KQNWS_SaveSharesVideoUrl;
/**剧本合拍 精选*/
UIKIT_EXTERN NSString * const KQNWS_GetEliteListVideoScript;
/**剧本合拍 更多*/
UIKIT_EXTERN NSString * const KQNWS_GetMoreJsonArrayListVideoScript;
/**剧本合拍 获取频道名*/
UIKIT_EXTERN NSString * const KQNWS_GetChannelListVideoScript;
/**查询剧本*/
UIKIT_EXTERN NSString * const KQNWS_GetOneVideoScript;
/**提交IDFA*/
UIKIT_EXTERN NSString * const KQNWS_SaveiOSIDFAUrl;
/**实时搜索关键词*/
UIKIT_EXTERN NSString * const KQNWS_GetUVMatchVideoUrl;
/**搜索关键词用户、视频*/
UIKIT_EXTERN NSString * const KQNWS_GetFuzzyListVideoUrl;
/**搜索关键词获取更多用户*/
UIKIT_EXTERN NSString * const KQNWS_GetMatchUserUrl;
/**搜索关键词获取更多视频*/
UIKIT_EXTERN NSString * const KQNWS_GetMatchVideoUrl;
/**热搜词查询接口*/
UIKIT_EXTERN NSString * const KQNWS_GetListSearchUrl;
/** 播放视频页整合请求调用该接口*/
UIKIT_EXTERN NSString * const KQNWS_GetAllListUserComments;
/**频道子控制器数据*/
UIKIT_EXTERN NSString * const KQNWS_GetListVideoColumn;
/**首页精选接口*/
UIKIT_EXTERN NSString * const KQNWS_GetHomeEliteDataMotif;
//输入手机号方式
UIKIT_EXTERN NSString * const KQNWS_EnterContactPrize;
//抽奖接口
UIKIT_EXTERN NSString * const KQNWS_GetDataPrize;
//投票接口
UIKIT_EXTERN NSString * const KQNWS_SaveUserVote;
//首页频道、发现社区、发现活动接口请求路径
UIKIT_EXTERN NSString * const KQNWS_GetDataMotif;
//个人中心打开第一次请求接口
UIKIT_EXTERN NSString * const KQNWS_GetHomePageUser;
//推荐关注接口
UIKIT_EXTERN NSString * const KQNWS_GetMayFriendUser;
//搜索关注接口
UIKIT_EXTERN NSString * const KQNWS_GetMissFriendUser;
//等级说明
UIKIT_EXTERN NSString * const KQNWS_GetMyLevel;
//等级说明
UIKIT_EXTERN NSString * const KQNWS_GetUpgradeDescription;
//第三方登录需要绑定手机号
UIKIT_EXTERN NSString * const KQNWS_UserInfo_Contact;
//标签
UIKIT_EXTERN NSString * const KQNWS_VideoThemeUrl;
//推送_查询单个视频
UIKIT_EXTERN NSString * const KQNWS_VideoPush;
/*****************************阿里云相关***************************/
/**阿里云图片上传正式*/
UIKIT_EXTERN NSString * const KQNWS_OSSFilePath;

/**阿里云视频上传正式*/
UIKIT_EXTERN NSString * const KQNWS_VIDEOFilePath;

/**阿里云图片上传测试*/
UIKIT_EXTERN NSString * const KQNWS_OSSTestFilePath;

/**BucketName测试环境*/
UIKIT_EXTERN NSString * const KQNWS_BucketNameTest;

/**BucketName*/
UIKIT_EXTERN NSString * const KQNWS_BucketNameJPG;

/**buck*/
UIKIT_EXTERN NSString * const KQNWS_BucketNameVIDEOS;

