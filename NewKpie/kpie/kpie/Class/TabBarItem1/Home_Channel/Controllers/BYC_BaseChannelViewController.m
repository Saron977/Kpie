//
//  BYC_BaseChannelViewController.m
//  kpie
//
//  Created by 元朝 on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelViewController.h"
#import "BYC_BaseChannelCollectionViewHandel.h"
#import "BYC_HttpServers+HomeVC.h"

@interface BYC_BaseChannelViewController ()

/***/
@property (nonatomic, strong)  BYC_BaseChannelCollectionViewHandel  *handel_BaseChannelCollectionView;
@end

@implementation BYC_BaseChannelViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSuViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSuViews];
    }
    return self;
}
- (void)initSuViews {

    //初始化collectionView
    if (_handel_BaseChannelCollectionView == nil) _handel_BaseChannelCollectionView = [BYC_BaseChannelCollectionViewHandel initBaseChannelCollectionViewHandle:self];
}

-(void)setStr_ChannelID:(NSString *)str_ChannelID {
    
    _str_ChannelID =   str_ChannelID;
    [self requestData];
}

- (void)reloadData {

    [self requestData];
}

- (void)requestData {
 
    [BYC_HttpServers requestHomeVCChannelDataWithParameters:@{@"videoColumn.channelid":_str_ChannelID} success:^(NSArray<BYC_OtherViewControllerModel *> *arr_Models) {
        
        _handel_BaseChannelCollectionView.arr_Models = arr_Models;
        
    } failure:nil];
}

@end
