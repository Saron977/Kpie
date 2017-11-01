//
//  HL_MyCenterheaderView.m
//  kpie
//
//  Created by sunheli on 16/9/27.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_MyCenterheaderView.h"
#import "UIView+BYC_GetViewController.h"
#import "UIImage+ImageEffects.h"
#import "BYC_MyCenterUserModel.h"
#import "BYC_PersonalDataViewController.h"
#import "BYC_ShowHeaderImageViewController.h"
#import "BYC_MyCenterFocusRequestDataHandler.h"
#import "HL_CenterViewController.h"
#import "BYC_UserInfoModel.h"

@interface HL_MyCenterheaderView ()
{
    NSString *_videos;
    NSString *_focus;
    NSString *_fans;
}
/***/
@property (nonatomic, strong)  BYC_AccountModel *model;

/**通知1*/
@property (nonatomic, strong)  NSString  *str_Notification1;
/**通知1*/
@property (nonatomic, strong)  NSString  *str_Notification2;

/**作品、关注、粉丝的数量*/
@property (nonatomic, strong)  NSArray   *titleCount;
@end

@implementation HL_MyCenterheaderView

-(NSArray *)titleCount{
    
    if (!_titleCount) {
        _titleCount = [NSArray array];
    }
    return _titleCount;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KUIColorFromRGB(0xECECEC);
        [self initView];
    
    }
    return self;
}
-(void)initView{
//    _imgV_BlurBackground = [[UIImageView alloc]initWithFrame:self.bounds];
//    [self addSubview:_imgV_BlurBackground];
    
    
    _View_Top = [[UIView alloc]init];
    _View_Top.backgroundColor = [UIColor clearColor];
    [self addSubview:_View_Top];
    
    _view_Middle = [[UIView alloc]init];
    _view_Middle.backgroundColor = [UIColor clearColor];
    [self addSubview:_view_Middle];
    
    _imgV_Header = [[UIImageView alloc]init];
    _imgV_Header.contentMode = UIViewContentModeScaleAspectFill;
    _imgV_Header.layer.borderWidth = .5f;
    _imgV_Header.layer.borderColor=KUIColorFromRGB(0X085E6D).CGColor;
    _imgV_Header.clipsToBounds = YES;
    _imgV_Header.layer.cornerRadius = 85/2.0f;
    [_view_Middle addSubview:_imgV_Header];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadAction:)];
    [_imgV_Header addGestureRecognizer:tap];
    _imgV_Header.userInteractionEnabled = YES;
    
    _lab_Nickname = [[UILabel alloc]init];
    _lab_Nickname.textColor = KUIColorBackgroundModule2;
    _lab_Nickname.font = [UIFont systemFontOfSize:15];
    [_view_Middle addSubview:_lab_Nickname];
    
    _imgV_Sex = [[UIImageView alloc]init];
    _imgV_Sex.contentMode = UIViewContentModeScaleAspectFill;
    [_view_Middle addSubview:_imgV_Sex];
    
    _btn_Focus = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_Focus addTarget:self action:@selector(addFocusOrcancle:) forControlEvents:UIControlEventTouchUpInside];
    [_view_Middle addSubview:_btn_Focus];
    
    _imgV_Level = [[UIImageView alloc]init];
    [_view_Middle addSubview:_imgV_Level];
    
    _imgV_LevelIcon = [[UIImageView alloc]init];
    [_view_Middle addSubview:_imgV_LevelIcon];
    
    _lab_LevelName = [[UILabel alloc]init];
    _lab_LevelName.textColor = KUIColorBackgroundModule2;
    _lab_LevelName.font = [UIFont systemFontOfSize:12];
    [_view_Middle addSubview:_lab_LevelName];
    
    _lab_Description = [[UILabel alloc]init];
    _lab_Description.textColor = KUIColorBackgroundModule2;
    _lab_Description.font = [UIFont systemFontOfSize:12];
    _lab_Description.numberOfLines = 0;
    [_view_Middle addSubview:_lab_Description];
    [self makeLayoutView];
}

