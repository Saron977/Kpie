//
//  BYC_FunctionTools.h
//  kpie
//
//  Created by 元朝 on 16/1/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#ifndef BYC_FunctionTools_h
#define BYC_FunctionTools_h

#define QNWS_CurrentDeviceSystemVersion [[UIDevice currentDevice].systemVersion floatValue]

//***************************色彩相关***************************//
//从RGB转换成UIColor （16进制->10进制）不带透明度
#define KUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//设置带透明度
#define KUIColorFromRGBA(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/*▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼主辅色▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼*/

/**主绿色毛玻璃状态*/
#define  KUIColorBaseGreenBlurEffect KUIColorFromRGB(0X006361)


/**主绿色正常状态*/
#define  KUIColorBaseGreenNormal     KUIColorFromRGB(0X2CA298)
/**主绿色高亮状态*/
#define  KUIColorBaseGreenHighlight  KUIColorFromRGB(0X258A81)
/**辅色橙正常状态*/
#define  KUIColorBaseOrangeNormal    KUIColorFromRGB(0XEFA24D)
/**辅色橙高亮状态*/
#define  KUIColorBaseOrangeHighlight KUIColorFromRGB(0XD69045)
/**辅色红正常状态*/
#define  KUIColorBaseRedNormal       KUIColorFromRGB(0XCF686A)
/**辅色红高亮状态*/
#define  KUIColorBaseRedHighlight    KUIColorFromRGB(0XB55B5C)
/**辅色紫正常状态*/
#define  KUIColorBasePurpleNormal    KUIColorFromRGB(0XA96CE6)
/**辅色紫高亮状态*/
#define  KUIColorBasePurpleHighlight KUIColorFromRGB(0X9660CC)

/*▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲主辅色▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲*/
/*▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼文字色值▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼*/

/**文字色值最黑*/
#define  KUIColorWordsBlack1    KUIColorFromRGB(0X21262C)
/**文字色值黑2*/
#define  KUIColorWordsBlack2    KUIColorFromRGB(0X3C4F5E)
/**文字色值黑3*/
#define  KUIColorWordsBlack3    KUIColorFromRGB(0X4D606F)
/**文字色值灰色*/
#define  KUIColorWordsBlack4    KUIColorFromRGB(0X6C7B8A)


/*▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲文字色值▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲*/
/*▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼背景\分割线色值▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼*/

/**背景色*/
#define  KUIColorBackground             KUIColorFromRGB(0XF0F0F0)
/**背景色1*/
#define  KUIColorBackground1            KUIColorFromRGB(0XA3A3A3)
/**模块色值1*/
#define  KUIColorBackgroundModule1      KUIColorFromRGB(0XFCFCFC)
/**模块色值2*/
#define  KUIColorBackgroundModule2      KUIColorFromRGB(0XFFFFFF)
/**分割线色值*/
#define  KUIColorBackgroundCuttingLine  KUIColorFromRGB(0XC5C5C5)
/**分割线色值*/
#define  KUIColorBackgroundTouchDown    KUIColorFromRGB(0XDEDEDE)


/*▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲文字色值▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲*/

//*************************** weak 化 self ***************************//
#define KWS(weakSelf)  __weak __typeof(&*self)weakSelf = self;\


//***************************图片相关***************************//
//读取本地图片
#define KImageOfFileAndType(fileName,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:type]]
//定义UIImage对象
#define KImageOfFile(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]]
//定义缓存UIImage对象
#define KImageNamed(fileName) [UIImage imageNamed:fileName]
//***************************调试相关***************************//

// ...表示宏定义的可变参数
// __VA_ARGS__:表示函数里面的可变参数

//以此打印 类的名字,所在方法的名字,所在行数
#ifdef DEBUG // 调试
#define QNWSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else // 发布
#define QNWSLog(...)
#endif

#ifdef DEBUG // 调试异常情况下给开发人员提示
#define QNWSShowException(exception) {[[UIView alloc] showAndHideHUDWithDetailsTitle:[NSString stringWithFormat:@"调试异常情况下给开发人员的提示，失败原因:%@",exception] WithState:BYC_MBProgressHUDHideProgress hideDelayed:10.0f completion:nil];QNWSLog(@"调试异常情况下给开发人员的提示，数据请求失败原因:%@",exception);}
#else // 发布情况下隐藏提示
#define QNWSShowException(...)
#endif

//定义一个空view
#define QNWSView [UIView alloc]
#define QNWSShowHUD(hud,state) {[QNWSView showHUDWithTitle:[NSString stringWithFormat:@"%@",hud] WithState:state];}
#define QNWSHideHUD(hud,state) {[QNWSView hideHUDWithTitle:[NSString stringWithFormat:@"%@",hud] WithState:state];}

#define QNWSShowAndHideHUD(hud,state) {[QNWSView showAndHideHUDWithTitle:[NSString stringWithFormat:@"%@",hud] WithState:state];}


//安全使用block
#define QNWSBlockSafe(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })
//弱引用
#define QNWSWeakSelf(type)  __weak typeof(type) weak##type = type
//强引用
#define QNWSStrongSelf(type)  __strong typeof(type) type = weak##type;
//通知中心
#define QNWSNotificationCenter [NSNotificationCenter defaultCenter]

#define QNWSUserDefaults [NSUserDefaults standardUserDefaults]
#define QNWSUserDefaultsSynchronize [QNWSUserDefaults synchronize]
#define QNWSUserDefaultsSetObjectForKey(object,key) [QNWSUserDefaults setObject:object forKey:key]
#define QNWSUserDefaultsSetValueForKey(value,key) [QNWSUserDefaults setValue:value forKey:key]
#define QNWSUserDefaultsObjectForKey(key) [QNWSUserDefaults objectForKey:key]
#define QNWSUserDefaultsValueForKey(key) [QNWSUserDefaults valueForKey:key]

#define QNWSDictionarySetObjectForKey(dic,object,key) {if((object)  != nil /*&& [dic isMemberOfClass:[NSMutableDictionary class]]*/) [dic setObject:object forKey:key]; else QNWSShowException(@"数据异常");}
#define QNWSDictionarySetValueForKey(dic,value,key) [dic setValue:value forKey:key]
#define QNWSDictionaryObjectForKey(dic,key) [dic objectForKey:key]
#define QNWSDictionaryValueForKey(dic,key) [dic valueForKey:key]

//***************************生成单例的宏***************************//
// 添加到@interface的宏，这个是暴露单例方法
#define QNWSSingleton_interface(className) \
+ (className *)shared##className;

// 添加到@implementation的宏，这个是重写实现单例的方法
#define QNWSSingleton_implementation(className) \
static className *_instance = nil; \
+ (className *)shared##className \
{ \
if(!_instance) return  [[self alloc] init]; \
else return _instance;\
}\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \


#endif /* BYC_FunctionTools_h */
