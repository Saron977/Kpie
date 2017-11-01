//
//  WX_DrawLotteryView.m
//  DrawLottery
//
//  Created by 王傲擎 on 16/7/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_DrawLotteryView.h"
#import "WX_MovieCViewController.h"
#import "WX_ToolClass.h"
#import "BYC_HttpServers.h"
#import "BYC_HttpServers+WX_GeekVC.h"
#import "BYC_Tool.h"
#import "IQKeyboardManager.h"



#define INTERVAL_KEYBOARD 20

static WX_DrawLotteryView   *view_Lottery_Back;
@interface WX_DrawLotteryView()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView       *imgView_Back;          /**<   图片 */
@property (nonatomic, strong) UILabel           *label_Winner;          /**<   中奖文字 */
@property (nonatomic, strong) UIImageView       *imgView_Winner;        /**<   开奖结果两侧图片 */
@property (nonatomic, strong) UIView            *view_CancelBtn_Back;   /**<   取消按钮背景,加大触控 */
@property (nonatomic, strong) UIButton          *button_Cancel;         /**<   取消按钮 */
@property (nonatomic, strong) UIButton          *button_Down;           /**<   下方按钮 */
@property (nonatomic, strong) UILabel           *label_Prompt;          /**<   提示文字 */
@property (nonatomic, strong) UIView            *view_TexrtFied_Back;   /**<   手机号输入_兑换码显示背景框 */
@property (nonatomic, strong) UITextField       *textField_phoneNum;    /**<   手机号输入 */
@property (nonatomic, copy  ) NSString          *str_PhoneNum;          /**<   手机号 */
@property (nonatomic, strong) UILabel           *label_CDKey;           /**<   兑换码 */
@property (nonatomic, strong) UILabel           *label_PrizeName;       /**<   奖品名 */
@property (nonatomic, assign) NSInteger         result_Lottery;         /**<   抽奖结果 : 0_ 未中奖 1_ 中奖_提交手机号 2_ 中奖_获奖券 */
@property (nonatomic, copy  ) NSString          *str_CDKey;             /**<   兑换码 */
@property (nonatomic, strong) UIPasteboard      *pasteboard_CDKey;      /**<   复制到剪贴板文字 */

@property (nonatomic, assign) DrawLottery       lottery_Type;           /**<   点击参与_类型 */
@property (nonatomic, strong) UIViewController  *controller;            /**<   参与拍摄_附带controller */
@property (nonatomic, strong) WX_GeekModel      *model_Geek;            /**<   怪咖模型,控制抽奖页面 */
@property (nonatomic, assign) BOOL              isRemoveNotifi;         /**<   是否移除监听 */
@property (nonatomic, assign) BOOL              is_PhoneNum;            /**<   是否是正确手机号 */
@property (nonatomic, assign) BOOL              is_ReturnPhone;         /**<   返回手机号模型 */



@end

@implementation WX_DrawLotteryView

+(void)showDrawLotteryViewWith:(DrawLottery)lotteryType ViewController:(UIViewController*)controller GeekModel:(WX_GeekModel *)model_Geek
{
    if (!view_Lottery_Back) {
        view_Lottery_Back = [[WX_DrawLotteryView alloc]init];
        view_Lottery_Back.userInteractionEnabled = YES;
        view_Lottery_Back.backgroundColor = KUIColorFromRGBA(0x000000, 0.7);
    }
    view_Lottery_Back.lottery_Type  = lotteryType;
    view_Lottery_Back.controller    = controller;
    view_Lottery_Back.model_Geek    = model_Geek;
    [[UIApplication sharedApplication].keyWindow addSubview:view_Lottery_Back];
    [view_Lottery_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [view_Lottery_Back createUI];
}

/// 创建UI
-(void)createUI
{
    /// 判断是否输入手机号,
    /// 没输入手机号 要求输入
    if (_model_Geek.str_phoneNum.length) {
        
        switch (view_Lottery_Back.lottery_Type) {
            case ENUM_Activities_JoinShooting:
                /// 参加拍摄
                [self pushMovieCViewController];
                break;
                
            case ENUM_Video_VoteWithLottery:
                /// 投票抽奖
                [self getOneLotteryChance];
                break;
                
            case ENUM_Video_ShareWithLottery:
                /// 投票抽奖
                [self getOneLotteryChance];
                break;
            
            case ENUM_Video_VoteEndNeedPhoneNum:
                /// 投票抽奖完成,填写手机号
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(closeView) userInfo:nil repeats:NO];
                
                [self createOrRemoveNotifiWith:NO];
                break;

            default:
                break;
        }
    }else{
        /// 创建手机号
        [self createPhoneNum];
    }
}



/// 关闭当前页面
-(void)closeView
{
    [view_Lottery_Back removeFromSuperview];
    
    view_Lottery_Back = nil;
    
}

