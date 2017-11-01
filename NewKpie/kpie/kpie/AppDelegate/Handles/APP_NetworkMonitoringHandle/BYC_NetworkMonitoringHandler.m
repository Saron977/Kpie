//
//  BYC_NetworkMonitoringHandler.m
//  kpie
//
//  Created by 元朝 on 16/8/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_NetworkMonitoringHandler.h"
#import "Reachability.h"
#import "BYC_NetworkMonitoringView.h"

static BYC_NetworkMonitoringHandler *mySelf;

@interface BYC_NetworkMonitoringHandler()

@property (nonatomic, strong) Reachability *conn;

@end

@implementation BYC_NetworkMonitoringHandler

+ (void)networkMonitoringHandler {

    mySelf = [[BYC_NetworkMonitoringHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:mySelf selector:@selector(checkNetworkState) name:kReachabilityChangedNotification object:nil];
    mySelf.conn = [Reachability reachabilityForInternetConnection];
    [mySelf.conn startNotifier];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mySelf checkNetworkState];
    });
}

- (void)checkNetworkState
{
    // 2.检测手机是否能上网络(WIFI\移动网络)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status = [conn currentReachabilityStatus];
    *KNetwork_Type = (ENUM_NETWORK_TYPE)status;
    NSString *str_NetWorkStatus;
    switch (status) {
        case NotReachable:
            str_NetWorkStatus = @"您已断开网络连接";
            break;
        case ReachableViaWiFi:
            str_NetWorkStatus = @"您已接入WiFi网络环境";
            break;
        case ReachableViaWWAN:
            str_NetWorkStatus = @"您已接入移动网络环境";
            break;
            
        default:
            break;
    }
    
    [BYC_NetworkMonitoringView networkMonitoringViewWith:str_NetWorkStatus];
}
@end
