//
//  WX_GeekActiveView.m
//  kpie
//
//  Created by 王傲擎 on 16/8/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_GeekActiveView.h"
#import "WX_ToolClass.h"
#import "WX_DrawLotteryView.h"
#import "BYC_LoginAndRigesterView.h"

static WX_GeekActiveView   *view_MainBack; /**< 图层_主背景界面 */

@interface WX_GeekActiveView()
@property (nonatomic, strong) UIImageView                               *imgView_Back;      /**< 图片_背景界面 */
@property (nonatomic, strong) UILabel                                   *label_Rank;        /**< 排行榜 */
@property (nonatomic, strong) UILabel                                   *label_Votes;       /**< 票数 */
@property (nonatomic, strong) UIButton                                  *button_Votes;      /**< 按钮_投票 */
@property (nonatomic, strong) UIButton                                  *button_Entry;      /**< 按钮_参赛 */
@property (nonatomic, strong) WX_GeekModel                              *model_Geek;        /**< 怪咖模型 */
@property (nonatomic, strong) UIViewController                          *controller;        /**<   参与拍摄_附带controller */
@property (nonatomic, strong) BYC_InStepCollectionViewCellModel         *model_InStep;      /**< 视频用户模型 */
@property (nonatomic, assign) BOOL                                      isRemoveNotifi;     /**<   是否移除监听 */

@end
@implementation WX_GeekActiveView

/// 展示活动界面
+(void)showGeekActiveViewAddToView:(UIView *)view withViewController:(UIViewController *)controller InStepModel:(BYC_InStepCollectionViewCellModel *)model_InStep
{
    if (!view_MainBack) {
        view_MainBack = [[WX_GeekActiveView alloc]init];
        [view addSubview:view_MainBack];
        
        [view_MainBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(view);
            make.height.mas_equalTo(57);
        }];
        [view_MainBack createOrRemoveNotifiWith:YES];
        view_MainBack.model_InStep = model_InStep;
        view_MainBack.controller = controller;
        [view_MainBack createUI];
    }
}

/// 创建ui
-(void)createUI
{
    /// 图片_背景界面
    _imgView_Back = [[UIImageView alloc]init];
    _imgView_Back.image = [UIImage imageNamed:@"img_guaikahuodong_video_hdbg"];
    [view_MainBack addSubview:_imgView_Back];
    
    [_imgView_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(view_MainBack);
    }];
    
    /// 排行榜
    NSString *str_Rank = [NSString stringWithFormat:@"活动排行: 0"];
    CGSize size_Rank  = [WX_ToolClass changeSizeWithString:str_Rank FontOfSize:14 bold:ENUM_BoldSystem];
    CGFloat width_Rank = size_Rank.width +10;
    CGFloat height_Rank =size_Rank.height/2;
    
    _label_Rank = [[UILabel alloc]init];
    _label_Rank.font = [UIFont boldSystemFontOfSize:12];
    _label_Rank.textColor = KUIColorFromRGB(0xffffff);
    _label_Rank.text = str_Rank;
    [view_MainBack addSubview:_label_Rank];
    
    [_label_Rank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view_MainBack).offset(50);
        make.centerY.equalTo(view_MainBack).offset(-height_Rank);
        make.width.mas_equalTo(width_Rank);
    }];
    
    /// 票数
    NSString *str_Votes = [NSString stringWithFormat:@"投票数: 0"];
    CGSize size_Votes  = [WX_ToolClass changeSizeWithString:str_Votes FontOfSize:14 bold:ENUM_BoldSystem];
    CGFloat width_Votes = size_Votes.width +10;
    CGFloat height_Votes =size_Votes.height/2;
    
    _label_Votes = [[UILabel alloc]init];
    _label_Votes.text = str_Votes;
    _label_Votes.font = [UIFont boldSystemFontOfSize:12];
    _label_Votes.textColor = KUIColorFromRGB(0xffffff);
    [view_MainBack addSubview:_label_Votes];
    
    [_label_Votes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label_Rank);
        make.centerY.equalTo(view_MainBack).offset(height_Votes);
        make.width.mas_equalTo(width_Votes);
    }];

    
    /// 按钮_参赛
    _button_Entry = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Entry setBackgroundImage:[UIImage imageNamed:@"icon_guaikahuodong_cansai_n"] forState:UIControlStateNormal];
    [_button_Entry setBackgroundImage:[UIImage imageNamed:@"icon_guaikahuodong_cansai_n"] forState:UIControlStateNormal];
    [_button_Entry addTarget:self action:@selector(clickPushMovieVC) forControlEvents:UIControlEventTouchUpInside];
    [view_MainBack addSubview:_button_Entry];
    
    [_button_Entry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view_MainBack);
        make.right.equalTo(view_MainBack.mas_right).offset(-14);
        make.height.mas_equalTo(@27);
        make.width.mas_equalTo(@67);
    }];
    
    /// 按钮_投票
    _button_Votes = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Votes setBackgroundImage:[UIImage imageNamed:@"icon_guaikahuodong_toupiao_n"] forState:UIControlStateNormal];
    [_button_Votes setBackgroundImage:[UIImage imageNamed:@"icon_guaikahuodong_toupiao_h"] forState:UIControlStateNormal];
    [_button_Votes addTarget:self action:@selector(geekVote) forControlEvents:UIControlEventTouchUpInside];
    [view_MainBack addSubview:_button_Votes];
    
    [_button_Votes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view_MainBack);
        make.right.equalTo(_button_Entry.mas_left).offset(-17);
        make.height.mas_equalTo(@27);
        make.width.mas_equalTo(@67);
    }];
    
}

