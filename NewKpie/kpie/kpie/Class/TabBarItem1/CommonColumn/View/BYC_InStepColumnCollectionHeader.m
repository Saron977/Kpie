//
//  BYC_InStepColumnCollectionHeader.m
//  kpie
//
//  Created by 元朝 on 15/12/23.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_InStepColumnCollectionHeader.h"
//#import "BYC_MediaPlayer.h"
#import "BYC_HomeBannnerHeader.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_MTBannerModel.h"
#import "BYC_MTVideoGroupModel.h"
#import "BYC_HTML5ViewController.h"
#import "WX_VoideDViewController.h"
#import "UIView+BYC_GetViewController.h"
#import "HL_TagTool.h"
#import "HL_TagViewController.h"

@interface BYC_InStepColumnCollectionHeader()<UITextViewDelegate>
{
    NSMutableAttributedString * attStr;
}
@property (weak, nonatomic) IBOutlet UIButton    *button_New;
@property (weak, nonatomic) IBOutlet UIButton    *button_Hot;
@property (weak, nonatomic) IBOutlet UIView      *view_New;
@property (weak, nonatomic) IBOutlet UIView      *view_Hot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageVHeight;
/**选择不同的数据类型按钮*/
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons_selectDataType;
@property (weak, nonatomic) IBOutlet UIView *view_ChangeDataType;

/**banner数据*/
@property (nonatomic, strong)  NSArray <BYC_MTBannerModel *>*array_Banner;
/**组*/
@property (nonatomic, strong)  NSArray *array_Group;

@property (nonatomic, strong) NSMutableArray *array_Topic;

@end

@implementation BYC_InStepColumnCollectionHeader

-(NSMutableArray *)array_Topic{
    
    if (!_array_Topic) {
        _array_Topic = [NSMutableArray array];
    }
    return _array_Topic;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    _view_ChangeDataType.layer.borderColor = KUIColorBaseGreenNormal.CGColor;
    //设置点击时的样式
    NSDictionary *linkAttributes =@{NSForegroundColorAttributeName:KUIColorFromRGB(0xF89117),NSUnderlineColorAttributeName:KUIColorFromRGB(0xF89117),NSUnderlineStyleAttributeName:@(NSUnderlinePatternSolid)};
    self.textView_Describe.linkTextAttributes = linkAttributes;
    self.textView_Describe.delegate = self;
}

- (void)setModel:(BYC_OtherViewControllerModel *)model {
    
    _model = model;
//    _label_Describe.text  = model.columndesc;
    
    if (model.columndesc != nil) {
        attStr = [[NSMutableAttributedString alloc]initWithString:model.columndesc];
        if([model.columndesc rangeOfString:@"#"].location !=NSNotFound){
            self.array_Topic = [HL_TagTool parseTag:model.columndesc];
            if (self.array_Topic.count > 0) {
                for (NSInteger i = 0; i<self.array_Topic.count; i++) {
                    
                    NSString *lable_attStr = self.array_Topic[i];
                    NSInteger location_attStr = [[attStr string] rangeOfString:lable_attStr].location;
                    NSInteger length_attStr = lable_attStr.length;
                    [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(0, attStr.length)];
                    [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0xF89117) range:NSMakeRange(location_attStr, length_attStr)];
                    //添加链接的方式
                    [attStr addAttribute:NSLinkAttributeName
                                   value:self.array_Topic[i]
                                   range:[[attStr string] rangeOfString:self.array_Topic[i]]];

                }
            }
        }
        else{
            attStr = [[NSMutableAttributedString alloc]initWithString:model.columndesc];
            [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(0, attStr.length)];
        }
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attStr.length)];
        self.textView_Describe.attributedText = attStr;
         [self.textView_Describe sizeToFit];
    }
}

-(void)setArray_SortModel:(NSArray<HL_ColumnVideoSortModel *> *)array_SortModel{
    if (array_SortModel.count >1) {
        [_button_New setTitle:array_SortModel[0].sortname forState:UIControlStateNormal];
        [_button_Hot setTitle:array_SortModel[1].sortname forState:UIControlStateNormal];
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
        case Enum_ShowHeaderTypeBanner:{
            [self showBanner];
        }
            break;
        case Enum_ShowHeaderTypeVideo:
            
            break;
            
        default:
            break;
    }
}

