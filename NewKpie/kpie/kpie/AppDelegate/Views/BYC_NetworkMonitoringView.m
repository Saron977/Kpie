//
//  BYC_NetworkMonitoringView.m
//  kpie
//
//  Created by 元朝 on 16/8/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_NetworkMonitoringView.h"
#import "NSString+BYC_Tools.h"

static  NSUInteger  key_SlefTag =  93;
static  NSUInteger  key_TitleFont =  12;
static  NSUInteger  key_SelfHeight =  20;
@interface BYC_NetworkMonitoringView()

@property (nonatomic, strong)  BYC_NetworkMonitoringView  *view_My;
/**提示文本*/
@property (nonatomic, copy)  NSString  *str_Title;

@end

@implementation BYC_NetworkMonitoringView

+ (void)networkMonitoringViewWith:(NSString *)title {

    CGSize  size = [title sizeWithfont:key_TitleFont boundingRectWithSize:CGSizeMake(MAXFLOAT, key_SelfHeight)];
    BYC_NetworkMonitoringView *my_Self = [[BYC_NetworkMonitoringView alloc] initWithFrame:CGRectMake((screenWidth - size.width - 20)/2, screenHeight - 80, size.width + 20 , key_SelfHeight)];
    my_Self.tag = key_SlefTag;
    my_Self.backgroundColor = [UIColor blackColor];
    my_Self.layer.cornerRadius = 3;
    my_Self.layer.masksToBounds = YES;
    my_Self.str_Title = title;
    [my_Self initSuviews];
}

- (void)initSuviews {

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:key_TitleFont];
    label.textColor = [UIColor whiteColor];
    label.text = _str_Title;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {(void)make.top.left.bottom.right;}];
    [self show];
}

- (void)show {

    if ([[[UIApplication sharedApplication].keyWindow viewWithTag:key_SlefTag] isKindOfClass:[self class]] )
        [[[UIApplication sharedApplication].keyWindow viewWithTag:key_SlefTag] removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

@end
