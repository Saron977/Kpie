//
//  BYC_ImageFromColor.h
//  kpie
//
//  Created by 元朝 on 15/11/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_ImageFromColor : NSObject

+ (UIImage *)imageFromColor:(UIColor *)color withImageFrame:(CGRect)frame;
@end
