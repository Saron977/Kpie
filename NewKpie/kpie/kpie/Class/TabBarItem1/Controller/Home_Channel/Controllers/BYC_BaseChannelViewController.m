//
//  BYC_BaseChannelViewController.m
//  kpie
//
//  Created by 元朝 on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelViewController.h"
#import "BYC_BaseChannelCollectionViewHandler.h"
#import "BYC_HttpServers+HomeVC.h"

@interface BYC_BaseChannelViewController ()

/***/
@property (nonatomic, strong)  BYC_BaseChannelCollectionViewHandler  *handel_BaseChannelCollectionView;
/**在第一次请求网络的时候顺带一起请求下来的全部数据*/
@property (nonatomic, strong) BYC_BaseChannelModels      *models_BaseChannel;
@end

@implementation BYC_BaseChannelViewController

#pragma mark - 本类系统相关方法(包括自定义的初始化方法)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSuViews];
    }
    return self;
}


#pragma mark - 初始化子视图及参数

- (void)initSuViews {
    
    //初始化collectionView
    if (_handel_BaseChannelCollectionView == nil) _handel_BaseChannelCollectionView = [BYC_BaseChannelCollectionViewHandler initBaseChannelCollectionViewHandle:self];
}
#pragma mark - 属性的get 及 set 方法

-(void)setModels_BaseChannel:(BYC_BaseChannelModels *)models_BaseChannel index:(NSUInteger)index{

    _models_BaseChannel = models_BaseChannel;
    [_handel_BaseChannelCollectionView setMotifModels:_models_BaseChannel index:index];
}

#pragma mark - 网络请求数据

#pragma mark - UIScrollView 以及其子类的数dataSource和delegate

#pragma mark - 其它系统类的代理（例如UITextFieldDelegate,UITextViewDelegate等）

#pragma mark - 自定义类的代理

#pragma mark - 本类创建的的相关方法（不是本类系统的方法）
@end
