//
//  BYC_SettingViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/2.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_SettingViewController.h"
#import "BYC_ImageFromColor.h"
#import "BYC_PersonalDataViewController.h"
#import "BYC_CommonViewController.h"
#import "BYC_AccountTool.h"
#import "WX_FMDBManager.h"

#import "BYC_ShareView.h"
#import "BYC_FindPassWordViewController.h"
#import "BYC_UsingFeedbackViewController.h"
#import "BYC_MainTabBarController.h"

@interface BYC_SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label_CacheNumber;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *button_items;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label_items;


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageV_items;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_ThirdLoginValid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_ThirdLoginUnvalid;

@property (weak, nonatomic) IBOutlet UIView *view_ModifyPassWord;

@property(nonatomic, assign) CGFloat                cacheMedia;
@property(nonatomic, assign) CGFloat                cacheMusic;
@property(nonatomic, assign) CGFloat                cacheVoice;
@property(nonatomic, assign) CGFloat                cacheScript;
@property(nonatomic, assign) CGFloat                cache;
@property(nonatomic, retain) WX_FMDBManager         *manager;

@end

@implementation BYC_SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingbuttonitems];
    self.title = @"设置";
    
}

-(void)viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];
    
    if (QNWSUserDefaultsObjectForKey(KSTR_KThirdLogin)) {//修改密码，先解在安
        
        _view_ModifyPassWord.hidden = YES;
        _constraint_ThirdLoginUnvalid.active = NO;
        _constraint_ThirdLoginValid.active = YES;
    }else {
        
        _view_ModifyPassWord.hidden = NO;
        _constraint_ThirdLoginValid.active = NO;
        _constraint_ThirdLoginUnvalid.active = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self cacheShow];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}
- (void)settingbuttonitems {
    self.manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    for (UIButton *button in _button_items) {
        
        [button setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents: UIControlEventTouchDown | UIControlEventTouchDragOutside];

    }
}

-(void)cacheShow
{
    self.cacheMedia =  [self fileSizeForDir:@"Media"];
    self.cacheMusic = [self fileSizeForDir:@"Music"];
    self.cacheVoice = [self fileSizeForDir:@"Voice"];
    self.cacheScript = [self fileSizeForDir:@"Script"];
    CGFloat cache = self.cacheMedia+self.cacheMusic + self.cacheVoice +self.cacheScript;
//    self.cache = [self fileSizeForDir:@"Voice"];
    self.label_CacheNumber.text = [NSString stringWithFormat:@"%.2f MB",cache];
}


