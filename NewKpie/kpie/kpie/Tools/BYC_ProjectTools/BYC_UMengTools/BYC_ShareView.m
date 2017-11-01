//
//  BYC_ShareView.m
//  kpie
//
//  Created by 元朝 on 15/11/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_ShareView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "BYC_BaseButton.h"

#define SELF_VIEW_HEIGHT    210
#define SHARE_VIEW_HEIGHT   111
#define CANCEL_VIEW_HEIGHT  49

NSString * const const_ShareResourceID       = @"ShareResourceID";
NSString * const const_ShareUserID           = @"ShareUserID";
NSString * const const_ShareResourceTitle    = @"ShareResourceTitle";
NSString * const const_ShareResourceImage    = @"ShareResourceImage";
NSString * const const_ShareKpieDownloadUrl  = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.kpie.android";
NSString const  *const_ShareActivityUrl      = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.kpie.android";
NSString const  *const_ShareActivityTitle    = @"看拍小活动";
NSString const  *const_ShareActivityContent  = @"精彩活动等着您。";
NSString const  *const_ShareActivityImageUrl = @"";


@interface BYC_ShareView() {

     BYC_ShareView *selfView;
     UITapGestureRecognizer *tap_RemoveShareView;
     UIView *view_Mask;
     id shareDelegateVC;
     BYC_ShareType _shareType;
     NSDictionary *_dic;
}

/**0微信 1朋友圈 2QQ 3新浪 4看拍*/
@property (nonatomic, strong)  NSMutableArray<UIView *> *button_platforms;;
@end

@implementation BYC_ShareView

- (void)showWithDelegateVC:(id)delegateVC shareContentOrMedia:(BYC_ShareType)shareType shareWithDic:(NSDictionary *)dic{
    
    _shareType = shareType;
    _dic = dic;
    shareDelegateVC = delegateVC;
    [self initViews];
}

- (void)initViews {

    if (!selfView) {
        NSArray *arrIcon = @[@"icon-wx-n",@"icon-pyqs-n",@"icon-qq-n",@"icon-wb-n"];
        NSArray *array_Title = @[@"微信好友",@"微信朋友圈",@"QQ",@"新浪微博"];
        
        selfView = [self initWithFrame:CGRectMake(0, screenHeight, screenWidth, SELF_VIEW_HEIGHT)];
        selfView.backgroundColor = KUIColorBaseGreenNormal;
        
        view_Mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        view_Mask.backgroundColor = KUIColorFromRGBA(0x202730, .2f);
        
        float float_Label_Title_Height = 20.0f;
        
        UILabel *label_Title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, screenWidth, float_Label_Title_Height)];
        label_Title.backgroundColor = [UIColor clearColor];
        label_Title.text            = @"分享";
        label_Title.textAlignment   = NSTextAlignmentCenter;
        label_Title.font            = [UIFont systemFontOfSize:17];
        label_Title.textColor       = KUIColorFromRGB(0xE5E5E5);
        
        UIView *view_Share = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label_Title.frame) + 15, screenWidth, SHARE_VIEW_HEIGHT)];
        view_Share.backgroundColor = [UIColor clearColor];
        
        UIView *view_Line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view_Share.frame), screenWidth, .5)];
        view_Line.backgroundColor = KUIColorBackgroundCuttingLine;
        
        
        BYC_BaseButton *button_Cancel = [BYC_BaseButton buttonWithType:UIButtonTypeCustom WithFrame:CGRectMake(0, 0, screenWidth, CANCEL_VIEW_HEIGHT)];
        button_Cancel.frame           = CGRectMake(0, CGRectGetMaxY(view_Line.frame), screenWidth, CANCEL_VIEW_HEIGHT);
        button_Cancel.backgroundColor = [UIColor clearColor];
        [button_Cancel setTitle:@"取消" forState:UIControlStateNormal];
        button_Cancel.titleLabel.font = [UIFont systemFontOfSize:18];
        [button_Cancel setTitleColor:KUIColorFromRGB(0xF1F1F1) forState:UIControlStateNormal];
        [button_Cancel addTarget:self action:@selector(disappearView) forControlEvents:UIControlEventTouchUpInside];
        
        [selfView addSubview:label_Title];
        [selfView addSubview:view_Share];
        [selfView addSubview:button_Cancel];
        [selfView addSubview:view_Line];
        [view_Mask addSubview:selfView];
        [KQNWS_KeyWindow addSubview:view_Mask];
        
        tap_RemoveShareView = [[UITapGestureRecognizer alloc] initWithTarget:selfView action:@selector(disappearView)];
        [view_Mask addGestureRecognizer:tap_RemoveShareView];
        
        
        CGFloat width = selfView.kwidth  / array_Title.count;
        
        for (int i = 0; i < array_Title.count; i++) {
            
            UIView *view_Container         = [[UIView alloc] initWithFrame:CGRectMake(i * width , 0, width, SHARE_VIEW_HEIGHT)];
            view_Container.backgroundColor = [UIColor clearColor];

            UIButton *button               = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:arrIcon[i]] forState:UIControlStateNormal];
            button.tag                     = i + 1;
            [button addTarget:selfView action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor         = [UIColor clearColor];
            [view_Container addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.centerX.equalTo(button.superview.mas_centerX).offset(0);
                make.top.equalTo(button.superview.mas_top).offset(0);
                make.width.offset(width);
                make.height.offset(CGRectGetHeight(view_Container.frame) - 45);
            }];
            
            UILabel *label        = [[UILabel alloc] initWithFrame:CGRectMake(0, SHARE_VIEW_HEIGHT - 20, CGRectGetWidth(view_Container.frame), 20)];
            label.text            = array_Title[i];
            label.font            = [UIFont systemFontOfSize:12];
            label.center          = CGPointMake(button.center.x, label.center.y);
            label.textColor       = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment   = NSTextAlignmentCenter;
            [view_Container addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(button.mas_centerX).offset(0);
                make.top.equalTo(button.mas_bottom).offset(0);
                make.width.offset(width);
                make.height.offset(20);
            }];
            
            
            [view_Share addSubview:view_Container];
            if (_button_platforms == nil)
                _button_platforms = [NSMutableArray array];
            [_button_platforms addObject:view_Container];
        }
    }
    
    [UIView animateWithDuration:.35 animations:^{
        
        selfView.top = screenHeight - SELF_VIEW_HEIGHT;
    }];
    
}

