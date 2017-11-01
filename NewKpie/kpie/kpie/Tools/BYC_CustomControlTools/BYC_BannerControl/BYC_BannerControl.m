//
//  BYC_BannerControl.m
//  kpie
//
//  Created by 元朝 on 16/7/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BannerControl.h"
#import "BYC_ScrollViewPanGestureRecognizer.h"

static CGFloat const timer_Time = 5;

@interface Banner_PageControl : UIPageControl
/**当前选中的pageControl*/
@property (strong, nonatomic) UIImage *image_Active;
/**没有选中的pageControl*/
@property (strong, nonatomic) UIImage *image_Inactive;
@end

@implementation Banner_PageControl

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image_Active = [UIImage imageNamed:@"home_icon_banner_h"];
        self.image_Inactive = [UIImage imageNamed:@"home_icon_banner_n"];
    }
    return self;
}
- (void)update {
    for (int i = 0; i < [self.subviews count]; i++) {
        if (![self.subviews[i] viewWithTag:i + 1]) {
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.subviews[i].bounds];
            imageV.tag = i + 1;
            [self.subviews[i] addSubview:imageV];
        }
    }
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *imagev = (UIImageView *)self.subviews[i].subviews[0];
        if ([imagev isKindOfClass:[UIImageView class]]) {
            if (i == self.currentPage) imagev.image = _image_Active;
            else imagev.image = _image_Inactive;
            imagev.superview.frame = CGRectMake(CGRectGetMinX(imagev.superview.frame), CGRectGetMinY(imagev.superview.frame),
                                                imagev.image.size.width, imagev.image.size.height);
            imagev.frame = imagev.superview.bounds;
        }
    }
}
- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self update];
}
@end

@interface BYC_BannerControl ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView           *scrollView;
/**左图*/
@property (strong, nonatomic) UIImageView            *imageV_Left;
/**中图*/
@property (strong, nonatomic) UIImageView            *imageV_Center;
/**右图*/
@property (strong, nonatomic) UIImageView            *imageV_Right;

/**左*/
@property (strong, nonatomic) UIButton               *button_Left;
/**中*/
@property (strong, nonatomic) UIButton               *button_Center;
/**右*/
@property (strong, nonatomic) UIButton               *button_Right;

/**左图下标*/
@property (assign, nonatomic) NSUInteger             index_LeftImage;
/**左图下标*/
@property (assign, nonatomic) NSUInteger             index_CenterImage;
/**左图下标*/
@property (assign, nonatomic) NSUInteger             index_RightImage;

/**默认图片*/
@property (strong, nonatomic) UIImage                *image_PlaceHolder;
/**轮播定时器*/
@property (assign, nonatomic) NSTimer                *timer;
/**翻页控件*/
@property (strong, nonatomic) Banner_PageControl     *pageControl;
/**定时器状态开关*/
@property (assign, nonatomic) BOOL                   isTimeUp;
/**点击后的回调*/
@property (copy, nonatomic  ) Block_TapCallBack      block_CallBack;
/**展示title*/
@property (strong, nonatomic  ) UILabel              *lab_Title;

/**展示的模型数据*/
@property (nonatomic, strong) NSArray  <BYC_BannerControlModel *> * arr_Models;
@end

@implementation BYC_BannerControl


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initParame];
    }
    return self;
}

+ (instancetype)bannerControlWithFrame:(CGRect)frame bannerControlModels:(NSArray <BYC_BannerControlModel *>  *)bannerControlModels placeHolderImage:(NSString *)placeHolder pageControlShowStyle:(ENUM_PageControlShowStyle)pageControlShowStyle tapCallBackBlock:(Block_TapCallBack)block_CallBack{
    
    NSAssert(bannerControlModels.count > 0, @"bannerControlModels不能没有数据");
    BYC_BannerControl *bannerControl = [[BYC_BannerControl alloc]initWithFrame:frame];
    bannerControl.image_PlaceHolder = [UIImage imageNamed:placeHolder];
    bannerControl.arr_Models = bannerControlModels;
    [bannerControl addPageControlWithStyle:pageControlShowStyle];
    bannerControl.block_CallBack = block_CallBack;
    return bannerControl;
}


