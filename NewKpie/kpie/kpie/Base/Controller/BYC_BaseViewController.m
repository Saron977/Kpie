//
//  BYC_BaseViewController.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_LeftViewController.h"
#import "BYC_SetBackgroundColor.h"
#import "UMMobClick/MobClick.h"

@interface BYC_BaseViewController ()

@end

@implementation BYC_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KUIColorBackground;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    if (![self isMemberOfClass:[BYC_LeftViewController class]])
//        [[BYC_SetBackgroundColor alloc] setBackgroundViewColor:self];
}

//友盟统计成对存在
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(void)setContectText:(NSString *)contectText {
    
    for (id object in _baseMaskView.subviews) {
        
        if ([object isMemberOfClass:[UILabel class]]) {
            
            ((UILabel *)object).text = contectText;
            _contectText = contectText;
        }
    }
}

- (UIView *)createMaskViewInViewMore:(UIView *)centerView content:(NSString *)text{
    
    return  [self maskViewInView:centerView content:text];
}

- (UIView *)maskViewInView:(UIView *)centerView content:(NSString *)text {
    
    UIView *view_Mask = [[UIView alloc] initWithFrame:centerView.bounds];
    view_Mask.backgroundColor = [UIColor clearColor];
    int i = ((int)(centerView.left / centerView.kwidth));
    
    CGFloat labelW = view_Mask.kwidth - 100;
    CGFloat labelH = 150;
    CGFloat labelX = view_Mask.left - view_Mask.kwidth * i + (view_Mask.kwidth - labelW) / 2.0f;
    CGFloat labelY = (view_Mask.bottom - labelH) / 2.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = KUIColorFromRGB(0x9BA0AA);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = text;
    [view_Mask addSubview:label];
    view_Mask.userInteractionEnabled = NO;
    return view_Mask;
    
}


- (void)dealloc {
    
    QNWSLog(@"%@类  死了",[self class]);
    @try {
        
        [QNWSNotificationCenter removeObserver:self];
    } @catch (NSException *exception) {
        QNWSShowException(exception);
    }
}



@end
