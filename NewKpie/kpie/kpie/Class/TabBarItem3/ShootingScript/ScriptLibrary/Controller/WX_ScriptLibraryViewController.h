//
//  WX_ScriptLibraryViewController.h
//  kpie
//
//  Created by 王傲擎 on 16/3/31.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "WX_ScriptModel.h"

typedef void(^BlockLibrary) (WX_ScriptModel *library_ScriptModel);

@interface WX_ScriptLibraryViewController : BYC_BaseViewController

@property (nonatomic, copy) BlockLibrary   libraryBlock;    /**<   点击后跳回剧本合拍界面, 给回调 */

@end
