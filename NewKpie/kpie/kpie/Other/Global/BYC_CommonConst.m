//
//  BYC_CommonConst.m
//  kpie
//
//  Created by 元朝 on 16/7/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//


//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼OC字符串类型常量▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//

 NSString * const  KSTR_UmengAppkey = @"5637374267e58e7595003359";

//***************************公用宏文件**************************//

 NSString * const  KSTR_FIRST_OPEN_APPLICATION_KEY    = @"firstOpneTheApplication";//第一次开启应用的key
 NSString * const  KSTR_FIRST_OPEN_OldAPPLICATION_KEY = @"firstOpneTheApplication";//更新之后第一次开启应用的key
 NSString * const  KSTR_FIRST_OPEN_SCRIPT_KEY         = @"firstOpenScript";//第一次打开剧本合拍
 NSString * const  KSTR_KLoginDefaultPhoneNum         = @"loginDefaultPhoneNum" ;//登陆快捷手机号
 NSString * const  KSTR_KLoginSuccessed               = @"KSTR_KLoginSuccessed";//登陆成功
 NSString * const  KSTR_KLoginOut                     = @"KSTR_KLoginOut";//退出登录
 NSString * const  KSTR_KDeviceToken                  = @"deviceToken";//plist文件里面获取token
 NSString * const  KSTR_KComment                      = @"comment";//消息红点标识
 NSString * const  KSTR_KNeedTeacher                  = @"uploadvideo";//需要名师点评标识
 NSString * const  KSTR_KNeedLogout                   = @"logout";//需要顶号标识
 NSString * const  KSTR_KUserfavoritessave            = @"userfavoritessave";//积分推送标识
 NSString * const  KSTR_KShowActivityRed              = @"showActivityRed";//活动小红点标示
 NSString * const  KSTR_KThirdLogin                   = @"ThirdLogin";//第三方登陆
 NSString * const  KSTR_KRecordLastADRequestTime      = @"RecordLastADRequestTime";//上一次广告请求时间
 NSString * const  KSTR_KRecordADRequestTimes         = @"RecordADRequestTimes";//每天广告请求次数
 NSString * const  KSTR_KRecordADRequestTimes2         = @"RecordADRequestTimes2";//每天卡片广告请求次数
 NSString * const  KSTR_KRecordADID                   = @"KSTR_KRecordADID";//广告ID
 NSString * const  KSTR_KRecordADID2                  = @"KSTR_KRecordADID2";//卡片广告ID
 NSString * const  KSTR_KRecordADRequestTodayFirst    = @"RecordADRequestTodayFirst";//每天第一次广告请求
 NSString * const  KSTR_KNetwork_IsWiFi               = @"KSTR_KNetwork_IsWiFi";//（没有存储值，默认就是什么网络状态都播放，有值就是WiFi播放）
 NSString * const  KSTR_KMsgAndNotRed               = @"KSTR_KMsgAndNotRed";//消息需要展示小红点
//语音键盘通知
 NSString * const  KSTR_KVoiceWillStart          = @"KSTR_KVoiceWillStart";/**< 将要开始录音 */
//数据表
 NSString * const  KSTR_TABLE_JoinShooting       = @"JoinShooting";/**<   查询是否存在合拍表,第一次进入显示提示图片 以及合拍沙盒文件夹名*/
/** 作为Url的临时标识，用于判断网络请求*/
 NSString * const  KSTR_DictionaryTemp           = @"KSTR_DictionaryTemp";
//***************************分享相关***************************//
 NSString * const  KSTR_KUMengShareContent       = @"玩转剧本，创意拼接。加入“看拍”，打造自己的bigger栏目~  http://a.app.qq.com/o/simple.jsp?pkgname=com.kpie.android";
/** 第三方登陆,没有填写手机号码，前三次弹窗提醒填写手机号。*/
NSString * const  KSTR_ThirdLoginBindingPhoneNum           = @"KSTR_ThirdLoginBindingPhoneNum";
//▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲OC字符串类型常量▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲//
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼基本类型常量▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//

//***************************动画相关***************************//

CGFloat  const  KFLOAT_K_PI                     = 3.14159265358979323846264338327950288;

//***************************视频拍摄相关宏**************************//
CGFloat  const  KFLOAT_KVideoShoot              = 300.00000;// 拍摄时长控制
CGFloat  const  KFLOAT_KVideoShootProgressHight = 8;
// 编辑界面,自动联播BUG___ (默认为0)1:关闭自动连播  0:开启
CGFloat  const  KFLOAT_LockAutoPlayVideo        = 0;
// 主界面快速进入视频上传界面 (默认为1)
// 1:开 0:关
CGFloat  const  KFLOAT_UnQuickToUpload          = 1;



/**网络状态*/
ENUM_NETWORK_TYPE type = ENUM_NETWORK_TYPE_NONE;
ENUM_NETWORK_TYPE * const  KNetwork_Type             = &type;

/**默认WiFi状态下播放*/
//▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲基本类型常量▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲//