/// 点击按钮
-(void)clickButton:(UIButton*)btn
{
    
    switch (view_Lottery_Back.lottery_Type) {
        case ENUM_Activities_JoinShooting:
            //// 栏目内_ 点击参加_ 拍摄
        {
            switch (btn.tag) {
                case 100:
                    /// 填入手机号
                    
                    [_textField_phoneNum resignFirstResponder];
                    
                    if (_is_PhoneNum) {
                        _is_ReturnPhone = YES;
                        
                        [self EnterPhoneNumberWithLotteryType:ENUM_Activities_JoinShooting];
                    }else{
                        [view_Lottery_Back showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];

                    }
                    
                    break;
                    
                default:
                    break;
            }
           
        }
            break;
        case ENUM_Video_VoteWithLottery:
            //// 视频内_ 点击参加_ 抽奖
            switch (btn.tag) {
                case 100:
                    /// 填入手机号
                    
                    [_textField_phoneNum resignFirstResponder];
                    if (_is_PhoneNum) {
                        
                        _is_ReturnPhone = YES;
                        [self EnterPhoneNumberWithLotteryType:ENUM_Video_VoteWithLottery];
                    }else{
                        [view_Lottery_Back showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];

                    }
                    
                    
                    break;
                    
                case 101:
                    /// 马上抽奖
                    [self animationDrawLottery];
                    
                    [self getDataPrize];
                    
                    break;
                    
                case 102:
                    /// 中奖填写手机号
                    [self animationDrawLottery];
                    
                    break;
                    
                case 103:
                    /// 未中奖
                    
                    [self closeView];
                    
                    break;
                    
                case 104:
                    /// 中奖_提交手机号
                    [_textField_phoneNum resignFirstResponder];
                    
                    if (_is_PhoneNum){
                        
                        [self EnterPhoneNumberWithLotteryType:ENUM_Video_VoteEndNeedPhoneNum];
                    }else{
                        [view_Lottery_Back showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
                    }
                    break;
                    
                case 105:
                    /// 中奖_获得兑换码
                    
                    [self closeView];
                    
                    break;
                    
                default:
                    break;
            }
            break;
        case ENUM_Video_ShareWithLottery:
            //// 视频内_ 点击参加_ 抽奖
            switch (btn.tag) {
                case 100:
                    /// 填入手机号
                    
                    [_textField_phoneNum resignFirstResponder];
                    
                    if (_is_PhoneNum){
                        
                        _is_ReturnPhone = YES;
                        
                        [self EnterPhoneNumberWithLotteryType:ENUM_Video_VoteWithLottery];
                        

                    }else{
                        [view_Lottery_Back showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];

                    }
                    
                    
                    break;
                    
                case 101:
                    /// 马上抽奖
                    [self animationDrawLottery];
                    
                    [self getDataPrize];
                    
                    break;
                    
                case 102:
                    /// 中奖填写手机号
                    [self animationDrawLottery];
                    
                    break;
                    
                case 103:
                    /// 未中奖
                    
                    [self closeView];
                    
                    break;
                    
                case 104:
                    /// 中奖_提交手机号
                    [_textField_phoneNum resignFirstResponder];
                    
                    if (_is_PhoneNum){

                        [self EnterPhoneNumberWithLotteryType:ENUM_Video_VoteEndNeedPhoneNum];
                    }else{
                        [view_Lottery_Back showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
                        
                    }
                    

                    
                    break;
                    
                case 105:
                    /// 中奖_获得兑换码
                    
                    [self closeView];
                    
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
   
    
}

/// 输入手机号
-(void)EnterPhoneNumberWithLotteryType:(DrawLottery)lotteryType
{

    
    if (_model_Geek.userID.length && _str_PhoneNum.length == 11) {
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setValue:_model_Geek.userID forKey:@"userId"];
        [parameters setValue:_str_PhoneNum forKey:@"contact"];
        
        [BYC_HttpServers Get:KQNWS_EnterContactPrize parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
            QNWSLog(@"responseObject == %@",responseObject);
            NSInteger integer_Reslut = [(NSNumber*)responseObject[@"reslut"] integerValue];
            NSString *str_Message = responseObject[@"message"];
            [view_Lottery_Back showAndHideHUDWithTitle:str_Message WithState:BYC_MBProgressHUDHideProgress];
            
            DrawLottery last_Type = view_Lottery_Back.lottery_Type;
            view_Lottery_Back.lottery_Type = lotteryType;
            
            if (integer_Reslut == 0) {
                /// 首次需要填写手机号,并返回
               [self firstUseGeekNeedPhoneNumber];
                /// 手机号输入成功
                switch (view_Lottery_Back.lottery_Type) {
                    case ENUM_Activities_JoinShooting:
                        /// 栏目界面_跳转拍摄界面
                        [self phoneNumberMakeSuccessWithRemoveSuperviews:YES];
                        break;
                    case ENUM_Video_VoteWithLottery:
                        /// 视频界面_获得抽奖机会
                        [self phoneNumberMakeSuccessWithRemoveSuperviews:YES];
                        break;
                    case ENUM_Video_ShareWithLottery:
                        /// 视频界面_获得抽奖机会
                        [self phoneNumberMakeSuccessWithRemoveSuperviews:YES];
                        break;
                    case ENUM_Video_VoteEndNeedPhoneNum:
                        /// 获得实物奖_提示文字
                        
                        [self phoneNumberMakeSuccessWithRemoveSuperviews:NO];
                        break;
                    default:
                        break;
                }
             
            }else{
                view_Lottery_Back.lottery_Type = last_Type;
            }
         
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            QNWSLog(@"输入手机号接口数据请求失败,%@",error);
            [view_Lottery_Back showAndHideHUDWithTitle:@"请求失败,请重试" WithState:BYC_MBProgressHUDHideProgress];
        }];
        
    }else if (_str_PhoneNum.length != 11 || ![BYC_Tool isMobileNumber:_str_PhoneNum]){
        [view_Lottery_Back showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];

    }
}

/// 获取抽奖结果
-(void)getDataPrize
{
     NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:_model_Geek.userID forKey:@"userId"];
    [parameters setValue:[NSString stringWithFormat:@"%zi",view_Lottery_Back.lottery_Type] forKey:@"drawType"];
    
    [BYC_HttpServers Get:KQNWS_GetDataPrize parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        id id_Prize = responseObject[@"prize"];
        if ([id_Prize isKindOfClass:[NSString class]]) {
            
            _model_Geek.prizeType   =   0;
            _result_Lottery         =   _model_Geek.prizeType;
        }else if ([id_Prize isKindOfClass:[NSMutableArray class]]){
            
            NSArray *array = responseObject[@"prize"];
            if (array.count) {
                NSArray *array_Prize    =   array[0];
                _model_Geek.prozeID     =   array_Prize[0];
                _model_Geek.prizeName   =   array_Prize[1];
                _model_Geek.appName     =   array_Prize[2];
                _model_Geek.prizeType   =   [(NSNumber*)array_Prize[3] integerValue];
                _model_Geek.winRate     =   [(NSNumber*)array_Prize[4] floatValue];
                
                _result_Lottery         =   _model_Geek.prizeType;
            }
        }
        
        _model_Geek.bool_VoteDraw = [(NSNumber*)responseObject[@"voteDraw"] boolValue];
        _model_Geek.bool_ShareDraw = [(NSNumber*)responseObject[@"shareDraw"] boolValue];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotification_GeekDrawLottery" object:_model_Geek];
        [self LotteryResult];

    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [view_Lottery_Back showAndHideHUDWithTitle:@"请求失败,请重试" WithState:BYC_MBProgressHUDHideProgress];
        QNWSLog(@"抽奖结果接口有误,error == %@",error);
    }];
}

