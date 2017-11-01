//
//  WX_ShareHandle.m
//  kpie
//
//  Created by 王傲擎 on 16/9/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ShareHandle.h"
#import "WX_ToolClass.h"

static WX_ShareHandle *shareHandle;
@interface WX_ShareHandle()

@property (nonatomic, assign) NSInteger         integer_NeedShareCounts;                /**<   需要分享次数 */
@property (nonatomic, assign) NSInteger         integer_CompleteShareCounts;            /**<   完成分享次数 */
@property (nonatomic, assign) BOOL              is_ShareQQ;                             /**<   分享qq */
@property (nonatomic, assign) BOOL              is_WeChatShare;                         /**<   微信 */
@property (nonatomic, assign) BOOL              is_WeChatMomentsShare;                  /**<   朋友圈 */
@property (nonatomic, assign) BOOL              is_SinaWeiBoShare;                      /**<   新浪微博 */
@property (nonatomic, strong) WX_ShareModel     *model_Share;                           /**<   模型_分享 */


@end

@implementation WX_ShareHandle

+(void)WX_ShareVideoWithModel:(WX_ShareModel *)model NeedShareCounts:(NSInteger)counts ShareQQ:(BOOL)isShareQQ ShareWeChat:(BOOL)isShareWeChat ShareWeChatMonents:(BOOL)isWeChatMonents ShareWeiBo:(BOOL)isShareWeiBo
{
    if (!shareHandle) {
        shareHandle = [[WX_ShareHandle alloc]init];
    }
    
    [shareHandle shareVideoWithModel:model NeedShareCounts:counts ShareQQ:isShareQQ ShareWeChat:isShareWeChat ShareWeChatMonents:isWeChatMonents ShareWeiBo:isShareWeiBo];
}

-(void)shareVideoWithModel:(WX_ShareModel *)model NeedShareCounts:(NSInteger)counts ShareQQ:(BOOL)isShareQQ ShareWeChat:(BOOL)isShareWeChat ShareWeChatMonents:(BOOL)isWeChatMonents ShareWeiBo:(BOOL)isShareWeiBo
{
    _integer_CompleteShareCounts    = 0;
    _integer_NeedShareCounts        = counts;
    _is_ShareQQ                     = isShareQQ;
    _is_WeChatShare                 = isShareWeChat;
    _is_WeChatMomentsShare          = isWeChatMonents;
    _is_SinaWeiBoShare              = isShareWeiBo;
    _model_Share                    = model;
    
    if (isShareWeChat){
        [self shareWeChatWithModel:model];
    }else if (isWeChatMonents){
        [self shareWeChatMonentsWithModel:model];
    }else if (isShareQQ) {
        [self shareQQWithModel:model];
    }else if (isShareWeiBo){
        [self shareWeiBoWithModel:model];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareDidFinishResponse:) name:KNotification_UploadShare object:nil];
}


/**
 分享完成通知回调

 @param noti 回调通知
 */
-(void)shareDidFinishResponse:(NSNotification*)noti
{
    WX_ShareModel *shareModel_Noti = (WX_ShareModel *)noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (shareModel_Noti.ENUM_ShareState) {
            case ENUM_WX_ShareStateSuccessed:
            {
                _integer_CompleteShareCounts++;
                
                if (_is_WeChatShare) {
                    [self shareWeChatWithModel:_model_Share];
                }else if (_is_WeChatMomentsShare){
                    [self shareWeChatMonentsWithModel:_model_Share];
                }else if (_is_ShareQQ){
                    [self shareQQWithModel:_model_Share];
                }else if (_is_SinaWeiBoShare){
                    [self shareWeiBoWithModel:_model_Share];
                    [self removeObject];
                }
                
                QNWSLog(@"一共需要分享 %zi, 完成分享% zi",_integer_NeedShareCounts,_integer_CompleteShareCounts);
                if (_integer_NeedShareCounts == _integer_CompleteShareCounts) {
                    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(shareCompleted) userInfo:nil repeats:NO];
                }
            }
                break;
            case ENUM_WX_ShareStateFailed:
            {
                
            }
                break;
            default:
                break;
        }
    });
}

