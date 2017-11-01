//
//  HL_RecommendView.m
//  kpie
//
//  Created by sunheli on 16/7/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_RecommendView.h"

@implementation HL_RecommendView
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KUIColorFromRGBA(0x000000, 0.68);
        [self initRecommendView];
    }
    return self;
}

-(void)initRecommendView{

    self.endToFavoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.endToFavoriteBtn setImage:[UIImage imageNamed:@"icon-dz-n"] forState:UIControlStateNormal];
    [self.endToFavoriteBtn setImage:[UIImage imageNamed:@"icon-dz-h"] forState:UIControlStateHighlighted];
    [self.endToFavoriteBtn setImage:[UIImage imageNamed:@"icon-dz-h"] forState:UIControlStateSelected];
    [self.endToFavoriteBtn setTitle:@"赞一个" forState:UIControlStateNormal];
    
   if (screenWidth == 320){
        // 5s
        self.endToFavoriteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.endToFavoriteBtn.titleEdgeInsets = UIEdgeInsetsMake(-50, -80, -120, 0);
    }else {
        // 6+
        self.endToFavoriteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.endToFavoriteBtn.titleEdgeInsets = UIEdgeInsetsMake(-50, -85, -120, 0);
    }
    
    self.endToPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.endToPlayBtn setTitle:@"重播" forState:UIControlStateNormal];
    /// 调整按钮 字体
    if (screenWidth == 320){
        // 5s
        self.endToPlayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.endToPlayBtn.titleEdgeInsets = UIEdgeInsetsMake(-50, -80, -120, 0);
        self.textFont = 13;
    }else {
        // 6+
        self.endToPlayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.endToPlayBtn.titleEdgeInsets = UIEdgeInsetsMake(-50, -85, -120, 0);
        self.textFont = 14;
    }
    [self.endToPlayBtn setImage:[UIImage imageNamed:@"icon-cb"] forState:UIControlStateNormal];
    [self.endToPlayBtn setImage:[UIImage imageNamed:@"icon-cb-h"] forState:UIControlStateHighlighted];
    
    self.recommendLabel = [[UILabel alloc]init];
    self.recommendLabel.text = @"相关推荐 :";
    self.recommendLabel.font = [UIFont systemFontOfSize:self.textFont];
    self.recommendLabel.textColor = KUIColorFromRGB(0xffffff);
    [self.recommendLabel sizeToFit];
    
    self.leftRecommendedVideo =[[UIView alloc]init];
    self.leftRecommendedVideo.backgroundColor = [UIColor blackColor];
    self.leftRecommendedVideo.tag = 401;
    self.rightRecommendedVideo = [[UIView alloc]init];
    self.rightRecommendedVideo.backgroundColor = [UIColor blackColor];
    self.rightRecommendedVideo.tag = 402;
    
    _leftvideoImgView = [[UIImageView alloc]init];
    /// 用户头像
    _leftuserImgView = [[UIImageView alloc]init];
    _leftuserImgView.layer.cornerRadius = 10;
    _leftuserImgView.layer.masksToBounds = YES;
    
    /// 用户昵称
    _leftnickLabel = [[UILabel alloc]init];
    _leftnickLabel.font = [UIFont systemFontOfSize:self.textFont -3];
    _leftnickLabel.textColor = KUIColorFromRGB(0xc4c4c4);
    [_leftnickLabel sizeToFit];
    /// 用户性别
    _leftsexImgView = [[UIImageView alloc]init];
    
    /// 底部遮挡
    _leftocclusionImgView = [[UIImageView alloc]init];
    _leftocclusionImgView.backgroundColor = KUIColorFromRGB(0x1A1F26);
    
    /// 影片名
    _leftvideoTitleLabel = [[UILabel alloc]init];
    _leftvideoTitleLabel.textColor = KUIColorFromRGB(0xffffff);
    _leftvideoTitleLabel.font = [UIFont systemFontOfSize:self.textFont -3];
    [_leftvideoTitleLabel sizeToFit];
    
    /// 点击量
    _leftviewsLabel = [[UILabel alloc]init];
    _leftviewsLabel.text = @"2233";
    _leftviewsLabel.textColor = KUIColorFromRGB(0x82868a);
    _leftviewsLabel.font = [UIFont systemFontOfSize:self.textFont -5];
    [_leftviewsLabel sizeToFit];
    
    /// 点击量(图片)
    _leftviewsImgView = [[UIImageView alloc]init];
    _leftviewsImgView.image = [UIImage imageNamed:@"icon-view-xiao"];
    
    
    _rightvideoImgView = [[UIImageView alloc]init];
    /// 用户头像
    _rightuserImgView = [[UIImageView alloc]init];
    _rightuserImgView.layer.cornerRadius = 10;
    _rightuserImgView.layer.masksToBounds = YES;
    
    /// 用户昵称
    _rightnickLabel = [[UILabel alloc]init];
    _rightnickLabel.font = [UIFont systemFontOfSize:self.textFont -3];
    _rightnickLabel.textColor = KUIColorFromRGB(0xc4c4c4);
    [_rightnickLabel sizeToFit];
    /// 用户性别
    _rightsexImgView = [[UIImageView alloc]init];
    
    /// 底部遮挡
    _rightocclusionImgView = [[UIImageView alloc]init];
    _rightocclusionImgView.backgroundColor = KUIColorFromRGB(0x1A1F26);
    
    /// 影片名
    _rightvideoTitleLabel = [[UILabel alloc]init];
    _rightvideoTitleLabel.textColor = KUIColorFromRGB(0xffffff);
    _rightvideoTitleLabel.font = [UIFont systemFontOfSize:self.textFont -3];
    [_rightvideoTitleLabel sizeToFit];
    
    /// 点击量
    _rightviewsLabel = [[UILabel alloc]init];
    _rightviewsLabel.text = @"2233";
    _rightviewsLabel.textColor = KUIColorFromRGB(0x82868a);
    _rightviewsLabel.font = [UIFont systemFontOfSize:self.textFont -5];
    [_rightviewsLabel sizeToFit];
    
    /// 点击量(图片)
    _rightviewsImgView = [[UIImageView alloc]init];
    _rightviewsImgView.image = [UIImage imageNamed:@"icon-view-xiao"];
   
    
    [self addSubview:self.endToFavoriteBtn];
    [self addSubview:self.endToPlayBtn];
    [self addSubview:self.recommendLabel];
    [self addSubview:self.leftRecommendedVideo];
    [_leftRecommendedVideo addSubview:_leftvideoImgView];
    [_leftRecommendedVideo addSubview:_leftuserImgView];
    [_leftRecommendedVideo addSubview:_leftnickLabel];
    [_leftRecommendedVideo addSubview:_leftsexImgView];
    [_leftRecommendedVideo addSubview:_leftocclusionImgView];
    [_leftocclusionImgView addSubview:_leftvideoTitleLabel];
    [_leftocclusionImgView addSubview:_leftviewsLabel];
    [_leftocclusionImgView addSubview:_leftviewsImgView];

    [self addSubview:self.rightRecommendedVideo];
    [_rightRecommendedVideo addSubview:_rightvideoImgView];
    [_rightRecommendedVideo addSubview:_rightuserImgView];
    [_rightRecommendedVideo addSubview:_rightnickLabel];
    [_rightRecommendedVideo addSubview:_rightsexImgView];
    [_rightRecommendedVideo addSubview:_rightocclusionImgView];
    [_rightocclusionImgView addSubview:_rightvideoTitleLabel];
    [_rightocclusionImgView addSubview:_rightviewsLabel];
    [_rightocclusionImgView addSubview:_rightviewsImgView];
    
    [self.endToFavoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-10);
        make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
        make.width.equalTo(self.mas_height).multipliedBy(0.289);
        make.height.equalTo(self.mas_width).multipliedBy(0.214);
    }];
    [self.endToPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
        make.top.equalTo(self.endToFavoriteBtn.mas_top);
        make.width.equalTo(self.endToFavoriteBtn.mas_width);
        make.height.equalTo(self.endToFavoriteBtn.mas_height);
    }];
    [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).multipliedBy(0.3);
        make.top.equalTo(self.endToFavoriteBtn.mas_bottom).offset(18);
    }];
    [_leftRecommendedVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.endToFavoriteBtn.mas_centerX);
        make.top.equalTo(self.recommendLabel.mas_bottom).offset(15);
        make.width.equalTo(self.mas_width).multipliedBy(0.355);
        make.height.equalTo(self.mas_height).multipliedBy(0.418);
    }];

    [self.rightRecommendedVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.endToPlayBtn.mas_centerX);
        make.top.equalTo(self.recommendLabel.mas_bottom).offset(15);
        make.width.equalTo(self.mas_width).multipliedBy(0.355);
        make.height.equalTo(self.mas_height).multipliedBy(0.418);
    }];
   
    [_leftvideoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(@0);
        make.width.mas_equalTo(_leftRecommendedVideo.mas_width);
        make.height.mas_equalTo(_leftRecommendedVideo.mas_height).multipliedBy(0.83);
    }];
    
    [_leftuserImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftRecommendedVideo.mas_left).offset(5);
        make.top.equalTo(_leftvideoImgView.mas_bottom).offset(-20);
        make.width.height.mas_equalTo(20);
    }];
    
    [_leftnickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftuserImgView.mas_right).offset(5);
        make.centerY.equalTo(_leftuserImgView.mas_centerY);
    }];
    [_leftsexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftnickLabel.mas_right).offset(5);
        make.centerY.equalTo(_leftnickLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [_leftocclusionImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftvideoImgView.mas_left);
        make.bottom.equalTo(_leftRecommendedVideo.mas_bottom);
        make.width.equalTo(_leftvideoImgView.mas_width);
        make.top.equalTo(_leftvideoImgView.mas_bottom);
    }];
    
    [_leftvideoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftuserImgView.mas_left);
        make.centerY.equalTo(_leftocclusionImgView.mas_centerY);
        make.width.equalTo(_leftocclusionImgView.mas_width).multipliedBy(0.6);
    }];
    
    [_leftviewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftocclusionImgView.mas_centerY);
        make.right.equalTo(_leftRecommendedVideo.mas_right);
    }];
    
    [_leftviewsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_leftviewsLabel.mas_left).offset(-3);
        make.centerY.equalTo(_rightocclusionImgView.mas_centerY);
        make.width.mas_equalTo(@10);
        make.height.mas_equalTo(@6);
    }];


    [_rightvideoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(@0);
        make.width.mas_equalTo(_rightRecommendedVideo.mas_width);
        make.height.mas_equalTo(_rightRecommendedVideo.mas_height).multipliedBy(0.83);
    }];
    
    [_rightuserImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightRecommendedVideo.mas_left).offset(5);
        make.top.equalTo(_rightvideoImgView.mas_bottom).offset(-20);
        make.width.height.mas_equalTo(20);
    }];
    
    [_rightnickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightuserImgView.mas_right).offset(5);
        make.centerY.equalTo(_rightuserImgView.mas_centerY);
    }];
    [_rightsexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightnickLabel.mas_right).offset(5);
        make.top.equalTo(_rightnickLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [_rightocclusionImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightvideoImgView.mas_left);
        make.width.equalTo(_rightvideoImgView.mas_width);
        make.top.equalTo(_rightvideoImgView.mas_bottom);
        make.bottom.equalTo(_rightRecommendedVideo.mas_bottom);
    }];
    
    [_rightvideoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightuserImgView.mas_left);
        make.centerY.equalTo(_rightocclusionImgView.mas_centerY);
        make.width.equalTo(_rightocclusionImgView.mas_width).multipliedBy(0.6);
    }];
    
    [_rightviewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightocclusionImgView.mas_centerY);
        make.right.equalTo(_rightRecommendedVideo.mas_right).offset(-2);
    }];
    
    [_rightviewsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightviewsLabel.mas_left).offset(-3);
        make.centerY.equalTo(_rightocclusionImgView.mas_centerY);
        make.width.mas_equalTo(@10);
        make.height.mas_equalTo(@6);
    }];
}