/// 首次使用 需要返回手机号
-(void)firstUseGeekNeedPhoneNumber
{

    if (_is_ReturnPhone) {
        BYC_AccountModel *model_Account = [BYC_AccountTool userAccount];
        model_Account.cellphonenumber = _str_PhoneNum;
        [BYC_AccountTool saveAccount:model_Account];

        _model_Geek.str_phoneNum = _str_PhoneNum;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotification_Mononoke" object:_model_Geek];
        _is_ReturnPhone = NO;
    }
}

/// 输入手机号成功返回
-(void)phoneNumberMakeSuccessWithRemoveSuperviews:(BOOL)isRemove
{
    _model_Geek.str_phoneNum = _str_PhoneNum;
    
    if (isRemove) {
        
        [self removeSuperviews];
    }
    
    [self createUI];
    
    _str_PhoneNum = @"";
}
/// 推入视频拍摄界面
-(void)pushMovieCViewController
{
    if (view_Lottery_Back.controller) {
        
        WX_MovieCViewController *movieVC = [[WX_MovieCViewController alloc]init];
        movieVC.movie_Type = ENUM_Type_Geek;
        [view_Lottery_Back.controller.navigationController pushViewController:movieVC animated:YES];
        
    }
    [self closeView];

}
/// 重置视图
-(void)removeSuperviews
{
    if (_textField_phoneNum) {
        
        /// 移除监听
        [self createOrRemoveNotifiWith:NO];
    }
    
    for (UIView *subViews in _imgView_Back.subviews) {
        [subViews removeFromSuperview];
    }
}
/// 创建输入手机号界面
-(void)createPhoneNum
{
    /// 设置背景图片
    _imgView_Back = [[UIImageView alloc]init];
    _imgView_Back.image = [UIImage imageNamed:@"guaika_video_img_pop_srsjh"];
    _imgView_Back.userInteractionEnabled = YES;
    [view_Lottery_Back addSubview:_imgView_Back];
    
    [_imgView_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view_Lottery_Back);
        make.width.equalTo(view_Lottery_Back.mas_width).multipliedBy(0.75);
        make.height.equalTo(_imgView_Back.mas_width).multipliedBy(0.74);
    }];
    
    /// 取消按钮背景,加大触控
    _view_CancelBtn_Back = [[UIView alloc]init];
    _view_CancelBtn_Back.backgroundColor = [UIColor clearColor];
    _view_CancelBtn_Back.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_CloseView = [[UITapGestureRecognizer alloc]initWithTarget:view_Lottery_Back action:@selector(closeView)];
    [_view_CancelBtn_Back addGestureRecognizer:tap_CloseView];
    [_imgView_Back addSubview:_view_CancelBtn_Back];
    
    [_view_CancelBtn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgView_Back.mas_right).offset(-7);
        make.centerY.equalTo(_imgView_Back.mas_top).offset(7);
        make.width.height.mas_equalTo(@80);
    }];
    
    /// 关闭按钮
    _button_Cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_n"] forState:UIControlStateNormal];
    [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_h"] forState:UIControlStateHighlighted];
    [_button_Cancel addTarget:view_Lottery_Back action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [_imgView_Back addSubview:_button_Cancel];
    
    [_button_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_view_CancelBtn_Back);
        make.width.height.mas_equalTo(@50);
    }];
    
    /// 手机号输入背景框
    _view_TexrtFied_Back = [[UIView alloc]init];
    _view_TexrtFied_Back.backgroundColor = KUIColorFromRGB(0xeeeeee);
    _view_TexrtFied_Back.layer.masksToBounds = YES;
    _view_TexrtFied_Back.layer.cornerRadius = 10;
    [_imgView_Back addSubview:_view_TexrtFied_Back];
    
    [_view_TexrtFied_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView_Back.mas_left).offset(10);
        make.right.equalTo(_imgView_Back.mas_right).offset(-10);
        make.centerY.equalTo(_imgView_Back).offset(-15);
        make.height.mas_equalTo(@40);
    }];
    
    /// 创建监听
    [self createOrRemoveNotifiWith:YES];
    
    /// 手机号码
    _textField_phoneNum = [[UITextField alloc]init];
    _textField_phoneNum.backgroundColor = KUIColorFromRGB(0xeeeeee);
    _textField_phoneNum.placeholder = @"请输入手机号";
    _textField_phoneNum.font = [UIFont systemFontOfSize:15];
    _textField_phoneNum.textColor = KUIColorFromRGB(0x333333);
    _textField_phoneNum.delegate = self;
    _textField_phoneNum.keyboardType = UIKeyboardTypePhonePad;
    _textField_phoneNum.returnKeyType = UIReturnKeyDone;
    _textField_phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_view_TexrtFied_Back addSubview:_textField_phoneNum];
    
    [_textField_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_TexrtFied_Back).offset(10);
        make.right.equalTo(_view_TexrtFied_Back).offset(-10);
        make.top.bottom.equalTo(_view_TexrtFied_Back);
    }];
    
    /// 提示文字
    NSString *str_Prompt = @"(为方便您获奖后更顺利通知到您)";
    CGSize size_Prompt = [WX_ToolClass changeSizeWithString:str_Prompt FontOfSize:10 bold:ENUM_NormalSystem];
    CGFloat width_Prompt = size_Prompt.width+10;
    
    _label_Prompt = [[UILabel alloc]init];
    _label_Prompt.text = str_Prompt;
    _label_Prompt.font = [UIFont boldSystemFontOfSize:10];
    _label_Prompt.textColor = KUIColorFromRGB(0xf23456);
    [_imgView_Back addSubview:_label_Prompt];
    
    [_label_Prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgView_Back.mas_centerY).offset(15+size_Prompt.height/2);
        make.centerX.equalTo(_imgView_Back.mas_centerX);
        make.width.mas_equalTo(width_Prompt);
        make.height.mas_equalTo(size_Prompt.height);
        
    }];
    
    /// 下方按钮
    _button_Down = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_Down.tag = 100;
    [_button_Down setImage:[UIImage imageNamed:@"guaika_video_btn_tijiao_n"] forState:UIControlStateNormal];
    [_button_Down setImage:[UIImage imageNamed:@"guaika_video_btn_tijiao_h"] forState:UIControlStateHighlighted];
    [_button_Down addTarget:view_Lottery_Back action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_imgView_Back addSubview:_button_Down];
    
    [_button_Down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label_Prompt.mas_bottom).offset(15);
        make.centerX.equalTo(_imgView_Back.mas_centerX);
    }];
    
}
/// 获得抽奖激活界面
-(void)getOneLotteryChance
{
    [self removeSuperviews];
    
    /// 更新约束
    if (!_imgView_Back) {
        _imgView_Back = [[UIImageView alloc]init];
        _imgView_Back.userInteractionEnabled = YES;
        [view_Lottery_Back addSubview:_imgView_Back];
    }
    _imgView_Back.image = [UIImage imageNamed:@"guaika_video_img_pop_cjzg"];
    _imgView_Back.alpha = 0.f;
    _imgView_Back.frame = CGRectMake(-10, -screenHeight*0.7, screenWidth, screenHeight*0.7);
    
    [UIView animateWithDuration:0.35 animations:^{
        _imgView_Back.frame = CGRectMake(0, 0, screenWidth, screenHeight *0.7);
        _imgView_Back.alpha = 1;
    } completion:^(BOOL finished) {
        [_imgView_Back mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view_Lottery_Back);
            make.top.equalTo(view_Lottery_Back);
            make.height.equalTo(view_Lottery_Back).multipliedBy(0.7);
            make.centerX.equalTo(view_Lottery_Back);
        }];
        
        
        /// 取消按钮背景,加大触控
        _view_CancelBtn_Back = [[UIView alloc]init];
        _view_CancelBtn_Back.backgroundColor = [UIColor clearColor];
        _view_CancelBtn_Back.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_CloseView = [[UITapGestureRecognizer alloc]initWithTarget:view_Lottery_Back action:@selector(closeView)];
        [_view_CancelBtn_Back addGestureRecognizer:tap_CloseView];
        [_imgView_Back addSubview:_view_CancelBtn_Back];
        CGFloat float_Top = screenHeight *0.40;
        CGFloat float_Right_OffSet = screenWidth *0.12;
        [_view_CancelBtn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imgView_Back.mas_right).offset(-float_Right_OffSet);
            make.centerY.equalTo(_imgView_Back.mas_top).offset(float_Top);
            make.width.height.mas_equalTo(@80);
        }];
        
        /// 关闭按钮
        _button_Cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_n"] forState:UIControlStateNormal];
        [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_h"] forState:UIControlStateHighlighted];
        [_button_Cancel addTarget:view_Lottery_Back action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_imgView_Back addSubview:_button_Cancel];
        
        [_button_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_view_CancelBtn_Back);
            make.width.height.mas_equalTo(@50);
        }];
        
        /// 下方按钮
        _button_Down = [UIButton buttonWithType:UIButtonTypeCustom];
        _button_Down.tag = 101;
        [_button_Down setImage:[UIImage imageNamed:@"guaika_video_btn_mscj_n"] forState:UIControlStateNormal];
        [_button_Down setImage:[UIImage imageNamed:@"guaika_video_btn_mscj_h"] forState:UIControlStateHighlighted];
        [_button_Down addTarget:view_Lottery_Back action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_imgView_Back addSubview:_button_Down];
        
        [_button_Down mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_imgView_Back.mas_bottom).offset(-15);
            make.centerX.equalTo(_imgView_Back.mas_centerX);
        }];
        

    }];
    
}
/// 抽奖动画
-(void)animationDrawLottery
{
    [self removeSuperviews];
    NSArray *array_Img = [[NSArray alloc]initWithObjects:@"cjdh_1",@"cjdh_2",@"cjdh_3",@"cjdh_4", nil];
    NSMutableArray *arrary_Animat = [[NSMutableArray alloc]init];
    
    for (NSString *str_Img in array_Img) {
        UIImage *image = [UIImage imageNamed:str_Img];
        [arrary_Animat addObject:image];
    }
    
    _imgView_Back.animationImages = arrary_Animat;
    [_imgView_Back setAnimationDuration:0.35f];
    [_imgView_Back setAnimationRepeatCount:0];
    [_imgView_Back startAnimating];
    
    [_imgView_Back mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view_Lottery_Back);
        make.width.height.mas_equalTo(200);
    }];
    
