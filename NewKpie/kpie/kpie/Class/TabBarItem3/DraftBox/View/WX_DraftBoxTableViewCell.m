//
//  WX_DraftBoxTableViewCell.m
//  kpie
//
//  Created by 王傲擎 on 15/12/4.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_DraftBoxTableViewCell.h"
#import "WX_UploadVideoViewController.h"

@implementation WX_DraftBoxTableViewCell
{
    
    __weak IBOutlet UIImageView *thumImage;
    __weak IBOutlet UILabel *title;
    __weak IBOutlet UILabel *contents;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)cellWithModel:(WX_DBBoxModel *)model
{
    title.text = model.title;
    if (model.imgDataStr.length > 0) {
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:model.imgDataStr options:0];
        thumImage.image = [UIImage imageWithData:imgData];
    }
    contents.text = model.mediaTitle;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
