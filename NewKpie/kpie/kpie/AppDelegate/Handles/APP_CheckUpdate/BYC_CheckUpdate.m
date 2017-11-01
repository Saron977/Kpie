//
//  BYC_CheckUpdate.m
//  kpie
//
//  Created by 元朝 on 2016/10/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_CheckUpdate.h"

static  NSString  * const S_AppStoreUrl = @"https://itunes.apple.com/cn/lookup?id=1066108130";
static  NSString  * const S_AppStoreDownloadUrl = @"https://itunes.apple.com/cn/app/kan-pai-bian-ji-zhi-zuo-gao/id1066108130?mt=8";
static  NSString  * const S_IgnoreUpdate  = @"ignoreUpdate";

@implementation BYC_CheckUpdate

+ (void)checkUpdate {
    
    if ([QNWSUserDefaultsValueForKey(S_IgnoreUpdate) intValue] == 3) return;
    
    __block NSError *error;
    NSURL *url = [NSURL URLWithString:S_AppStoreUrl];
    __block NSString *str_JsonResponse;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        str_JsonResponse =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (error != nil) {
            QNWSLog(@"更新检查错误: %@", error)
            return;
        }else dispatch_async(dispatch_get_main_queue(), ^{[self exeDecoding:str_JsonResponse];});
    });
}

+ (void)exeDecoding:(NSString *)jsonResponseString {

    if (jsonResponseString != nil) {
        //解析json数据为数据字典
        NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *itunesResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!error) [self executeUpdate:itunesResponse];
    }
}

+ (void)executeUpdate:(NSDictionary *)itunesResponse {
    NSString *str_NewVersion;
    NSString *str_ReleaseNotes;
    
    NSArray *configData = [itunesResponse valueForKey:@"results"];
    for(id config in configData) {
        //从数据字典中检出版本号数据及更新记录
        str_NewVersion = [config valueForKey:@"version"];
        str_ReleaseNotes = [config objectForKey:@"releaseNotes"];
    }

    NSDictionary *dic_APPInfo = @{@"version":str_NewVersion,@"releaseNotes":str_ReleaseNotes};
    NSString *str_BundleShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if ([str_NewVersion compare:str_BundleShortVersion options:NSNumericSearch] == NSOrderedDescending) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self appUpdateWithAlert:dic_APPInfo];
        });
    }
}

+ (void)appUpdateWithAlert:(NSDictionary *)objectData {
    NSString *str_ReleaseNotes = objectData[@"releaseNotes"];
    NSString *str_NewVersion = objectData[@"version"];
    
    NSNumber *num =  QNWSUserDefaultsValueForKey(S_IgnoreUpdate);
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"检测到最新版本%@",str_NewVersion]
                               message:str_ReleaseNotes
                              delegate:self
                      cancelButtonTitle:[num intValue] == 2 ? @"忽略更新" : @"稍后更新" otherButtonTitles:@"立即更新", nil] show];
}

+ (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if (QNWS_CurrentDeviceSystemVersion >= 10.0)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:S_AppStoreDownloadUrl] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
        else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:S_AppStoreDownloadUrl]];
        
    }
    
    NSNumber *num =  QNWSUserDefaultsValueForKey(S_IgnoreUpdate);
    int value;
    if (num) {
        value = [num intValue];
        value++;
    }else value = 1;
    
    QNWSUserDefaultsSetValueForKey(@(value), S_IgnoreUpdate);
}

@end