//    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(LotteryResult) userInfo:nil repeats:NO];
}

/// 抽奖结果
-(void)LotteryResult
{
    [self removeSuperviews];
    [_imgView_Back stopAnimating];
    
    if (_result_Lottery == 0) {
        /// 没中奖
        _imgView_Back.image = [UIImage imageNamed:@"guaika_video_img_pop_wcz"];
        _imgView_Back.userInteractionEnabled = YES;
        [view_Lottery_Back addSubview:_imgView_Back];
        
        [_imgView_Back mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view_Lottery_Back);
            make.width.equalTo(view_Lottery_Back.mas_width).multipliedBy(0.75);
            make.height.equalTo(_imgView_Back.mas_width).multipliedBy(1.16);
        }];
        
        /// 装饰文字
        _imgView_Winner = [[UIImageView alloc]init];
        _imgView_Winner.image = [UIImage imageNamed:@"guaika_video_img_zhuangshi"];
        [_imgView_Back addSubview:_imgView_Winner];
        
        [_imgView_Winner mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view_Lottery_Back);
            make.top.equalTo(_imgView_Back).offset(26);
            make.height.equalTo(_imgView_Back).multipliedBy(0.285);
        }];
        
        /// 取消按钮背景,加大触控
        _view_CancelBtn_Back = [[UIView alloc]init];
        _view_CancelBtn_Back.backgroundColor = [UIColor clearColor];
        _view_CancelBtn_Back.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_CloseView = [[UITapGestureRecognizer alloc]initWithTarget:view_Lottery_Back action:@selector(closeView)];
        [_view_CancelBtn_Back addGestureRecognizer:tap_CloseView];
        [_imgView_Back addSubview:_view_CancelBtn_Back];
        
        [_view_CancelBtn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imgView_Back.mas_right).offset(-7);
            make.centerY.equalTo(_imgView_Back.mas_top).offset(7);
            make.width.height.mas_equalTo(@80);
        }];
        
        /// 关闭按钮
        _button_Cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_n"] forState:UIControlStateNormal];
        [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_h"] forState:UIControlStateHighlighted];
        [_button_Cancel addTarget:view_Lottery_Back action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_imgView_Back addSubview:_button_Cancel];
        
        [_button_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_view_CancelBtn_Back);
            make.width.height.mas_equalTo(@50);
        }];
        
        /// 下方按钮
        _button_Down = [UIButton buttonWithType:UIButtonTypeCustom];
        _button_Down.tag = 103;
        [_button_Down setImage:[UIImage imageNamed:@"guaika_video_btn_jxjy_n"] forState:UIControlStateNormal];
        [_button_Down setImage:[UIImage imageNamed:@"guaika_video_btn_jxjy_h"] forState:UIControlStateHighlighted];
        [_button_Down addTarget:view_Lottery_Back action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_imgView_Back addSubview:_button_Down];
        
        [_button_Down mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_imgView_Back.mas_bottom).offset(-12);
            make.centerX.equalTo(_imgView_Back.mas_centerX);
        }];
        
    }else if(_result_Lottery == 1){
        /// 中奖_提交手机号
        _imgView_Back.image = [UIImage imageNamed:@"guaika_video_img_pop_lqjl"];
        _imgView_Back.userInteractionEnabled = YES;
        [view_Lottery_Back addSubview:_imgView_Back];
        
        [_imgView_Back mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view_Lottery_Back);
            make.width.equalTo(view_Lottery_Back.mas_width).multipliedBy(0.75);
            make.height.equalTo(_imgView_Back.mas_width).multipliedBy(1.372);
        }];
        
        /// 中奖文字
        NSString *str_Winner = @"恭喜您获得了大礼包奖品";
        CGSize size_Winner = [WX_ToolClass changeSizeWithString:str_Winner FontOfSize:15 bold:ENUM_NormalSystem];
        CGFloat float_Winner_Width = size_Winner.width +10;
        _label_Winner = [[UILabel alloc]init];
        _label_Winner.font = [UIFont boldSystemFontOfSize:15];
        _label_Winner.textAlignment = NSTextAlignmentCenter;
        _label_Winner.text = str_Winner;
        _label_Winner.textColor = KUIColorFromRGB(0x17323f);
        [_imgView_Back addSubview:_label_Winner];
        
        [_label_Winner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView_Back).offset(20);
            make.centerX.equalTo(_imgView_Back);
            make.height.mas_equalTo(size_Winner.height);
            make.width.mas_equalTo(float_Winner_Width);
        }];
        
        /// 中奖信息
        CGSize size_PrizeName = [WX_ToolClass changeSizeWithString:_model_Geek.prizeName FontOfSize:15 bold:ENUM_NormalSystem];
        CGFloat float_PrizeName_Width = size_PrizeName.width +10;
        _label_PrizeName = [[UILabel alloc]init];
        _label_PrizeName.font = [UIFont boldSystemFontOfSize:15];
        _label_PrizeName.textColor = KUIColorFromRGB(0x17323f);
        _label_PrizeName.textAlignment = NSTextAlignmentCenter;
        _label_PrizeName.text = _model_Geek.prizeName;
        [_imgView_Back addSubview:_label_PrizeName];
        
        [_label_PrizeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_Winner.mas_bottom).offset(5);
            make.centerX.equalTo(_label_Winner.mas_centerX);
            make.width.mas_equalTo(float_PrizeName_Width);
            make.height.mas_equalTo(size_PrizeName.height);
        }];
        
        /// 装饰文字
        _imgView_Winner = [[UIImageView alloc]init];
        _imgView_Winner.image = [UIImage imageNamed:@"guaika_video_img_zhuangshi"];
        [_imgView_Back addSubview:_imgView_Winner];
        
        [_imgView_Winner mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view_Lottery_Back);
            make.top.equalTo(_imgView_Back).offset(26);
            make.height.equalTo(_imgView_Back).multipliedBy(0.285);
        }];
        
        /// 取消按钮背景,加大触控
        _view_CancelBtn_Back = [[UIView alloc]init];
        _view_CancelBtn_Back.backgroundColor = [UIColor clearColor];
        _view_CancelBtn_Back.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_CloseView = [[UITapGestureRecognizer alloc]initWithTarget:view_Lottery_Back action:@selector(closeView)];
        [_view_CancelBtn_Back addGestureRecognizer:tap_CloseView];
        [_imgView_Back addSubview:_view_CancelBtn_Back];
        
        [_view_CancelBtn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imgView_Back.mas_right).offset(-7);
            make.centerY.equalTo(_imgView_Back.mas_top).offset(7);
            make.width.height.mas_equalTo(@80);
        }];
        
        /// 关闭按钮
        _button_Cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_n"] forState:UIControlStateNormal];
        [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_h"] forState:UIControlStateHighlighted];
        [_button_Cancel addTarget:view_Lottery_Back action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_imgView_Back addSubview:_button_Cancel];
        
        [_button_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_view_CancelBtn_Back);
            make.width.height.mas_equalTo(@50);
        }];
        
        
        
        /// 下方按钮
        _button_Down = [UIButton buttonWithType:UIButtonTypeCustom];
        _button_Down.tag = 104;
        [_button_Down setImage:[UIImage imageNamed:@"guaika_video_btn_lqjl_n"] forState:UIControlStateNormal];
        [_button_Down setImage:[UIImage imageNamed:@"guaika_video_btn_lqjl_h"] forState:UIControlStateHighlighted];
        [_button_Down addTarget:view_Lottery_Back action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_imgView_Back addSubview:_button_Down];
        
        [_button_Down mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_imgView_Back).offset(-12);
            make.centerX.equalTo(_imgView_Back.mas_centerX);
        }];
        
        /// 提示文字
        NSString *str_Prompt = @"请输入手机号领取奖励,我们将在第一时间联系您";
        CGSize size_Prompt = [WX_ToolClass changeSizeWithString:str_Prompt FontOfSize:10 bold:ENUM_NormalSystem];
        CGFloat width_Prompt = size_Prompt.width+10;
        
        _label_Prompt = [[UILabel alloc]init];
        _label_Prompt.text = str_Prompt;
        _label_Prompt.font = [UIFont boldSystemFontOfSize:10];
        _label_Prompt.textColor = KUIColorFromRGB(0xfe7e73);
        _label_Prompt.textAlignment = NSTextAlignmentCenter;
        [_imgView_Back addSubview:_label_Prompt];
        
        [_label_Prompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imgView_Back.mas_centerX);
            make.width.mas_equalTo(width_Prompt);
            make.height.mas_equalTo(size_Prompt.height);
            make.bottom.equalTo(_button_Down.mas_top).offset(-15);
        }];
        
        /// 创建监听
        [self createOrRemoveNotifiWith:YES];
        
        /// 手机号输入背景框
        _view_TexrtFied_Back = [[UIView alloc]init];
        _view_TexrtFied_Back.backgroundColor = KUIColorFromRGB(0xeeeeee);
        _view_TexrtFied_Back.layer.masksToBounds = YES;
        _view_TexrtFied_Back.layer.cornerRadius = 10;
        [_imgView_Back addSubview:_view_TexrtFied_Back];
        
        [_view_TexrtFied_Back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView_Back.mas_left).offset(10);
            make.right.equalTo(_imgView_Back.mas_right).offset(-10);
            //            make.centerY.equalTo(_imgView_Back).offset(-15);
            make.height.mas_equalTo(@40);
            make.bottom.equalTo(_label_Prompt.mas_top).offset(-9);
        }];
        
        /// 手机号码
        _textField_phoneNum = [[UITextField alloc]init];
        _textField_phoneNum.backgroundColor = KUIColorFromRGB(0xeeeeee);
        _textField_phoneNum.placeholder = @"请输入手机号";
        _textField_phoneNum.font = [UIFont systemFontOfSize:15];
        _textField_phoneNum.textColor = KUIColorFromRGB(0x333333);
        _textField_phoneNum.delegate = self;
        _textField_phoneNum.keyboardType = UIKeyboardTypePhonePad;
        _textField_phoneNum.returnKeyType = UIReturnKeyDone;
        _textField_phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_view_TexrtFied_Back addSubview:_textField_phoneNum];
        
        [_textField_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view_TexrtFied_Back).offset(10);
            make.right.equalTo(_view_TexrtFied_Back).offset(-10);
            make.top.bottom.equalTo(_view_TexrtFied_Back);
        }];
        
        /// 不存在 展示图片
        [UIView animateWithDuration:1.0f animations:^{
            
            _imgView_Back.layer.transform = CATransform3DMakeScale(.5f, .5f, 1.f);
            [UIView animateWithDuration:0.95f animations:^{
                _imgView_Back.layer.transform = CATransform3DIdentity;
            }];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.0f animations:^{
                
                _imgView_Back.layer.transform = CATransform3DMakeScale(.5f, .5f, 1.f);
                [UIView animateWithDuration:0.95f animations:^{
                    _imgView_Back.layer.transform = CATransform3DIdentity;
                }];
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        
    }else if (_result_Lottery == 2){
        /// 中奖_获奖券
        _imgView_Back.image = [UIImage imageNamed:@"img_guaika_hjq"];
        _imgView_Back.userInteractionEnabled = YES;
        [view_Lottery_Back addSubview:_imgView_Back];
        
        [_imgView_Back mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view_Lottery_Back);
            make.width.equalTo(view_Lottery_Back.mas_width).multipliedBy(0.75);
            make.height.equalTo(_imgView_Back.mas_width).multipliedBy(1.372);
        }];
        
        /// 中奖文字
        NSString *str_Winner = @"恭喜您获得了大礼包奖品";
        CGSize size_Winner = [WX_ToolClass changeSizeWithString:str_Winner FontOfSize:15 bold:ENUM_NormalSystem];
        CGFloat float_Winner_Width = size_Winner.width +10;
        _label_Winner = [[UILabel alloc]init];
        _label_Winner.font = [UIFont boldSystemFontOfSize:15];
        _label_Winner.textAlignment = NSTextAlignmentCenter;
        _label_Winner.text = str_Winner;
        _label_Winner.textColor = KUIColorFromRGB(0x17323f);
        [_imgView_Back addSubview:_label_Winner];
        
        [_label_Winner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView_Back).offset(20);
            make.centerX.equalTo(_imgView_Back);
            make.height.mas_equalTo(size_Winner.height);
            make.width.mas_equalTo(float_Winner_Width);
        }];
        
        /// 中奖信息
        NSString *str_PrizeName = [NSString stringWithFormat:@"%@ 兑换码",_model_Geek.appName];
        CGSize size_PrizeName = [WX_ToolClass changeSizeWithString:str_PrizeName FontOfSize:15 bold:ENUM_NormalSystem];
        CGFloat float_PrizeName_Width = size_PrizeName.width +10;
        _label_PrizeName = [[UILabel alloc]init];
        _label_PrizeName.font = [UIFont boldSystemFontOfSize:15];
        _label_PrizeName.textColor = KUIColorFromRGB(0x17323f);
        _label_PrizeName.textAlignment = NSTextAlignmentCenter;
        _label_PrizeName.text = str_PrizeName;
        [_imgView_Back addSubview:_label_PrizeName];
        
        [_label_PrizeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_Winner.mas_bottom).offset(5);
            make.centerX.equalTo(_label_Winner.mas_centerX);
            make.width.mas_equalTo(float_PrizeName_Width);
            make.height.mas_equalTo(size_PrizeName.height);
        }];
        
        /// 装饰文字
        _imgView_Winner = [[UIImageView alloc]init];
        _imgView_Winner.image = [UIImage imageNamed:@"guaika_video_img_zhuangshi"];
        [_imgView_Back addSubview:_imgView_Winner];
        
        [_imgView_Winner mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view_Lottery_Back);
            make.top.equalTo(_imgView_Back).offset(26);
            make.height.equalTo(_imgView_Back).multipliedBy(0.285);
        }];
        
        /// 取消按钮背景,加大触控
        _view_CancelBtn_Back = [[UIView alloc]init];
        _view_CancelBtn_Back.backgroundColor = [UIColor clearColor];
        _view_CancelBtn_Back.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_CloseView = [[UITapGestureRecognizer alloc]initWithTarget:view_Lottery_Back action:@selector(closeView)];
        [_view_CancelBtn_Back addGestureRecognizer:tap_CloseView];
        [_imgView_Back addSubview:_view_CancelBtn_Back];
        
        [_view_CancelBtn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imgView_Back.mas_right).offset(-7);
            make.centerY.equalTo(_imgView_Back.mas_top).offset(7);
            make.width.height.mas_equalTo(@80);
        }];
        
        /// 关闭按钮
        _button_Cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_n"] forState:UIControlStateNormal];
        [_button_Cancel setImage:[UIImage imageNamed:@"guaika_video_btn_close_h"] forState:UIControlStateHighlighted];
        [_button_Cancel addTarget:view_Lottery_Back action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_imgView_Back addSubview:_button_Cancel];
        
        [_button_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_view_CancelBtn_Back);
            make.width.height.mas_equalTo(@50);
        }];
        
        /// 下方按钮
        _button_Down = [UIButton buttonWithType:UIButtonTypeCustom];
        _button_Down.tag = 105;
        [_button_Down setImage:[UIImage imageNamed:@"btn_guaika_hjq_qr_n"] forState:UIControlStateNormal];
        [_button_Down setImage:[UIImage imageNamed:@"btn_guaika_hjq_qr_h"] forState:UIControlStateHighlighted];
        [_button_Down addTarget:view_Lottery_Back action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_imgView_Back addSubview:_button_Down];
        
        [_button_Down mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_imgView_Back).offset(-12);
            make.centerX.equalTo(_imgView_Back.mas_centerX);
        }];
        
        /// 提示文字
        NSString *str_Prompt = [NSString stringWithFormat:@"请牢记以上兑换码,下载\"%@\"APP,兑换使用",_model_Geek.appName];
        CGSize size_Prompt = [WX_ToolClass changeSizeWithString:str_Prompt FontOfSize:10 bold:ENUM_NormalSystem];
        CGFloat width_Prompt = size_Prompt.width+10;
        
        _label_Prompt = [[UILabel alloc]init];
        _label_Prompt.text = str_Prompt;
        _label_Prompt.font = [UIFont boldSystemFontOfSize:10];
        _label_Prompt.textColor = KUIColorFromRGB(0xfe7e73);
        _label_Prompt.textAlignment = NSTextAlignmentCenter;
        [_imgView_Back addSubview:_label_Prompt];
        
        [_label_Prompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imgView_Back.mas_centerX);
            make.width.mas_equalTo(width_Prompt);
            make.height.mas_equalTo(size_Prompt.height);
            make.bottom.equalTo(_button_Down.mas_top).offset(-15);
        }];
        
        /// 兑换码背景框
        _view_TexrtFied_Back = [[UIView alloc]init];
        _view_TexrtFied_Back.backgroundColor = KUIColorFromRGB(0xeeeeee);
        _view_TexrtFied_Back.layer.masksToBounds = YES;
        _view_TexrtFied_Back.layer.cornerRadius = 10;
        [_imgView_Back addSubview:_view_TexrtFied_Back];
        
        [_view_TexrtFied_Back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView_Back.mas_left).offset(10);
            make.right.equalTo(_imgView_Back.mas_right).offset(-10);
            //            make.centerY.equalTo(_imgView_Back).offset(-15);
            make.height.mas_equalTo(@40);
            make.bottom.equalTo(_label_Prompt.mas_top).offset(-9);
        }];
        
        
        /// 兑换码
        _str_CDKey = _model_Geek.prizeName;
        NSString *str_CDKey = [NSString stringWithFormat:@"兑换码: %@",_str_CDKey];
        _label_CDKey = [[UILabel alloc]init];
        _label_CDKey.text = str_CDKey;
        _label_CDKey.font = [UIFont systemFontOfSize:15];
        _label_CDKey.textAlignment = NSTextAlignmentCenter;
        _label_CDKey.textColor = KUIColorFromRGB(0x999999);
        _label_CDKey.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_Copy = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(copyCFKey)];
        [_label_CDKey addGestureRecognizer:tap_Copy];
        [_imgView_Back addSubview:_label_CDKey];
        
        [_label_CDKey mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view_TexrtFied_Back).offset(10);
            make.right.equalTo(_view_TexrtFied_Back).offset(-10);
            make.top.bottom.equalTo(_view_TexrtFied_Back);
            
        }];
        
        _pasteboard_CDKey = [UIPasteboard generalPasteboard];
        _pasteboard_CDKey.string = _str_CDKey;
        
        /// 不存在 展示图片
        
        [UIView animateWithDuration:1.45f animations:^{
            
            _imgView_Back.layer.transform = CATransform3DMakeScale(.45f, .45f, 1.f);
            [UIView animateWithDuration:1.25f animations:^{
                _imgView_Back.layer.transform = CATransform3DIdentity;
            }];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.45f animations:^{
                
                _imgView_Back.layer.transform = CATransform3DMakeScale(.45f, .45f, 1.f);
                [UIView animateWithDuration:1.25f animations:^{
                    _imgView_Back.layer.transform = CATransform3DIdentity;
                }];
            } completion:^(BOOL finished) {
                
                if (_pasteboard_CDKey.string.length) {
                    
                    [view_Lottery_Back showAndHideHUDWithTitle:@"已复制到剪贴板" WithState:BYC_MBProgressHUDHideProgress];
                }else{
                    [view_Lottery_Back showAndHideHUDWithTitle:@"复制异常,请重试" WithState:BYC_MBProgressHUDHideProgress];
                }
                
            }];
        }];
    }
    
    
}

