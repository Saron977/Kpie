    //
//  BYC_AusleseViewController.m
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_AusleseViewController.h"
#import "BYC_AusleseVCMainCollectionViewHandler.h"


@interface BYC_AusleseViewController ()

/**设置头部主题*/
@property (nonatomic, strong)  setupHeaderMotifBlock  block_SetupHeaderMotif;
@end
@implementation BYC_AusleseViewController

#pragma mark - 本类系统相关方法(包括自定义的初始化方法)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BYC_AusleseVCMainCollectionViewHandler initAusleseVCMainCollectionViewHandel:self];
}

- (instancetype)initWithBlock:(setupHeaderMotifBlock)block {
    
    self = [super init];
    if (self) {

        _block_SetupHeaderMotif = block;
    }
    return self;
}

- (void)setupMotif:(NSArray <BYC_MotifModel *> *)arr_MotifModels {
    
    NSAssert(_block_SetupHeaderMotif, @"请使用默认初始化方法,传递一个设置主题的block块");
    QNWSBlockSafe(_block_SetupHeaderMotif,arr_MotifModels);
}

@end
