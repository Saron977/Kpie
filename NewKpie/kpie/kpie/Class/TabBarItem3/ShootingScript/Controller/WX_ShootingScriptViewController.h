//
//  WX_ShootingScriptViewController.h
//  kpie
//
//  Created by 王傲擎 on 16/3/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "WX_ScriptModel.h"

@interface WX_ShootingScriptViewController : BYC_BaseViewController

@property (nonatomic, strong) WX_ScriptModel *Libtary_ScriptModel;        /**<    从剧本库跳转过来 */

@property (nonatomic, strong) WX_ScriptModel *videoD_ScriptModel;         /**<    从视频详情跳转过来  */

@end
