//
//  BYC_FirstViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/13.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_FirstViewController.h"
#import "BYC_SubmitIDFAHandle.h"

@interface BYC_FirstViewController ()
{
    NSArray *img_array;
    NSInteger now_img;
    UIButton *btn;
    
}

@property (strong, nonatomic) UIImageView   *background_img;
@property (strong, nonatomic) UIImageView   *front_img;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation BYC_FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _background_img = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_background_img];
    
    _front_img = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_front_img];
    
    NSInteger height = screenHeight;
    switch (height) {
        case 480:
            img_array = [[NSArray alloc]initWithObjects:@"lead4s1.png",@"lead4s2.png",@"lead4s3.png",@"lead4s4.png",nil];
            break;
        case 568:
            img_array = [[NSArray alloc]initWithObjects:@"lead5:5s1.png",@"lead5:5s2.png",@"lead5:5s3.png",@"lead5:5s4.png",nil];
            break;
        case 667:
            img_array = [[NSArray alloc]initWithObjects:@"lead6:6s1.png",@"lead6:6s2.png",@"lead6:6s3.png",@"lead6:6s4.png",nil];
            break;
            
        default:
            img_array = [[NSArray alloc]initWithObjects:@"lead6p:6sp1.png",@"lead6p:6sp2.png",@"lead6p:6sp3.png",@"lead6p:6sp4.png",nil];
            break;
    }
    
    now_img = 0;
    
    switch (height) {
        case 480:
            _background_img.image = KImageOfFile(@"lead4s1.png");
            _front_img.image = KImageOfFile(@"lead4s1.png");
            break;
        case 568:
            _background_img.image = KImageOfFile(@"lead5:5s1.png");
            _front_img.image = KImageOfFile(@"lead5:5s1.png");
            break;
        case 667:
            _background_img.image = KImageOfFile(@"lead6:6s1.png");
            _front_img.image = KImageOfFile(@"lead6:6s1.png");
            break;
            
        default:
            _background_img.image = KImageOfFile(@"lead6p:6sp1.png");
            _front_img.image = KImageOfFile(@"lead6p:6sp1.png");
            break;
    }
    
    UISwipeGestureRecognizer *leftGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    leftGR.direction = UISwipeGestureRecognizerDirectionLeft;
    _front_img.userInteractionEnabled = YES;
    [_front_img addGestureRecognizer:leftGR];
    UISwipeGestureRecognizer *rightGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    rightGR.direction = UISwipeGestureRecognizerDirectionRight;
    [_front_img addGestureRecognizer:rightGR];
    
    //page视图
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 25, self.view.frame.size.width,10)];
    //未选中颜色
    _pageControl.pageIndicatorTintColor = KUIColorFromRGBA(0xffffff, .5f);
    //当前page的颜色
    _pageControl.currentPageIndicatorTintColor = KUIColorBaseGreenNormal;
    _pageControl.numberOfPages = img_array.count;
    _pageControl.userInteractionEnabled = NO;
//    [self.view addSubview:_pageControl];
    [self creatButton:0];
    
}

#pragma mark - SelfMethod
- (void)swipeLeft
{

    if (now_img<img_array.count - 1) {
        now_img++;
        
        [self leftHide];
        [self creatButton:now_img];
    }
}

- (void)creatButton:(NSInteger)index {

//    if (!btn) {//不明白，先这么写吧。
    
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //这里有个小弊端，不能使用imageWithContentsOfFile加载图片，很郁闷。只能使用imageNamed方法加载，导致有缓存清除不掉
    if (index == img_array.count - 1) {
        [btn setImage:[UIImage imageNamed:@"btn_mskq_n"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_mskq_h"] forState:UIControlStateHighlighted];
    }else {
        [btn setImage:[UIImage imageNamed:@"btn-ksty-n"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn-ksty-h"] forState:UIControlStateHighlighted];
    }
    btn.frame = CGRectMake((screenWidth - 152) / 2, screenHeight - 65, 152, 40);
    [btn addTarget:self action:@selector(btnGo) forControlEvents:UIControlEventTouchUpInside];
    
    //    }
    
    [self.view addSubview:btn];
//    [self.view insertSubview:btn atIndex:self.view.subviews.count - 1];
//    [self.view bringSubviewToFront:btn];
}

-(void)btnGo
{
    //点击之后算打开APP，然后提交查看进行排重操作
    [BYC_SubmitIDFAHandle handleOfsubmitIDFA];
    
    if (self.delegate && self.onStartClick) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:self.onStartClick];
#pragma clang diagnostic pop
    }
    [self.view removeFromSuperview];
}

-(void)swipeRight
{
    
    if (now_img>0) {
        now_img--;
        [self rightHide];
        btn.alpha = 0;
    }
    [self creatButton:now_img];
}
- (void)leftHide
{
    
    [UIView animateWithDuration:.4f animations:^{
        
        _front_img.frame = CGRectMake(-screenWidth, _front_img.frame.origin.y, _front_img.frame.size.width, _front_img.frame.size.height);
        _front_img.alpha = 0;
        _background_img.image = KImageOfFile([img_array objectAtIndex:now_img]);
        
    } completion:^(BOOL finished) {
        
        [self showImage];
    }];
    
}
- (void)rightHide
{
    
    [UIView animateWithDuration:.4f animations:^{
        
        _front_img.frame = CGRectMake(screenWidth, _front_img.frame.origin.y, _front_img.frame.size.width, _front_img.frame.size.height);
        _front_img.alpha = 0;
        _background_img.image = KImageOfFile([img_array objectAtIndex:now_img]);
        
    } completion:^(BOOL finished) {
        
        [self showImage];
    }];
}
- (void)showImage
{
    _front_img.frame = CGRectMake(0, 0, _front_img.frame.size.width,_front_img.frame.size.height);
    _front_img.alpha = 1;
    _front_img.image = KImageOfFile([img_array objectAtIndex:now_img]);
    
    _pageControl.currentPage = now_img;
}

-(void)dealloc {

    QNWSLog(@"启动完成");
}

@end
