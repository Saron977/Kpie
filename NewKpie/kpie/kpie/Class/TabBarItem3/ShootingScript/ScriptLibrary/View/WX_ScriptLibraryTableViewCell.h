//
//  WX_ScriptLibraryTableViewCell.h
//  kpie
//
//  Created by 王傲擎 on 16/4/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WX_ScriptModel.h"
//#import "WX_ScriptLibraryViewController.h"

@interface WX_ScriptLibraryTableViewCell : UITableViewCell <NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *scriptTitleImgView;
@property (weak, nonatomic) IBOutlet UILabel *scriptTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scriptDescribeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pushImgView;
@property (nonatomic, strong) WX_ScriptModel   *scriptModel;

@end
