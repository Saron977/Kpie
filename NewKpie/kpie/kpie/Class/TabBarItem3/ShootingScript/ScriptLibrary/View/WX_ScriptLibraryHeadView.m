//
//  WX_ScriptLibraryHeadView.m
//  kpie
//
//  Created by 王傲擎 on 16/4/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ScriptLibraryHeadView.h"

@implementation WX_ScriptLibraryHeadView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        _partImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.bottom-1, screenWidth, 1)];
        _partImgView.backgroundColor = KUIColorFromRGB(0xdedede);
        [self addSubview:_partImgView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.04*screenWidth, 0, screenWidth, self.kheight)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = KUIColorFromRGB(0x87A4C9);
        [self addSubview:_titleLabel];
        
        _pullImgView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth *(1-0.05-0.05/2), (self.kheight-screenWidth*0.05)/2, screenWidth*0.05, screenWidth*0.05)];
        _pullImgView.image = [UIImage imageNamed:@"btn_xiangshang_n"];
        [self addSubview:_pullImgView];
        
        
        _scriptNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth -_pullImgView.kwidth-screenWidth*0.1, _pullImgView.korigin.y, screenWidth*0.05, screenWidth*0.05)];
        _scriptNumLabel.font = [UIFont systemFontOfSize:12];
        _scriptNumLabel.textAlignment = NSTextAlignmentRight;
        _scriptNumLabel.textColor = KUIColorFromRGB(0xBDBFC1);
        [self addSubview:_scriptNumLabel];
    }
    
    return self;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