- (void)disappearView {
    
    [UIView animateWithDuration:.35 animations:^{
        
            selfView.top = screenHeight;
    } completion:^(BOOL finished) {
        
        [selfView removeFromSuperview];
        [view_Mask removeFromSuperview];
        [view_Mask removeGestureRecognizer:tap_RemoveShareView];
        selfView = nil;
        view_Mask = nil;
    }];
    
}

-(void)dealloc {
    
    QNWSLog(@"%@类 死了",[self class]);
}


- (void)buttonAction:(UIButton *)sender {
    
    [self disappearView];
    UMengShareToPlatform platform;
    id delegate;
    switch (sender.tag) {
        case 1:{
            
            platform = UMengShareToWechatSession;
            delegate = nil;
        }
            break;
        case 2:{
        
            platform = UMengShareToWechatTimeline;
            delegate = nil;
        }

            break;
        case 3:{
            
            platform = UMengShareToQQ;
            delegate = nil;
        }
            
            break;
        case 4:{
        
            platform = UMengShareToSina;
            delegate = shareDelegateVC;
        }
            
            break;
//        case 5:{
//        //转发到看拍
//            
//        }
//            break;
        default:
            platform = 0;
            delegate = nil;
            break;
    }

    NSString *url         = _shareType == BYC_ShareTypeActivity ? const_ShareActivityUrl : const_ShareKpieDownloadUrl;
    NSString *stringTitle = _shareType == BYC_ShareTypeActivity ? const_ShareActivityTitle : @"看拍kPie";

    switch (_shareType) {
        case BYC_ShareTypeText:
            [BYC_UMengShareTool shareTitle:stringTitle Content:KSTR_KUMengShareContent withImage:[UIImage imageNamed:@"shareIcon"] orImageUrl:nil Url:url delegate:delegate shareToPlatform:platform];
            break;
        case BYC_ShareTypeMedia:
            [BYC_UMengShareTool shareMediaID:_dic[const_ShareResourceID] videoUserid:_dic[const_ShareUserID] WithMediaTitle:_dic[const_ShareResourceTitle] ImageUrl:_dic[const_ShareResourceImage] mediaImage:nil delegate:delegate shareToPlatform:platform shareType:ENUM_ShareDefault];
            break;
        case BYC_ShareTypeActivity:
            [BYC_UMengShareTool shareTitle:stringTitle Content:[const_ShareActivityContent copy] withImage:nil orImageUrl:[const_ShareActivityImageUrl copy] Url:url delegate:delegate shareToPlatform:platform];
            break;
        default:
            break;
    }
}

-(void)layoutSubviews {

    [super layoutSubviews];
    
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && ![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
            
            _button_platforms[0].hidden = YES;
            _button_platforms[1].hidden = YES;
            _button_platforms[2].hidden = YES;
            _button_platforms[3].frame  = CGRectMake(0, 0, selfView.kwidth, SHARE_VIEW_HEIGHT);
            
    }else if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
            
            _button_platforms[0].hidden = YES;
            _button_platforms[1].hidden = YES;
            _button_platforms[2].hidden = NO;
            _button_platforms[2].frame  = CGRectMake(0, 0, selfView.kwidth / 2.0, SHARE_VIEW_HEIGHT);
            _button_platforms[3].frame  = CGRectMake(selfView.kwidth / 2.0, 0, selfView.kwidth / 2.0, SHARE_VIEW_HEIGHT);
        }else if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
            
            _button_platforms[0].hidden = NO;
            _button_platforms[1].hidden = NO;
            _button_platforms[2].hidden = YES;
            _button_platforms[0].frame  = CGRectMake(0, 0, selfView.kwidth / 3.0, SHARE_VIEW_HEIGHT);
            _button_platforms[1].frame  = CGRectMake(selfView.kwidth / 3.0, 0, selfView.kwidth / 3.0, SHARE_VIEW_HEIGHT);
            _button_platforms[3].frame  = CGRectMake(selfView.kwidth / 3.0 * 2, 0, selfView.kwidth / 3.0, SHARE_VIEW_HEIGHT);
        }
}

@end
