//
//  BYC_MTColumnViewcontroller.h
//  kpie
//
//  Created by 元朝 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"

#import "BYC_OtherViewControllerModel.h"
#import "BYC_ADModel.h"
#import "BYC_BaseColumnViewController.h"
@interface BYC_MTColumnViewcontroller : BYC_BaseColumnViewController

@property (nonatomic, strong)  BYC_ADModel  *idModel;

@property (nonatomic, strong) NSString                       *columnID;

@property (nonatomic, strong) BYC_OtherViewControllerModel   *otherModel;

@end
