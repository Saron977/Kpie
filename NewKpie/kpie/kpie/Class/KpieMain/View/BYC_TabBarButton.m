//
//  BYC_TabBarButton.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_TabBarButton.h"

#define ImageRidio 0.7

@implementation BYC_TabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.imageView.contentMode = UIViewContentModeCenter;
        [self setupRegisterNotification];
        
    }
    return self;
}

 - (void)setupRegisterNotification {
 
     [QNWSNotificationCenter addObserverForName:KNotification_ShowTabBarButtonRed object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
         
         if (self.tag == [note.userInfo[@"tag"] integerValue]) {
             
             UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.kwidth * .55f, 5, 10, 10)];
             view.tag = 10011;
             view.backgroundColor = [UIColor redColor];
             [self addSubview:view];
             view.layer.cornerRadius = view.kwidth / 2.0f;
         }
     }];

     
     [QNWSNotificationCenter addObserverForName:KNotification_HideTabBarButtonRed object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
     
         [self exeRemoveRedPoint:[note.userInfo[@"tag"] integerValue]];//莫名其妙各种摸不着头脑的BUG,调用了移除不了红点。
     }];
 }
// 传递UITabBarItem给tabBarButton,给tabBarButton内容赋值
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    [self setImage:_item.image forState:UIControlStateNormal];
    [self setImage:_item.selectedImage forState:UIControlStateSelected];

}

-(void)setHighlighted:(BOOL)highlighted {

    [super setHighlighted:highlighted];
    
    [self exeRemoveRedPoint:self.tag];
}

- (void)exeRemoveRedPoint:(NSInteger)tag {

    if (self.tag == tag) {
        
        NSInteger count = self.subviews.count;
        for (int i = 0; i < count; i++) {
            
            UIView *suView = self.subviews[i];
            if ([suView isMemberOfClass:[UILabel class]] || [suView isMemberOfClass:[UIImageView class]]) {
                continue;
            }
            [suView removeFromSuperview];//移除小红点
            suView = nil;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height;
    CGFloat imageX = 0;
    CGFloat imageY = (self.frame.size.height - imageH) / 2;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
}
@end
