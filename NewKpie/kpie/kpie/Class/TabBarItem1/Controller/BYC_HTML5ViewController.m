//
//  BYC_HTML5ViewController.m
//  kpie
//
//  Created by 元朝 on 16/3/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HTML5ViewController.h"


@interface BYC_HTML5ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
/**HTML5网址*/
@property (nonatomic, copy)  NSString  *HTML5String;
@end

@implementation BYC_HTML5ViewController

- (instancetype)initWithHTML5String:(NSString *)HTML5String;
{
    self = [super init];
    if (self) {
        
        _HTML5String = HTML5String;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_HTML5String]]];
    [self.view addSubview:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
@end
