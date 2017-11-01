//
//  BYC_HomeBannnerHeader.h
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BYC_HomeBannnerHeader : UICollectionReusableView

@property (nonatomic, strong)  NSArray  *array_bannnerModels;

/**来自栏目*/
@property (nonatomic, assign)  BOOL  isFrmoColumn;
/**来自栏目*/
@property (nonatomic, assign)  CGFloat  bannerHeight;

+ (instancetype)getSelfObject;

@end
