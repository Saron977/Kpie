//
//  WX_TencentTool.h
//  kpie
//
//  Created by 王傲擎 on 2017/4/17.
//  Copyright © 2017年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    WX_Tencent_QQ           =   1,              //<**   qq */
    WX_Tencent_WeChat       =   2,              //<**   微信 */
}WX_TencentPlatform;

@interface WX_TencentTool : NSObject
QNWSSingleton_interface(WX_TencentTool);
/**
 *  设置QQID和Key
 */
+ (void)WX_SetTencentToolQQIDAndAppKey;
/**
 *  第三方登录调用接口
 *
 *  @param shareToPlatform      登录的平台
 *  @param presentingController 推出登录界面的控制器
 *  @param thirdAccountDicBlock 第三方登录数据成功的回调
 */
+ (void)WX_loginTencentPlatform:(WX_TencentPlatform)tencentPlatform presentingController:(id)presentingController thirdAccountDictionary:(void(^)(NSDictionary *thirdAccountDic))thirdAccountDicBlock;

@end
