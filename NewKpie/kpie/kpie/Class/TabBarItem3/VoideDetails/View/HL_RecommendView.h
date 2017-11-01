//
//  HL_RecommendView.h
//  kpie
//
//  Created by sunheli on 16/7/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WX_RandomVideoModel.h"

@interface HL_RecommendView : UIView

@property (nonatomic, assign) NSInteger                                    textFont;
@property (nonatomic, strong) UIButton                                     *endToFavoriteBtn;            /**< 播放结束, 赞一个(喜欢) */
@property (nonatomic, strong) UIButton                                     *endToPlayBtn;                /**< 播放结束, 准备重播 */
@property (nonatomic, strong) UIView                                       *leftRecommendedVideo;          /**< 推荐视频,左侧 */
@property (nonatomic, strong) UIView                                       *rightRecommendedVideo;         /**< 推荐视频,右侧 */
@property (nonatomic, strong) UILabel                                      *recommendLabel;

@property (nonatomic, strong) UIImageView                                  *leftvideoImgView;
@property (nonatomic, strong) UIImageView                                  *leftuserImgView;
@property (nonatomic, strong) UILabel                                      *leftnickLabel;
@property (nonatomic, strong) UIImageView                                  *leftsexImgView;
@property (nonatomic, strong) UIImageView                                  *leftocclusionImgView;
@property (nonatomic, strong) UILabel                                      *leftvideoTitleLabel;
@property (nonatomic, strong) UILabel                                      *leftviewsLabel;
@property (nonatomic, strong) UIImageView                                  *leftviewsImgView;

@property (nonatomic, strong) UIImageView                                  *rightvideoImgView;
@property (nonatomic, strong) UIImageView                                  *rightuserImgView;
@property (nonatomic, strong) UILabel                                      *rightnickLabel;
@property (nonatomic, strong) UIImageView                                  *rightsexImgView;
@property (nonatomic, strong) UIImageView                                  *rightocclusionImgView;
@property (nonatomic, strong) UILabel                                      *rightvideoTitleLabel;
@property (nonatomic, strong) UILabel                                      *rightviewsLabel;
@property (nonatomic, strong) UIImageView                                  *rightviewsImgView;


-(void)initRecommendedVideoViewWithWithVideoArr:(NSMutableArray *)randomArray;

@end
