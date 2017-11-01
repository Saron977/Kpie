//
//  BYC_UMengShareTool.h
//  kpie
//
//  Created by 元朝 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>


typedef enum : NSUInteger {
    UMengShareToSina = 1,//新浪微博
    UMengShareToQzone,   //QQ空间
    UMengShareToQQ,      //QQ好友
    UMengShareToWechatSession,      //微信好友
    UMengShareToWechatTimeline,      // 微信朋友圈
} UMengShareToPlatform;//分享的平台

typedef enum {
    ENUM_ShareDefault   =   0,  /**<   默认分享 */
    ENUM_ShareUpload    =   1,  /**<   上传分享 */
}ENUM_ShareType;



@interface BYC_UMengShareTool : NSObject
//<UMSocialUIDelegate>


/**
 *  设置第三方分享ID和Key
 */
+ (void)setShareAppIDAndAppKey;
/**
 *  设置第三方推送ID和Key
 */
+ (void)setPushAppIDAndAppKeyWithApplication:(UIApplication *)application LaunchOptions:(NSDictionary *)launchOptions;
/**
 *  配置友盟统计
 */
+ (void)setUMStatistics;
/**
 *  分享调用接口
 *
 *  @param title    分享标题
 *  @param content  文字内容
 *  @param image    分享图片
 *  @param urlStr   分享网址
 *  @param delegate 回调代理
 *  @param shareToPlatform 分享的平台
 */
+ (void)shareTitle:(NSString*)title Content:(NSString *)content withImage:(UIImage *)image orImageUrl:(NSString *)imageUrl Url:(NSString*)urlStr delegate:(id)delegate shareToPlatform:(UMengShareToPlatform)shareToPlatform;

+ (void)shareMediaID:(NSString *)MediaID videoUserid:(NSString *)videoUserid WithMediaTitle:(NSString *)MediaTitle ImageUrl:(NSString*)imageUrl mediaImage:(NSString *)mediaImage delegate:(id)delegate shareToPlatform:(UMengShareToPlatform)shareToPlatform shareType:(ENUM_ShareType)shareType;
/**
 *  第三方登录调用接口
 *
 *  @param shareToPlatform      登录的平台
 *  @param presentingController 推出登录界面的控制器
 *  @param thirdAccountDicBlock 第三方登录数据成功的回调
 */
+ (void)loginPlatform:(UMengShareToPlatform)loginToPlatform presentingController:(id)presentingController thirdAccountDictionary:(void(^)(NSDictionary *thirdAccountDic))thirdAccountDicBlock;

@end
