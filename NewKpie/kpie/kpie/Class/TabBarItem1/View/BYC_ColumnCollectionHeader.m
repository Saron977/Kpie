//
//  BYC_ColumnCollectionHeader.m
//  kpie
//
//  Created by 元朝 on 15/12/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_ColumnCollectionHeader.h"
#import "BYC_HomeBannnerHeader.h"
#import "WX_VoideDViewController.h"
#import "BYC_HTML5ViewController.h"
#import "UIView+BYC_GetViewController.h"

typedef NS_ENUM(NSUInteger, Enum_ShowHeaderType) {
    /**图片*/
    Enum_ShowHeaderTypeImage = 1,
    /**轮播图*/
    Enum_ShowHeaderTypeBanner,
    /**视频*/
    Enum_ShowHeaderTypeVideo,
};

@interface BYC_ColumnCollectionHeader()

@property (weak, nonatomic) IBOutlet UILabel     *label_Introduce;
@property (weak, nonatomic) IBOutlet UIButton    *button_New;
@property (weak, nonatomic) IBOutlet UIButton    *button_Hot;
@property (weak, nonatomic) IBOutlet UIView      *view_New;
@property (weak, nonatomic) IBOutlet UIView      *view_Hot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageVHeight;
/**选中的活动类型*/
@property (nonatomic, assign)  Enum_ShowHeaderType    type_ShowHeader;


@end

@implementation BYC_ColumnCollectionHeader
- (void)setModel:(BYC_OtherViewControllerModel *)model {
    
    _model = model;
    
    if (_array_VideoGroup) {//类似世纪樱花 活动的栏目
        
        [_button_New setTitle:((BYC_MTVideoGroupModel *)_array_VideoGroup[0]).videoGroup_Name forState:UIControlStateNormal];
        [_button_Hot setTitle:((BYC_MTVideoGroupModel *)_array_VideoGroup[1]).videoGroup_Name forState:UIControlStateNormal];
    }else if ([_model.isactive intValue] != 2){//普通栏目及名师点评栏目
        
        [_imageV_BG sd_setImageWithURL:[NSURL URLWithString:model.secondcover] placeholderImage:nil];
        
        if ([_model.columnname isEqualToString:@"名师点评"]) {
            
            [_button_New setTitle:@"未点评" forState:UIControlStateNormal];
            [_button_Hot setTitle:@"已点评" forState:UIControlStateNormal];
        }else {
            
            [_button_New setTitle:@"最新" forState:UIControlStateNormal];
            [_button_Hot setTitle:@"最热" forState:UIControlStateNormal];
        }
    }

    _label_Introduce.text  = model.columndesc;
    
}

-(void)setSelectButton:(BYC_TopHiddenViewSelectedButton)selectButton {
    
    [self selectButton:selectButton];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    [self selectButton:sender.tag];
    if (self.headerButtonAction) self.headerButtonAction(sender.tag);
}

-(void)setArray_Banner:(NSArray<BYC_MTBannerModel *> *)array_Banner {
    
    if (_array_Banner != array_Banner) {
        
        _array_Banner = array_Banner;
        _imageV_BG.image = nil;
        if (_array_Banner.count > 1) self.type_ShowHeader = Enum_ShowHeaderTypeBanner;
        else self.type_ShowHeader = Enum_ShowHeaderTypeImage;
    }
}


-(void)setType_ShowHeader:(Enum_ShowHeaderType)type_ShowHeader {
    
    switch (type_ShowHeader) {
        case Enum_ShowHeaderTypeImage:
        {
            
            [_imageV_BG sd_setImageWithURL:[NSURL URLWithString: _array_Banner.count == 1 ? _array_Banner[0].secCover_Url : _model.secondcover] placeholderImage:nil];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jump)];
            [_imageV_BG addGestureRecognizer:tap];
        }
            break;
        case Enum_ShowHeaderTypeBanner:
            [self showBanner];
            break;
        case Enum_ShowHeaderTypeVideo:
            break;
            
        default:
            break;
    }
}

//类型跳转
- (void)jump {
    
    if (_array_Banner.count > 0) {
        
        BYC_MTBannerModel *model = _array_Banner[0];

        if (model.modelType == HomeVCBannerModelTypeImage) return;
        else if(model.modelType == HomeVCBannerModelTypeVedio){
            
            WX_VoideDViewController *voideVC = [[WX_VoideDViewController alloc]init];
            [voideVC receiveTheModelWith:_array_Banner WithNum:0 WithType:0];
            voideVC.hidesBottomBarWhenPushed = YES;
            if(model.isvr == 1) voideVC.isVR = YES;
            else voideVC.isVR = NO;
            [self.getBGViewController.navigationController pushViewController:voideVC animated:YES];
        }else if(model.modelType == HomeVCBannerModelTypeWeb){
            
            BYC_HTML5ViewController *HTML5VC = [[BYC_HTML5ViewController alloc] initWithHTML5String:[model isMemberOfClass:[BYC_MTBannerModel class]] ? ((BYC_MTBannerModel *)model).secCover_Path : model.videomp4];
            [self.getBGViewController.navigationController pushViewController:HTML5VC animated:YES];
        }
    }
    
}

- (void)showBanner {
    
    if (![_imageV_BG viewWithTag:110]) {
        
        BYC_HomeBannnerHeader *banner = [[[NSBundle mainBundle] loadNibNamed:@"BYC_HomeBannnerHeader" owner:nil
                                                                     options:nil] lastObject];
        banner.isFrmoColumn = YES;
        banner.bannerHeight = CGRectGetHeight(_imageV_BG.frame);
        banner.tag = 110;
        banner.array_bannnerModels = _array_Banner;
        [_imageV_BG addSubview:banner];
    }
}


- (void)selectButton:(NSInteger)flag {
    
    switch (flag) {
        case 1://最新
            
            _view_New.hidden = NO;
            _view_Hot.hidden = YES;
            [_button_New setTitleColor:KUIColorFromRGB(0x4BC8BD) forState:UIControlStateNormal];
            [_button_Hot setTitleColor:KUIColorFromRGB(0X4D606F) forState:UIControlStateNormal];
            
            break;
        case 2://最热
            
            _view_New.hidden = YES;
            _view_Hot.hidden = NO;
            [_button_Hot setTitleColor:KUIColorFromRGB(0x4BC8BD) forState:UIControlStateNormal];
            [_button_New setTitleColor:KUIColorFromRGB(0X4D606F) forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
}
@end
