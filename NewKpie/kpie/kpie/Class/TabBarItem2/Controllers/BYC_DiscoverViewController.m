//
//  BYC_DiscoverViewController.m
//  kpie
//
//  Created by 元朝 on 16/6/20.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_DiscoverViewController.h"
#import "BYC_ChannelViewController.h"
#import "BYC_OtherViewController.h"
#import "BYC_HttpServers+HomeVC.h"
#import "BYC_HttpServers+BYC_MotifData.h"
#import "BYC_OtherViewController.h"

@implementation BYC_DiscoverViewController

-(void)viewDidLoad {

    [super viewDidLoad];
    self.isNoCustomNavBar = YES;
    [self initParam];
    //请求数据
    [self requestData];
}

- (void)initParam {
 
    //网络不好的时候，需要重新刷新数据
    [QNWSNotificationCenter addObserver:self selector:@selector(requestData) name:nil object:self];
}

- (void)requestData {
    
     [self requestChannelListData];
}

//发现
- (void)requestChannelListData {
    
    [BYC_HttpServers requestMotifDataWithParameters:@{@"upType":@0} success:^(AFHTTPRequestOperation *operation, NSArray<BYC_MotifModel *> *arr_MotifModels, BYC_BaseChannelModels *models) {
        
        [self setupWith:arr_MotifModels];
        
    } failure:nil];
}

- (void)setupWith:(NSArray<BYC_MotifModel *> *)arr_MotifModels{

    //需要设置主题
    NSMutableArray *mArr_Temp = [self.arr_Items mutableCopy];
    if (!mArr_Temp) mArr_Temp = [NSMutableArray array];
    
    for (BYC_MotifModel *model_Temp in arr_MotifModels) {
        
        BYC_BaseViewController *vc;
        switch (model_Temp.motifmode) {
            case ENUM_MotifModeOld: {
                vc = [[BYC_OtherViewController alloc] initWithMotifModel:model_Temp];
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
}
@end
