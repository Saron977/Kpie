//
//  BYC_BaseCollectionView.m
//  kpie
//
//  Created by 元朝 on 16/7/9.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseCollectionView.h"

@implementation BYC_BaseCollectionView

//
//+ (instancetype)initBaseChannelCollectionViewHandle:(UIView *)view {
//
//    
//}

- (void)prepareRefresh

{
    
    NSMutableArray *headerImages = [NSMutableArray array];
    
    for (int i = 1; i <= 4; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"topload%d",i]];
        
        [headerImages addObject:image];
        
    }
    
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        //下拉刷新要做的操作.
        
    }];
    
    gifHeader.stateLabel.hidden = YES;
    
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    
    
    [gifHeader setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    
    [gifHeader setImages:headerImages forState:MJRefreshStateRefreshing];
    
    self.header = gifHeader;

    NSMutableArray *footerImages = [NSMutableArray array];
    
    for (int i = 1; i <= 4; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"footerload%d",i]];
        
        [footerImages addObject:image];
        
    }
    
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        //上拉加载需要做的操作.
        
    }];
    
    
    
    gifFooter.stateLabel.hidden = YES;
    
    gifFooter.refreshingTitleHidden = YES;
    
    [gifFooter setImages:@[footerImages[0]] forState:MJRefreshStateIdle];
    
    [gifFooter setImages:footerImages forState:MJRefreshStateRefreshing];
    
    self.footer = gifFooter;
    
}


//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    [KUIColorBaseGreenBlurEffect setFill];
//    UIRectFill(CGRectMake(0, -self.contentInset.top , self.kwidth, KHeightNavigationBar));
//}

//自定义一个方法实现


@end
