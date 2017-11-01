//
//  BYC_ServerPort.m
//  kpie
//
//  Created by 元朝 on 16/7/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//


//正式地址
 NSString * const KQNWS_KPIE_MAIN_URL                     = @"http://api.kpie.com.cn/";
//添加话题
 NSString * const KQNWS_GetEliteListVideoThemeUrl         = @"theme/elite";
//上传 - 发布
 NSString * const KQNWS_PostUploadVideoUrl                = @"video/upload";
//精选数据
 NSString * const KQNWS_GetChoicenessList1VideoUrl        = @"getChoicenessList1Video.action";
//栏目标题数据
 NSString * const KQNWS_GetListVideoChannelsUrl           = @"getListVideoChannels.action";
//注册发送验证码
 NSString * const KQNWS_SendSmsUrl                        = @"sms/send";
//注册
 NSString * const KQNWS_RegisterUserUrl                   = @"users/register";
//完善资料
 NSString * const KQNWS_SaveUserInfoUrl                   = @"users/perfectInfo";
//登录
 NSString * const KQNWS_Login1UserUrl                     = @"users/login";
//退出登录
 NSString * const KQNWS_LogoutUrl                         = @"users/logout";

//第三方登录
 NSString * const KQNWS_WQWThirdLoginUserUrl              = @"users/thirdLogin";
//栏目视频
 NSString * const KQNWS_GetColumnAllJsonArrayListVideoUrl = @"getColumnAllJsonArrayListVideo.action";
//比基尼大赛第一次进
 NSString * const KQNWS_GetGroupAllJsonArrayListVideoUrl  = @"motif/details"; //@"getGroupAllJsonArrayListVideo.action";
//比基尼大赛
 NSString * const KQNWS_GetGroupJsonArrayListVideoUrl     = @"getGroupJsonArrayListVideo.action";
//大片
 NSString * const KQNWS_GetMineVideoUrl                   = @"getMineVideo.action";
//忘记密码
 NSString * const KQNWS_ForgetPasswordUserUrl             = @"/users/forgetPwd";    //@"forgetPasswordUser.action";
//修改密码
 NSString * const KQNWS_ModifyPasswordUserUrl             = @"users/updatePwd";
//阿里云加签
 NSString * const KQNWS_OssUrl                            = @"default/getToken";
//举报接口
 NSString * const KQNWS_SaveUserReport                    = @"reports/post";   //@"saveUserReports.action";
//添加关注接口
 NSString * const KQNWS_SaveFriendsUserUrl                = @"userInfo/save";   //@"saveFriends1User.action";
//取消关注接口
 NSString * const KQNWS_RemoveFriendsUserUrl              = @"userInfo/remove";   //@"removeFriendsUser.action";
//评论展示接口
 NSString * const KQNWS_GetComments                       = @"getList1UserComments.action";
//发表评论接口
 NSString * const KQNWS_SaveUserComments                  = @"comments/post";   //@"save2UserComments.action";
//获取点击量接口
 NSString * const KQNWS_SaveViewsVideo                    = @"video/views";     //@"saveViewsVideo.action";
//喜欢接口
 NSString * const KQNWS_IsSaveUserFavorites               = @"isSaveUserFavorites.action";
//添加喜欢
 NSString * const KQNWS_SaveUserFavorites                 = @"video/favor"; //@"save2UserFavorites.action";
//取消喜欢
 NSString * const KQNWS_RemoveUserFavorites               = @"remove2UserFavorites.action";
//获取音乐
 NSString * const KQNWS_GetMusic                          = @"music/list";
//相关视频
 NSString * const KQNWS_GetRandomListVideo                = @"getRandomListVideo.action";
//评论删除
 NSString * const KQNWS_DeletePhoneUserComments           =  @"comments/delete";   //@"deletePhoneUserComments.action";
//作品删除
 NSString * const KQNWS_DeletePhoneVideo                  = @"video/delete";   //@"deletePhoneVideo.action";
//上传界面名师点评接口
 NSString * const KQNWS_IsApplyVideo                      = @"video/isApply";
//个人中心关注数量的接口
 NSString * const KQNWS_GetFocusUserUrl                   = @"getFocusUser.action";
//个人中心粉丝数量的接口
 NSString * const KQNWS_GetFansUserUrl                    = @"getFansUser.action";
//个人中心刷新用户信息的接口
 NSString * const KQNWS_GetUserUrl                        = @"users/homePage";   //@"getUser.action";
//判断是否关注
 NSString * const KQNWS_IsSaveUserUrl                     = @"isSaveUser.action";
//个人中心拉黑
 NSString * const KQNWS_UpdateBlackListUserUrl            = @"userInfo/black";   //@"updateBlackListUser.action";
//开机启动广告
 NSString * const KQNWS_GetListAdvertUrl                  = @"advert/getList";
//icon皮肤
 NSString * const KQNWS_GetListSkin                       = @"getListSkin.action";
