//
//  BYC_UserAgreementViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_UserAgreementViewController.h"

@interface BYC_UserAgreementViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView_Content;

@end

@implementation BYC_UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"用户协议";
    
}

-(void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    
    _textView_Content.contentOffset = CGPointMake(0, 0);

}


@end
