//
//  WX_PhotoKitCollectionViewCell.h
//  Album
//
//  Created by 王傲擎 on 16/8/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WX_PhotoSelectedViewController.h"
#import <Photos/Photos.h>
typedef void(^SelectedAsset)(id);

@interface WX_PhotoKitCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy  ) SelectedAsset                 selectedAsset;  /**<   选中/取消 asset */
@property (nonatomic, assign) BOOL                          isSelect;       /**<   是否被选中 */
@property (nonatomic, strong) UIImage                       *img_Photo;     /**<   图片 */
@property (nonatomic, strong) UIButton                      *btn_Selected;          /**<   按钮_选中 */


-(void)initCellTypeWithPhotoKitType:(PhtotKitType)photoKitType PHAsset:(PHAsset*)asset;

@end