/// 长按复制
-(void)copyCFKey
{
    _pasteboard_CDKey.string = @"";
    _pasteboard_CDKey.string = _str_CDKey;

    if (_pasteboard_CDKey.string.length) {
        
        [view_Lottery_Back showAndHideHUDWithTitle:@"已复制到剪贴板" WithState:BYC_MBProgressHUDHideProgress];
    }else{
        [view_Lottery_Back showAndHideHUDWithTitle:@"复制异常,请重试" WithState:BYC_MBProgressHUDHideProgress];
    }
}


/// 恢复主背景页面约束
-(void)restoreBackViewConstraint
{
    [view_Lottery_Back mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.bottom.equalTo([UIApplication sharedApplication].keyWindow);
    }];
}
#pragma mark --------- 代理
/// UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (toBeString.length > 11) {
        return NO;
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    _str_PhoneNum = textField.text;
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _str_PhoneNum = textField.text;

    if (_str_PhoneNum.length > 11) {
        _str_PhoneNum = [_str_PhoneNum substringFromIndex:11];
    }
    
    if (![BYC_Tool isMobileNumber:_str_PhoneNum]) {
        [view_Lottery_Back showAndHideHUDWithTitle:@"请输入正确的手机号码" WithState:BYC_MBProgressHUDHideProgress];
        _is_PhoneNum = NO;
    }else{
        _is_PhoneNum = YES;
    }
}

#pragma mark -------- 键盘遮罩
//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    /// 获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    /// 计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = kbHeight/3 +INTERVAL_KEYBOARD;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    /// 将视图上移计算好的偏移
    if(offset > 0){
        [view_Lottery_Back mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-offset);
            make.right.left.height.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        /// 告诉self.view约束需要更新
        [self setNeedsUpdateConstraints];
        /// 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:duration animations:^{
            [view_Lottery_Back layoutIfNeeded];
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    /// 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    /// 视图下沉恢复原状
    [view_Lottery_Back mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.bottom.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    /// 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    /// 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:duration animations:^{
        [view_Lottery_Back layoutIfNeeded];
    }];

}

/// 创建/移除监听
-(void)createOrRemoveNotifiWith:(BOOL)isCreate
{
    if (isCreate) {
        _isRemoveNotifi = NO;
        QNWSLog(@"创建监听");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    }else{
        _isRemoveNotifi = YES;
        QNWSLog(@"移除监听");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    }
}
-(void)dealloc
{
    if (!_isRemoveNotifi) {
        [self createOrRemoveNotifiWith:NO];
    }
    NSLog(@"%s 关闭",__func__);
}

@end
