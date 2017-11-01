//
//  WX_AlbumViewController.h
//  kpie
//
//  Created by 王傲擎 on 16/3/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "WX_AlbumModel.h"

@interface WX_AlbumViewController : BYC_BaseViewController

//@property(nonatomic, strong) NSMutableArray         *assetArray; /**< 相册文件数组  */
@property (nonatomic, strong) WX_AlbumModel         *albumModel;    /**<  存储转换后的相册影集  */

@end
