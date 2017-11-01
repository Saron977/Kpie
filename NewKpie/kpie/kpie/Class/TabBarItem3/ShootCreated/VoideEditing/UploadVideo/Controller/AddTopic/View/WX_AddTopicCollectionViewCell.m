//
//  WX_AddTopicCollectionViewCell.m
//  kpie
//
//  Created by 王傲擎 on 15/11/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_AddTopicCollectionViewCell.h"

@implementation WX_AddTopicCollectionViewCell
//{
//    UILabel             *topiclabel;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backGView.userInteractionEnabled = YES;
        backGView.backgroundColor = KUIColorFromRGB(0xfcfcfc);
        [self addSubview:backGView];
        
        self.topiclabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backGView.frame.size.width, backGView.frame.size.height)];

        self.topiclabel.textColor = KUIColorFromRGB(0x3c4f5e);
        self.topiclabel.textAlignment = NSTextAlignmentCenter;
        self.topiclabel.backgroundColor = [UIColor clearColor];
        self.topiclabel.font = [UIFont systemFontOfSize:13];
        [backGView addSubview:self.topiclabel];
 

    }
    return self;
}



-(void)setTheCellWithModel:(WX_AddTopicModel *)model
{
//    topiclabel.text = model.themeName;
}
@end
