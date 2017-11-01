//
//  BYC_MainTabBarController.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_MainTabBarController.h"
#import "BYC_BaseNavigationController.h"
#import "BYC_LoginAndRigesterView.h"
#import "BYC_TabBar.h"
#import "WX_ShootingScriptViewController.h"
#import "WX_MovieCViewController.h"
#import "WX_ShootCViewController.h"
#import "BYC_AccountTool.h"
#import <QuartzCore/QuartzCore.h>
#import "BYC_ImageChangeSkin.h"
#import "BYC_ButtonChangeSkin.h"
#import "WX_AnimationLayer.h"
#import "BYC_MainNavigationController.h"
#import "BYC_ADModel.h"

UIKIT_EXTERN NSInteger CountdownTime;

@interface BYC_MainTabBarController ()<BYC_TabBarDelegate>
/**
 *  存放TabBar的数组
 */
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic,assign ) BOOL           isClickButton;
@property (nonatomic,strong ) UIView         *backGView;
@property (nonatomic,strong ) BYC_ButtonChangeSkin       *cameraButton;
@property (nonatomic, strong) BYC_ButtonChangeSkin       *scriptBtn;            /**<  剧本合拍按钮  */
@property(nonatomic,strong) BYC_ButtonChangeSkin         *shootBtn;             /**< 拍摄按钮 */
@property(nonatomic,strong) BYC_ButtonChangeSkin         *createBtn;            /**< 创作按钮 */
@property(nonatomic,strong) BYC_ButtonChangeSkin         *otherBtn;            /**< 其他按钮 */

@property (nonatomic, retain) BYC_ButtonChangeSkin       *cameraBtn;            /**< 不全button 点击范围  */
@property (nonatomic, assign) NSInteger                  animationCount;        /**<  动画执行次数  */

@property (nonatomic,strong ) NSArray        *iconArray;
@property (nonatomic,strong ) NSArray        *selectArray;
@property (nonatomic,strong ) NSArray        *titleArray;
@property (nonatomic, strong) BYC_TabBar     *myCustomTabBar;
/**YES：已经打开过*/
@property (nonatomic, assign)  BOOL  isOpened;


@end

@implementation BYC_MainTabBarController
QNWSSingleton_implementation(BYC_MainTabBarController)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (!_isOpened) {
        _isOpened = YES;
        [self initViews];
        if (_model_AD)
            if (_model_AD.advertList2.count > 0) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CountdownTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [QNWSNotificationCenter postNotificationName:KNotification_NeedShowAD object:_model_AD.advertList2];
                });
            }
    }
}

-(void)setOthers
{
    //设置iconArray 数组
    self.iconArray = @[@"btn_sy_jbhp_n",@"btn-xzps-n",@"btn-dpcz-n"];
    self.selectArray = @[@"btn_sy_jbhp_h",@"btn-xzps-h",@"btn-dpcz-h"];
    self.titleArray = @[@"合 拍",@"拍 摄",@"上 传"];
    
    self.items = [NSMutableArray array];
}

- (void)initViews {
    
    [self setOthers];
    [self initSubVC];
    // 自定义tabBar
    [self setTabBar];

}

- (void)initSubVC {
    
    self.homeViewController = [[BYC_HomeViewController alloc] init];
    [self setOneChildViewController:self.homeViewController image:[BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_sy_n"] selectedImage:[BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_sy_h"] title:@"首页"];
    
    self.tabBarItemTwoViewController = [[BYC_DiscoverViewController alloc] init];
    [self setOneChildViewController:self.tabBarItemTwoViewController image:[BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_fx_n"] selectedImage:[BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_fx_h"] title:@"发现"];
    
    self.focusViewController = [[BYC_FocusViewController alloc] init];
    [self setOneChildViewController:self.focusViewController image:[BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_dt_n"] selectedImage:[BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_dt_h"] title:@"动态"];
    
    self.tabBarItemFiveViewController = [[BYC_PersonalViewController alloc] init];
    [self setOneChildViewController:self.tabBarItemFiveViewController image:[BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_wd_n"] selectedImage:[BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_wd_h"] title:@"我的"];
    
}

