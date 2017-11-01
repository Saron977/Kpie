//
//  BYC_UMengShareTool.m
//  kpie
//
//  Created by 元朝 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_UMengShareTool.h"

#import "NSString+BYC_HaseCode.h"
#import "BYC_RSA.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"
#import "QNWS_UMStatisticsHandler.h"
#import "WX_ShareModel.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation BYC_UMengShareTool

//配置分享
+ (void)setShareAppIDAndAppKey {
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:KSTR_UmengAppkey];
     
    //用下面的代码打开我们SDK在控制台的输出后能看到相应的错误码。
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx2a101fe70731cac5" appSecret:@"b75cba779a7ab4cde5d3d95d170b54ad" redirectURL:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.kpie.android"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1104776482" appSecret:nil redirectURL:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.kpie.android"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3263021995" appSecret:@"e1637bf018effd991868ebf3ba9afc47" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

//配置推送
+ (void)setPushAppIDAndAppKeyWithApplication:(UIApplication *)application LaunchOptions:(NSDictionary *)launchOptions {
    
    
    [UMessage startWithAppkey:KSTR_UmengAppkey launchOptions:launchOptions];
    
    
    
    if (QNWS_CurrentDeviceSystemVersion >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = (id)application.delegate;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert |
                                                 UNAuthorizationOptionBadge |
                                                 UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              }];
    }else if (QNWS_CurrentDeviceSystemVersion >= 8.0){
        //iOS8 - iOS10
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound |
                                                    UIUserNotificationTypeAlert
                                                                                     categories:nil];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

//配置友盟统计
+ (void)setUMStatistics
{
    UMConfigInstance.appKey = KSTR_UmengAppkey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    //以设备的远程推送Token作为设备统计
    [MobClick profileSignInWithPUID:QNWSUserDefaultsObjectForKey(KSTR_KDeviceToken)];
    
    
//    {//模拟用户操作
//        dispatch_queue_t queue = dispatch_queue_create("com.QNWS.UMStatistics", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_async(queue, ^{
//            
//            [QNWS_UMStatisticsHandler exeUMStatistics];
//        });
//    }
}

+ (void)shareTitle:(NSString*)title Content:(NSString *)content withImage:(UIImage *)image orImageUrl:(NSString *)imageUrl Url:(NSString*)urlStr delegate:(id)delegate shareToPlatform:(UMengShareToPlatform)shareToPlatform{
    
    NSAssert(!(image && imageUrl.length > 0) , @"image 和 imageUrl 不能同时存在");
    if (imageUrl.length > 0) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self shareWithTitle:title Content:content image:image Url:urlStr delegate:delegate shareToPlatform:shareToPlatform];
        }];
    }else [self shareWithTitle:title Content:content image:image Url:urlStr delegate:delegate shareToPlatform:shareToPlatform];
}

+ (void)shareWithTitle:(NSString*)title Content:(NSString *)content image:(UIImage *)image Url:(NSString*)urlStr delegate:(id)delegate shareToPlatform:(UMengShareToPlatform)shareToPlatform{
    
    NSInteger loginPlatform;
    switch (shareToPlatform) {
        case UMengShareToSina://新浪微博
            
            loginPlatform = UMSocialPlatformType_Sina;
            break;
        case UMengShareToQzone://QQ空间
            
            loginPlatform = UMSocialPlatformType_Qzone;
            break;
        case UMengShareToQQ://QQ好友
            
            loginPlatform = UMSocialPlatformType_QQ;
            break;
        case UMengShareToWechatSession://微信好友
            
            loginPlatform = UMSocialPlatformType_WechatSession;
            break;
        case UMengShareToWechatTimeline:// 微信朋友圈
            
            loginPlatform = UMSocialPlatformType_WechatTimeLine;
            break;
            
        default:
            break;
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *pageObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:image];
    pageObject.webpageUrl = urlStr;
    messageObject.shareObject = pageObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:loginPlatform messageObject:messageObject currentViewController:delegate completion:^(id result, NSError *error) {
        if(error){
            [QNWSView showAndHideHUDWithTitle:@"分享失败,请重试" WithState:BYC_MBProgressHUDHideProgress];
        }else{
            QNWSShowAndHideHUD(@"分享成功", BYC_MBProgressHUDHideProgress);
            [BYC_HttpServers Get:KQNWS_InvitUserUrl parameters:@[[BYC_AccountTool userAccount].userid] success:nil failure:nil];
        }
    }];
}

