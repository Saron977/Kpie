//
//  WX_SphereMenu.h
//  底部视频点击按钮 Demo
//
//  Created by 王傲擎 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SphereMenuDelegate <NSObject>

- (void)sphereDidSelected:(int)index;

@end
@interface WX_SphereMenu : UIView

- (instancetype)initWithStartPoint:(CGPoint)startPoint
                        startImage:(UIImage *)startImage
                     submenuImages:(NSArray *)images;

@property (nonatomic, weak) id<SphereMenuDelegate> delegate;

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat sphereDamping;
@property (nonatomic, assign) CGFloat sphereLength;
@end
