//
//  BYC_PlaceHolderView.m
//  kpie
//
//  Created by 元朝 on 16/5/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_PlaceHolderView.h"

@interface BYC_PlaceHolderView()

/**提示字符*/
@property (nonatomic, copy)  NSString  *promptText;

@end

@implementation BYC_PlaceHolderView

- (instancetype)initWithPromptText:(NSString *)promptText frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _promptText = promptText;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {

    UILabel *label = [[UILabel alloc] init];
    label.text = _promptText.length == 0 ? @"暂无数据" : _promptText;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = KUIColorFromRGB(0X828E9A);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {

        make.leading.trailing.equalTo(label.superview).insets(UIEdgeInsetsMake(0, 50, 0, 50));
        make.centerY.equalTo(label.superview);
    }];
}
@end
