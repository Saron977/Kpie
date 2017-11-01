//
//  BYC_TabBarItemNavigationBar.m
//  kpie
//
//  Created by 元朝 on 16/7/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_TabBarItemNavigationBar.h"
#import "BYC_SegmentSwitch.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_SearchViewController.h"


#define tabBarItemNavigationBarFrame CGRectMake(0, 0, screenWidth, KHeightNavigationBar)

@interface BYC_TabBarItemNavigationBar ()<BYC_SegmentSwitchDelegate>

@property (nonatomic, strong)  BYC_SegmentSwitch *segmentSwitch;

@end

@implementation BYC_TabBarItemNavigationBar

+ (instancetype)initTabBarItemNavigationBarWithItems:(NSArray <NSString *> *)items {
    
    BYC_TabBarItemNavigationBar *tabBarItemNavigationBar = [[BYC_TabBarItemNavigationBar alloc] initWithFrame:tabBarItemNavigationBarFrame];
    tabBarItemNavigationBar.arr_Items = items;
    tabBarItemNavigationBar.backgroundColor = KUIColorBaseGreenNormal;
    [tabBarItemNavigationBar initSubViews];
    return tabBarItemNavigationBar;
}

-(void)setArr_Items:(NSArray<NSString *> *)arr_Items {

    _arr_Items = arr_Items;
    [self initSubViews];
}

- (void)initSubViews {

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initTitleViews];
    [self initrightButton];
}

- (void)initTitleViews {

    _segmentSwitch = [[BYC_SegmentSwitch alloc] initWithConfigureItems:_arr_Items];
    _segmentSwitch.delegate = self;
    [self addSubview:_segmentSwitch];
}
- (void)initrightButton {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10, KHeightStateBar + (44 - 32) / 2 , 32, 32);
    [self addSubview:rightButton];
    rightButton.tag = 101;
    [rightButton setImage:[UIImage imageNamed:@"home_btn_search_n"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"home_btn_search_h"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        (void)make.bottom.trailing;
        make.width.height.offset(48);
    }];
}

 - (void)searchAction {
 
     BYC_SearchViewController *searchVC = [[BYC_SearchViewController alloc] init];
     [[self getBGViewController].navigationController pushViewController:searchVC animated:YES];
 }

-(void)setFloat_Progress:(CGFloat)float_Progress {
    
    _float_Progress = float_Progress;
    _segmentSwitch.float_Progress = _float_Progress;
}

#pragma mark - BYC_SegmentSwitchDelegate

- (void)segmentSwitch:(BYC_SegmentSwitch *)segmentSwitch didSelectItemAtIndexPath:(int)index {

    if (_delegate && [_delegate respondsToSelector:@selector(tabBarItemNavigationBar:didSelectItemAtIndexPath:)])
        [_delegate tabBarItemNavigationBar:self didSelectItemAtIndexPath:index];
}
@end