- (void)setTabBar {

    _myCustomTabBar = [[BYC_TabBar alloc] initWithFrame:self.tabBar.bounds];
    _myCustomTabBar.delegate = self;
    _myCustomTabBar.items = self.items;
    
    for (id object in self.tabBar.subviews) {
        
        if ([object isMemberOfClass:NSClassFromString(@"UITabBarButton")]) {
            [object removeFromSuperview];
        }
    }
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bj"]];
    [self.tabBar setShadowImage:[UIImage imageNamed:@"bj"]];
    [self.tabBar addSubview:_myCustomTabBar];
}
#pragma mark - 添加一个子控制器
- (void)setOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    vc.title = title;
    //不希望使用系统颜色，需要对图片加上属性UIImageRenderingModeAlwaysOriginal
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    [self addChildViewController:vc];

}


#pragma mark - 当点击tabBar上的按钮调用
#if 1
/**
 *   定义Button
 *
 **/
-(void)createCameraButtonWithTpye:(NSInteger)type
{
    
    // type - 选择在新建是图上添加 还是在原视图添加
    // type - 0 在原始图上添加    type - 1 在新建视图上添加
    if (type == 1) {
        if (!self.cameraButton) {
            
            self.cameraButton = [BYC_ButtonChangeSkin buttonWithType:UIButtonTypeCustom];
            self.cameraButton.frame = CGRectMake((_backGView.kwidth-55)/2,  _backGView.bottom-(55-49), 55, 55);
            [self.cameraButton setImageDic:[BYC_ImageChangeSkin getDicImageNamed:@"home_tab_btn_gn_n"] forState:UIControlStateNormal];
            [self.cameraButton setImageDic:[BYC_ImageChangeSkin getDicImageNamed:@"home_tab_btn_gn_n"] forState:UIControlStateSelected];
            [self.cameraButton addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
            self.cameraButton.isCheckLogin = YES;
            [_backGView addSubview:self.cameraButton];
        }
        
        /// 给button 动画
        [UIView animateWithDuration:.55 animations:^{
            _cameraButton.transform = CGAffineTransformMakeRotation(M_PI/4*3);
        } completion:^(BOOL finished) {

        }];
        
    }
}

-(void)createBackgroundViewWithType:(BOOL)type
{
    // type - 隐藏 / 显示 背景画布
    // type - 0 隐藏背景画布    type - 1 显示背景画布
    
    if (type) {
        _animationCount = 0;
        if (!_backGView) {
            
            _backGView = [[UIView alloc]init];
            _backGView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
            
            // 添加手势
            _backGView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView)];
            [_backGView addGestureRecognizer:tap];
            
            [self.view addSubview:_backGView];
        }
        _backGView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-KHeightTabBar);
        

