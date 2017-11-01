//
//  WX_MovieCViewController.h
//  kpie
//
//  Created by 王傲擎 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "WX_ThemeModel.h"
#import "WX_ShootingScriptViewController.h"
#import "WX_ScriptModel.h"

typedef enum {
    ENUM_Type_Normal        =   0,  /**<    正常拍摄 */
    ENUM_Type_Geek          =   1,  /**<    怪咖栏目 */
    ENUM_Type_Script        =   2,  /**<    剧本合拍 */
}MoiveCreateType;
typedef void(^blockTheme) (WX_ThemeModel *themeModel);

typedef void(^shootingScript) (WX_ScriptModel *scriptModel);

@interface WX_MovieCViewController : BYC_BaseViewController

@property(nonatomic, assign) BOOL           isFromShootVC;

@property (nonatomic, assign) BOOL          isFromScriptVC; /**<   来自剧本合拍 */

/* 添加话题Model */
@property(nonatomic, strong)    WX_ThemeModel  *themeModel;

@property(nonatomic, copy)  shootingScript   scriptBlock;   /**<   剧本合拍回调 */

@property(nonatomic, assign) MoiveCreateType    movie_Type; /**<   拍摄类型 */


@property(nonatomic, copy)  blockTheme block;
@end