- (void)bannerControlWithModels:(NSArray <BYC_BannerControlModel *>  *)bannerControlModels placeHolderImage:(NSString *)placeHolder pageControlShowStyle:(ENUM_PageControlShowStyle)pageControlShowStyle tapCallBackBlock:(Block_TapCallBack)block_CallBack {
    
    NSAssert(bannerControlModels.count > 0, @"bannerControlModels不能没有数据");
    if (!_scrollView)[self initParame];
    self.image_PlaceHolder = [UIImage imageNamed:placeHolder];
    self.arr_Models = bannerControlModels;
    [self addPageControlWithStyle:pageControlShowStyle];
    self.block_CallBack = block_CallBack;
    if (!_timer)[self starTimer];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.timer invalidate];
        self.timer = nil;
    } else
        [self starTimer];
}

-(void)setArr_BannerControlModels:(NSArray<BYC_BannerControlModel *> *)arr_BannerControlModels {
    
    _arr_BannerControlModels = arr_BannerControlModels;
    self.arr_Models = _arr_BannerControlModels;
    
}
- (void)initParame {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * 3, CGRectGetHeight(_scrollView.frame));
    _scrollView.delegate = self;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIImageView *imageV;
    UIButton *button;
    
    [self creatImageV:&imageV button:&button index:0];
    _imageV_Left = imageV;
    _button_Left = button;
    
    [self creatImageV:&imageV button:&button index:1];
    _imageV_Center = imageV;
    _button_Center = button;
    _imageV_Center.userInteractionEnabled = YES;
    [_imageV_Center addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction)]];
    [_button_Center addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self creatImageV:&imageV button:&button index:2];
    _imageV_Right = imageV;
    _button_Right = button;
    
    [self addSubview:_scrollView];
    _pageControl = [[Banner_PageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    [self addSubview:_pageControl];
    
    
    _lab_Title = [UILabel new];
    [self addSubview:_lab_Title];
    _lab_Title.backgroundColor = KUIColorFromRGBA(0x000000, .5);
    _lab_Title.font = [UIFont systemFontOfSize:12];
    _lab_Title.textColor = [UIColor whiteColor];
    [_lab_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        (void)make.left.right.bottom;
        make.top.equalTo(_pageControl.mas_bottom);
    }];
}

- (void)creatImageV:(UIImageView **)imageV button:(UIButton **)button index:(int)index{
    
    *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame) * index, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    
    *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [*button setHidden: YES];
    [*button setImage:[UIImage imageNamed:@"Play_n"] forState:UIControlStateNormal];
    [*button setImage:[UIImage imageNamed:@"Play_h"] forState:UIControlStateHighlighted];
    [*imageV addSubview:*button];
    
    [*button mas_makeConstraints:^(MASConstraintMaker *make) {(void)make.center;}];
    [_scrollView addSubview:*imageV];
}

-(void)setArr_Models:(NSArray<BYC_BannerControlModel *> *)arr_Models {
    
    _arr_Models = arr_Models;
    if (_arr_Models.count == 0) return;
    
    _index_LeftImage = _arr_Models.count - 1;
    _index_CenterImage = 0;
    _index_RightImage = 1;
    [self updateImage];
    
}

- (void)addPageControlWithStyle:(ENUM_PageControlShowStyle)pageControlStyle {
    
    if (pageControlStyle == ENUM_PageControlShowStyleNone || _arr_Models.count < 2) return;
    
    _pageControl.numberOfPages = _arr_Models.count;
    
    switch (pageControlStyle) {
        case ENUM_PageControlShowStyleBottomLeft:
            _pageControl.frame = CGRectMake(0, CGRectGetHeight(_scrollView.frame) - 20, 20 * _pageControl.numberOfPages, 20);
            break;
        case ENUM_PageControlShowStyleCenter: {
        
            CGFloat y;
            if (_arr_Models[0].str_Title == nil) {y = CGRectGetHeight(_scrollView.frame) - 21;}
            else {y = CGRectGetHeight(_scrollView.frame) - 41;}
            _pageControl.frame = CGRectMake((CGRectGetWidth(_scrollView.frame) - 20 * _pageControl.numberOfPages) / 2, y, 20 * _pageControl.numberOfPages, 20);
        }
            break;
        case ENUM_PageControlShowStyleBottomRight:
            _pageControl.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) - 20 * _pageControl.numberOfPages, CGRectGetHeight(_scrollView.frame) - 60, 20 * _pageControl.numberOfPages, 20);
            break;
        case ENUM_PageControlShowStyleTopLeft:
            _pageControl.frame = CGRectMake(0, 0, 20 * _pageControl.numberOfPages, 20);
            break;
        case ENUM_PageControlShowStyleTopRight:
            _pageControl.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) - 20 * _pageControl.numberOfPages, 0, 20 * _pageControl.numberOfPages, 20);
            break;
            
        default:
            break;
    }
}

