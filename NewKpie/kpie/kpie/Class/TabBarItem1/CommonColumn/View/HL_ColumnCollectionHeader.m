//
//  HL_ColumnCollectionHeader.m
//  kpie
//
//  Created by sunheli on 16/11/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_ColumnCollectionHeader.h"
#import "BYC_HomeBannnerHeader.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_MTBannerModel.h"
#import "BYC_MTVideoGroupModel.h"
#import "BYC_HTML5ViewController.h"
#import "WX_VoideDViewController.h"
#import "UIView+BYC_GetViewController.h"
#import "HL_TagTool.h"
#import "HL_TagViewController.h"
#import "HL_JumpToVideoPlayVC.h"



@interface HL_ColumnCollectionHeader ()<UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *array_Topic;


/**
 Group数组
 */
@property (nonatomic, strong) NSMutableArray <UIButton *> *button_GroupArray;

/**
 比基尼外的Group数组
 */
@property (nonatomic, strong) NSMutableArray <UIButton *> *button_Array;

/**
 比基尼Group数组
 */
@property (nonatomic, strong) NSMutableArray <UIButton *> *button_MTArray;

@end

@implementation HL_ColumnCollectionHeader
-(NSMutableArray *)array_Topic{
    
    if (!_array_Topic) {
        _array_Topic = [NSMutableArray array];
    }
    return _array_Topic;
}

-(NSMutableArray *)button_Array{
    if (!_button_Array) {
        _button_Array = [NSMutableArray array];
    }
    return _button_Array;
}

-(NSMutableArray *)button_GroupArray{
    if (!_button_GroupArray) {
        _button_GroupArray = [NSMutableArray array];
    }
    return _button_GroupArray;
}

-(NSMutableArray *)button_MTArray{
    if (!_button_MTArray) {
        _button_MTArray = [NSMutableArray array];
    }
    
    return _button_MTArray;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initColumnHeaderView];
        [self makeColumnHeaderViewLayOut];
    }
    return self;
}