-(void)makeLayoutView{
    
  [_View_Top mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.equalTo(self);
      make.height.mas_equalTo(64);
  }];
    
    [_view_Middle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_View_Top.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [_imgV_Header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_Middle.mas_left).offset(18);
        make.top.equalTo(_view_Middle.mas_top).offset(35);
        make.width.height.mas_equalTo(85);
    }];
    
    [_lab_Nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV_Header.mas_right).offset(18);
        make.top.equalTo(_view_Middle.mas_top).offset(35);
    }];
    
    [_imgV_Sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lab_Nickname.mas_right).offset(2);
        make.top.equalTo(_view_Middle.mas_top).offset(36);
        make.width.height.mas_equalTo(14);
    }];
    
    [_btn_Focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_view_Middle);
        make.right.equalTo(_view_Middle.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    [_imgV_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV_Header.mas_right).offset(18);
        make.top.equalTo(_lab_Nickname.mas_bottom).offset(8);
        make.width.height.mas_equalTo(16);
    }];
    
    [_imgV_LevelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV_Level.mas_right).offset(8);
        make.top.equalTo(_lab_Nickname.mas_bottom).offset(10);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(12);
    }];

    [_lab_LevelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV_LevelIcon.mas_right).offset(8);
        make.top.equalTo(_lab_Nickname.mas_bottom).offset(11);
    }];
    
    [_lab_Description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV_Header.mas_right).offset(18);
         make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(_imgV_Level.mas_bottom).offset(8);
    }];
    
}

-(void)setHandle:(BYC_MyCenterHandler *)handle {
    
    _handle = handle;
    self.model = (BYC_MyCenterUserModel *)_handle.model_CurrentUser;
    
}

-(void)setModel:(BYC_MyCenterUserModel *)model {
    
    _model = model;
    [self loadData];
    [self registerKVO];
}

- (void)loadData {
    
    _videos =[NSString stringWithFormat:@"%ld\n作品",(long)(_model.userInfo.videos <= 0 ? 0 : _model.userInfo.videos)];
    _focus  = [NSString stringWithFormat:@"%ld\n关注",(long)(_model.userInfo.focus <= 0 ? 0 : _model.userInfo.focus)];
    _fans   = [NSString stringWithFormat:@"%ld\n粉丝",(long)(_model.userInfo.fans <= 0 ? 0 : _model.userInfo.fans)];
    self.titleCount = @[_videos,_focus,_fans];
    if (self.sendWorksAndFocusAndFansCountBlock) {
        self.sendWorksAndFocusAndFansCountBlock(self.titleCount);
    }
    //只要是自己的列表就不出现关注按钮
    if ([[BYC_AccountTool userAccount].userid isEqualToString:_model.userid])
        _btn_Focus.hidden = YES;
    else
        [_btn_Focus setImage:[UIImage imageNamed: _model.whetherFocusForCell == WhetherFocusForCellNO  || _model.whetherFocusForCell == WhetherFocusForCellFocused ? @"icon-gzs-n" : @"icon-ygzs-h"] forState:UIControlStateNormal];
    if (_model) {
        
        __weak __typeof(self) weakSelf = self;
        
        [_imgV_Header sd_setImageWithURL:[NSURL URLWithString:_model.headportrait] placeholderImage:[UIImage imageNamed:@"icon-tx-160"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            __block UIImage *imageBlur =  image;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                imageBlur = [imageBlur blurImageWithRadius:20];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.image = imageBlur;
                });
            });
        }];
        if (_model.nickname == nil) _lab_Nickname.text = @"昵称";
        else _lab_Nickname.text = _model.nickname;
        [_lab_Nickname sizeToFit];
        
        if (_model.userInfo.mydescription.length > 0) _lab_Description.text = _model.userInfo.mydescription;
        else _lab_Description.text = @"此人很懒，没留下描述...";
        [_lab_Description sizeToFit];
    }
    
    if (_model.sex == 0) _imgV_Sex.image = [UIImage imageNamed:@"icon-nan"];
    else if(_model.sex == 1) _imgV_Sex.image = [UIImage imageNamed:@"icon-nv-xiao"];
    else _imgV_Sex.image = [UIImage imageNamed:@"baomi"];
    
    [_imgV_Level sd_setImageWithURL:[NSURL URLWithString:_model.userTitle.titleimg] placeholderImage:nil];
    [_imgV_LevelIcon sd_setImageWithURL:[NSURL URLWithString:_model.userLevel.levelimg] placeholderImage:nil];
    _lab_LevelName.text = _model.userTitle.titlename;
    [_lab_LevelName sizeToFit];
}

