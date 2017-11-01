//
//  BYC_HomeVCAdvertisementHandler.m
//  kpie
//
//  Created by 元朝 on 16/7/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AdvertisementHandler.h"
#import "BYC_ADModel.h"
#import "WX_VoideDViewController.h"
#import "BYC_MainNavigationController.h"
#import "BYC_MTColumnViewcontroller.h"
#import "BYC_JumpToVCHandler.h"
#import "BYC_BannerControl.h"
#import "HL_JumpToVideoPlayVC.h"

static  NSArray <BYC_ADModel *> *_arrayAD;
static  BOOL _whetherOpenAD;
static  UIView *_view_background;
static  BOOL _whetherPushAD;

@implementation BYC_AdvertisementHandler


+ (void)handleOfAdvertisement {
    
    //弹广告通知
    [QNWSNotificationCenter addObserver:self selector:@selector(showAD:) name:KNotification_NeedShowAD object:nil];
    //push广告通知
    [QNWSNotificationCenter addObserver:self selector:@selector(pushAD:) name:KNotification_NeedPushAD object:nil];
}

+ (void)viewWillAppearShowAD {
    
    if (!_whetherOpenAD && _arrayAD.count > 0) {
        
        [self showAD:nil];
    }
}

+ (void)showAD:(NSNotification *)notification {
    
    if (notification) _arrayAD = notification.object;
    if (!_whetherPushAD) {
    
        
#warning 这里只对第一条数据进行次数判断，有时间在对所有数据进行判断。
        if (!_arrayAD || _arrayAD.count == 0) return;
        
        NSString *whetherTodayFirst = QNWSUserDefaultsObjectForKey(KSTR_KRecordADID2);
        
        if (![whetherTodayFirst isEqualToString:_arrayAD[0].advertid]) {
            
            QNWSUserDefaultsSetObjectForKey(_arrayAD[0].advertid, KSTR_KRecordADID2);
            QNWSUserDefaultsSetObjectForKey(@(_arrayAD[0].opens), KSTR_KRecordADRequestTimes2);
            QNWSUserDefaultsSynchronize;
        }
        
        NSInteger count = [QNWSUserDefaultsObjectForKey(KSTR_KRecordADRequestTimes2) integerValue];
        if (count <= 0) return;
        
        if (_arrayAD.count > 0) {
            
            //展示广告
            [self show];
            --count;//次数-1操作
            QNWSUserDefaultsSetObjectForKey(@(count), KSTR_KRecordADRequestTimes2);
        }
    }
}

+ (void)show {
    
    if (_arrayAD.count > 0) {
    
        _whetherOpenAD = YES;
        UIView *view_fullScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        view_fullScreen.tag = 9999;
        _view_background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidthOnTheBasisOfIPhone6SizeNONeed6P(258) , KHeightOnTheBasisOfIPhone6SizeNONeed6P(350))];
        [view_fullScreen addSubview:_view_background];
        _view_background.layer.cornerRadius = 10;
        _view_background.layer.masksToBounds = YES;
        
        [KQNWS_KeyWindow addSubview:view_fullScreen];
        _view_background.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0f, [UIScreen mainScreen].bounds.size.height / 2.0f);
        
        [self setupBannerControl];
        UIButton *button_closeView = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_closeView setImage:[UIImage imageNamed:@"icon-gb"] forState:UIControlStateNormal];
        button_closeView.frame = CGRectMake(_view_background.kwidth - 40 , 0, 40, 40);
        [button_closeView addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_view_background addSubview:button_closeView];
        
        _view_background.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:2 delay:1 usingSpringWithDamping:.5 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveLinear animations:^{
            
            _view_background.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }
}

+ (void)setupBannerControl {
    
    if (![_view_background viewWithTag:101]) {
        
        QNWSWeakSelf(self);
        BYC_BannerControl *control_Banner = [BYC_BannerControl bannerControlWithFrame:_view_background.bounds bannerControlModels:[self getImagesWithBannerModels] placeHolderImage:nil pageControlShowStyle:ENUM_PageControlShowStyleCenter tapCallBackBlock:^(NSInteger index) {
            
            [weakself openAD:_arrayAD[index]];
        }];
        
        control_Banner.tag = 101;
        [_view_background addSubview:control_Banner];
    }
}

+ (NSArray<BYC_BannerControlModel *> *)getImagesWithBannerModels {
    
    NSMutableArray *arr_Image = [NSMutableArray array];
    if (_arrayAD.count > 0) {//banner数据
        
        for (int i = 0; i < _arrayAD.count; i++) {
            
            BYC_BannerControlModel *model = [[BYC_BannerControlModel alloc] init];
            NSString *str_Image = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)_arrayAD[i].advertimg, NULL, NULL,  kCFStringEncodingUTF8 ));
            model.str_ImageUrl = str_Image;
            model.bannerControlShowStyle = _arrayAD[i].adverttype == 1 ? ENUM_BannerControlShowStyleVideo : ENUM_BannerControlShowStyleImage;
            [arr_Image addObject:model];
        }
    }
    return arr_Image;
}

//push全屏广告
+ (void)pushAD:(NSNotification *)notification {
    
    BYC_ADModel *model = notification.object;
    if (model.advertList2.count > 0)_arrayAD = model.advertList2;
    [self openAD:model.advertList1[0]];
    
}
+ (void)closeAction:(UIButton *)button{
    
    [[KQNWS_KeyWindow viewWithTag:9999] removeFromSuperview];
}

+ (void)openAD:(BYC_ADModel *)modelAD  {
    
    @try {
        
        _whetherPushAD = YES;
        switch (modelAD.adverttype) {/**广告类型：1 视频 2 栏目  3 网址*/
            case 1:
            {

                [HL_JumpToVideoPlayVC jumpToVCWithModel:modelAD.video andVideoTepy:modelAD.video.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
                
            }
            break;
            case 3:
                [BYC_JumpToVCHandler jumpToWebWithUrl:modelAD.adverturl];
            break;
            default://BYC~~~！20161223录数据可能会有误，后台说默认的话也跳栏目
                [BYC_JumpToVCHandler jumpToColumnWithColumnId:modelAD.adverturl];
            break;
        }
        
    [self closeAction:nil];
    } @catch (NSException *exception) {
        QNWSShowException(exception);
    }

}

@end