#pragma mark ----------- 剧本合拍按钮

        if (!self.scriptBtn) {
            self.scriptBtn = [BYC_ButtonChangeSkin buttonWithType:UIButtonTypeCustom];
            [self.scriptBtn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:[NSString stringWithFormat:@"%@",self.iconArray[0]]] forState:UIControlStateNormal];
            [self.scriptBtn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:[NSString stringWithFormat:@"%@",self.selectArray[0]]] forState:UIControlStateHighlighted];
            [self.scriptBtn setTitle:[NSString stringWithFormat:@"%@",self.titleArray[0]] forState:UIControlStateNormal];
            [self.scriptBtn setTitle:[NSString stringWithFormat:@"%@",self.titleArray[0]] forState:UIControlStateHighlighted];
            self.scriptBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -screenWidth/4, 0);
            if (screenWidth/40 > 10) {
                [self.scriptBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            }else{
                [self.scriptBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                
            }
            self.scriptBtn.titleLabel.alpha = 0.f;
            _scriptBtn.tag = 301;
            [self.scriptBtn addTarget:self action:@selector(buttonWithNum:) forControlEvents:UIControlEventTouchUpInside];
            [self.backGView addSubview:self.scriptBtn];
        }
        
        
        self.scriptBtn.frame = CGRectMake(screenWidth*(1-0.16*3)/4, screenHeight*0.68, screenWidth*0.16, screenWidth*0.16);
        [WX_AnimationLayer setViewAnimationWithView:self.scriptBtn StartPonit:CGPointMake(screenWidth/2, screenHeight) EndPoint:self.scriptBtn.center BeginTime:0.f ShowOrHidden:YES Controller:self];

        
        
#pragma mark ----------- 拍摄按钮
        if (!self.shootBtn) {
            
            self.shootBtn = [BYC_ButtonChangeSkin buttonWithType:UIButtonTypeCustom];
            [self.shootBtn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:[NSString stringWithFormat:@"%@",self.iconArray[1]]] forState:UIControlStateNormal];
            [self.shootBtn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:[NSString stringWithFormat:@"%@",self.selectArray[1]]] forState:UIControlStateHighlighted];
            [self.shootBtn setTitle:[NSString stringWithFormat:@"%@",self.titleArray[1]] forState:UIControlStateNormal];
            [self.shootBtn setTitle:[NSString stringWithFormat:@"%@",self.titleArray[1]] forState:UIControlStateHighlighted];
            self.shootBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -screenWidth/4, 0);
            if (screenWidth/40 > 10) {
                [self.shootBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            }else{
                [self.shootBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                
            }
            self.shootBtn.titleLabel.alpha = 0.f;
            _shootBtn.tag = 302;
            [self.shootBtn addTarget:self action:@selector(buttonWithNum:) forControlEvents:UIControlEventTouchUpInside];
            [self.backGView addSubview:self.shootBtn];
            
        }
        self.shootBtn.frame = CGRectMake(screenWidth*(1-0.16)/2, screenHeight*0.58, screenWidth*0.16, screenWidth*0.16);
        [WX_AnimationLayer setViewAnimationWithView:self.shootBtn StartPonit:CGPointMake(screenWidth/2, screenHeight) EndPoint:self.shootBtn.center BeginTime:0.15f ShowOrHidden:YES Controller:self];

        
#pragma mark --------- 创作按钮
        
        if (!self.createBtn) {
            
            self.createBtn = [BYC_ButtonChangeSkin buttonWithType:UIButtonTypeCustom];
            [self.createBtn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:[NSString stringWithFormat:@"%@",self.iconArray[2]]] forState:UIControlStateNormal];
            [self.createBtn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:[NSString stringWithFormat:@"%@",self.selectArray[2]]] forState:UIControlStateHighlighted];
            [self.createBtn setTitle:[NSString stringWithFormat:@"%@",self.titleArray[2]] forState:UIControlStateNormal];
            [self.createBtn setTitle:[NSString stringWithFormat:@"%@",self.titleArray[2]] forState:UIControlStateHighlighted];
            self.createBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -screenWidth/4, 0);
            if (screenWidth/40 > 10) {
                [self.createBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            }else{
                [self.createBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                
            }
            self.createBtn.titleLabel.alpha = 0.f;
            [self.createBtn addTarget:self action:@selector(buttonWithNum:) forControlEvents:UIControlEventTouchUpInside];
            _createBtn.tag = 303;
            [self.backGView addSubview:self.createBtn];
            
        }
        self.createBtn.frame = CGRectMake(screenWidth -(screenWidth*(1-0.16*3)/4) -screenWidth*0.16, screenHeight*0.68, screenWidth*0.16, screenWidth*0.16);
        [WX_AnimationLayer setViewAnimationWithView:self.createBtn StartPonit:CGPointMake(screenWidth/2, screenHeight) EndPoint:self.createBtn.center BeginTime:0.25f ShowOrHidden:YES Controller:self];
        
        
#pragma mark ----- 不知道是什么按钮
#if 0
        if (self.otherBtn) {
            self.otherBtn = nil;
        }
        self.otherBtn = [BYC_ButtonChangeSkin buttonWithType:UIButtonTypeCustom];
        self.otherBtn.frame = CGRectMake(screenWidth*((1-0.16*4)/5*4+0.16*3), screenHeight*0.70, screenWidth*0.16, screenWidth*0.16);
        [self.otherBtn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:[NSString stringWithFormat:@"%@",self.iconArray[1]]] forState:UIControlStateNormal];
        [self.otherBtn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:[NSString stringWithFormat:@"%@",self.selectArray[1]]] forState:UIControlStateHighlighted];
        [self.otherBtn setTitle:[NSString stringWithFormat:@"%@",self.titleArray[1]] forState:UIControlStateNormal];
        [self.otherBtn setTitle:[NSString stringWithFormat:@"%@",self.titleArray[1]] forState:UIControlStateHighlighted];
        self.otherBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -screenWidth/4, 0);
        if (screenWidth/40 > 10) {
            [self.otherBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }else{
            [self.otherBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            
        }
        [self.otherBtn addTarget:self action:@selector(buttonWithNum:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backGView addSubview:self.otherBtn];
        
        self.otherBtn.alpha = 0.0f;
        self.otherBtn.titleLabel.alpha = 0.0f;
        self.otherBtn.center = CGPointMake(screenWidth/2 , screenHeight -screenWidth*0.16);
        [UIButton animateWithDuration:0.35f animations:^{
            self.otherBtn.alpha = 0.75f;
            self.otherBtn.frame = CGRectMake(screenWidth*((1-0.16*4)/5*4+0.16*3), screenHeight*0.70, screenWidth*0.16, screenWidth*0.16);
        } completion:^(BOOL finished) {
            [UIButton animateWithDuration:0.08f animations:^{
                self.otherBtn.titleLabel.alpha = 1.0f;
            }];
        }];
#endif
     

        [self.backGView bringSubviewToFront:self.cameraButton];

    }else{

        [UIView animateWithDuration:.55f animations:^{
            [WX_AnimationLayer setViewAnimationWithView:self.scriptBtn StartPonit:CGPointMake(screenWidth/2, screenHeight) EndPoint:CGPointMake(screenWidth/2, screenHeight) BeginTime:0.05f ShowOrHidden:NO Controller:self];
            
            [WX_AnimationLayer setViewAnimationWithView:self.shootBtn StartPonit:CGPointMake(screenWidth/2, screenHeight) EndPoint:CGPointMake(screenWidth/2, screenHeight) BeginTime:0.15f ShowOrHidden:NO Controller:self];
            
            [WX_AnimationLayer setViewAnimationWithView:self.createBtn StartPonit:CGPointMake(screenWidth/2, screenHeight) EndPoint:CGPointMake(screenWidth/2, screenHeight) BeginTime:0.25f ShowOrHidden:NO Controller:self];
            
            _cameraButton.transform = CGAffineTransformIdentity;

        } completion:^(BOOL finished) {

        }];
    }
}



// 点击camera按钮的时候调用
- (void)tabBarDidClickCameraButton:(BYC_TabBar *)tabBar
{
    self.isClickButton = !self.isClickButton;
    if (self.isClickButton == 1) {
        [self createBackgroundViewWithType:1];
        
        [self createCameraButtonWithTpye:1];
        NSLog(@"进入选择画面111111");
        [self.cameraButton setHidden:NO];
        [self.cameraBtn setHidden:YES];
        
    }
    if (self.isClickButton == 0) {
        [self createBackgroundViewWithType:0];
        
        //            [self.cameraButton setHidden:YES];
        
        [self.cameraBtn setHidden:NO];
        
        
        [self setButtonSelectedIsNo];
        
        NSLog(@"退出选择画面1111111");
    }

}


-(void)cameraButtonClick
{
    self.isClickButton = !self.isClickButton;
    
    if (self.isClickButton == 1) {
        [self createBackgroundViewWithType:1];
        
        [self createCameraButtonWithTpye:1];
        [self.cameraButton setHidden:NO];

        [self.cameraBtn setHidden:YES];
        NSLog(@"进入选择画面2222222");
        
        
    }
    if (self.isClickButton == 0) {
        [self createBackgroundViewWithType:0];
        
        
        [self.cameraBtn setHidden:NO];

        
        [self setButtonSelectedIsNo];
        
        NSLog(@"退出选择画面2222222");
    }
    
}



//点击背景视图,取消选择操作
-(void)tapBackView
{
    [self createBackgroundViewWithType:0];
    
//    [self.cameraButton setHidden:YES];

    [self.cameraBtn setHidden:NO];
    
    self.isClickButton = 0;
    
    [self setButtonSelectedIsNo];
}

// 设置Btn状态
-(void)setButtonSelectedIsNo
{
    self.createBtn.selected = NO;
    self.shootBtn.selected = NO;
    self.scriptBtn.selected = NO;
}


// 点击下方button
-(void)buttonWithNum:(UIButton *)button
{
    QNWSLog(@"button.currentTitle == %@",button.currentTitle);

    button.selected = !button.selected;
    switch (button.tag) {
        case 301:
        {
            WX_ShootingScriptViewController *scriptVC = [[WX_ShootingScriptViewController alloc]init];
            [self.navigationController pushViewController:scriptVC animated:YES];
        }
            break;
        case 302:
        {  WX_MovieCViewController *movieVC = [[WX_MovieCViewController alloc]init];
            QNWSLog(@"self.navigationController  ==  %@",self.navigationController);
            [self.navigationController pushViewController:movieVC animated:YES];
        }
            break;
        case 303:
        {
            
            WX_ShootCViewController *shootVC = [[WX_ShootCViewController alloc]init];
            [self.navigationController pushViewController:shootVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ----- 动画代理
-(void)animationDidStart:(CAAnimation *)anim
{
    QNWSLog(@"%@--动画开始", [self class]);
    
    // 退出动画时 隐藏文字
    if (!self.isClickButton) {
        _animationCount++;
        [self setButtonAnimationStartOrFinish:NO];
    }


}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    QNWSLog(@"%@---动画结束", [self class]);

    if (self.isClickButton) {
        self.scriptBtn.transform = CGAffineTransformIdentity;
        self.createBtn.transform = CGAffineTransformIdentity;
        self.shootBtn.transform = CGAffineTransformIdentity;
        _animationCount++;
        

        [self setButtonAnimationStartOrFinish:YES];
    }else {
        
        [self.scriptBtn removeFromSuperview];
        self.scriptBtn = nil;
        [self.createBtn removeFromSuperview];
        self.createBtn = nil;
        [self.shootBtn removeFromSuperview];
        self.shootBtn = nil;
        
        _backGView.frame = CGRectMake(-10000, -10000, 0, 0);
        [self.view addSubview:_backGView];
        [self.cameraButton setHidden:YES];
    }
}


-(void)setButtonAnimationStartOrFinish:(BOOL)isStart
{
    switch (_animationCount) {
        case 1:
        {
            self.scriptBtn.titleLabel.alpha = isStart;
        }
            break;
        case 2:
        {
            
            self.shootBtn.titleLabel.alpha = isStart;
        }
            break;
        case 3:
        {
            
            self.createBtn.titleLabel.alpha = isStart;
            /// 全部完成后, 重置计数器
            _animationCount = 0;

        }
            break;
            
        default:
            break;
    }
}




// 创建通知中心
-(void)createNotification
{
    
    [QNWSNotificationCenter addObserver:self selector:@selector(notice:) name:@"hiddenTheButton" object:nil];
}

-(void)notice:(NSNotification *)object
{
    NSLog(@"sender == %@",object.userInfo);
    

    if ([object.userInfo isEqualToDictionary:@{@"1":@"1"}]) {
        [self.cameraButton setHidden:YES];
        [self.cameraBtn setHidden:YES];
        [self.cameraBtn removeFromSuperview];
    }else if ([object.userInfo isEqualToDictionary:@{@"2":@"2"}]){
        
        [self.cameraBtn setHidden:NO];
        [self.cameraButton setHidden:YES];

    }
    
}

#endif

// 退出视图前,清除画布

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.isClickButton = 0;
    
    [self createBackgroundViewWithType:0];
    [self.cameraBtn setHidden:YES];
    
    [self setButtonSelectedIsNo];

}

@end