- (IBAction)buttonAction:(UIButton *)sender {
    
    UIColor *color = sender.tracking == 0 || sender.state == 0 ? KUIColorWordsBlack1 : KUIColorBaseGreenNormal;
    UIImage *image = sender.tracking == 0 || sender.state == 0 ? [UIImage imageNamed:@"wode_icon_xiayibu_n"] : [UIImage imageNamed:@"icon-jr-h"];
    CGSize  size   = sender.tracking ==0  || sender.state == 0 ? CGSizeMake(16, 16) : CGSizeMake(8, 16);
    
    switch (sender.tag) {
        case 1://通用
        {
            if (sender.tracking == 0 && sender.highlighted == 1) {
                
                BYC_CommonViewController *commonVC = [[BYC_CommonViewController alloc] init];
                [self.navigationController pushViewController:commonVC animated:YES];
            }
        }
            ((UILabel *)_label_items[sender.tag - 1]).textColor = color;
            ((UIImageView *)_imageV_items[sender.tag - 1]).image = image;
            ((UIImageView *)_imageV_items[sender.tag - 1]).mj_size = size;
            break;
        case 2://个人信息
        {
            if (sender.tracking == 0 && sender.highlighted == 1) {
                
                BYC_PersonalDataViewController *personalDataVC = [[BYC_PersonalDataViewController alloc] init];
                [self.navigationController pushViewController:personalDataVC animated:YES];
            }
        }
            ((UILabel *)_label_items[sender.tag - 1]).textColor = color;
            ((UIImageView *)_imageV_items[sender.tag - 1]).image = image;
            ((UIImageView *)_imageV_items[sender.tag - 1]).mj_size = size;
            break;
        case 3://修改密码
        {
            if (sender.tracking == 0 && sender.highlighted == 1) {

                if (QNWSUserDefaultsObjectForKey(KSTR_KThirdLogin)) {//修改密码，先解在安
                
                    [self.view showAndHideHUDWithDetailsTitle:@"您是通过QQ/微信/微博登录的，无需修改密码" WithState:BYC_MBProgressHUDHideProgress completion:nil];
                }else {
                
                    BYC_FindPassWordViewController *findPassWordVC = [[BYC_FindPassWordViewController alloc] init];
                    [self.navigationController pushViewController:findPassWordVC animated:YES];
                }
            }
        }
            ((UILabel *)_label_items[sender.tag - 1]).textColor = color;
            ((UIImageView *)_imageV_items[sender.tag - 1]).image = image;
            ((UIImageView *)_imageV_items[sender.tag - 1]).mj_size = size;
            break;
            break;
        case 4://使用反馈
        {
            if (sender.tracking == 0 && sender.highlighted == 1) {
                
                BYC_UsingFeedbackViewController *usingFeedbackVC = [[BYC_UsingFeedbackViewController alloc] init];
                [self.navigationController pushViewController:usingFeedbackVC animated:YES];
            }
        }
            ((UILabel *)_label_items[sender.tag - 1]).textColor = color;
            ((UIImageView *)_imageV_items[sender.tag - 1]).image = image;
            ((UIImageView *)_imageV_items[sender.tag - 1]).mj_size = size;
            break;
            break;
        case 5://清除缓存
        {
            if (sender.tracking == 0 && sender.highlighted == 1) {

                [self deleteCache];
                
                self.cacheMedia =  [self fileSizeForDir:@"Media"];
                self.cacheMusic = [self fileSizeForDir:@"Music"];
                self.cacheVoice = [self fileSizeForDir:@"Voice"];
                self.cacheScript = [self fileSizeForDir:@"Script"];
                CGFloat cache = self.cacheMedia + self.cacheMusic + self.cacheVoice + self.cacheScript;
                self.label_CacheNumber.text = [NSString stringWithFormat:@"%.2f MB",cache];
            }
            
        }
            _label_CacheNumber.textColor = color;
            
            ((UILabel *)_label_items[sender.tag - 1]).textColor = color;
            break;
        case 6://邀请好友
        {
            if (sender.tracking == 0 && sender.highlighted == 1)
                [[BYC_ShareView alloc] showWithDelegateVC:self shareContentOrMedia:BYC_ShareTypeText shareWithDic:nil];
            
        }
            ((UILabel *)_label_items[sender.tag - 1]).textColor = color;
            ((UIImageView *)_imageV_items[sender.tag - 2]).image = image;
            ((UIImageView *)_imageV_items[sender.tag - 2]).mj_size = size;
            break;
        case 7://退出登录
        {
            sender.backgroundColor = KUIColorBaseGreenNormal;
            if (sender.tracking == 0 && sender.highlighted == 1) {
                
                [BYC_AccountTool clearUserAccount];
                [self.view showAndHideHUDWithTitle:@"您已成功退出!" WithState:BYC_MBProgressHUDHideProgress completion:^(BOOL finished) {
                    //回到首页
                    KMainTabBarVC.selectedIndex = 0;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }
            
            break;
            
        default:
            break;
    }
}

-(CGFloat)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    /// 计算沙盒 Media文件大小
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mediaPath = [[docArray objectAtIndex:0] stringByAppendingPathComponent:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    CGFloat size = 0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:mediaPath error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [mediaPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
        else {
            [self fileSizeForDir:fullPath];
        }
    }
    return size;
}

-(void)deleteCache
{
    NSString *FMDB_Path;
    for (int i = 0; i < 2; i++) {
        switch (i) {
            case 0:
            {
                FMDB_Path = @"/Voice";
            }
                break;
            case 1:
            {
                FMDB_Path = @"/Script";
                [WX_FMDBManager deleteWithTable:@"Script3"];

            }
                break;
            default:
                break;
        }
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *voicePath = [documentDir stringByAppendingPathComponent:FMDB_Path];
        BOOL isvoiceDelete=[[NSFileManager defaultManager] removeItemAtPath:voicePath error:nil];
        if (isvoiceDelete) {
            QNWSLog(@"沙盒数据清除成功_%@",FMDB_Path);
        }
    }
}

@end