//动态列表
 NSString * const KQNWS_GetFriendsJsonArrayList2VideoUrl  = @"video/dynamic"; //@"getFriendsJsonArrayList2Video.action";
//赞过的视频
 NSString * const KQNWS_GetListUserFavoritesUrl           =@"video/collect";  // @"getListUserFavorites.action";
//左侧栏的消息列表
 NSString * const KQNWS_GetMineList1UserCommentsUrl       = @"comments/mine";  //@"getMineList1UserComments.action";
//用户使用反馈
 NSString * const KQNWS_SaveUserFeedbackUrl               = @"/feedback/post";
//左侧栏的通知列表
 NSString * const KQNWS_GetListCast1PushMsgUrl            = @"pushMsg/msg";    //@"getListCast1PushMsg.action";
//左侧栏的消息列表全部已读
 NSString * const KQNWS_ModifyStateUserCommentsUrl        = @"comments/read";   //@"modifyStateUserComments.action";
//左侧栏的已读通知列表
NSString * const KQNWS_GetListCast1PushMsgReadUrl          = @"pushMsg/read";
//邀请好友获取积分
 NSString * const KQNWS_InvitUserUrl                      = @"users/init";
//分享视频获取积分
 NSString * const KQNWS_SaveSharesVideoUrl                = @"video/shares";
//剧本合拍 精选
 NSString * const KQNWS_GetEliteListVideoScript           = @"script/elite";
//剧本合拍 更多
 NSString * const KQNWS_GetMoreJsonArrayListVideoScript   = @"scriptChannel/list";
//剧本合拍 获取频道名
 NSString * const KQNWS_GetChannelListVideoScript         = @"script/library";
//查询剧本
 NSString * const KQNWS_GetOneVideoScript                 = @"script/details/";   //@"getOneVideoScript.action";
//提交IDFA
 NSString * const KQNWS_SaveiOSIDFAUrl                    = @"saveiOSIDFA.action";
//实时搜索关键词
 NSString * const KQNWS_GetUVMatchVideoUrl                = @"search";
//搜索关键词用户、视频
 NSString * const KQNWS_GetFuzzyListVideoUrl              = @"getFuzzyListVideo.action";
//搜索关键词获取更多用户
 NSString * const KQNWS_GetMatchUserUrl                   = @"users/search";
//搜索关键词获取更多视频
 NSString * const KQNWS_GetMatchVideoUrl                  = @"video/search";
//热搜词查询接口
 NSString * const KQNWS_GetListSearchUrl                  = @"getListSearch.action";
// 播放视频页整合请求调用该接口
 NSString * const KQNWS_GetAllListUserComments            = @"comments/play";  //@"getAllListUserComments.action";
//频道子控制器数据
 NSString * const KQNWS_GetListVideoColumn                = @"getListVideoColumn.action";
/**首页精选接口*/
 NSString * const KQNWS_GetHomeEliteDataMotif             = @"motif/home";
//输入手机号方式
 NSString * const KQNWS_EnterContactPrize                 = @"enterContactPrize.action";
//抽奖接口
 NSString * const KQNWS_GetDataPrize                      = @"getDataPrize.action";
//投票接口
 NSString * const KQNWS_SaveUserVote                      = @"saveUserVote.action";
//首页频道、发现社区、发现活动接口请求路径
 NSString * const KQNWS_GetDataMotif                      = @"motif/details";

//个人中心打开第一次请求接口
NSString * const KQNWS_GetHomePageUser                    = @"getHomePageUser.action";

//搜索关注接口
NSString * const KQNWS_GetMayFriendUser                   = @"users/may";   //@"getMayFriendUser.action";

//我的等级
NSString * const KQNWS_GetMissFriendUser                  = @"";

//我的等级
NSString * const KQNWS_GetMyLevel                         = @"users/upgrade";
//等级说明
NSString * const KQNWS_GetUpgradeDescription              = @"users/level";
//第三方登录需要绑定手机号
NSString * const KQNWS_UserInfo_Contact                   = @"userInfo/contact";

//标签
NSString * const  KQNWS_VideoThemeUrl                     = @"video/theme";
//推送_查询单个视频
NSString * const  KQNWS_VideoPush                         = @"video/push";

//***************************阿里云相关***************************//
//阿里云图片上传正式
 NSString * const KQNWS_OSSFilePath                       = @"http://images.kpie.com.cn/";

//阿里云视频上传正式
 NSString * const KQNWS_VIDEOFilePath                     = @"http://videos.kpie.com.cn/";

//阿里云图片上传测试
 NSString * const KQNWS_OSSTestFilePath                   = @"http://sz-kpie-test.oss-cn-shenzhen.aliyuncs.com/";

//BucketName测试环境
 NSString * const KQNWS_BucketNameTest                    = @"sz-kpie-test";

//BucketName
 NSString * const KQNWS_BucketNameJPG                     = @"sz-kpie-jpg";

//buck
 NSString * const KQNWS_BucketNameVIDEOS                  = @"sz-kpie-videos";
