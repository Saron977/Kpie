//
//  BYC_BaseNavigationController.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseNavigationController.h"
#import "UIView+BYC_Tools.h"

@interface BYC_BaseNavigationController ()<UIGestureRecognizerDelegate>
@end

@implementation BYC_BaseNavigationController

+ (void)initialize
{
    // 获取当前类下面的UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    
    // 设置导航条按钮的文字颜色
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.interactivePopGestureRecognizer.delegate = self;
    [[UINavigationBar appearance] setBarTintColor:KUIColorBaseGreenNormal];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
//    [self recursion_UINavigationBar:self.navigationBar];
//    [self.navigationBar insertSubview:[self.navigationBar getBlurEffectViewWithStyle:UIBlurEffectStyleLight frame:CGRectMake(0, -20, screenWidth, KHeightNavigationBar)] atIndex:0];
}

/**
 *  找到影响最佳设置毛玻璃的视图，然后设置其alpha = 0
 */
- (void)recursion_UINavigationBar:(UIView *)view {

    if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
        view.alpha = 0;//通过无数次摸索，查找设置毛玻璃效果为什么不理想，原来要设置这个东东的alpha = 0，不然毛玻璃效果很差。我也是醉了。
        return;
    }
    if (view.subviews.count > 0)for (UIView *view1 in view.subviews)[self recursion_UINavigationBar:view1];
}

/**
 *  选择不同导航栏样式
 *
 *  @param NavgationBarStyle 导航栏样式
 */
- (void)selectNavgationBar:(BYC_BaseNavigationControllerSelectNavgationBarStyle)NavgationBarStyle {

    switch (NavgationBarStyle) {
        case BYC_BaseNavigationControllerSelectNavgationBarStyleOne:
 
            _selectNavgationBarStyle = BYC_BaseNavigationControllerSelectNavgationBarStyleOne;
            break;
        case BYC_BaseNavigationControllerSelectNavgationBarStyleTwo:

            _selectNavgationBarStyle = BYC_BaseNavigationControllerSelectNavgationBarStyleTwo;
            break;
        case BYC_BaseNavigationControllerSelectNavgationBarStyleThree:

            _selectNavgationBarStyle = BYC_BaseNavigationControllerSelectNavgationBarStyleThree;
            break;
            
        default:
            break;
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if (_selectNavgationBarStyle == BYC_BaseNavigationControllerSelectNavgationBarStyleOne) {
        
        [self navgationBarStyleOne:viewControllerToPresent];
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    
    if (_selectNavgationBarStyle == BYC_BaseNavigationControllerSelectNavgationBarStyleOne) {
        
        [self navgationBarStyleOne:viewController];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navgationBarStyleOne:(UIViewController *)viewController {

    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 40, 44);
    [_leftButton setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    _backActionSEL = @selector(backAction);
    [_leftButton addTarget:self action:_backActionSEL forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    viewController.navigationItem.leftBarButtonItem = item;
}

- (void)navgationBarStyleTwo:(UIViewController *)viewController {

    

}

- (void)navgationBarStyleThree:(UIViewController *)viewController {
    
    
}



- (void)backAction {

    [self popViewControllerAnimated:YES];
}


@end


