//
//  BYC_CustomCenterViewController.m
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_CustomCenterViewController.h"
#import "BYC_CustomCenterCollectionViewController.h"

@interface BYC_CustomCenterViewController ()<CustomCenterCollectionViewControllerDelegate> 

@end

@implementation BYC_CustomCenterViewController

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (!_handler_Content) {
        
        [self.childViewControllers makeObjectsPerformSelector:@selector(setDelegate:) withObject:self];
        [self initViews];
    }
}

- (void)initViews{

    _flo_OffSetY = -flo_DefaultOffSetY;
    _handler_Content = [BYC_CustomCenterControlColletionHandler customCenterControlColletionHandlerWithParentViewController:self];
    _view_Container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), flo_DefaultOffSetY)];
    [self.view addSubview:_view_Container];
}

- (void)customCenterCollectionViewController:(BYC_CustomCenterCollectionViewController *)vc setupCollectionViewOffSetYWhenViewWillAppear:(UIScrollView *)scrollView {
 
//     if (_flo_OffSetY < -(KHeightNavigationBar + flo_SegmentViewHeight)) {//上个collection的偏移小于导航栏+flo_SegmentViewHeight （注：_flo_OffSetY始终记录的是上一个collection的偏移量）
//         [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, _flo_OffSetY) animated:YES];
//         _view_Container.frame = CGRectMake(CGRectGetMinX(_view_Container.frame), 0, CGRectGetWidth(_view_Container.frame), CGRectGetHeight(_view_Container.frame));
//     } else {
//         if (scrollView.contentOffset.y < -(KHeightNavigationBar + flo_SegmentViewHeight)) {//自身collection的偏移小于
//             [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -(KHeightNavigationBar + flo_SegmentViewHeight)) animated:YES];
//             // 使选项卡停在navigationBar下面
//             _view_Container.frame = CGRectMake(CGRectGetMinX(_view_Container.frame), KHeightNavigationBar - flo_HeadViewHeight, CGRectGetWidth(_view_Container.frame), CGRectGetHeight(_view_Container.frame));
//         }
//     }
}

- (void)customCenterCollectionViewController:(BYC_CustomCenterCollectionViewController *)vc scrollViewIsScrolling:(UIScrollView *)scrollView {
 
//     CGFloat deltaY =  scrollView.contentOffset.y - _flo_OffSetY;
//     self.flo_OffSetY = scrollView.contentOffset.y;
//     if (_flo_OffSetY > -(flo_DefaultOffSetY - flo_HeadViewHeight + KHeightNavigationBar)) {
//         
//         // 使选项卡停在navigationBar下面
//         _view_Container.frame = CGRectMake(CGRectGetMinX(_view_Container.frame),KHeightNavigationBar - flo_HeadViewHeight, CGRectGetWidth(_view_Container.frame), CGRectGetHeight(_view_Container.frame));
//         
//         return;
//     } else if (_flo_OffSetY < -flo_DefaultOffSetY) {
//         
//         // 使整个头停在navigationBar下面
//         _view_Container.frame = CGRectMake(CGRectGetMinX(_view_Container.frame), 0, CGRectGetWidth(_view_Container.frame), CGRectGetHeight(_view_Container.frame));
//         return;
//     }
//     
//     // 这里是让_view_Container随着上下滚动
//    
//    CGFloat f = CGRectGetMinY(_view_Container.frame) - deltaY;
//    
//    if (scrollView.contentOffset.y >= -(flo_SegmentViewHeight + KHeightNavigationBar)) {
//        f = flo_DefaultOffSetY - (flo_SegmentViewHeight + KHeightNavigationBar);
//    }else if (scrollView.contentOffset.y < -flo_DefaultOffSetY)
//        f = 0;
//    
//     _view_Container.frame = CGRectMake(CGRectGetMinX(_view_Container.frame), f, CGRectGetWidth(_view_Container.frame), CGRectGetHeight(_view_Container.frame));
// 
}
@end