/// 怪咖投票
-(void)geekVote
{
    [self showAndHideHUDWithTitle:@"活动已结束" WithState:BYC_MBProgressHUDHideProgress];
//    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
//        
//        BYC_AccountModel *model = [BYC_AccountTool userAccount];
//        
//        _model_Geek.userID = model.userid;
//        _model_Geek.str_phoneNum = model.cellphonenumber;
//        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//        //    userVote.userid=$&userVote.videoid=$";
//        [dic setValue:_model_Geek.userID  forKey:@"userVote.userid"];
//        [dic setValue:_model_InStep.videoid forKey:@"userVote.videoid"];
//        
//        [BYC_HttpServers Get:KQNWS_SaveUserVote parameters:dic success:^(AFHTTPRequestOperation *operation,id responseObject) {
//            
//            /// 获取结果
//            NSInteger integer_Result = [(NSNumber*)responseObject[@"result"] integerValue];
//            
//            /// 投票成功_ 信息
//            if (integer_Result == 0) {
//                NSArray *array_List = responseObject[@"list"][0];
//                
//                /// 投票数
//                NSInteger integer_Votes = [(NSNumber*)array_List[4] integerValue];
//                _label_Votes.text = [NSString stringWithFormat:@"投票数: %zi",integer_Votes];
//                
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"SaveUserVote" object:array_List];
//                
//                /// 投票 抽奖
//                if (_model_Geek.bool_VoteDraw) {
//                    
//                    [self clcikEntryWith:ENUM_Video_VoteWithLottery];
//                }
//                
//            }
//            
//            /// 提示是文字
//            NSString *str_Message = responseObject[@"message"];
//            
//            [self showAndHideHUDWithTitle:str_Message WithState:BYC_MBProgressHUDHideProgress];
//            
//        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
//            QNWSLog(@"怪咖投票接口有误,error == %@",error);
//        }];
//    }];
    
    
}

/// 参与按钮
-(void)clickPushMovieVC
{
    [self showAndHideHUDWithTitle:@"活动已结束" WithState:BYC_MBProgressHUDHideProgress];
//    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
//        
//        BYC_AccountModel *model = [BYC_AccountTool userAccount];
//        
//        _model_Geek.userID = model.userid;
//        _model_Geek.str_phoneNum = model.cellphonenumber;
//        
//        [WX_DrawLotteryView showDrawLotteryViewWith:ENUM_Activities_JoinShooting ViewController:_controller GeekModel:_model_Geek];
//    }];
    
}

/// 投票
-(void)clcikEntryWith:(DrawLottery)lotteryType
{
    [WX_DrawLotteryView showDrawLotteryViewWith:lotteryType ViewController:nil GeekModel:_model_Geek];
    
    [QNWSNotificationCenter postNotificationName:@"DrawLotteryMediaStop" object:nil];
    
}

/// 分享成功后调用
-(void)shareToDraw
{
    if (_model_Geek.bool_ShareDraw) {
        
        BYC_AccountModel *model = [BYC_AccountTool userAccount];
        _model_Geek.userID = model.userid;
        _model_Geek.str_phoneNum = model.cellphonenumber;
        [self clcikEntryWith:ENUM_Video_ShareWithLottery];
    }
}

/// 获取模型
-(void)getGeekModel:(NSNotification*)notif
{
    _model_Geek = (WX_GeekModel*)notif.object;
    QNWSLog(@"通知返回模型更新 %@",_model_Geek);
}


/// 设置值
+(void)setGeekActiveViewValueWith:(WX_GeekModel*)model_Geek
{
    view_MainBack.model_Geek = model_Geek;
    view_MainBack.label_Rank.text = [NSString stringWithFormat:@"活动排行: %zi",view_MainBack.model_Geek.integer_Rank];
    view_MainBack.label_Votes.text = [NSString stringWithFormat:@"投票数: %zi",view_MainBack.model_Geek.interger_Votes];
    
}

/// 创建/移除监听
-(void)createOrRemoveNotifiWith:(BOOL)isCreate
{
    if (isCreate) {
        /// 监听 怪咖
        _isRemoveNotifi = NO;
        QNWSLog(@"创建监听");
    
        [QNWSNotificationCenter addObserver:self selector:@selector(shareToDraw) name:@"shareToDraw" object:nil];

        [QNWSNotificationCenter addObserver:self selector:@selector(getGeekModel:) name:@"NSNotification_GeekDrawLottery" object:nil];
        
    }else{
        
        _isRemoveNotifi = YES;
        QNWSLog(@"移除监听");

        [QNWSNotificationCenter removeObserver:self name:@"shareToDraw" object:nil];
        
        [QNWSNotificationCenter removeObserver:self name:@"NSNotification_GeekDrawLottery" object:nil];

    }
}

/// 重置视图
+(void)removeSuperviews
{
    for (UIView *subViews in view_MainBack.subviews) {
        [subViews removeFromSuperview];
    }
    
    [view_MainBack createOrRemoveNotifiWith:NO];
    
    [view_MainBack removeFromSuperview];
    
    view_MainBack = nil;
}

-(void)dealloc
{
    if (!_isRemoveNotifi) {
        [self createOrRemoveNotifiWith:NO];
    }
    QNWSLog(@"%s 释放",__func__);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
