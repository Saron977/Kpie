//
//  BYC_PersonalViewController.m
//  kpie
//
//  Created by 元朝 on 16/6/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_PersonalViewController.h"
#import "HL_PersonalView.h"
#import "HL_PersonalTableViewCell.h"
#import "BYC_MainNavigationController.h"

#import "BYC_ShowHeaderImageViewController.h"
#import "BYC_PersonalDataViewController.h"
#import "HL_CenterViewController.h"

#import "WX_DraftBoxViewController.h"
#import "WX_MaterialLibraryViewController.h"
#import "BYC_LeftLikeViewController.h"

#import "BYC_LeftMassegeViewController.h"
#import "BYC_LeftIntegralViewController.h"
#import "BYC_SkillViewController.h"

#import "BYC_SettingViewController.h"

#import "WX_MyMovieViewController.h"
#import "BYC_LeftFocusViewController.h"

#import "BYC_UMengShareTool.h"
#import "BYC_LoginAndRigesterView.h"
#import "BYC_AccountTool.h"
#import "BYC_AccountModel.h"
#import "HL_MyFansVC.h"
#import "BYC_HttpServers+HL_PersonalVC.h"

#import "BYC_MyCenterHandler.h"

@interface BYC_PersonalViewController ()<UITableViewDelegate, UITableViewDataSource,personalViewButtonActionDelegate>

@property (nonatomic, strong) UITableView         *tableView;
@property (nonatomic, strong) HL_PersonalView     *personalView;       /**<   表头*/
@property (nonatomic, strong) NSArray             *personalArr;        /**<   存放分类名*/
@property (nonatomic, strong) NSArray             *personalIconArr;    /**<    存放分类Icon*/
@property (nonatomic, strong) BYC_AccountModel    *userInfoModel;  /**<   用户信息*/

@end

@implementation BYC_PersonalViewController

-(NSArray *)personalArr{
    if (!_personalArr) {
        _personalArr = @[@[@"草稿箱",@"素材库",@"赞过的视频"],@[@"我的消息",@"快速升级",@"看拍技巧"],@[@"设置"]];
    }
    return _personalArr;
}

-(NSArray *)personalIconArr{
    if (!_personalIconArr) {
        _personalIconArr = @[@[@"wode_icon_cgx_n",@"wode_icon_sck_n",@"wode_icon_zgdsp_n"],@[@"wode_icon_xiaoxi_n",@"wode_icon_kssj_n",@"wode_icon_kpjq_n"],@[@"wode_icon_shezhi_n"]];
    }
    return _personalIconArr;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setCustomNavBar];
        
    }
    return self;
}


-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{  
    [super viewWillAppear:animated];
    [self createHeaderUI];
    [self getUserInfoData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark ------获取用户信息
-(void)getUserInfoData{
    self.userInfoModel = [BYC_AccountTool userAccount];
    [self reloadUserInfo];
}
- (void)reloadUserInfo {
    
    //获取个人信息
    //loadType:   0--默认加载  1--作品  2--关注  3--粉丝
    //toUserId:   他人主页-----他人的UserId    个人主页 ----self.userInfoModel.userid
    //upType:     0--默认   1--下拉  2--上拉
    //userid     登陆用户Id   self.userInfoModel.userid
    [self requestDataWithUrlWithParameters:@{@"loadType":@0,@"toUserId":self.userInfoModel.userid,@"upType":@0,@"userId":self.userInfoModel.userid} completion:nil];
}
- (void)requestDataWithUrlWithParameters:(id)parameters completion:(void(^)(BOOL success))completion{
    [BYC_HttpServers requestPersonalVCDataWithParameters:parameters success:^(BYC_MyCenterHandler *handler) {
    
        self.userInfoModel.userInfo.videos = handler.model_User.userInfo.videos;
        self.userInfoModel.userInfo.fans   = handler.model_User.userInfo.fans;
        self.userInfoModel.userInfo.focus  = handler.model_User.userInfo.focus;
        [BYC_AccountTool saveAccount:self.userInfoModel];//操作后的归档
        self.personalView.userInfoModel = self.userInfoModel;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -----自定义NaVBar
-(void)setCustomNavBar{
    UIView *navTitleBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, KHeightNavigationBar)];
    navTitleBgView.backgroundColor = KUIColorBaseGreenNormal;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-50, 20, 100, 44)];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];//KUIColorFromRGB(0XFFFFFF);
    titleLab.text = @"我";
//    titleLab.alpha = 0.7;
    [navTitleBgView addSubview:titleLab];
    [self.view addSubview:navTitleBgView];
}
#pragma mark ------UI
-(void)createHeaderUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight-100) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.personalView = [[HL_PersonalView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 140)];
    self.tableView.backgroundColor = KUIColorBackground;
    self.tableView.tableHeaderView = self.personalView;
    self.tableView.tableHeaderView.backgroundColor = KUIColorFromRGB(0xFCFCFC);
    self.personalView.delegate =self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HL_PersonalTableViewCell class] forCellReuseIdentifier:@"personalCell"];
    [self.view addSubview:self.tableView];
    
}

