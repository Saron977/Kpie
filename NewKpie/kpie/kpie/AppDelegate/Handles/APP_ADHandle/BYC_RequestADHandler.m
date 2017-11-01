//
//  BYC_RequestADHandler.m
//  kpie
//
//  Created by 元朝 on 16/8/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_RequestADHandler.h"
#import "BYC_PropertyManager.h"
#import "NSDictionary+BYC_NullChangeNilWithDic.h"

NSInteger CountdownTime = 5;
typedef void(^BlockOpenApp)();

@interface BYC_RequestADHandler() {

    NSTimer *_timer_ShowAD;//广告倒计时
    NSData *_data;//图片数据
}

/***/
@property (nonatomic, strong)  BlockOpenApp  block;

@end

@implementation BYC_RequestADHandler

+ (instancetype)requestADHandlerWithBlock:(void(^)())block {

    BYC_RequestADHandler *mySelf = [BYC_RequestADHandler new];
    mySelf.block = block;
    [mySelf requstAD:nil];
    return mySelf;
}

- (void)requstAD:(NSString *)toDayString {
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//同步请求广告
        
        
        NSString *stringIP = [QNWS_Main_HostIP copy];
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",stringIP ? stringIP : KQNWS_KPIE_MAIN_URL ,KQNWS_GetListAdvertUrl];
        NSURL *url = [NSURL URLWithString:urlstr];
        NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
        urlrequest.HTTPMethod = @"GET";
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
        requestOperation.securityPolicy = [AFSecurityPolicy defaultPolicy];
        requestOperation.shouldUseCredentialStorage = YES;
        [requestOperation setValue:@3 forKeyPath:@"request.timeoutInterval"];
        [requestOperation start];
        [requestOperation waitUntilFinished];
        NSDictionary *respondDataDic = [NSDictionary changeType:(NSDictionary *)[requestOperation.responseSerializer responseObjectForResponse:requestOperation.response data:requestOperation.responseData error:nil]];
        _model_AD = [BYC_ADModel initModelWithDictionary:respondDataDic[@"data"]];

    });
    
    
    if (!_model_AD || _model_AD.advertList1.count == 0) {
        //打开APP
        QNWSBlockSafe(_block,nil);
        return;
    }
    
    NSString *whetherTodayFirst = QNWSUserDefaultsObjectForKey(KSTR_KRecordADID);
    if (_model_AD.advertList1.count > 0) {
        if (![whetherTodayFirst isEqualToString:_model_AD.advertList1[0].advertid]) {
            
            QNWSUserDefaultsSetObjectForKey(_model_AD.advertList1[0].advertid, KSTR_KRecordADID);
            QNWSUserDefaultsSetObjectForKey(@(_model_AD.advertList1[0].opens), KSTR_KRecordADRequestTimes);
            QNWSUserDefaultsSynchronize;
        }
    }
    NSInteger count = [QNWSUserDefaultsObjectForKey(KSTR_KRecordADRequestTimes) integerValue];
    if (count <= 0) {
    
        QNWSBlockSafe(_block,_model_AD);
        return;
    }
    
    
    if (_model_AD.advertList1.count > 0) {
        
        //展示广告
        [self showAD];
        --count;//次数-1操作
        QNWSUserDefaultsSetObjectForKey(@(count), KSTR_KRecordADRequestTimes);
    }else QNWSBlockSafe(_block,_model_AD);
}

- (void)showAD {
    
    UIView *view_background        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth , screenHeight)];
    view_background.tag            = 1000;
    view_background.center         = KQNWS_KeyWindow.center;
    UIImageView *imageAD           = [[UIImageView alloc] initWithFrame:view_background.bounds];
    imageAD.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpADAction:)];
    [imageAD addGestureRecognizer:tap];
    
    UIView *view_Close             = [[UIView alloc] initWithFrame:CGRectMake(view_background.kwidth - 60 - 20 , 20, 60, 60)];
    view_Close.backgroundColor     = KUIColorFromRGBA(0xFFFFFF, .6);
    view_Close.layer.cornerRadius  = 30;
    view_Close.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap_Close = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeADAction:)];
    [view_Close addGestureRecognizer:tap_Close];
    UILabel *label_Close      = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, view_Close.kwidth, view_Close.kheight / 2.0 - 10)];
    label_Close.text          = @"关闭";
    label_Close.textAlignment = NSTextAlignmentCenter;
    label_Close.textColor     = KUIColorFromRGBA(0x000000, .5);
    
    UILabel *label_Time = [[UILabel alloc] initWithFrame:CGRectMake(0, view_Close.kheight / 2.0, view_Close.kwidth, view_Close.kheight / 2.0 - 10)];
    label_Time.text          = [NSString stringWithFormat:@"%ld s",(long)CountdownTime];
    label_Time.tag           = 1002;
    label_Time.textAlignment = NSTextAlignmentCenter;
    label_Time.textColor     = KUIColorFromRGBA(0x000000, .5);
    
    [view_Close addSubview:label_Close];
    [view_Close addSubview:label_Time];
    [view_background addSubview:imageAD];
    [view_background addSubview:view_Close];
    
    NSString *str_Image = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)_model_AD.advertList1[0].advertimg, NULL, NULL,  kCFStringEncodingUTF8 ));
    NSURL *url = [NSURL URLWithString:str_Image];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"GET";
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/png"];
    [requestOperation setValue:@1 forKeyPath:@"request.timeoutInterval"];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    _data = requestOperation.responseData;
    if (!_data) {
    
        QNWSBlockSafe(_block,_model_AD);
        [self closeADAction:nil];
        return;
    }
    imageAD.image = [UIImage imageWithData:_data];
    [KQNWS_KeyWindow addSubview:view_background];
    QNWSBlockSafe(_block,_model_AD);
    [KQNWS_KeyWindow bringSubviewToFront:view_background];
    
    _timer_ShowAD = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closeADAction:) userInfo:nil repeats:YES];
}

- (void)jumpADAction:(UITapGestureRecognizer *)tap {
    
    @try {
        
        [QNWSNotificationCenter postNotificationName:KNotification_NeedPushAD object: _model_AD];
        tap = nil;
        if (_timer_ShowAD) {
            
            [_timer_ShowAD invalidate];
        }
        [[KQNWS_KeyWindow viewWithTag:1000] removeFromSuperview];
    } @catch (NSException *exception) {
        QNWSShowException(exception);
    }
}

- (void)closeADAction:(id)object{
    
    if ([object isKindOfClass:[NSTimer class]]) {
        
        CountdownTime--;
        UILabel *label = (UILabel *)[KQNWS_KeyWindow viewWithTag:1002];
        label.text = [NSString stringWithFormat:@"%ld s",(long)CountdownTime];
        if (CountdownTime != 0)return;
    }
    
    if (_timer_ShowAD) {
        
        [_timer_ShowAD invalidate];
    }
    [[KQNWS_KeyWindow viewWithTag:1000] removeFromSuperview];
}


@end
