//
//  BYC_AboutKpieViewController.m
//  kpie
//
//  Created by 元朝 on 16/3/15.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AboutKpieViewController.h"
#import "BYC_UserAgreementViewController.h"

@interface BYC_AboutKpieViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label_Version;

@end

@implementation BYC_AboutKpieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于看拍";
    
    [self getVersion];
}

- (void)getVersion {

    _label_Version.text = [NSString stringWithFormat:@"当前版本：%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

}
- (IBAction)buttonAction:(UIButton *)sender {
  
    BYC_UserAgreementViewController *userAgreementVC = [[BYC_UserAgreementViewController alloc] init];
    [self.navigationController pushViewController:userAgreementVC animated:YES];
}

@end
