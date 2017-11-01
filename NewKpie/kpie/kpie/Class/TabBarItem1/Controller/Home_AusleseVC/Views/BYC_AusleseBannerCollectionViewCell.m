//
//  BYC_AusleseBannerCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 16/7/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AusleseBannerCollectionViewCell.h"
#import "BYC_BannerControl.h"
#import "BYC_BannerControlModel.h"
#import "BYC_AusleseJumpToVCHandler.h"
@interface BYC_AusleseBannerCollectionViewCell ()

/**轮播banner*/
@property (nonatomic, strong)  BYC_BannerControl  *bannerControl;

@end

@implementation BYC_AusleseBannerCollectionViewCell

-(void)setArr_BannerModels:(NSArray<BYC_BaseVideoModel *> *)arr_BannerModels {

    _arr_BannerModels = arr_BannerModels;
    if (_arr_BannerModels.count > 0) [self setupBanner];
    
}

- (void)setupBanner {
    
    NSMutableArray *mArr_Temp = [NSMutableArray array];
    for (BYC_AusleseVCBannerModel *model_Banner in _arr_BannerModels) {
     
        BYC_BannerControlModel *model = [[BYC_BannerControlModel alloc] init];
        model.str_ImageUrl =  model_Banner.elitetype == 0 || model_Banner.elitetype == 2 ? model_Banner.picturejpg : [model_Banner.picturejpg componentsSeparatedByString:@","][0];
        model.bannerControlShowStyle = model_Banner.elitetype == 0 ? ENUM_BannerControlShowStyleVideo : ENUM_BannerControlShowStyleImage;
        model.str_Title = model_Banner.videotitle;
        [mArr_Temp addObject:model];
    }
    
    _bannerControl = [BYC_BannerControl bannerControlWithFrame:self.bounds bannerControlModels:mArr_Temp placeHolderImage:nil pageControlShowStyle:ENUM_PageControlShowStyleCenter tapCallBackBlock:^(NSInteger index) {
        
        BYC_BaseVideoModel *model = _arr_BannerModels[index];
        [BYC_AusleseJumpToVCHandler jumpToVCWithModel:model];
    }];
    
    [self addSubview:_bannerControl];
}
@end