- (void)starTimer {
    if (_arr_Models.count > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:timer_Time target:self selector:@selector(moveImage) userInfo:nil repeats:YES];
        _isTimeUp = NO;
    }
}

- (void)moveImage {
    
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

//更新图片
- (void)updateImage {
    
    [_imageV_Left sd_setImageWithURL:[NSURL URLWithString:_arr_Models[_index_LeftImage].str_ImageUrl] placeholderImage:_image_PlaceHolder];
    _button_Left.hidden = _arr_Models[_index_LeftImage].bannerControlShowStyle == ENUM_BannerControlShowStyleImage ? YES : NO;
    [_imageV_Center sd_setImageWithURL:[NSURL URLWithString:_arr_Models[_index_CenterImage].str_ImageUrl] placeholderImage:_image_PlaceHolder];
    _button_Center.hidden = _arr_Models[_index_CenterImage].bannerControlShowStyle == ENUM_BannerControlShowStyleImage ? YES : NO;
    
    if (_arr_Models.count < 2) {
        _scrollView.scrollEnabled = NO;
        [_lab_Title mas_updateConstraints:^(MASConstraintMaker *make) {
            
            if (_arr_Models[_index_CenterImage].str_Title == nil) {
                
                _lab_Title.hidden = YES;
            }else {
                
                _lab_Title.hidden = NO;
                _lab_Title.text = [@"  " stringByAppendingString:_arr_Models[_index_CenterImage].str_Title];
                make.top.offset(self.kheight - 20);
            }
        }];
        return;
    }
    [_imageV_Right sd_setImageWithURL:[NSURL URLWithString:_arr_Models[_index_RightImage].str_ImageUrl] placeholderImage:_image_PlaceHolder];
    _button_Right.hidden = _arr_Models[_index_RightImage].bannerControlShowStyle == ENUM_BannerControlShowStyleImage ? YES : NO;
    _pageControl.currentPage = _index_CenterImage;
    if (_arr_Models[_index_CenterImage].str_Title == nil) {

        _lab_Title.hidden = YES;
        _pageControl.top = CGRectGetHeight(_scrollView.frame) - 21;
        return;
    }else {
        _lab_Title.hidden = NO;
        _lab_Title.text = [@"  " stringByAppendingString:_arr_Models[_index_CenterImage].str_Title];
        _pageControl.top = CGRectGetHeight(_scrollView.frame) - 41;
    }
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (_scrollView.contentOffset.x == 0) {
        _index_LeftImage   = --_index_LeftImage;
        _index_CenterImage = --_index_CenterImage;
        _index_RightImage  = --_index_RightImage;
        
        if (_index_LeftImage == -1) _index_LeftImage     = _arr_Models.count - 1;
        if (_index_CenterImage == -1) _index_CenterImage = _arr_Models.count - 1;
        if (_index_RightImage == -1) _index_RightImage   = _arr_Models.count - 1;
        
    } else if(_scrollView.contentOffset.x == CGRectGetWidth(_scrollView.frame) * 2 || _scrollView.contentOffset.x == (NSInteger)(_scrollView.kwidth * 2) || _scrollView.contentOffset.x == (NSInteger)(_scrollView.kwidth * 2) + .5f) {//此处这么多||是因为后两个判断是在scrollView的宽度不是整数时，意思就是有小数的时候，会导致判断不准确
        _index_CenterImage = ++_index_CenterImage;
        _index_LeftImage   = ++_index_LeftImage;
        _index_RightImage  = ++_index_RightImage;
        
        if (_index_LeftImage == _arr_Models.count) _index_LeftImage     = 0;
        if (_index_CenterImage == _arr_Models.count) _index_CenterImage = 0;
        if (_index_RightImage == _arr_Models.count) _index_RightImage   = 0;
        
    } else
        return;
    
    [self updateImage];
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:timer_Time]];
    _isTimeUp = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self starTimer];
}

- (void)buttonAction {
    
    QNWSBlockSafe(_block_CallBack,_index_CenterImage);
}
@end
