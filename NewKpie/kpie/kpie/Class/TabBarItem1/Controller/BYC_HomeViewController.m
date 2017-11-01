//
//  BYC_HomeViewController.m
//  kpie
//
//  Created by 元朝 on 15/10/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_HomeViewController.h"
#import "BYC_AusleseViewController.h"
#import "BYC_ChannelViewController.h"
#import "BYC_AdvertisementHandler.h"
#import "BYC_HttpServers+HomeVC.h"

@interface BYC_HomeViewController ()

/**精选控制器*/
@property (nonatomic, strong)  BYC_AusleseViewController *ausleseVC;

@end

@implementation BYC_HomeViewController

#pragma mark - 本类系统相关方法(包括自定义的初始化方法)

- (void)viewDidLoad {
    [super viewDidLoad];
    //处理广告
    [BYC_AdvertisementHandler handleOfAdvertisement];
    //初始化参数
    [self initParam];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //处理广告
    [BYC_AdvertisementHandler viewWillAppearShowAD];
}

#pragma mark - 初始化子视图及参数

- (void)initParam {
    
    if (self.arr_Items.count == 0) {
        
        _ausleseVC = [[BYC_AusleseViewController alloc] initWithBlock:^(NSArray <BYC_MotifModel *> *arr_MotifModels){
            //需要设置主题
            NSMutableArray *mArr_Temp = [self.arr_Items mutableCopy];
            
            for (BYC_MotifModel *model_Temp in arr_MotifModels) {
                
                BYC_BaseViewController *vc;
                switch (model_Temp.motifmode) {
                    case ENUM_MotifModeOld: {//未知频道
                        vc = [[BYC_BaseViewController alloc] init];
                        break;
                    }
                    case ENUM_MotifModeNew: {
                        
                        vc = [[BYC_ChannelViewController alloc] initWithMotifModel:model_Temp andWithChannelDataModel:nil];
                        break;
                    }
                }
                
                [mArr_Temp addObject:@{model_Temp.motifname:vc}];
            }
            
            self.arr_Items = [mArr_Temp copy];
        }];
        
        self.arr_Items = @[@{@"精选":_ausleseVC}];
    }
}


#pragma mark - 属性的get 及 set 方法

#pragma mark - 网络请求数据

#pragma mark - UIScrollView 以及其子类的数dataSource和delegate

#pragma mark - 其它系统类的代理（例如UITextFieldDelegate,UITextViewDelegate等）

#pragma mark - 自定义类的代理

#pragma mark - 本类创建的的相关方法（不是本类系统的方法）




@end
