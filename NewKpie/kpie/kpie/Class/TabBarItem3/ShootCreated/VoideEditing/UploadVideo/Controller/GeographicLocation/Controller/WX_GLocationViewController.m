//
//  WX_GLocationViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_GLocationViewController.h"

@interface WX_GLocationViewController ()

@end

@implementation WX_GLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}

-(void)createUI
{
    self.title = @"选择当前位置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
