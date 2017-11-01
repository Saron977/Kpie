//
//  BYC_ChannelViewController.m
//  kpie
//
//  Created by 元朝 on 16/7/4.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ChannelViewController.h"
#import "BYC_BaseChannelViewController.h"
#import "BYC_HttpServers+BYC_MotifData.h"
#import "BYC_ScrollSubtitleView.h"

@interface BYC_ChannelViewController()

/**主题模型*/
@property (nonatomic, strong)  BYC_MotifModel  *model_Motif;
/**频道数据，在第一次请求网络的时候顺带一起请求下来的全部数据*/
@property (nonatomic, strong)  BYC_BaseChannelModels *models_BaseChannel;

@end

@implementation BYC_ChannelViewController

#pragma mark - 本类系统相关方法(包括自定义的初始化方法)

- (instancetype)initWithMotifModel:(BYC_MotifModel *)motifModel andWithChannelDataModel:(BYC_BaseChannelDataModel *)channelDataModel{
    
    self = [super init];
    if (self) {
        [self initParams];
        self.model_Motif = motifModel;
        if (channelDataModel !=nil) {
        self.selectIndex = channelDataModel.number-1;
        }
        [self requestData];
    }
    return self;
}

#pragma mark - 初始化子视图及参数

- (void)initParams {

    //网络不好的时候，需要重新刷新数据
    [QNWSNotificationCenter addObserver:self selector:@selector(requestData) name:nil object:self];
}
#pragma mark - 属性的get 及 set 方法

#pragma mark - 网络请求数据


- (void)requestData {
    
    //因为这个类是共有的类，所以通知触发之后若不判断也会造成 不同模块的这个类 在有数据的情况下又进行了一次网络请求。
    if (_models_BaseChannel.arr_ChannelDataModels.count == 0) [self requestChannelListData];
}

//频道第一次初始化的时候获取下第一个栏目的全部数据
- (void)requestChannelListData {
    
    [BYC_HttpServers requestMotifDataWithParameters:@{@"motifId":_model_Motif.motifid,@"sortBy":@0,@"sortType":@0,@"upType":@0} success:^(AFHTTPRequestOperation *operation, NSArray<BYC_MotifModel *> *arr_MotifModels, BYC_BaseChannelModels *models) {
        
        self.models_BaseChannel = models;
        
    } failure:nil];
}

#pragma mark - UIScrollView 以及其子类的数dataSource和delegate

#pragma mark - 其它系统类的代理（例如UITextFieldDelegate,UITextViewDelegate等）

#pragma mark - 自定义类的代理

#pragma mark - 本类创建的的相关方法（不是本类系统的方法）
//所有频道数据
-(void)setModels_BaseChannel:(BYC_BaseChannelModels *)models_BaseChannel {

    _models_BaseChannel = models_BaseChannel;
    _models_BaseChannel.model_Motif = _model_Motif;
    // 添加所有子控制器
    [self setUpAllViewController];
    //添加完毕重置子视图
    [self resetSubViews];
}

// 添加所有子控制器 每个频道下的分类
- (void)setUpAllViewController
{
        int i = 0;
        for (BYC_BaseChannelDataModel *model in _models_BaseChannel.arr_ChannelDataModels) {
            
            BYC_BaseChannelViewController *vc = [[BYC_BaseChannelViewController alloc] init];
            vc.title                 = model.channelname;
            [vc setModels_BaseChannel:_models_BaseChannel index:i];
            [self addChildViewController:vc];
            ++i;
        }
}
@end