-(void)initColumnHeaderView{
    
    _view_Top = [[UIView alloc]init];
    //Banner
    _view_Banner = [[UIView alloc]init];
    //栏目简介
    _textView_Description = [[UITextView alloc]init];
    _textView_Description.font = [UIFont systemFontOfSize:12];
    _textView_Description.backgroundColor = [UIColor clearColor];
    _textView_Description.textColor = KUIColorFromRGB(0x4D606F);
    _textView_Description.delegate = self;
    _textView_Description.scrollEnabled = NO;
    _textView_Description.editable = NO;
    
    //设置点击时的样式
    NSDictionary *linkAttributes =@{NSForegroundColorAttributeName:KUIColorFromRGB(0xF89117),NSUnderlineColorAttributeName:KUIColorFromRGB(0xF89117),NSUnderlineStyleAttributeName:@(NSUnderlinePatternSolid)};
    _textView_Description.linkTextAttributes = linkAttributes;
    
    _view_Group = [[UIView alloc]init];
    _view_Group.backgroundColor = [UIColor clearColor];
    
    _view_OtherGroup = [[UIView alloc]init];
    _view_OtherGroup.clipsToBounds = YES;
    _view_OtherGroup.layer.cornerRadius = 15;
    _view_OtherGroup.layer.borderWidth = 1;
    _view_OtherGroup.layer.borderColor = KUIColorBaseGreenNormal.CGColor;
    
    _button_Group1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Group1 setBackgroundColor:KUIColorBaseGreenNormal];
    [_button_Group1 setTitleColor:KUIColorWordsBlack3 forState:UIControlStateNormal];
    [_button_Group1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _button_Group1.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_Group1 setTitle:@"------" forState:UIControlStateNormal];
    _button_Group1.selected = YES;
    _button_Group1.tag = 3;
    [_button_Group1 addTarget:self action:@selector(buttonColumnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _button_Group2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Group2 setTitleColor:KUIColorWordsBlack2 forState:UIControlStateNormal];
    [_button_Group2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _button_Group2.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_Group2 setTitle:@"------" forState:UIControlStateNormal];
    _button_Group2.selected = NO;
    _button_Group2.tag = 4;
    [_button_Group2 addTarget:self action:@selector(buttonColumnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button_Array addObject:_button_Group1];
    [self.button_Array addObject:_button_Group2];
    
    _groupView_MT = [[HL_ColumnGroupView alloc]init];
    [self.groupView_MT.button_Group1 addTarget:self action:@selector(buttonColumnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.groupView_MT.button_Group2 addTarget:self action:@selector(buttonColumnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.groupView_MT.button_Group3 addTarget:self action:@selector(buttonColumnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button_MTArray addObject:self.groupView_MT.button_Group1];
    [self.button_MTArray addObject:self.groupView_MT.button_Group2];
    [self.button_MTArray addObject:self.groupView_MT.button_Group3];
    
    _imageView_spric = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_sqfgx"]];
    
    _view_Bottom = [[UIView alloc]init];
    
    _button_New = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_New setTitleColor:KUIColorWordsBlack2 forState:UIControlStateNormal];
    [_button_New setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateSelected];
    _button_New.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_New setTitle:@"最新" forState:UIControlStateNormal];
    _button_New.selected = YES;
    _button_New.tag = 1;
    [_button_New addTarget:self action:@selector(buttonColumnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_Hot = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_Hot setTitleColor:KUIColorWordsBlack2 forState:UIControlStateNormal];
    [_button_Hot setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateSelected];
    _button_Hot.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button_Hot setTitle:@"最热" forState:UIControlStateNormal];
    _button_Hot.selected = NO;
    _button_Hot.tag = 2;
    [_button_Hot addTarget:self action:@selector(buttonColumnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _view_New = [[UIView alloc]init];
    _view_New.backgroundColor = KUIColorBaseGreenNormal;
    _view_New.hidden = NO;
    
    _view_Hot = [[UIView alloc]init];
    _view_Hot.backgroundColor = KUIColorBaseGreenNormal;
    _view_Hot.hidden = YES;
    
    _view_BottomLine = [[UIView alloc]init];
    _view_BottomLine.backgroundColor = KUIColorBaseGreenNormal;
    
    [self addSubview:_view_Top];
    [_view_Top addSubview:_view_Banner];
    [_view_Top addSubview:_textView_Description];
    [_view_Top addSubview:_view_Group];
    [_view_OtherGroup addSubview:_button_Group1];
    [_view_OtherGroup addSubview:_button_Group2];
    [_view_OtherGroup addSubview:_imageView_spric];
    [_view_Group addSubview:_groupView_MT];
    [_view_Group addSubview:_view_OtherGroup];
    
    
    [self addSubview:_view_Bottom];
    [_view_Bottom addSubview:_button_New];
    [_view_Bottom addSubview:_button_Hot];
    [_view_Bottom addSubview:_view_New];
    [_view_Bottom addSubview:_view_Hot];
    [_view_Bottom addSubview:_view_BottomLine];

}

-(void)makeColumnHeaderViewLayOut{
    
    [_view_Top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-screenHeight*0.042);
    }];
    
    [_view_Banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(_view_Top);
        make.height.mas_equalTo(KImageHeight_ActivityIn);
    }];
    
    [_textView_Description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_Top.mas_left).offset(8);
        make.right.equalTo(_view_Top.mas_right).offset(-8);
        make.top.equalTo(_view_Banner.mas_bottom).offset(8);
    }];
    
    [_view_Group mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_view_Top);
        make.height.mas_equalTo(screenHeight*0.066);
    }];
    [_groupView_MT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_Group.mas_left).offset(20);
        make.right.equalTo(_view_Group.mas_right).offset(-20);
        make.top.equalTo(_view_Group.mas_top).offset(2);
        make.bottom.equalTo(_view_Group.mas_bottom).offset(-8);
    }];
    [_view_OtherGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_view_Group.mas_top).offset(2);
        make.bottom.equalTo(_view_Group.mas_bottom).offset(-8);
        make.width.mas_equalTo(screenWidth*0.7);
    }];
    
    [_imageView_spric mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_view_OtherGroup.mas_top).offset(3);
        make.bottom.equalTo(_view_OtherGroup.mas_bottom).offset(-3);
        make.centerX.equalTo(_view_OtherGroup.mas_centerX);
        make.width.mas_equalTo(1);
    }];
    
    
    [_button_Group1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_view_OtherGroup);
        make.right.equalTo(_imageView_spric.mas_left);
    }];
    
    [_button_Group2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(_view_OtherGroup);
        make.left.equalTo(_imageView_spric.mas_right);
    }];
    
    [_view_Bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_view_Top.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    [_button_New mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_view_Bottom);
        make.width.mas_equalTo(screenWidth/2.0);
        make.bottom.equalTo(_view_Bottom.mas_bottom).offset(-1);
    }];
    [_button_Hot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_New.mas_right);
        make.top.right.equalTo(_view_Bottom);
        make.bottom.equalTo(_view_Bottom.mas_bottom).offset(-1);
    }];
    
    [_view_New mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(_view_Bottom);
        make.top.equalTo(_button_New.mas_bottom);
        make.width.mas_equalTo(screenWidth/2);
    }];
    
    [_view_Hot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_view_Bottom);
        make.top.equalTo(_button_Hot.mas_bottom);
        make.left.equalTo(_view_New.mas_right);
    }];
    
    [_view_BottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_view_Bottom);
        make.bottom.equalTo(_view_Bottom.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setModel:(BYC_OtherViewControllerModel *)model {
    
    _model = model;
    NSMutableAttributedString * attStr;
    if (_model.columndesc != nil) {
        attStr = [[NSMutableAttributedString alloc]initWithString:_model.columndesc];
        if([_model.columndesc rangeOfString:@"#"].location !=NSNotFound){
            self.array_Topic = [HL_TagTool parseTag:_model.columndesc];
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
            attStr = [[NSMutableAttributedString alloc]initWithString:_model.columndesc];
            [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(0, attStr.length)];
        }
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attStr.length)];
        self.textView_Description.attributedText = attStr;
        [self.textView_Description sizeToFit];
    }
    
    if (_model.arr_Area.count > 0) {
        self.button_GroupArray = self.button_MTArray;
    }
    else{
        self.button_GroupArray = self.button_Array;
    }
}

