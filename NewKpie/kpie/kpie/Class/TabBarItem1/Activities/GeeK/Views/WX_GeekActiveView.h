//
//  WX_GeekActiveView.h
//  kpie
//
//  Created by 王傲擎 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WX_GeekModel.h"
#import "BYC_InStepCollectionViewCellModel.h"

@interface WX_GeekActiveView : UIView

+(void)showGeekActiveViewAddToView:(UIView*)view withViewController:(UIViewController*)controller InStepModel:(BYC_InStepCollectionViewCellModel*)model_InStep ;      /**<   展示活动页面 */

+(void)setGeekActiveViewValueWith:(WX_GeekModel*)model_Geek;    /**<   给页面设置值 */

+(void)removeSuperviews;    /**<   移除视图 */
@end
