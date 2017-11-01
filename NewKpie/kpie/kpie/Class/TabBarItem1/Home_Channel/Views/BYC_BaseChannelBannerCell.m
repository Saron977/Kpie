//
//  BYC_BaseChannelBannerCell.m
//  kpie
//
//  Created by 元朝 on 16/7/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelBannerCell.h"
#import "BYC_BannerControlModel.h"
#import "BYC_BannerControl.h"
#import "WX_VoideDViewController.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_HTML5ViewController.h"

@interface BYC_BaseChannelBannerCell ()

@property (weak, nonatomic) IBOutlet UILabel    *label_Content;
@property (weak, nonatomic) IBOutlet UIView     *view_Banner;
@property (nonatomic, strong) BYC_BannerControl *control_Banner;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Background;

@end

@implementation BYC_BaseChannelBannerCell

-(void)setModel_Other:(BYC_OtherViewControllerModel *)model_Other {

    _model_Other = model_Other;
    _label_Content.text = _model_Other.columnDesc;
    [self.label_Content setNeedsLayout];
    [self.label_Content layoutIfNeeded];
}

-(void)setArr_BannerModels:(NSArray<BYC_BaseChannelBannerModel *> *)array_BannerModels {

    _arr_BannerModels = array_BannerModels;
    
    [self initBannerControl];
}

- (void)initBannerControl {

    [self getImagesWithBannerModels];
    
    if (!_control_Banner) {
    
        _control_Banner = [BYC_BannerControl bannerControlWithFrame:CGRectMake(CGRectGetMinX(_view_Banner.bounds), CGRectGetMinY(_view_Banner.bounds), self.kwidth, CGRectGetHeight(_view_Banner.bounds)) bannerControlModels:[self getImagesWithBannerModels] placeHolderImage:nil pageControlShowStyle:ENUM_PageControlShowStyleCenter tapCallBackBlock:^(NSInteger index) {
            
            [self jumpWithIndex:index];
        }];
        
        [self addSubview:_control_Banner];
    }else _control_Banner.arr_BannerControlModels = [self getImagesWithBannerModels];
}

- (NSArray<BYC_BannerControlModel *> *)getImagesWithBannerModels {

    NSMutableArray *arr_Image = [NSMutableArray array];
    if (_arr_BannerModels.count > 0) {//banner数据
        
        for (BYC_BaseChannelBannerModel *model_Banner in _arr_BannerModels) {
            
            BYC_BannerControlModel *model = [[BYC_BannerControlModel alloc] init];
            model.str_ImageUrl = model_Banner.secCover_Url;
            model.bannerControlShowStyle = [model_Banner.secCover_Type intValue] == 1 ? ENUM_BannerControlShowStyleVideo : ENUM_BannerControlShowStyleImage;
            [arr_Image addObject:model];
        }
    }else {//无banner数据,展示图片
        
        BYC_BannerControlModel *model = [[BYC_BannerControlModel alloc] init];
        model.str_ImageUrl = _model_Other.secondCover;
        model.bannerControlShowStyle = ENUM_BannerControlShowStyleImage;
        [arr_Image addObject:model];
    }

    return arr_Image;
}

#warning 按道理，只有一张图的时候也应该在某种条件下触发，点击跳转事件。但是现在没有实现、必须后台配合
- (void)jumpWithIndex:(NSInteger)index {

    BYC_MTBannerModel *model = _arr_BannerModels[index];
    if (model.modelType == HomeVCBannerModelTypeImage || model == nil) return;
    else if(model.modelType == HomeVCBannerModelTypeVedio){
        
        WX_VoideDViewController *voideVC = [[WX_VoideDViewController alloc]init];
        if (model.isVR == 1) voideVC.isVR = YES;
        else voideVC.isVR = NO;
        [voideVC receiveTheModelWith:_arr_BannerModels WithNum:0 WithType:0];
        voideVC.hidesBottomBarWhenPushed = YES;
        [[self getBGViewController].navigationController pushViewController:voideVC animated:YES];
    }else if(model.modelType == HomeVCBannerModelTypeWeb){
        
        BYC_HTML5ViewController *HTML5VC = [[BYC_HTML5ViewController alloc] initWithHTML5String:[model isMemberOfClass:[BYC_MTBannerModel class]] ? ((BYC_MTBannerModel *)model).secCover_Path : model.videoMP4];
        [[self getBGViewController].navigationController pushViewController:HTML5VC animated:YES];
    }
}
@end
