//
//  BYC_HomeViewCntrollerModel.h
//  kpie
//
//  Created by 元朝 on 15/11/2.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseVideoModel.h"

@interface BYC_HomeViewControllerModel : BYC_BaseVideoModel

@property (nonatomic, assign  ) BOOL      isLike;//(0未喜欢1已喜欢)
@property (nonatomic, copy    ) NSString  *media_Parameter;// 合拍合成参数
@property (nonatomic, assign  ) NSInteger templets;// 合拍制作数量

@end