- (void)registerKVO {

    [_model.userInfo rac_observeKeyPath:@"videos" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        _videos =[NSString stringWithFormat:@"%ld\n作品",(long)(_model.userInfo.videos <= 0 ? 0 : [value integerValue])];
        self.titleCount = @[_videos,_focus,_fans];
        if (self.sendWorksAndFocusAndFansCountBlock) {
            self.sendWorksAndFocusAndFansCountBlock(self.titleCount);
        }
    }];
    [_model.userInfo rac_observeKeyPath:@"focus" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        _focus  = [NSString stringWithFormat:@"%ld\n关注",(long)(_model.userInfo.focus <= 0 ? 0 : [value integerValue])];
        self.titleCount = @[_videos,_focus,_fans];
        if (self.sendWorksAndFocusAndFansCountBlock) {
            self.sendWorksAndFocusAndFansCountBlock(self.titleCount);
        }
    }];
    
    [_model.userInfo rac_observeKeyPath:@"fans" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        _fans  = [NSString stringWithFormat:@"%ld\n粉丝",(long)(_model.userInfo.fans <= 0 ? 0 : [value integerValue])];
        self.titleCount = @[_videos,_focus,_fans];
        if (self.sendWorksAndFocusAndFansCountBlock) {
            self.sendWorksAndFocusAndFansCountBlock(self.titleCount);
        }
    }];
    
    [_model rac_observeKeyPath:@"whetherFocusForCell" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        [_btn_Focus setImage:[UIImage imageNamed: [value integerValue] == 1 || [value integerValue] == 2  ? @"icon-ygzs-h" : @"icon-gzs-n"] forState:UIControlStateNormal];
    }];
}

-(void)addFocusOrcancle:(UIButton *)sender{
    
    [BYC_MyCenterFocusRequestDataHandler whetherSelectFocusWithToUserID:_model handler:_handle completion:^(BOOL success, WhetherFocusForCell status) {
        sender.userInteractionEnabled = YES;
        [QNWSNotificationCenter postNotificationName:@"SaveOrRemove" object:nil];
        SearchUserListFocusStateBlock searchUserListFocusStateBlock = ((HL_CenterViewController *)self.getBGViewController).searchUserListFocusStateBlock;
        if (searchUserListFocusStateBlock) searchUserListFocusStateBlock(status);
    }];

}

-(void)clickHeadAction:(UITapGestureRecognizer *)sender{
    if ([_handle.model_User.userid isEqualToString:_model.userid]) {
        
        BYC_PersonalDataViewController *personalDataVC = [[BYC_PersonalDataViewController alloc] init];
        [self.getBGViewController.navigationController pushViewController:personalDataVC animated:YES];
    }else {
        
        BYC_ShowHeaderImageViewController *showHeaderImageVC = [[BYC_ShowHeaderImageViewController alloc] init];
        showHeaderImageVC.imageUrl = _model.headportrait;
        
        [self.getBGViewController presentViewController:showHeaderImageVC animated:YES completion:nil];
    }

}

-(void)dealloc {
    
    [QNWSNotificationCenter removeObserver:self];
}



@end