+(void)shareMediaID:(NSString *)MediaID videoUserid:(NSString *)videoUserid WithMediaTitle:(NSString *)MediaTitle ImageUrl:(NSString*)imageUrl mediaImage:(NSString *)mediaImage delegate:(id)delegate shareToPlatform:(UMengShareToPlatform)shareToPlatform shareType:(ENUM_ShareType)shareType
{
    
    //设置分享内容和回调对象 此接口是首先判断授权，然后编辑，最后分享
    NSString *mediaUrl = [NSString stringWithFormat:@"http://www.kpie.com.cn/player?videoId=%@",MediaID];
    NSInteger loginPlatform;
//    NSString *shareStr = [NSString stringWithFormat:@"%@",MediaTitle];

    switch (shareToPlatform) {
        case UMengShareToSina://新浪微博
            
            loginPlatform = UMSocialPlatformType_Sina;
            break;
        case UMengShareToQzone://QQ空间
            
            loginPlatform = UMSocialPlatformType_Qzone;
            break;
        case UMengShareToQQ://QQ好友
            
            loginPlatform = UMSocialPlatformType_QQ;
            break;
        case UMengShareToWechatSession://微信好友
            
            loginPlatform = UMSocialPlatformType_WechatSession;
            break;
        case UMengShareToWechatTimeline:// 微信朋友圈
            
            loginPlatform = UMSocialPlatformType_WechatTimeLine;
            break;
            
        default:
            break;
    }
    
    switch (shareType) {
        case ENUM_ShareDefault:
            /// 默认分享
        {
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self WX_shareMediaID:MediaID videoUserid:videoUserid WithMediaTitle:MediaTitle image:image url:mediaUrl delegate:nil loginPlatform:loginPlatform shareType:shareType];
            }];
            
            
        }
            break;
        case ENUM_ShareUpload:
            /// 上传后分享视频
        {
            NSData *imgData = [[NSData alloc]initWithBase64EncodedString:mediaImage options:0];
            UIImage* image = [UIImage imageWithData:imgData];
            [self WX_shareMediaID:MediaID videoUserid:videoUserid WithMediaTitle:MediaTitle image:image url:mediaUrl delegate:nil loginPlatform:loginPlatform shareType:shareType];
        }
            
        default:
            break;
    }
}

+(void)WX_shareMediaID:(NSString *)MediaID videoUserid:(NSString *)videoUserid WithMediaTitle:(NSString *)mediaTitle image:(UIImage*)image url:(NSString*)url delegate:(id)delegate loginPlatform:(NSInteger)loginPlatform shareType:(ENUM_ShareType)shareType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = [self WX_UMShareObjectWithMediaTitle:mediaTitle image:image url:url loginPlatform:loginPlatform];
    
    [[UMSocialManager defaultManager] shareToPlatform:loginPlatform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            QNWSLog(@"error == %@",error);
            if (shareType == ENUM_ShareUpload) {
                WX_ShareModel *shareModel = [[WX_ShareModel alloc]init];
                shareModel.ENUM_ShareState = ENUM_WX_ShareStateFailed;
                [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_UploadShare object:shareModel];
            }
        }else{
            switch (shareType) {
                case ENUM_ShareUpload:
                    /// 上传后分享视频
                {
                    WX_ShareModel *shareModel = [[WX_ShareModel alloc]init];
                    shareModel.ENUM_ShareState = ENUM_WX_ShareStateSuccessed;
                    [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_UploadShare object:shareModel];
                }
                    break;
                case ENUM_ShareDefault:
                    /// 默认分享
                {
                    QNWSShowAndHideHUD(@"分享成功", BYC_MBProgressHUDHideProgress);
                    [BYC_HttpServers Get:KQNWS_SaveSharesVideoUrl parameters:@[MediaID,[BYC_AccountTool userAccount].userid] success:nil failure:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"shareToDraw" object:nil];
                }
                    
                default:
                    break;
            }
        }
        }];
}

+(UMShareObject *)WX_UMShareObjectWithMediaTitle:(NSString *)mediaTitle image:(UIImage*)image url:(NSString*)url loginPlatform:(NSInteger)loginPlatform
{
    if (loginPlatform == UMSocialPlatformType_Sina && ![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]) {
            QNWSLog(@"没安装新浪客户端");
            UMShareWebpageObject *webObject = [UMShareWebpageObject shareObjectWithTitle:mediaTitle descr:@"" thumImage:image];
            webObject.webpageUrl = url;
            return webObject;
    }else{
        UMShareVideoObject *videoObject = [UMShareVideoObject shareObjectWithTitle:mediaTitle descr:nil thumImage:image];
        videoObject.videoUrl = url;
        return videoObject;
    }
}

