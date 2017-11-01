//
//  BYC_RecommendCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_RecommendCollectionViewCell.h"

@interface BYC_RecommendCollectionViewCell ()

@property (nonatomic, strong)  UIImageView  *imageView;
@end

@implementation BYC_RecommendCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initParame];
        [self initSubViews];
    }
    return self;
}

- (void)initParame {

    self.layer.cornerRadius  = 5.f;
    self.layer.masksToBounds = YES;
    self.layer.rasterizationScale  = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize     = YES;
}

#pragma mark - 初始化子视图
- (void)initSubViews {
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];
}

-(void)setStr_Url:(NSString *)str_Url {

    _str_Url = str_Url;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_str_Url] placeholderImage:nil];
}
@end