#pragma mark ---------- 写入推荐视图信息
-(void)initRecommendedVideoViewWithWithVideoArr:(NSMutableArray *)randomArray{
     WX_RandomVideoModel *leftvideoModel = [randomArray firstObject];
    WX_RandomVideoModel *rightvideoModel = [randomArray lastObject];
    
    /// 影片图片
    [_leftvideoImgView sd_setImageWithURL:[NSURL URLWithString:leftvideoModel.picturejpg] placeholderImage:nil];
    
    /// 用户头像
    [_leftuserImgView sd_setImageWithURL:[NSURL URLWithString:leftvideoModel.users.headportrait] placeholderImage:nil];
    
    
    /// 用户昵称
    _leftnickLabel.text = leftvideoModel.users.nickname;
    [_leftnickLabel sizeToFit];
    
    /// 用户性别
    if (leftvideoModel.users.sex) {
        _leftsexImgView.image = [UIImage imageNamed:@"icon-nv-xiao"];
    }else{
        _leftsexImgView.image = [UIImage imageNamed:@"icon-nan-xiao"];
    }
    /// 影片名
    _leftvideoTitleLabel.text = leftvideoModel.videotitle;
    _leftvideoTitleLabel.textColor = KUIColorFromRGB(0xffffff);
    _leftvideoTitleLabel.font = [UIFont systemFontOfSize:self.textFont -3];
    /// 点击量
    NSString *leftviewsStr = [NSString stringWithFormat:@"%zi",leftvideoModel.views];
    _leftviewsLabel.text = leftviewsStr;
    [_leftviewsLabel sizeToFit];

        /// 影片图片
        [_rightvideoImgView sd_setImageWithURL:[NSURL URLWithString:rightvideoModel.picturejpg] placeholderImage:nil];
        
        /// 用户头像
        [_rightuserImgView sd_setImageWithURL:[NSURL URLWithString:rightvideoModel.users.headportrait] placeholderImage:nil];
        
        
        /// 用户昵称
        _rightnickLabel.text = rightvideoModel.users.nickname;
        [_rightnickLabel sizeToFit];
        
        /// 用户性别
        if (rightvideoModel.users.sex) {
            _rightsexImgView.image = [UIImage imageNamed:@"icon-nv-xiao"];
        }else{
            _rightsexImgView.image = [UIImage imageNamed:@"icon-nan-xiao"];
        }
        /// 影片名
        _rightvideoTitleLabel.text = rightvideoModel.videotitle;
        _rightvideoTitleLabel.textColor = KUIColorFromRGB(0xffffff);
        _rightvideoTitleLabel.font = [UIFont systemFontOfSize:self.textFont -3];
        /// 点击量
        NSString *rightviewsStr = [NSString stringWithFormat:@"%zi",rightvideoModel.views];
        _rightviewsLabel.text = rightviewsStr;
        [_rightviewsLabel sizeToFit];
    
}

@end
