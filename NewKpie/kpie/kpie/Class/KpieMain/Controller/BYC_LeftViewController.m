//
//  BYC_LeftViewController.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LeftViewController.h"
#import "BYC_SettingViewController.h"
#import "HL_CenterViewController.h"
#import "BYC_LoginAndRigesterView.h"
#import "BYC_AccountTool.h"
#import "BYC_SkillViewController.h"
#import "WX_DraftBoxViewController.h"
#import "WX_MaterialLibraryViewController.h"
#import "WX_MyMovieViewController.h"
#import "BYC_UMengShareTool.h"
#import "BYC_SetBackgroundColor.h"
#import "BYC_MainNavigationController.h"
#import "BYC_LeftFocusViewController.h"
#import "BYC_LeftLikeViewController.h"
#import "BYC_LeftMassegeViewController.h"
#import "BYC_LeftTableViewCell.h"
#import "BYC_LeftIntegralViewController.h"

@interface BYC_LeftViewController ()<UITableViewDataSource,UITableViewDelegate> {

    UIImageView *_view_CornerMask;//消息红点标识
}

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Header;
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (weak, nonatomic) IBOutlet UILabel *label_NickName;

@property (strong, nonatomic) NSArray *arrayCellTitle;
@property (strong, nonatomic) NSArray *arrayCellImageN;
@property (nonatomic, strong) NSArray *arrayCellImageH;


@end

@implementation BYC_LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[BYC_SetBackgroundColor alloc] setBackgroundViewColor:self];
    //初始化子视图
    [self initViews];
    
}

- (void)initViews {

    _settingTableView.showsVerticalScrollIndicator = NO;
    
    _imageV_Header.layer.borderWidth = 2.0f;
    _imageV_Header.layer.borderColor=KUIColorFromRGB(0X085E6D).CGColor;
    _imageV_Header.layer.masksToBounds = YES;
    _imageV_Header.layer.cornerRadius = 85 / 2.0f;
    _arrayCellTitle =  @[@[@"作品", @"草稿箱", @"素材库"], @[@"消息", @"关注", @"喜欢",@"快速升级"]];
    _arrayCellImageN = @[@[@"icon-dp-n", @"icon-cgx-n", @"icon-sck-n"], @[@"icon-xx-n", @"icon-hy-n", @"icon-leftlike-n", @"icon-kssj-n"]];
    _arrayCellImageH = @[@[@"icon-dp-h", @"icon-cgx-h", @"icon-sck-h"], @[@"icon-xx-h", @"icon-hy-h", @"icon-leftlike-h", @"icon-kssj-h"]];
    
    if ([BYC_AccountTool userAccount]) {
        BYC_AccountModel *userModel = [BYC_AccountTool userAccount];
        _label_NickName.text = [NSString stringWithFormat:@"%@",userModel.nickname];
        [_imageV_Header sd_setImageWithURL:[NSURL URLWithString:userModel.headportrait] placeholderImage:nil];
    }
    [QNWSNotificationCenter addObserver:self selector:@selector(kLoginSuccessed:) name:KSTR_KLoginSuccessed object:nil];
    [QNWSNotificationCenter addObserver:self selector:@selector(kCommentName:) name:KNotification_Comment object:nil];

}

- (void)kLoginSuccessed:(NSNotification *)notification {
    
    BYC_AccountModel *userModel = notification.object;
    if (userModel.headportrait.length > 0) {
        
        _label_NickName.text = [NSString stringWithFormat:@"%@",userModel.nickname];
        [_imageV_Header sd_setImageWithURL:[NSURL URLWithString:userModel.headportrait] placeholderImage:nil];
    }else {
        
        _imageV_Header.image = [UIImage imageNamed:@"icon-tx-170"];
        _label_NickName.text = [NSString stringWithFormat:@"登录"];
    }

}

- (void)kCommentName:(NSNotification *)notification {

    _view_CornerMask.hidden = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _arrayCellTitle.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ((NSArray *)_arrayCellTitle[section]).count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    BYC_LeftTableViewCell *cell = (BYC_LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"BYC_LeftTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }

    if (indexPath.section == 1 && indexPath.row == 0) {
        
        _view_CornerMask = cell.imageV_CornerMask;
    }
    cell.label_Title.text = ((NSArray *)_arrayCellTitle[indexPath.section])[indexPath.row];
    cell.imageV_Header.image = [UIImage imageNamed:((NSArray *)_arrayCellImageN[indexPath.section])[indexPath.row]];
    cell.imageV_Header.highlightedImage = [UIImage imageNamed:((NSArray *)_arrayCellImageH[indexPath.section])[indexPath.row]];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return .5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return .5f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, .5f)];
    lineImageView.image = [UIImage imageNamed:@"image-fgx"];
    
    return lineImageView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    //未登录跳转去登录
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                WX_MyMovieViewController *myMovieVC = [[WX_MyMovieViewController alloc]init];
                [KMainNavigationVC pushViewController:myMovieVC animated:YES];
                
            }else if (indexPath.row == 1){
                WX_DraftBoxViewController *draftBoxVC = [[WX_DraftBoxViewController alloc]init];
                [KMainNavigationVC pushViewController:draftBoxVC animated:YES];
                
            }else if (indexPath.row == 2){
                WX_MaterialLibraryViewController *materialVC = [[WX_MaterialLibraryViewController alloc]init];
                [KMainNavigationVC pushViewController:materialVC animated:YES];
                
            }
        }else {
            
            if (indexPath.row == 0) {
                BYC_LeftMassegeViewController *leftMassegeVC = [[BYC_LeftMassegeViewController alloc]init];
                _view_CornerMask.hidden = YES;
                [KMainNavigationVC pushViewController:leftMassegeVC animated:YES];
                
            }else if (indexPath.row == 1){
                BYC_LeftFocusViewController *leftFocusVC = [[BYC_LeftFocusViewController alloc]init];
                [KMainNavigationVC pushViewController:leftFocusVC animated:YES];
                
            }else if (indexPath.row == 2){
                BYC_LeftLikeViewController *leftLikeVC = [[BYC_LeftLikeViewController alloc]init];
                [KMainNavigationVC pushViewController:leftLikeVC animated:YES];
                
            }else if (indexPath.row == 3){
                BYC_LeftIntegralViewController *leftLikeVC = [[BYC_LeftIntegralViewController alloc]init];
                [KMainNavigationVC pushViewController:leftLikeVC animated:YES];
                
            }
        }
    }];
    
}


- (IBAction)techniqueAction:(UIButton *)sender {

    BYC_SkillViewController *skillVC = [[BYC_SkillViewController alloc] init];
    
    [KMainNavigationVC pushViewController:skillVC animated:YES];
}

- (IBAction)settingsAction:(UIButton *)sender {
    
    //未登录跳转去登录
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        BYC_SettingViewController *settingVC = [[BYC_SettingViewController alloc] init];
        [KMainNavigationVC pushViewController:settingVC animated:YES];
    }];

}

- (IBAction)personCenterAction:(UIButton *)sender {
    
    //未登录跳转去登录
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        HL_CenterViewController *myCenterVC = [[HL_CenterViewController alloc] init];
        [KMainNavigationVC pushViewController:myCenterVC animated:YES];
    }];
    
}

@end
