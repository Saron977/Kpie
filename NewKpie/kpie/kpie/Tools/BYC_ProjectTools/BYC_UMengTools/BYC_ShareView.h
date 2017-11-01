//
//  BYC_ShareView.h
//  kpie
//
//  Created by 元朝 on 15/11/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_UMengShareTool.h"
#import "BYC_PropertyManager.h"


/*资源ID<一般是视频ID，不排除以后会有其它ID>*/
extern NSString * const const_ShareResourceID;

/*用户ID*/
extern NSString * const const_ShareUserID;

/*资源标题*/
extern NSString * const const_ShareResourceTitle;

/*资源图片*/
extern NSString * const const_ShareResourceImage;

/*看拍下载页*/
extern NSString * const const_ShareKpieDownloadUrl;

/*活动连接,默认也是看拍下载页*/
extern NSString const * const_ShareActivityUrl;

/*活动标题*/
extern NSString const * const_ShareActivityTitle;

/*活动内容*/
extern NSString const * const_ShareActivityContent;

/*活动标图片地址*/
extern NSString const * const_ShareActivityImageUrl;

typedef NS_ENUM(NSUInteger, BYC_ShareType) {
    BYC_ShareTypeText,
    BYC_ShareTypeMedia,
    BYC_ShareTypeActivity,

};

@interface BYC_ShareView : UIView

/**
 *  显示
 *  delegateVC : 弹出微博分享界面需要<必须传一个代理控制器>
 */
- (void)showWithDelegateVC:(id)delegateVC shareContentOrMedia:(BYC_ShareType)shareType shareWithDic:(NSDictionary *)dic;

@end