///**
// 自定义关闭授权页面事件
// 
// @param navigationCtroller 关闭当前页面的navigationCtroller对象
// 
// */
//-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService
//{
//    QNWSLog(@" 000000000 关闭了当前授权界面");
//    return YES;
//}
//
///**
// 关闭当前页面之后
// 
// @param fromViewControllerType 关闭的页面类型
// 
// */
//-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
//{
//    QNWSLog(@" 000000000 关闭了当前界面");
//}
//
///**
// 分享成功后回调
//
// @param response 回调
// */
//
//
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    QNWSLog(@"分享完成回调");
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        if ( response.responseCode == UMSResponseCodeSuccess) {
//            _integer_CompleteShareCounts++;
//            
//            if (_is_WeChatShare) {
//                [self shareWeChatWithModel:_model_Share];
//            }else if (_is_WeChatMomentsShare){
//                [self shareWeChatMonentsWithModel:_model_Share];
//            }else if (_is_ShareQQ){
//                [self shareQQWithModel:_model_Share];
//            }else if (_is_SinaWeiBoShare){
//                [self shareWeiBoWithModel:_model_Share];
//                [self removeObject];
//            }
//
//            QNWSLog(@"一共需要分享 %zi, 完成分享% zi",_integer_NeedShareCounts,_integer_CompleteShareCounts);
//            if (_integer_NeedShareCounts == _integer_CompleteShareCounts) {
//                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(shareCompleted) userInfo:nil repeats:NO];
//            }
//        }
//    });
//}


/**
 分享到微信

 @param model    模型
 @param delegate 代理
 */
-(void)shareWeChatWithModel:(WX_ShareModel*)model
{
    QNWSLog(@"分享至 微信");
    [[UIView alloc] showAndHideHUDWithTitle:@"正在打开微信" WithState:BYC_MBProgressHUDHideProgress];
    [BYC_UMengShareTool shareMediaID:model.share_VideoID videoUserid:model.share_UserID WithMediaTitle:model.share_VideoTitle ImageUrl:nil mediaImage:model.share_ImageDataStr  delegate:self shareToPlatform:UMengShareToWechatSession shareType:ENUM_ShareUpload];
    _is_WeChatShare = NO;
}

/**
 分享到朋友圈

 @param model    模型
 @param delegate 代理
 */
-(void)shareWeChatMonentsWithModel:(WX_ShareModel*)model
{
    QNWSLog(@"分享至 微信朋友圈");
    [[UIView alloc] showAndHideHUDWithTitle:@"正在打开微信" WithState:BYC_MBProgressHUDHideProgress];
    [BYC_UMengShareTool shareMediaID:model.share_VideoID videoUserid:model.share_UserID WithMediaTitle:model.share_VideoTitle ImageUrl:nil mediaImage:model.share_ImageDataStr  delegate:self shareToPlatform:UMengShareToWechatTimeline shareType:ENUM_ShareUpload];
    _is_WeChatMomentsShare = NO;
}


/**
 分享到微博

 @param model    模型
 @param delegate 代理
 */
-(void)shareWeiBoWithModel:(WX_ShareModel*)model
{
    QNWSLog(@"分享至 微博");
    [[UIView alloc] showAndHideHUDWithTitle:@"正在打开微博" WithState:BYC_MBProgressHUDHideProgress];
    [BYC_UMengShareTool shareMediaID:model.share_VideoID videoUserid:model.share_UserID WithMediaTitle:model.share_VideoTitle ImageUrl:nil mediaImage:model.share_ImageDataStr  delegate:(id)[WX_ToolClass getCurrentVC] shareToPlatform:UMengShareToSina shareType:ENUM_ShareUpload];
    _is_SinaWeiBoShare = NO;
}


/**
 分享到qq

 @param model    模型
 @param delegate 代理
 */
-(void)shareQQWithModel:(WX_ShareModel*)model
{
    QNWSLog(@"分享至 QQ");
    [[UIView alloc] showAndHideHUDWithTitle:@"正在打开QQ" WithState:BYC_MBProgressHUDHideProgress];
    [BYC_UMengShareTool shareMediaID:model.share_VideoID videoUserid:model.share_UserID WithMediaTitle:model.share_VideoTitle ImageUrl:nil mediaImage:model.share_ImageDataStr  delegate:self shareToPlatform:UMengShareToQQ shareType:ENUM_ShareUpload];
    _is_ShareQQ = NO;
}

-(void)shareCompleted
{
//    [[UIView alloc]showAndHideHUDWithTitle:@"分享完成" WithState:BYC_MBProgressHUDHideProgress];
    
    [self removeObject];
    
}


/**
 移除控制器
 */
-(void)removeObject
{
    shareHandle = nil;
}

-(void)dealloc
{
    QNWSLog(@"%s 掉了",__func__);
}
@end
