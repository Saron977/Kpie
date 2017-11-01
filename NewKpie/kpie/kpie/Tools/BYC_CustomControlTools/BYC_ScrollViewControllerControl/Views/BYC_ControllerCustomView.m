//
//  BYC_ControllerCustomView.h
//  kpie
//
//  Created by 元朝 on 16/7/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ControllerCustomView.h"

@interface BYC_ControllerCustomView ()

/***/
@property (nonatomic, strong)  id  object_Notification;
@property (nonatomic, strong)  UIButton  *button;

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation BYC_ControllerCustomView

- (instancetype)initWithFrame:(CGRect)frame andNotificationObject:(id)object
{
    self = [super initWithFrame:frame];
    if (self) {
        _object_Notification = object;
        [self initSubViews];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initSubViews {
    
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {(void)make.top.leading.bottom.trailing;}];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction)];
    [self addGestureRecognizer:tap];
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    _imageView.image = [UIImage imageNamed:_imageUrl];
    
}
- (void)buttonAction {

    [QNWSNotificationCenter postNotificationName:@"" object:_object_Notification];
}

@end
