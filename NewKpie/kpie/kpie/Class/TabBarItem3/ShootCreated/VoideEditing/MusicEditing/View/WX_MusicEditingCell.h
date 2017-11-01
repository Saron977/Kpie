//
//  WX_MusicEditingCell.h
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WX_MusicEditingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property(nonatomic, assign) BOOL       isSelected;
@end
