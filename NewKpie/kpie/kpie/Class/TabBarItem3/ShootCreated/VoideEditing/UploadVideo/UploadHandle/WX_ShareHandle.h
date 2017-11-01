//
//  WX_ShareHandle.h
//  kpie
//
//  Created by 王傲擎 on 16/9/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYC_UMengShareTool.h"
#import "WX_ShareModel.h"

@interface WX_ShareHandle : NSObject <UMSocialPlatformProvider>

//+(void)WX_ShareHandle

/**
 分享

 @param model           分享模型
 @param delegate        分享设置代理
 @param counts          分享次数
 @param isShareQQ       是否分享到qq
 @param isShareWeChat   是否分享到微信
 @param isWeChatMonents 是否分享到朋友圈
 @param isShareWeiBo    是否分享到微博
 */

+(void)WX_ShareVideoWithModel:(WX_ShareModel*)model NeedShareCounts:(NSInteger)counts ShareQQ:(BOOL)isShareQQ ShareWeChat:(BOOL)isShareWeChat ShareWeChatMonents:(BOOL)isWeChatMonents ShareWeiBo:(BOOL)isShareWeiBo;

@end