#pragma mark ----- 头部各按钮的点击事件
-(void)personalButtonAction:(id)sender{
    if (sender == self.personalView.tap) {//点击头像
        BYC_ShowHeaderImageViewController *showHeaderImageVC = [[BYC_ShowHeaderImageViewController alloc] init];
        showHeaderImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        showHeaderImageVC.imageUrl = self.userInfoModel.headportrait;
        [self presentViewController:showHeaderImageVC animated:YES completion:nil];
        
    }else if (sender == self.personalView.button_Edit){//编辑资料
        
        BYC_PersonalDataViewController *editVC = [[BYC_PersonalDataViewController alloc]init];
        [KMainNavigationVC pushViewController:editVC animated:YES];
    }else if (sender == self.personalView.button_myCenter){
        HL_CenterViewController *myCenterVC = [[HL_CenterViewController alloc]init];
//        myCenterVC.isFromLeftHeader = YES;
        [KMainNavigationVC pushViewController:myCenterVC animated:YES];
        
    }else if (sender == self.personalView.button_Work){//作品
        WX_MyMovieViewController *myWorksVC = [[WX_MyMovieViewController alloc]init];
        [KMainNavigationVC pushViewController:myWorksVC animated:YES];
        
    }
//    else if(sender == self.personalView.button_Forward){}//转发
    else if (sender == self.personalView.button_Follow){//关注
        BYC_LeftFocusViewController *focusVC =[[BYC_LeftFocusViewController alloc]init];
        [KMainNavigationVC pushViewController:focusVC animated:YES];
        
    }else if (sender == self.personalView.button_Fans){//粉丝
        HL_MyFansVC *myFansVC = [[HL_MyFansVC alloc]init];
        [KMainNavigationVC pushViewController:myFansVC animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.personalArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) return 3;
    else return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HL_PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
    cell.selectedBackgroundView.backgroundColor = KUIColorFromRGB(0xE5E5E5);
    switch (indexPath.section) {
        case 0:
            cell.personalStr = self.personalArr[0][indexPath.row];
            cell.personalIcoStr = self.personalIconArr[0][indexPath.row];
            if (indexPath.row == 2) {
                cell.H_spiteLine.hidden = YES;
            }

            break;
         case 1:
            cell.personalStr = self.personalArr[1][indexPath.row];
            cell.personalIcoStr = self.personalIconArr[1][indexPath.row];
            
            
            if (indexPath.row == 0) {
                if (QNWSUserDefaultsValueForKey(KSTR_KMsgAndNotRed)) {[cell exeAddRedView];}
                [QNWSNotificationCenter addObserverForName:KNotification_Comment object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                    [cell exeAddRedView];
                }];
                [QNWSNotificationCenter addObserverForName:KNotification_TeacherComments object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                    [cell exeAddRedView];
                }];
                
                [QNWSNotificationCenter addObserverForName:KNotification_HideRedPoint object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                    [cell exeRemoveRedView];
                }];
            }
            if (indexPath.row == 2) {
                cell.H_spiteLine.hidden = YES;
            }
            break;
            case 2:
            cell.personalStr = self.personalArr[2][indexPath.row];
            cell.personalIcoStr = self.personalIconArr[2][indexPath.row];
            cell.H_spiteLine.hidden = YES;
            break;
        default:
            break;
    }
return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HL_PersonalTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {//草稿箱
                WX_DraftBoxViewController *draftBoxVC = [[WX_DraftBoxViewController alloc]init];
                [KMainNavigationVC pushViewController:draftBoxVC animated:YES];
            }
            else if (indexPath.row == 1){//素材库
                WX_MaterialLibraryViewController *materialLibraryVC = [[WX_MaterialLibraryViewController alloc]init];
                [KMainNavigationVC pushViewController:materialLibraryVC animated:YES];
            }
            else{//赞过的视频
                BYC_LeftLikeViewController *likedVideoVC = [[BYC_LeftLikeViewController alloc]init];
                [KMainNavigationVC pushViewController:likedVideoVC animated:YES];
            }
            break;
        case 1:
            if (indexPath.row == 0) {//我的消息                
                [cell exeRemoveRedView];
                BYC_LeftMassegeViewController *massageVC =[[BYC_LeftMassegeViewController alloc]init];
                [KMainNavigationVC pushViewController:massageVC animated:YES];
                
            }
            else if (indexPath.row == 1){//快速升级
                BYC_LeftIntegralViewController *integralVC = [[BYC_LeftIntegralViewController alloc]init];
                [KMainNavigationVC pushViewController:integralVC animated:YES];
            }
            else{//看拍技巧
                BYC_SkillViewController *skillVC = [[BYC_SkillViewController alloc]init];
                [KMainNavigationVC pushViewController:skillVC animated:YES];
            }
            break;
        default:{//设置
            BYC_SettingViewController *settingVC = [[BYC_SettingViewController alloc] init];
            [KMainNavigationVC pushViewController:settingVC animated:YES];
        }
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    headerView.backgroundColor = KUIColorFromRGB(0xF0F0F0);
    return headerView;
}

@end
