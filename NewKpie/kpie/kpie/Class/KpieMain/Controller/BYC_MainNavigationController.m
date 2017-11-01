//
//  BYC_MainNavigationController.m
//  kpie
//
//  Created by 元朝 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_MainNavigationController.h"
#import "AppDelegate.h"
#import "BYC_BaseViewController.h"
#import "ZFPlayer.h"
#import "BYC_FocusViewController.h"
#import "WX_VoideDViewController.h"

@interface BYC_MainNavigationController ()<UINavigationControllerDelegate>

/**导航栏的状态*/
@property (nonatomic, strong)  NSMutableDictionary  *mDic_State;
/**需要隐藏导航栏的控制器*/
@property (nonatomic, strong)  NSArray  *arr_NeedHidden;
/**push还是Pop*/
@property (nonatomic, assign)  UINavigationControllerOperation  isPush;

@end

@implementation BYC_MainNavigationController
QNWSSingleton_implementation(BYC_MainNavigationController)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arr_NeedHidden = @[@"WX_VoideDViewController",
                        @"WX_GeekViewController",
                        @"BYC_SkillViewController",
                        @"BYC_SearchViewController",
                        @"HL_CenterViewController",
                        @"WX_JoinShootingViewController"];
    
    self.delegate = self;
 
    //移除系统pop手势的target以及事件
    [self removePopTarget];
}

- (void)removePopTarget {
    
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    [self.interactivePopGestureRecognizer removeTarget:internalTarget action:internalAction];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer)
        [self popViewControllerAnimated:YES];
    
    return YES;
}

-(NSMutableDictionary *)mDic_State {

    if (!_mDic_State) _mDic_State = [NSMutableDictionary dictionary];
    return _mDic_State;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self pushAndPopHandle:viewController];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {

    _isPush = operation;
    
    return nil;
}

- (void)pushAndPopHandle:(UIViewController *)viewController {

    NSUInteger index_Current = self.viewControllers.count;
    [self pushAndPopHandle:viewController index:index_Current withPushOrPop:_isPush];
}

- (void)pushAndPopHandle:(UIViewController *)viewController index:(NSUInteger)index_Current withPushOrPop:(UINavigationControllerOperation)operation{

    if (index_Current > 0) {
        
       BOOL is_Current = NO;
        for (NSString *str_Class in _arr_NeedHidden)
            if ([viewController isKindOfClass:NSClassFromString(str_Class)]) is_Current = YES;
        
        QNWSDictionarySetObjectForKey(self.mDic_State, @(is_Current), @(index_Current));
        if (operation == UINavigationControllerOperationPop) {
            
            if (index_Current > 1) {
                
                BOOL is_Next = [QNWSDictionaryObjectForKey(_mDic_State, @(index_Current + 1)) boolValue];
                if ((is_Next == NO && is_Current == YES) || (is_Next == YES && is_Current == NO) || (is_Next == NO && is_Current == NO))
                    [self setNavigationBarHidden:is_Current animated:YES];
            }else [self setNavigationBarHidden:YES animated:YES];
        }else if(operation == UINavigationControllerOperationPush)
            self.navigationBarHidden = is_Current;
    }
}


/************************************************************************************/
/************   三个方法写在根视图中,全局禁用转屏,在需要转屏的页面中可以选择开启   ************/
/***********************************************************************************/


-(BOOL)shouldAutorotate
{
    if ([self.visibleViewController isMemberOfClass:NSClassFromString(@"WX_VoideDViewController")] || [self.visibleViewController isMemberOfClass:NSClassFromString(@"WX_GeekViewController")] || [self.visibleViewController isMemberOfClass:NSClassFromString(@"WX_JoinShootingViewController")] || [self.visibleViewController isMemberOfClass:NSClassFromString(@"HL_VRvideoViewController")]) {
        if (_isVR) {
            return YES;
            }
        else return !ZFPlayerShared.isLockScreen;
    }
    else if ([self.visibleViewController isMemberOfClass:NSClassFromString(@"BYC_MainTabBarController")] || [self.visibleViewController isMemberOfClass:NSClassFromString(@"BYC_SearchViewController")]){
    // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
    return !ZFPlayerShared.isLockScreen;
        
    }
    else {
        return NO;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    UIInterfaceOrientationMask orientation;
    if ([self.visibleViewController isMemberOfClass:NSClassFromString(@"WX_VoideDViewController")] || [self.visibleViewController isMemberOfClass:NSClassFromString(@"WX_GeekViewController")] || [self.visibleViewController isMemberOfClass:NSClassFromString(@"WX_JoinShootingViewController")] || [self.visibleViewController isMemberOfClass:NSClassFromString(@"HL_VRvideoViewController")]) {
        
         orientation = UIInterfaceOrientationMaskAllButUpsideDown;
        
        }else if ([self.visibleViewController isMemberOfClass:NSClassFromString(@"BYC_MainTabBarController")] || [self.visibleViewController isMemberOfClass:NSClassFromString(@"BYC_SearchViewController")]) { // BYC_FocusViewController这个页面支持转屏方向
        if (ZFPlayerShared.isAllowLandscape) {
            orientation = UIInterfaceOrientationMaskAllButUpsideDown;}
        else {
            orientation = UIInterfaceOrientationMaskPortrait;}
    }
    else { orientation = UIInterfaceOrientationMaskPortrait;}
    return orientation;
}

-(void)setChildrenOrientationSupport
{
    
    QNWSLog(@"===  %@",self.childViewControllers);
    
    
    [self preferredInterfaceOrientationForPresentation];
    [self shouldAutorotate];
    [self supportedInterfaceOrientations];
}

@end
