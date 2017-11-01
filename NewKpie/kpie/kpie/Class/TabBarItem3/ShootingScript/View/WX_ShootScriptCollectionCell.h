//
//  WX_ShootScriptCollectionCell.h
//  kpie
//
//  Created by 王傲擎 on 16/3/31.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WX_ShootScriptCollectionCell : UICollectionViewCell

@property(nonatomic, strong) UIButton                *scriptBtn;                /**<  剧本按钮点击播放  */
@property(nonatomic, strong) UIView                  *unDownloadView;           /**<  未下载  */
@property(nonatomic, strong) UIImageView             *imgView_PlayIcon;         /**<   播放按钮 */



@end
