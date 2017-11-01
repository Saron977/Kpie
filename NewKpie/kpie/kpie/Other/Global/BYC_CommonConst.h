//
//  BYC_CommonConst.h
//  kpie
//
//  Created by 元朝 on 16/7/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

typedef NS_ENUM(NSInteger, ENUM_NETWORK_TYPE) {
    ENUM_NETWORK_TYPE_NONE = 0,  //无网络
    ENUM_NETWORK_TYPE_WiFi,  //无线网络
    ENUM_NETWORK_TYPE_Mobile,//移动网络
};

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼OC字符串类型常量▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//

//***************************第三方KEY**************************//

/**友盟key*/
UIKIT_EXTERN NSString * const  KSTR_UmengAppkey;

//***************************标识**************************//
/**第一次开启应用的key*/
UIKIT_EXTERN NSString * const  KSTR_FIRST_OPEN_APPLICATION_KEY;
/**更新之后第一次开启应用的key*/
UIKIT_EXTERN NSString * const  KSTR_FIRST_OPEN_OldAPPLICATION_KEY;
/**第一次打开剧本合拍*/
UIKIT_EXTERN NSString * const  KSTR_FIRST_OPEN_SCRIPT_KEY;
/**登陆快捷手机号*/
UIKIT_EXTERN NSString * const  KSTR_KLoginDefaultPhoneNum;
/**登陆成功*/
UIKIT_EXTERN NSString * const  KSTR_KLoginSuccessed;
/**退出登录成功*/
UIKIT_EXTERN NSString * const  KSTR_KLoginOut;
/**plist文件里面获取token*/
UIKIT_EXTERN NSString * const  KSTR_KDeviceToken;
/**消息红点标识*/
UIKIT_EXTERN NSString * const  KSTR_KComment;
/**需要名师点评标识*/
UIKIT_EXTERN NSString * const  KSTR_KNeedTeacher;
/**需要顶号标识*/
UIKIT_EXTERN NSString * const  KSTR_KNeedLogout;
/**积分推送标识*/
UIKIT_EXTERN NSString * const  KSTR_KUserfavoritessave;
/**活动小红点标示*/
UIKIT_EXTERN NSString * const  KSTR_KShowActivityRed;
/**第三方登陆*/
UIKIT_EXTERN NSString * const  KSTR_KThirdLogin;
/**上一次广告请求时间*/
UIKIT_EXTERN NSString * const  KSTR_KRecordLastADRequestTime;
/**每天广告请求次数*/
UIKIT_EXTERN NSString * const  KSTR_KRecordADRequestTimes;
/**每天广告请求次数*/
UIKIT_EXTERN NSString * const  KSTR_KRecordADRequestTimes2;
/**每天第一次广告请求*/
UIKIT_EXTERN NSString * const  KSTR_KRecordADRequestTodayFirst;
/**广告ID*/
UIKIT_EXTERN NSString * const  KSTR_KRecordADID;
/**卡片广告ID*/
UIKIT_EXTERN NSString * const  KSTR_KRecordADID2;
/**语音键盘通知,将要开始录音*/
UIKIT_EXTERN NSString * const  KSTR_KVoiceWillStart;
/**查询是否存在合拍表,第一次进入显示提示图片 以及合拍沙盒文件夹名*/
UIKIT_EXTERN NSString * const  KSTR_TABLE_JoinShooting;

/** 作为Url的临时标识，用于判断网络请求*/
UIKIT_EXTERN NSString * const  KSTR_DictionaryTemp;
/** 第三方登陆,没有填写手机号码，前三次弹窗提醒填写手机号。*/
UIKIT_EXTERN NSString * const  KSTR_ThirdLoginBindingPhoneNum;
//消息需要展示小红点
UIKIT_EXTERN NSString * const  KSTR_KMsgAndNotRed;
//***************************分享相关***************************//
/**分享文本*/
UIKIT_EXTERN NSString * const  KSTR_KUMengShareContent;

UIKIT_EXTERN NSString * const  KSTR_KNetwork_IsWiFi;
//***************************动画相关***************************//


//▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲OC字符串类型常量▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲//


//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼基本类型常量▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//

//***************************视频拍摄相关宏**************************//
/**拍摄时长控制*/
UIKIT_EXTERN CGFloat  const  KFLOAT_KVideoShoot;
UIKIT_EXTERN CGFloat  const  KFLOAT_KVideoShootProgressHight;
UIKIT_EXTERN CGFloat  const  KFLOAT_K_PI;

/** 1:关闭自动连播  0:开启*/
UIKIT_EXTERN CGFloat  const  KFLOAT_LockAutoPlayVideo;
/**主界面快速进入视频上传界面 (默认为1)1:开 0:关*/
UIKIT_EXTERN CGFloat  const  KFLOAT_UnQuickToUpload;

/**网络状态*/
UIKIT_EXTERN ENUM_NETWORK_TYPE * const  KNetwork_Type;
//▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲基本类型常量▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲//

