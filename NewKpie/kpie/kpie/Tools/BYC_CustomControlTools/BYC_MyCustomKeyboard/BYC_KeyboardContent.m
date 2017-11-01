//
//  BYC_KeyboardContent.m
//  自定义键盘
//
//  Created by 元朝 on 16/3/2.
//  Copyright © 2016年 BYC. All rights reserved.
//

#import "BYC_KeyboardContent.h"

@implementation BYC_KeyboardContent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (id)initWithBlock:(SelectEmojiBlock)block {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _view_Smilies.block = block;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)initViews {
    _view_Smilies = [[BYC_KeyboardEmoji alloc] initWithFrame:CGRectZero];
    
    _scrollView_Smilies = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, _view_Smilies.kheight)];
    _scrollView_Smilies.backgroundColor = [UIColor clearColor];
    _scrollView_Smilies.contentSize = CGSizeMake(_view_Smilies.kwidth, _view_Smilies.kheight);
    _scrollView_Smilies.pagingEnabled = YES;
    _scrollView_Smilies.showsHorizontalScrollIndicator = NO;
    _scrollView_Smilies.delegate = self;
    [_scrollView_Smilies addSubview:_view_Smilies];
    [self addSubview:_scrollView_Smilies];
    
    _control_Page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView_Smilies.bottom, screenWidth, 20)];
    _control_Page.backgroundColor = [UIColor clearColor];
    _control_Page.numberOfPages = _view_Smilies.pageNumber;
    _control_Page.currentPage = 0;
    _control_Page.pageIndicatorTintColor = [UIColor blackColor];
    _control_Page.currentPageIndicatorTintColor = [UIColor blueColor];
    [self addSubview:_control_Page];
    
    self.kheight = _scrollView_Smilies.kheight + _control_Page.kheight;
    self.kwidth = _view_Smilies.kwidth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int pageNumber = scrollView.contentOffset.x / screenWidth;
    _control_Page.currentPage = pageNumber;
}

-(void)dealloc {

    QNWSLog(@"%@",NSStringFromClass([self class]));
    
}

@end