-(void)setIsHiddenView_ChangeDataType:(BOOL)isHiddenView_ChangeDataType{
    _isHiddenView_ChangeDataType = isHiddenView_ChangeDataType;
    if (_isHiddenView_ChangeDataType) {
        
        _view_ChangeDataType.hidden = YES;
        [_view_ChangeDataType mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.offset(1);
        }];
    }
    else{
        _view_ChangeDataType.hidden = NO;
        [_view_ChangeDataType mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.offset(40);
        }];
    }
 
}

//类型跳转
- (void)jump {

    if (_array_Banner.count > 0) {
    
        BYC_MTBannerModel *model = _array_Banner[0];
        
        if (model.modelType == HomeVCBannerModelTypeImage) return;
        else if(model.modelType == HomeVCBannerModelTypeVedio){
            
            WX_VoideDViewController *voideVC = [[WX_VoideDViewController alloc]init];
            if(model.isvr == 1) voideVC.isVR = YES;
            else voideVC.isVR = NO;
            [voideVC receiveTheModelWith:_array_Banner WithNum:0 WithType:0];
            voideVC.hidesBottomBarWhenPushed = YES;
            [[self getBGViewController].navigationController pushViewController:voideVC animated:YES];
        }else if(model.modelType == HomeVCBannerModelTypeWeb){
            
            BYC_HTML5ViewController *HTML5VC = [[BYC_HTML5ViewController alloc] initWithHTML5String:[model isMemberOfClass:[BYC_MTBannerModel class]] ? ((BYC_MTBannerModel *)model).secCover_Path : model.videomp4];
            [[self getBGViewController].navigationController pushViewController:HTML5VC animated:YES];
        }
    }
}
- (void)showBanner {

    if (![_imageV_BG viewWithTag:110]) {
        
        BYC_HomeBannnerHeader *banner = [[[NSBundle mainBundle] loadNibNamed:@"BYC_HomeBannnerHeader" owner:nil
                                                                     options:nil] lastObject];
        banner.isFrmoColumn = YES;
        banner.bannerHeight = 170.0f;
        banner.tag = 110;

        banner.array_bannnerModels = _array_Banner;
        [_imageV_BG addSubview:banner];
    }
}

-(void)setDic_Data:(NSDictionary *)dic_Data {

    if (_dic_Data != dic_Data) {
        
        _dic_Data = dic_Data;
        self.array_Banner = [_dic_Data objectForKey:@"bannerData"];
        self.array_Group = [_dic_Data objectForKey:@"groupData"];
    }
}

-(void)setArray_Banner:(NSArray *)array_Banner {

    _array_Banner = array_Banner;
    BYC_MTBannerModel *model;
    NSMutableArray *arr_Banner = [NSMutableArray array];
    for (int i =0; i<_array_Banner.count; i++) {
        model = _array_Banner[i];
        if (model.secondcovertype == 0) {
            model.modelType = HomeVCBannerModelTypeImage;
        }
        else if (model.secondcovertype ==  1){
        model.modelType = HomeVCBannerModelTypeVedio;
        }
        else if (model.secondcovertype ==  2){
        model.modelType = HomeVCBannerModelTypeWeb;
        }
        [arr_Banner addObject:model];
    }
    _array_Banner = (NSArray *)arr_Banner;
    if (_array_Banner.count > 1) self.type_ShowHeader = Enum_ShowHeaderTypeBanner;
    else self.type_ShowHeader = Enum_ShowHeaderTypeImage;
    
}

-(void)setArray_Group:(NSArray *)array_Group {

    if (array_Group.count > 1){
        _array_Group = array_Group;
        [self initGroupBar];
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

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if (URL == nil) {
        NSString *topic = [[textView.attributedText string] substringWithRange:NSMakeRange(characterRange.location, characterRange.length)];
        NSLog(@"topic===%@",topic);
        //标签跳转
        HL_TagViewController *tagVC = [[HL_TagViewController alloc]init];
        tagVC.title = topic;
                [self.getBGViewController.navigationController pushViewController:tagVC animated:YES];
        
    }
    return YES;
    
}


@end
