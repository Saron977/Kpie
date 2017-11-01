//
//  BYC_BaseColumnViewController.m
//  kpie
//
//  Created by 元朝 on 16/9/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseColumnViewController.h"
#import "BYC_LoginAndRigesterView.h"
#import "WX_GeekModel.h"
#import "BYC_ShareView.h"
#import "BYC_CheckLoginButton.h"

@interface BYC_BaseColumnViewController ()<UMSocialUIDelegate>

@property (nonatomic, strong) BYC_CheckLoginButton      *button_Topside;    /**<   浮动按钮_参与 */
@end

@implementation BYC_BaseColumnViewController


#pragma mark - 本类系统相关方法(包括自定义的初始化方法)

#pragma mark - 初始化子视图

#pragma mark - 属性的get 及 set 方法

-(void)setIsShowJoinInStepButton:(BOOL)isShowJoinInStepButton {

    _isShowJoinInStepButton = isShowJoinInStepButton;
    if (_isShowJoinInStepButton) [self setupJoinInStepButton];
}

-(void)setIsShowShareButton:(BOOL)isShowShareButton {

    _isShowShareButton = isShowShareButton;
    if (_isShowShareButton) [self setupShareButton];
}

- (void)setModel:(BYC_OtherViewControllerModel *)model {

    _model = model;
    if (_model.themename.length > 0) self.isShowJoinInStepButton = YES;
    else self.isShowJoinInStepButton = NO;
}

#pragma mark - 网络请求数据

#pragma mark - UIScrollView 以及其子类的数据源和代理

#pragma mark - 其它系统类的代理（例如UITextField,UITextView等）

#pragma mark - 自定义类的代理

#pragma mark - 本类创建的的相关方法（不是本类系统的方法）

-(void)setupShareButton
{
    UIButton *btn_Share = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Share.frame = CGRectMake(0, 0, 80, 30);
    btn_Share.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [btn_Share setTitle:@"分 享" forState:UIControlStateNormal];
    btn_Share.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn_Share setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btn_Share setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [btn_Share addTarget:self action:@selector(clickShareAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn_Share];
}

// 设置浮动按钮
-(void)setupJoinInStepButton {
    
    _button_Topside = [BYC_CheckLoginButton buttonWithType:UIButtonTypeCustom];
    [_button_Topside setImage:[UIImage imageNamed:@"guaika_lanmu_btn_cansai_n"] forState:UIControlStateNormal];
    [_button_Topside setImage:[UIImage imageNamed:@"guaika_lanmu_btn_cansai_h"] forState:UIControlStateHighlighted];
    [_button_Topside addTarget:self action:@selector(clickJoinInStepAction:) forControlEvents:UIControlEventTouchUpInside];
    _button_Topside.isCheckLogin = YES;
    [self.view addSubview:_button_Topside];
    
    [_button_Topside mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.centerX;
        make.bottom.offset(-15);
    }];
}

//只是为了不提示警告写的，具体实现应该在子类中复写该方法
- (void)clickJoinInStepAction:(UIButton *)button {}
- (void)clickShareAction:(UIButton *)button {

    [[BYC_ShareView alloc] showWithDelegateVC:self shareContentOrMedia:BYC_ShareTypeActivity shareWithDic:nil];
}

-(void)dealloc {

    [QNWSNotificationCenter removeObserver:self];
}
@end
