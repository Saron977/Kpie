//
//  BYC_SkillCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 15/11/19.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_SkillCollectionViewCell.h"

@interface BYC_SkillCollectionViewCell(){

    UIImage *_image;
}

@end

@implementation BYC_SkillCollectionViewCell

-(void)setCellImageName:(NSString *)cellImageName {
    
    if (_cellImageName != cellImageName) {
        
        _cellImageName = cellImageName;
        _image = KImageOfFileAndType(cellImageName, @"png");
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect {

    [_image drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - KHeightNavigationBar)];
}

-(void)dealloc {

    QNWSLog(@"%@类 死了",[self class]);
}
@end
