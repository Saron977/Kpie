//
//  BYC_CommonViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/16.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_CommonViewController.h"
#import "WX_FMDBManager.h"
#import "BYC_AboutKpieViewController.h"
#import "BYC_ImageFromColor.h"

@interface BYC_CommonViewController()

@property (weak, nonatomic) IBOutlet UIButton *button_Protocol;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_AboutKpie;
@property (weak, nonatomic) IBOutlet UILabel *label_AboutKpie;

@property (weak, nonatomic) IBOutlet UISwitch *switch_Control;


@end

@implementation BYC_CommonViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = @"通用";
    _switch_Control.on = QNWSUserDefaultsObjectForKey(KSTR_KNetwork_IsWiFi) == nil ? NO : YES;
    [_button_Protocol setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
}

- (IBAction)NetWorkingState:(id)sender {
    UISwitch *wifiSwitch = (UISwitch *)sender;

    QNWSUserDefaultsSetObjectForKey(wifiSwitch.isOn == YES ? @(wifiSwitch.isOn) : nil, KSTR_KNetwork_IsWiFi);
    NSMutableDictionary *md = [NSMutableDictionary dictionary];

}

- (IBAction)buttonAction:(UIButton *)sender {
    
    _label_AboutKpie.textColor = sender.tracking == 0 || sender.state == 0 ? KUIColorWordsBlack1 : KUIColorBaseGreenNormal;
     _imageV_AboutKpie.image = sender.tracking == 0 || sender.state == 0 ? [UIImage imageNamed:@"wode_icon_xiayibu_n"] : [UIImage imageNamed:@"icon-jr-h"];
    _imageV_AboutKpie.mj_size = sender.tracking == 0 || sender.state == 0 ? CGSizeMake(16, 16) : CGSizeMake(8, 16);
    
    if (sender.tracking == 0 && sender.highlighted == 1) {

        BYC_AboutKpieViewController *aboutKpieVC = [[BYC_AboutKpieViewController alloc] init];
        [self.navigationController pushViewController:aboutKpieVC animated:YES];
    }

}
@end