-(void)setDic_Data:(NSDictionary *)dic_Data {
        _dic_Data = dic_Data;
        self.array_Banner = [_dic_Data objectForKey:@"bannerData"];
        self.array_Group = [_dic_Data objectForKey:@"groupData"];
}

//最新、最热
-(void)setArray_SortModel:(NSArray<HL_ColumnVideoSortModel *> *)array_SortModel{
    if (array_SortModel.count >0) {
        [_button_New setTitle:array_SortModel[0].sortname forState:UIControlStateNormal];
        [_button_Hot setTitle:array_SortModel[1].sortname forState:UIControlStateNormal];
    }
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
        
        [_view_Banner addSubview:_bannerControl];
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
    
    if (array_Group.count > 1){
        _array_Group = array_Group;
        [self initGroupBar];
    }
}

- (void)initGroupBar {
    
    for (int i = 0; i < _array_Group.count ; i++) {
        UIButton *button = self.button_GroupArray[i];
        BYC_MTVideoGroupModel *model = _array_Group[i];
        [button setTitle:model.groupname forState:UIControlStateNormal];
    }
}

-(void)setSelectButton:(BYC_TopHiddenViewSelectedButton)selectButton {
    
    [self selectButton:selectButton];
}

- (void)buttonColumnAction:(UIButton *)sender {

    switch (sender.tag) {
        case Enum_SelectTypeNew:
        case Enum_SelectTypeHot:
            [self selectButton:sender.tag];
            break;
        case Enum_ActionSelectTypeFocus://赛区看点
            [self selectDataType:sender.tag];
            break;
        case Enum_ActionSelectTypeFavorite://热门选手
        case Enum_ActionSelectTypeOther://合拍剧本
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
    for (UIButton *btn in self.button_GroupArray) {
        
        if (flag == btn.tag) {
            btn.backgroundColor = KUIColorBaseGreenNormal;
            btn.selected = YES;
        }else {
            btn.backgroundColor = [UIColor clearColor];
            btn.selected = NO;
        }
    }
}

- (void)selectButton:(NSInteger)flag {
    
    _type_Select = flag;
    switch (flag) {
        case Enum_SelectTypeNew://最新
            
            _view_New.hidden = NO;
            _view_Hot.hidden = YES;
            _button_New.selected = YES;
            _button_Hot.selected = NO;
            break;
        case Enum_SelectTypeHot://最热
            
            _view_New.hidden = YES;
            _view_Hot.hidden = NO;
            _button_New.selected = NO;
            _button_Hot.selected = YES;
            break;
        default:
            break;
    }
    
}

-(void)setIsHiddenView_ChangeDataType:(BOOL)isHiddenView_ChangeDataType{
    _isHiddenView_ChangeDataType = isHiddenView_ChangeDataType;
    if (_isHiddenGroupView_ChangeColumnType) {
        if (_isHiddenView_ChangeDataType) {
            
            _view_OtherGroup.hidden = YES;
            [_view_Group mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(10);
            }];
        }
        else{
            _view_OtherGroup.hidden = NO;
            [_view_Group mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(screenHeight*0.066);
            }];
        }

    }
    else{
        _view_OtherGroup.hidden = YES;
        [_view_Group mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(screenHeight*0.066);
        }];
    }
    
}

-(void)setIsHiddenGroupView_ChangeColumnType:(BOOL)isHiddenGroupView_ChangeColumnType{
    _isHiddenGroupView_ChangeColumnType = isHiddenGroupView_ChangeColumnType;
    if (_isHiddenGroupView_ChangeColumnType) {
        self.groupView_MT.hidden = YES;
         self.isHiddenView_ChangeDataType =  _array_Group.count > 1 ? NO : YES;
        
    }
    else{
        self.groupView_MT.hidden = NO;
        self.isHiddenView_ChangeDataType = YES;
    }
}


-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if (URL == nil) {
        NSString *topic = [[textView.attributedText string] substringWithRange:NSMakeRange(characterRange.location, characterRange.length)];
        NSLog(@"topic===%@",topic);
        //标签跳转
        HL_TagViewController *tagVC = [[HL_TagViewController alloc]init];
        tagVC.title = topic;
        tagVC.themeStr = topic;
        [self.getBGViewController.navigationController pushViewController:tagVC animated:YES];
        
    }
    return YES;
    
}




@end
