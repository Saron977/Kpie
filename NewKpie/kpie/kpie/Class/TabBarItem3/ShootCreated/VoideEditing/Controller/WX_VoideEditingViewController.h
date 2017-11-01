//
//  WX_VoideEditingViewController.h
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "WX_ThemeModel.h"
@interface WX_VoideEditingViewController : BYC_BaseViewController


@property (nonatomic, strong) WX_ThemeModel        *themeModel;       /**<   话题Model */

@property (nonatomic, copy)   NSString             *scriptStrid;      /**<   剧本合拍__剧本strid */
@property (nonatomic, copy)   NSString             *scriptName;       /**<   剧本名 */

-(void)receiveTheVoide:(NSMutableArray *)voideArray;


@end
