//
//  WX_MediaCollectionViewCell.h
//  kpie
//
//  Created by 王傲擎 on 15/11/19.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
#import "NSDate+TimeInterval.h"


@interface WX_MediaCollectionViewCell : UICollectionViewCell


@property(nonatomic, assign) NSInteger           section;
@property(nonatomic, assign) NSInteger           row;

@property(nonatomic, retain)UIView              *BGView;
@property(nonatomic, retain)UIButton            *selButton;
@property(nonatomic, retain)UIImageView         *selImgView;

@property(nonatomic, assign) BOOL               isClick;





-(void)setCellWithImage:(UIImage *)image time:(NSString *)time;

#if 0
- (void)bind:(ALAsset *)asset;
-(void)setCellWithAsset:(ALAsset *)asset;
#endif
@end
