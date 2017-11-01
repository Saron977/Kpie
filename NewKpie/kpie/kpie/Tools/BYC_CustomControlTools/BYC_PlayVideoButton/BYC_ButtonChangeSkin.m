//
//  BYC_ButtonChangeSkin.m
//  kpie
//
//  Created by 元朝 on 16/2/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ButtonChangeSkin.h"
#import "BYC_ImageChangeSkin.h"

@interface BYC_ButtonChangeSkin()

@property (nonatomic, copy)  NSString *string_ImageNameNormal;
@property (nonatomic, copy)  NSString *string_ImageNameHighlighted;
@property (nonatomic, copy)  NSString *string_BackgroundImageNameNormal;
@property (nonatomic, copy)  NSString *string_BackgroundImageNameHighlighted;
@end
@implementation BYC_ButtonChangeSkin


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [QNWSNotificationCenter addObserver:self selector:@selector(reloadImage) name:KNotification_ReloadImage object:nil];
    }
    return self;
}

-(void)setImageDic:(NSDictionary *)imageDic forState:(UIControlState)state {

    if (state == UIControlStateNormal) _string_ImageNameNormal = imageDic[@"ImageName"];
    if (state == UIControlStateHighlighted) _string_ImageNameHighlighted = imageDic[@"ImageName"];
    [self setImage:imageDic[@"Image"] forState:state];

}
-(void)setBackgroundImageDic:(NSDictionary *)backgroundImageDic forState:(UIControlState)state {
    
    if (state == UIControlStateNormal) _string_BackgroundImageNameNormal = backgroundImageDic[@"ImageName"];
    if (state == UIControlStateHighlighted) _string_BackgroundImageNameHighlighted = backgroundImageDic[@"ImageName"];
    [self setBackgroundImage:backgroundImageDic[@"Image"] forState:state];
    
}

- (void)reloadImage {

    if (_string_ImageNameNormal.length > 0 && _string_ImageNameNormal != nil) {

        NSDictionary *dicNormal = @{@"ImageName":_string_ImageNameNormal,@"Image":[BYC_ImageChangeSkin getImageNamed:_string_ImageNameNormal]};
        [self setImageDic:dicNormal forState:UIControlStateNormal];
    }
    if (_string_ImageNameHighlighted.length > 0 && _string_ImageNameHighlighted != nil) {

        NSDictionary *dicHighlighted = @{@"ImageName":_string_ImageNameHighlighted,@"Image":[BYC_ImageChangeSkin getImageNamed:_string_ImageNameHighlighted]};
        [self setImageDic:dicHighlighted forState:UIControlStateNormal];
    }
    
    if (_string_BackgroundImageNameNormal.length > 0 && _string_BackgroundImageNameNormal != nil) {
        
        NSDictionary *dicBacNormal = @{@"ImageName":_string_BackgroundImageNameNormal,@"Image":[BYC_ImageChangeSkin getImageNamed:_string_BackgroundImageNameNormal]};
        [self setBackgroundImageDic:dicBacNormal forState:UIControlStateNormal];
    }
    
    if (_string_BackgroundImageNameHighlighted.length > 0 && _string_BackgroundImageNameHighlighted != nil) {
        
        NSDictionary *dicBacNormal = @{@"ImageName":_string_BackgroundImageNameHighlighted,@"Image":[BYC_ImageChangeSkin getImageNamed:_string_BackgroundImageNameHighlighted]};
        [self setBackgroundImageDic:dicBacNormal forState:UIControlStateNormal];
    }
}

-(void)dealloc {

    [QNWSNotificationCenter removeObserver:self];
}

@end
