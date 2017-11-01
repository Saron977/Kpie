//
//  WX_UploadVideoViewController.h
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "CTAssetsPickerController.h"
#import "WX_MediaInfoModel.h"
#import "WX_ThemeModel.h"
#import "WX_DBBoxModel.h"

@interface WX_UploadVideoViewController : BYC_BaseViewController

#if 0
-(void)setImageWithAsset:(NSMutableArray *)assetsArray;

#endif


@property(nonatomic, strong)  WX_ThemeModel       *themeModel;            /**< 话题Model */

-(void)setMediaWithModel:(WX_MediaInfoModel *)model;


-(void)setFromDraftBoxModel:(WX_DBBoxModel *)model;

@property (nonatomic, copy)   NSString             *scriptStrid;         /**<   剧本合拍__剧本strid */
@property (nonatomic, copy)   NSString             *scriptName;       /**<   剧本名 */


@end
