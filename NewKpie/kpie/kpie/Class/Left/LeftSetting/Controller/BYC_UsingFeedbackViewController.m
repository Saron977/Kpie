//
//  BYC_UsingFeedbackViewController.m
//  kpie
//
//  Created by 元朝 on 15/12/29.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_UsingFeedbackViewController.h"
#import "BYC_TextView.h"
#import "BYC_ImageFromColor.h"
#import "BYC_HttpServers+BYC_Settings.h"

@interface BYC_UsingFeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>


@property (strong, nonatomic)  UIButton *button_Send;

@property (nonatomic, strong)  BYC_TextView *textview;
@property (nonatomic, strong)  UITextField  *textField_QQWXNum;
@property (nonatomic, strong)  UITextField  *textField_SurplusNum;
@property (strong, nonatomic)   UIView *view_Containers;
@end

@implementation BYC_UsingFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"使用反馈";

    [self initViews];
}
//初始化并定义大小
-(void)initViews {

    _view_Containers                             = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 200 + 1 + 34)];
    _textview                                    = [[BYC_TextView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200)];

    UIView *view_Line                            = [[UIView alloc] initWithFrame:CGRectMake(0, _textview.bottom, screenWidth, .5f)];
    view_Line.backgroundColor                    = KUIColorBackgroundTouchDown;
    view_Line.clipsToBounds                      = NO;
    
    _textField_QQWXNum                           = [[UITextField alloc] initWithFrame:CGRectMake(20, view_Line.bottom, screenWidth, 34)];
    _textField_SurplusNum                        = [[UITextField alloc] initWithFrame:CGRectMake(view_Line.right - 50,  self.view_Containers.bottom - self.textField_QQWXNum.kheight - 30, 50, 30)];

    self.view_Containers.backgroundColor         = KUIColorBackgroundModule1;
    _textview.backgroundColor                    = [UIColor clearColor];
    _textField_QQWXNum.backgroundColor           = [UIColor clearColor];
    _textField_SurplusNum.backgroundColor        = [UIColor clearColor];
    _textField_SurplusNum.textAlignment          = NSTextAlignmentRight;
    
    _textField_SurplusNum.textColor               = KUIColorWordsBlack1;
    _textField_SurplusNum.font                   = [UIFont systemFontOfSize:12];
    _textField_SurplusNum.userInteractionEnabled = NO;
    _textField_SurplusNum.text                   = @"0/520";
    
    
    [self.view addSubview:self.view_Containers];
    [self.view_Containers addSubview:view_Line];
    [self.view_Containers addSubview:self.textview];
    [self.view_Containers addSubview:self.textField_QQWXNum];
    [self.view addSubview:_textField_SurplusNum];
    
    _textview.delegate = self;       //设置代理方法的实现类
    _textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    _textview.textColor = KUIColorWordsBlack1;
    [QNWSNotificationCenter addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    // 默认允许垂直方向拖拽
    _textview.alwaysBounceVertical = YES;
    _textview.placeHolder = @"请留下您的宝贵意见！";
    _textField_QQWXNum.placeholder = @"您的联系方式（QQ/微信/手机号)";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = KUIColorFromRGBA(0x9BA0AA, 1);
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_textField_QQWXNum.placeholder attributes:dict];
    [_textField_QQWXNum setAttributedPlaceholder:attribute];
    _textField_QQWXNum.textColor = KUIColorWordsBlack1;
    _textField_QQWXNum.delegate = self;
    self.button_Send = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.button_Send];
    [self.button_Send mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.button_Send.superview.mas_left).offset(0);
        make.bottom.equalTo(self.button_Send.superview.mas_bottom).offset(0);
        make.right.equalTo(self.view_Containers.superview.mas_right).offset(0);
        make.height.offset(49);
    }];
    [self.button_Send setTitle:@"发送" forState:UIControlStateNormal];
    [self.button_Send setTitleColor:KUIColorFromRGB(0x2D343C) forState:UIControlStateHighlighted];
    self.button_Send.backgroundColor = KUIColorBaseGreenNormal;
    [self.button_Send addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.button_Send  setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGB(0x1C222A) withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
}

#pragma mark - 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - 文字改变的时候调用
- (void)textChange
{
    // 判断下textView有木有内容
    if (_textview.text.length) { // 有内容
        _textview.hidePlaceHolder = YES;

    }else{
        _textview.hidePlaceHolder = NO;
        
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 520) {
        [textView resignFirstResponder];
        [self.view showAndHideHUDWithDetailsTitle:@"不能超过520个字" WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
          [textView becomeFirstResponder];
        }];
        textView.text = [textView.text substringToIndex:520];
        number = 520;
    }
    self.textField_SurplusNum.text = [NSString stringWithFormat:@"%ld/520",(long)number];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不能有换行
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        [self.view showAndHideHUDWithDetailsTitle:@"不能换行" WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
            [textField becomeFirstResponder];
        }];
        return NO;
    }
    
    return YES;
}

- (void)buttonAction:(UIButton *)sender {
    
    if (_textview.text.length < 15) {
        
        [self.view showAndHideHUDWithTitle:@"反馈信息必须大于15个字" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }
    
    NSDictionary *dic = @{@"feedbackcontent":_textview.text,@"usercontact":_textField_QQWXNum.text,@"userid":[BYC_AccountTool userAccount].userid};
    
    [self requestDataWithUrl:KQNWS_SaveUserFeedbackUrl parameters:dic type:0];
}

- (void)requestDataWithUrl:(NSString *)url parameters:(id)parameters type:(NSInteger)integer {
    
    [self.view showHUDWithTitle:@"提交反馈中..." WithState:BYC_MBProgressHUDHideProgress];
    
    [BYC_HttpServers requestUsingFeedbackDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation) {
        
        if (self.view.isDisplayHUD) {
            
            [self.view showAndHideHUDWithTitle:@"感谢反馈攻城狮GG会尽快处理。" WithState:0 completion:^(BOOL finished) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else [self.navigationController popViewControllerAnimated:YES];
    } failure:nil];
}
@end
