//
//  WX_GuideView.m
//  kpie
//
//  Created by 王傲擎 on 16/4/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_GuideView.h"

@implementation WX_GuideView

// 根据数组内容设置滑动页

-(instancetype)initWithFrame:(CGRect)frame WithImgArray:(NSArray *)imgArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollViewAndPage];
        self.scrollView.contentSize = CGSizeMake(screenWidth*imgArray.count, screenHeight);
        for (int i = 0; i < imgArray.count; i++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*screenWidth, 0, screenWidth, screenHeight)];
            NSString * imgName = [NSString stringWithFormat:@"%@",imgArray[i]];
            imgView.image = KImageOfFile(imgName);
            if (i == imgArray.count -1) {
                imgView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgHideen)];
                [imgView addGestureRecognizer:tap];
            }
            [self.scrollView addSubview:imgView];
            
        }
        self.pageControl.numberOfPages = imgArray.count;
        self.pageControl.currentPage = 0;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];

    }
    
    return self;
}

// 创建滑动视图
-(void)createScrollViewAndPage
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, screenHeight - 30 - 30, 100, 30)];
    self.pageControl.center = CGPointMake(screenWidth/2, screenHeight*0.9);
    //未选中颜色
    self.pageControl.pageIndicatorTintColor = KUIColorFromRGBA(0xffffff, .5f);
    //当前page的颜色
    self.pageControl.currentPageIndicatorTintColor = KUIColorBaseGreenNormal;
    [self addSubview:self.pageControl];
}


#pragma mark ------  UIScrollViewDelegate 滑动代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x)/screenWidth;
    self.pageControl.currentPage = index;
    
    if (self.pageControl.currentPage == self.pageControl.numberOfPages -1 || self.pageControl.currentPage == 0) {
        self.scrollView.bounces = NO;
    
    }else{
        self.scrollView.bounces = YES;
    }
}

-(void)imgHideen
{
    [UIView animateWithDuration:2.0f animations:^{
        
        self.alpha = 0.f;
        
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(removeSelf) userInfo:nil repeats:NO];
    
}

-(void)removeSelf
{
    
    for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if (subView == self) {
            [subView removeFromSuperview];
        }
    }
}

-(void)dealloc
{
    QNWSLog(@" %@ 死了",[self class]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
