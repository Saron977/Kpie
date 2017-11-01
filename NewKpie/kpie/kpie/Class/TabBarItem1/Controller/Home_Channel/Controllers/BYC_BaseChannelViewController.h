//
//  BYC_BaseChannelViewController.h
//  kpie
//
//  Created by 元朝 on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseViewController.h"
#import "BYC_BaseChannelModels.h"
#import "BYC_BaseChannelDataModel.h"
#import "BYC_BaseChannelColumnModel.h"

@interface BYC_BaseChannelViewController : BYC_BaseViewController

-(void)setModels_BaseChannel:(BYC_BaseChannelModels *)models_BaseChannel index:(NSUInteger)index;
@end
