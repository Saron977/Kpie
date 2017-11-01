//
//  BYC_TabBar.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_TabBar.h"
#import "BYC_TabBarButton.h"
#import "WX_SphereMenu.h"
#import "BYC_LoginAndRigesterView.h"
#import "BYC_AccountTool.h"
#import "BYC_ImageChangeSkin.h"
#import "BYC_ButtonChangeSkin.h"
#import "UIView+BYC_Tools.h"
#import "BYC_MainTabBarController.h"

@interface BYC_TabBar()

@property (nonatomic, weak) BYC_ButtonChangeSkin *cameraButton;

@property (nonatomic, strong) NSMutableArray <BYC_TabBarButton *> *itemButtons;

@property (nonatomic, weak) BYC_ButtonChangeSkin *selectedButton;

@end

@implementation BYC_TabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initParam];
        self.backgroundColor = KUIColorWordsBlack1;
    }
    return self;
}


- (void)initParam {

    [QNWSNotificationCenter addObserver:self selector:@selector(reloadImage) name:KNotification_ReloadImage object:nil];
    
    //毛玻璃滤镜
    //        [self setBlurEffectWithStyle:UIBlurEffectStyleDark];
    QNWSWeakSelf(self);
    [KMainTabBarVC rac_observeKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        BYC_ButtonChangeSkin *button = weakself.itemButtons[[value intValue]];
        weakself.selectedButton.selected = NO;
        button.selected = YES;
        weakself.selectedButton = button;
    }];
}

-(NSMutableArray<BYC_TabBarButton *> *)itemButtons {

    if (_itemButtons == nil) {
        
        _itemButtons = [NSMutableArray array];
       
    }
    
    return _itemButtons;
}

//更新皮肤
- (void)reloadImage {

        _itemButtons[0].item.image = [BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_sy_n"];
        _itemButtons[0].item.selectedImage = [BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_sy_h"];
        _itemButtons[1].item.image = [BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_dt_n"];
        _itemButtons[1].item.selectedImage = [BYC_ImageChangeSkin getImageNamed:@"home_tab_btn_dt_h"];
}

-(void)setItems:(NSArray *)items {

    _items = items;
    
    for (UITabBarItem *item in _items) {
        
        BYC_TabBarButton *btn = [BYC_TabBarButton buttonWithType:UIButtonTypeCustom];
        [self.itemButtons addObject:btn];
        
        btn.item = item;
        btn.tag = self.itemButtons.count - 1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        if (btn.tag == 0) {
            KMainTabBarVC.selectedIndex = 0;
            btn.selected = YES;
            self.selectedButton = btn;
        }
        if (btn.tag == 2 || btn.tag == 3) btn.isCheckLogin = YES;
        [self addSubview:btn];
    }
}



- (void)btnClick:(BYC_TabBarButton *)button {

    KMainTabBarVC.selectedIndex = button.tag;
}

- (UIButton *)cameraButton{
    
    if (_cameraButton == nil) {
  
        BYC_ButtonChangeSkin *btn = [BYC_ButtonChangeSkin buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:@"home_tab_btn_gn_n"] forState:UIControlStateNormal];
        [btn setBackgroundImageDic:[BYC_ImageChangeSkin getDicImageNamed:@"home_tab_btn_gn_h"] forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, 0, 55, 55);
        btn.isCheckLogin = YES;
        
        [btn addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _cameraButton = btn;
        [self addSubview:_cameraButton];
        
    }
    return _cameraButton;
}


// 点击加号按钮的时候调用
- (void)cameraButtonClick
{
    [QNWSNotificationCenter postNotificationName:@"fmVideoPlayer" object:nil];
    
    if ([_delegate respondsToSelector:@selector(tabBarDidClickCameraButton:)]) {
        [_delegate tabBarDidClickCameraButton:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / (self.items.count + 1);
    CGFloat btnH = self.bounds.size.height;
    
    
    int i = 0;
    for (UIView *tabBarButton in self.itemButtons) {
        if (i == 2) {
            i = 3;
        }
        btnX = i * btnW;
        tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
        i++;
    }
    self.cameraButton.center = CGPointMake(w * 0.5, h  - self.cameraButton.bounds.size.height / 2);
    self.cameraButton.tag = 101;
    
}
@end
