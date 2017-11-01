//
//  BYC_TimerTools.m
//  kpie
//
//  Created by 元朝 on 16/4/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_TimerTools.h"

@implementation BYC_TimerTools

#pragma mark --创建定时器----

+(void)GCDTimerWithObject:(id)object
{
    UIButton   *button = (UIButton *)object;
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [button setTitle:@"重新获取" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [button setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