+(void)loginPlatform:(UMengShareToPlatform)loginToPlatform presentingController:(id)presentingController thirdAccountDictionary:(void (^)(NSDictionary *))thirdAccountDicBlock {
    
    NSInteger loginPlatform = 0;
    NSString *str_Channel;
    switch (loginToPlatform) {
        case UMengShareToSina://新浪微博登陆
            
            loginPlatform = UMSocialPlatformType_Sina;
            str_Channel = @"新浪微博";
            break;
        case UMengShareToQQ://QQ登陆
            
            loginPlatform = UMSocialPlatformType_QQ;
            str_Channel = @"QQ";
            break;
        case UMengShareToWechatSession://微信登陆
            
            loginPlatform = UMSocialPlatformType_WechatSession;
            str_Channel = @"微信";
            break;
        default:
            break;
    }
   
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:loginPlatform currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            QNWSLog(@"三方登录失败");
            [QNWSView showAndHideHUDWithTitle:@"登录失败,请重试" WithState:BYC_MBProgressHUDHideProgress];
        }else{
            UMSocialUserInfoResponse *userInfo_Response = result;
            NSDictionary *dic;
            @try {
                
                NSString *str_UserId = userInfo_Response.uid;
                NSString *passWord = [BYC_RSA encryptString:userInfo_Response.uid];
                NSString *str_DeviceToken = QNWSUserDefaultsObjectForKey(KSTR_KDeviceToken) == nil ? @"":QNWSUserDefaultsObjectForKey(KSTR_KDeviceToken);
                NSString *str_ImageUrl = userInfo_Response.iconurl;
                NSString *str_NickName = userInfo_Response.name;
                //                NSNumber *sex = [NSNumber numberWithBool:false];//这样写登录不上去，只能写下面的字符串了。原因待查。
                NSString *sex = @"false";
                NSString *str_City = @"";
                NSString *str_AccessToken = userInfo_Response.accessToken;
                
                //后台需要传递的数据规则
                NSString *total = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",str_UserId,
                                   passWord,
                                   str_DeviceToken,
                                   str_ImageUrl,
                                   str_NickName,
                                   sex,//性别0
                                   str_City,//城市
                                   str_AccessToken];
                
                NSInteger totalInteger = [total javaHashCode];//hashCode编码
                NSString *totalString = [NSString stringWithFormat:@"%ld",(long)totalInteger];
                NSString *rsaString   = [BYC_RSA encryptString:totalString];
                
                NSDictionary *userInfo_Dic = @{
                                               @"city":str_City,//城市
                                               @"mydescription":@"",
                                               @"nationality":@"中国"
                                               };
                NSMutableDictionary *users_Dic = [[NSMutableDictionary alloc]init];
                [users_Dic setObject:str_UserId      forKey:@"cellphonenumber"];
                [users_Dic setObject:str_Channel     forKey:@"channel"];
                [users_Dic setObject:str_DeviceToken forKey:@"devicetokens"];
                [users_Dic setObject:str_ImageUrl    forKey:@"headportrait"];
                [users_Dic setObject:str_NickName    forKey:@"nickname"];
                [users_Dic setObject:passWord        forKey:@"password"];
                [users_Dic setObject:@"iOS"          forKey:@"platform"];
                [users_Dic setObject:sex             forKey:@"sex"];//性别0
                [users_Dic setObject:userInfo_Dic    forKey:@"userInfo"];
                
                NSMutableDictionary *dic_All = [[NSMutableDictionary alloc]init];
                [dic_All addEntriesFromDictionary:@{
                                                    @"accessToken":str_AccessToken,
                                                    @"totalData":rsaString,
                                                    }];
                [dic_All setObject:users_Dic        forKey:@"users"];
                dic = [NSDictionary dictionaryWithDictionary:dic_All];

                
            } @catch (NSException *exception) {QNWSShowException(exception);}
            QNWSUserDefaultsSetObjectForKey(KSTR_KThirdLogin, KSTR_KThirdLogin);
            [QNWSUserDefaults synchronize]; //记录第三方登陆的标志
            thirdAccountDicBlock(dic);

        }
    }];
}
@end
