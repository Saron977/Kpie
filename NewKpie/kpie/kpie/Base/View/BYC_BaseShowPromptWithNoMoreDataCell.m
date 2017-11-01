//
//  BYC_BaseShowPromptWithNoMoreDataCell.m
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseShowPromptWithNoMoreDataCell.h"

@implementation BYC_BaseShowPromptWithNoMoreDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)buttonAction:(UIButton *)sender {

    if (_delegate_BaseShowPromptWithNoMoreDataCell && [_delegate_BaseShowPromptWithNoMoreDataCell respondsToSelector:@selector(baseShowPromptWithNoMoreDataCellTouchBegin:)]) {
        [_delegate_BaseShowPromptWithNoMoreDataCell baseShowPromptWithNoMoreDataCellTouchBegin:self];
    }
}

@end
