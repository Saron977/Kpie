//
//  BYC_JumpToVCHandler.h
//  kpie
//
//  Created by 元朝 on 16/8/3.
//  Copyright © 2016年 QNWS. All rights reserved.
//


#import "BYC_JumpToVCHandler.h"
#import "BYC_MainNavigationController.h"
#import "BYC_HTML5ViewController.h"
#import "BYC_MTColumnViewcontroller.h"

@interface BYC_JumpToVCHandler ()

@end

@implementation BYC_JumpToVCHandler

+ (void)jumpToWebWithUrl:(NSString *)url {
    
    @try {
        
        BYC_HTML5ViewController *vc = [[BYC_HTML5ViewController alloc] initWithHTML5String:url];
        vc.hidesBottomBarWhenPushed = YES;
        [KMainNavigationVC pushViewController:vc animated:YES]; 
    } @catch (NSException *exception) {
        QNWSShowException(exception);
    }
}

+(void)jumpToColumnWithColumnId:(NSString *)columnId{
   
    @try {
        BYC_MTColumnViewcontroller * vc = [[BYC_MTColumnViewcontroller alloc]init];
        vc.columnID = columnId;
        vc.hidesBottomBarWhenPushed = YES;
        [KMainNavigationVC pushViewController:vc animated:YES];
    } @catch (NSException *exception) {
        QNWSShowException(exception);
    }

}

@end
