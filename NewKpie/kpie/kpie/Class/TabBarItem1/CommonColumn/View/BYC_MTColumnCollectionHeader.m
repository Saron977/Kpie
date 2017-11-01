//
//  BYC_MTColumnCollectionHeader.m
//  kpie
//
//  Created by 元朝 on 15/12/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_MTColumnCollectionHeader.h"
#import "BYC_HomeBannnerHeader.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_MTBannerModel.h"
#import "BYC_MTVideoGroupModel.h"
#import "BYC_HTML5ViewController.h"
#import "WX_VoideDViewController.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_BannerControl.h"
#import "HL_JumpToVideoPlayVC.h"

@interface BYC_MTColumnCollectionHeader()

@property (weak, nonatomic) IBOutlet UIButton    *button_New;
@property (weak, nonatomic) IBOutlet UIButton    *button_Hot;
@property (weak, nonatomic) IBOutlet UIView      *view_New;
@property (weak, nonatomic) IBOutlet UIView      *view_Hot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageVHeight;
/**选择不同的数据类型按钮*/
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons_selectDataType;

@property (weak, nonatomic) IBOutlet UIView *view_ChangeDataType;

@property (nonatomic, strong) BYC_BannerControl  *bannerControl;
@end

@implementation BYC_MTColumnCollectionHeader

-(void)awakeFromNib {
    [super awakeFromNib];
    _view_ChangeDataType.layer.borderColor = KUIColorBaseGreenNormal.CGColor;
    
    //默认状态
    _type_Select = Enum_SelectTypeNew;
    _type_SelectAction = Enum_ActionSelectTypeFocus;
    _constraintImageVHeight.constant = KImageHeight_ActivityIn;
}


-(void)setModel:(BYC_OtherViewControllerModel *)model{
    _model = model;
}

-(void)setDic_Data:(NSDictionary *)dic_Data {
        _dic_Data = dic_Data;
        self.array_Banner = [_dic_Data objectForKey:@"bannerData"];
        self.array_Group = [_dic_Data objectForKey:@"groupData"];
}

-(void)setArray_Banner:(NSArray *)array_Banner {
    
    _array_Banner = array_Banner;
    [self initBannerControl];    
}
-(void)initBannerControl{
    if (!_bannerControl) {
        
        _bannerControl = [BYC_BannerControl bannerControlWithFrame:CGRectMake(0, 0, screenWidth, KImageHeight_ActivityIn) bannerControlModels:[self getImagesWithBannerModels] placeHolderImage:nil pageControlShowStyle:ENUM_PageControlShowStyleCenter tapCallBackBlock:^(NSInteger index) {
            
            [self jumpWithIndex:index];
        }];
        
        [self addSubview:_bannerControl];
    }else _bannerControl.arr_BannerControlModels = [self getImagesWithBannerModels];
}


- (NSArray<BYC_BannerControlModel *> *)getImagesWithBannerModels {
    NSMutableArray *arr_Image = [NSMutableArray array];
    if (_array_Banner.count > 0) {//banner数据
        
        for (BYC_MTBannerModel *model_Banner in _array_Banner) {
            
            BYC_BannerControlModel *model = [[BYC_BannerControlModel alloc] init];
            model.str_ImageUrl = model_Banner.secondcover;
            model.bannerControlShowStyle = model_Banner.secondcovertype == 1 ? ENUM_BannerControlShowStyleVideo : ENUM_BannerControlShowStyleImage;
            [arr_Image addObject:model];
        }
    }else {//无banner数据,展示图片
        
        BYC_BannerControlModel *model = [[BYC_BannerControlModel alloc] init];
        model.str_ImageUrl = _model.secondcover;
        model.bannerControlShowStyle = ENUM_BannerControlShowStyleImage;
        [arr_Image addObject:model];
    }
    
    return arr_Image;
    
}

-(void)jumpWithIndex:(NSInteger)index{
    if (_array_Banner.count > 0) {
        BYC_MTBannerModel *model = _array_Banner[index];
        if (model.secondcovertype == 0) {return;}
        else if(model.secondcovertype == 1){
            
            [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
        }else if(model.secondcovertype == 2){
            
            BYC_HTML5ViewController *HTML5VC = [[BYC_HTML5ViewController alloc] initWithHTML5String:[model isMemberOfClass:[BYC_MTBannerModel class]] ? model.secondcoverpath : model.video];
            [[self getBGViewController].navigationController pushViewController:HTML5VC animated:YES];
        }
    }
    else{
        return;
    }
}


-(void)setArray_Group:(NSArray *)array_Group {
    if (array_Group.count >0) {
        _view_ChangeDataType.userInteractionEnabled = YES;
        _array_Group = array_Group;
        [self initGroupBar];
    }
    else{
        _view_ChangeDataType.userInteractionEnabled = NO;
    }
}

- (void)initGroupBar {
    
    for (int i = 0; i < _array_Group.count ; i++) {
        UIButton *button = _buttons_selectDataType[i];
        BYC_MTVideoGroupModel *model = _array_Group[i];
        [button setTitle:model.groupname forState:UIControlStateNormal];
    }
}




-(void)setSelectButton:(BYC_TopHiddenViewSelectedButton)selectButton {
    
    [self selectButton:selectButton];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case Enum_SelectTypeNew:
        case Enum_SelectTypeHot:
            [self selectButton:sender.tag];
            break;
        case Enum_ActionSelectTypeFocus://赛区看点
            [self selectDataType:sender.tag];
            break;
        case Enum_ActionSelectTypeFavorite://热门选手
            [self selectDataType:sender.tag];
            break;
        case Enum_ActionSelectTypeTitbits://精彩花絮
            [self selectDataType:sender.tag];
            break;
            
        default://最新和最热

            break;
    }
    
    if (self.headerButtonAction) self.headerButtonAction(sender.tag);
}

- (void)selectDataType:(NSInteger)flag {

    
    _type_SelectAction = flag;
    for (UIButton *btn in _buttons_selectDataType) {
        
        if (flag == btn.tag) {
        
            btn.backgroundColor = KUIColorBaseGreenNormal;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
        
            [btn setTitleColor:KUIColorFromRGB(0X677C99) forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
        }
        
    }
}

- (void)selectButton:(NSInteger)flag {
    
    _type_Select = flag;
    switch (flag) {
        case Enum_SelectTypeNew://最新
            
            _view_New.hidden = NO;
            _view_Hot.hidden = YES;
            [_button_New setTitleColor:KUIColorFromRGB(0x4BC8BD) forState:UIControlStateNormal];
            [_button_Hot setTitleColor:KUIColorFromRGB(0X4D606F) forState:UIControlStateNormal];
            
            break;
        case Enum_SelectTypeHot://最热
            
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
