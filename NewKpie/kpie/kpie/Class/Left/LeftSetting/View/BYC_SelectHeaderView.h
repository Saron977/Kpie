//
//  BYC_SelectHeaderView.h
//  kpie
//
//  Created by 元朝 on 15/11/17.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_PersonalDataViewController.h"

typedef void(^returnImageDataBlock)(UIImage *image , NSData *data);

@interface BYC_SelectHeaderView : UIView

@property (nonatomic, strong)  returnImageDataBlock  returnImageDataBlock;
@property (nonatomic, weak)    BYC_PersonalDataViewController  *personalDataVC;;

//调用相机
- (void)selectCamera;

@end
