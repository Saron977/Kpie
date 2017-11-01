//
//  BYC_HistoryCollectionReusableView.m
//  kpie
//
//  Created by 元朝 on 16/5/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HistoryCollectionReusableView.h"
#import "BYC_HistoryKeywordsHandel.h"

@interface BYC_HistoryCollectionReusableView()

/**左边标题label*/
@property (nonatomic, strong)  UILabel   *label_Left;
/**右边标题button*/
@property (nonatomic, strong)  UIButton  *button_right;

@end

@implementation BYC_HistoryCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {

    _label_Left = ({
    
        UILabel *label = [[UILabel alloc] init];
        label.text = @"----";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = KUIColorFromRGB(0X87A4C9);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.equalTo(label.superview).insets(UIEdgeInsetsMake(0, 20, 5, 0));
        }];
        label;
    });
    
    _button_right = ({
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"清空记录" forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:KUIColorFromRGB(0X87A4C9) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.trailing.bottom.equalTo(button.superview).insets(UIEdgeInsetsMake(0, 0, 5, 20));
        }];
        
        button;
    });
}

#pragma mark - set方法
-(void)setDic_Data:(NSDictionary *)dic_Data {

    _dic_Data = dic_Data;
    _label_Left.text = dic_Data[@"title"];
    _button_right.hidden = [dic_Data[@"isHidden"] boolValue];
}

- (void)buttonAction {

    if (self.clearRecodBlock) _clearRecodBlock();
    //清除历史关键词搜索
    [BYC_HistoryKeywordsHandel clearHistoryKeyword];
}
@end
