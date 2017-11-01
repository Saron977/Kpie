//
//  WX_MoreMusicCell.h
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WX_MusicModel.h"

typedef void(^blockCellButton) (BOOL isDown);
@interface WX_MoreMusicCell : UITableViewCell <NSURLConnectionDataDelegate>

@property(nonatomic,copy)blockCellButton block;

@property (weak, nonatomic) IBOutlet UIButton           *downButton;
@property (weak, nonatomic) IBOutlet UILabel            *titleLabel;
@property(nonatomic,retain) WX_MusicModel               *model;

@end
