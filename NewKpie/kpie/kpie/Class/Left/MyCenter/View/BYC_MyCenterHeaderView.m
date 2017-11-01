//
//  BYC_MyCenterHeaderView.m
//  kpie
//
//  Created by 元朝 on 16/9/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MyCenterHeaderView.h"
#import "UIView+BYC_GetViewController.h"
#import "UIImage+ImageEffects.h"
#import "BYC_MyCenterUserModel.h"
#import "BYC_PersonalDataViewController.h"
#import "BYC_ShowHeaderImageViewController.h"
#import "BYC_MyCenterFocusRequestDataHandler.h"
#import "HL_CenterViewController.h"
#import "BYC_UserInfoModel.h"

UIKIT_EXTERN const float flo_SegmentViewHeight;
UIKIT_EXTERN const float flo_HeadViewHeight;
UIKIT_EXTERN const float flo_DefaultOffSetY;
UIKIT_EXTERN NSString *Notification_CustomCenterControlColletionScroll;
UIKIT_EXTERN NSString *Notification_CustomCenterControlColletionClickButtonScroll;

@interface BYC_MyCenterHeaderView ()
/**模糊背景*/
@property (weak, nonatomic) IBOutlet UIImageView *imgV_BlurBackground;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *imgV_Header;
/**昵称*/
@property (weak, nonatomic) IBOutlet UILabel *lab_Nickname;
/**性别*/
@property (weak, nonatomic) IBOutlet UIImageView *imgV_Sex;
/**等级图*/
@property (weak, nonatomic) IBOutlet UIImageView *imgV_Level;
/**等级图标*/
@property (weak, nonatomic) IBOutlet UIImageView *imgV_LevelIcon;
/**等级名称*/
@property (weak, nonatomic) IBOutlet UILabel *lab_LevelName;
/**个人描述*/
@property (weak, nonatomic) IBOutlet UILabel *lab_Description;
/**作品、关注、粉丝的数量*/
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray <UILabel *> *labs_Count;
/**作品、关注、粉丝*/
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray <UILabel *> *labs_ZpGzFs;
/**底部滑动的view*/
@property (weak, nonatomic) IBOutlet UIView *view_ScrollPage;

@property (weak, nonatomic) IBOutlet UIView *view_Middle;

@property (weak, nonatomic) IBOutlet UIButton *btn_Focus;

/***/
@property (nonatomic, strong)  BYC_MyCenterUserModel *model;

/**通知1*/
@property (nonatomic, strong)  NSString  *str_Notification1;
/**通知1*/
@property (nonatomic, strong)  NSString  *str_Notification2;

/**记录滑动方向，若是>0右滑 <0左滑*/
@property (nonatomic, assign)  float  flag;

@end

@implementation BYC_MyCenterHeaderView

-(void)awakeFromNib {

    [super awakeFromNib];
    
    [self setupSubViews];
    [self initParam];
}

- (void)setupSubViews {

    _imgV_Header.layer.borderWidth = .5f;
    _imgV_Header.layer.borderColor=KUIColorFromRGB(0X085E6D).CGColor;
    _imgV_Header.layer.masksToBounds = YES;
    _imgV_Header.layer.cornerRadius = 85 / 2.0f;
}

- (void)initParam {

    [self registerNotification];
}

- (void)registerKVO {
    
    [_model.userInfo rac_observeKeyPath:@"videos" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        _labs_Count[0].text = [NSString stringWithFormat:@"%ld",(long)(_model.userInfo.videos <= 0 ? 0 : [value integerValue])];
    }];
    
    [_model.userInfo rac_observeKeyPath:@"focus" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        _labs_Count[1].text = [NSString stringWithFormat:@"%ld",(long)(_model.userInfo.focus <= 0 ? 0 : [value integerValue])];
    }];
    
    [_model.userInfo rac_observeKeyPath:@"fans" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        _labs_Count[2].text = [NSString stringWithFormat:@"%ld",(long)(_model.userInfo.fans <= 0 ? 0 : [value integerValue])];
    }];
    
    [_model rac_observeKeyPath:@"whetherFocusForCell" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        [_btn_Focus setImage:[UIImage imageNamed: [value integerValue] == WhetherFocusForCellYES || [value integerValue] == WhetherFocusForCellHXFocus  ?  @"icon-gzs-n" : @"icon-ygzs-h" ] forState:UIControlStateNormal];
    }];
}

- (void)registerNotification {

    _str_Notification1 = [Notification_CustomCenterControlColletionScroll copy];
    _str_Notification2 = [Notification_CustomCenterControlColletionClickButtonScroll copy];
    [QNWSNotificationCenter addObserver:self selector:@selector(scrollChnageAction:) name:_str_Notification1 object:nil];
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

    _labs_Count[0].text = [NSString stringWithFormat:@"%ld",(long)(_model.userInfo.videos <= 0 ? 0 : _model.userInfo.videos)];
    _labs_Count[1].text = [NSString stringWithFormat:@"%ld",(long)(_model.userInfo.focus <= 0 ? 0 : _model.userInfo.focus)];
    _labs_Count[2].text = [NSString stringWithFormat:@"%ld",(long)(_model.userInfo.fans <= 0 ? 0 : _model.userInfo.fans)];
    //只要是自己的列表就不出现关注按钮
    if ([[BYC_AccountTool userAccount].userid isEqualToString:_model.userid])
        _btn_Focus.hidden = YES;
    else
        [_btn_Focus setImage:[UIImage imageNamed: _model.attentionstate != 4  ? @"icon-ygzs-h" : @"icon-gzs-n"] forState:UIControlStateNormal];
    if (_model) {
        
        __weak __typeof(self) weakSelf = self;
        
        [_imgV_Header sd_setImageWithURL:[NSURL URLWithString:_model.headportrait] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            __block UIImage *imageBlur =  image;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                imageBlur = [imageBlur blurImageWithRadius:20];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.imgV_BlurBackground.image = imageBlur;
                }); 
            });
        }];
        _lab_Nickname.text = _model.nickname;
        if (_model.description.length > 0) _lab_Description.text = _model.description;
        else _lab_Description.text = @"此人很懒，没留下描述...";
    }
    
    if (_model.sex == 0) _imgV_Sex.image = [UIImage imageNamed:@"icon-nan"];
    else if(_model.sex == 1) _imgV_Sex.image = [UIImage imageNamed:@"icon-nv-xiao"];
    else _imgV_Sex.image = [UIImage imageNamed:@"baomi"];
    
    [_imgV_Level sd_setImageWithURL:[NSURL URLWithString:_model.titleImg] placeholderImage:nil];
    [_imgV_LevelIcon sd_setImageWithURL:[NSURL URLWithString:_model.levelImg] placeholderImage:nil];
    _lab_LevelName.text = _model.titleName;
}

-(void)didMoveToSuperview {

    [self.getBGViewController rac_observeKeyPath:@"flo_OffSetY" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        CGFloat _flo_OffSetY = [value doubleValue];
        if (_flo_OffSetY > -(flo_DefaultOffSetY - flo_HeadViewHeight + KHeightNavigationBar))self.view_Middle.alpha = 0;
         else if (_flo_OffSetY < -flo_DefaultOffSetY) self.view_Middle.alpha = 1;
        else {
            
            CGFloat alpha =  (_flo_OffSetY - (-(flo_DefaultOffSetY - flo_HeadViewHeight + KHeightNavigationBar))) /  (-flo_DefaultOffSetY - (-(flo_DefaultOffSetY - flo_HeadViewHeight + KHeightNavigationBar)));
            self.view_Middle.alpha = alpha;
        }
    }];
}

- (void)scrollChnageAction:(NSNotification *)notification {
    
    [self handleScroll:[notification.object doubleValue]];
}

- (void)handleScroll:(CGFloat)offset {

     NSInteger index = offset / screenWidth;
    if (index < 0 || index >  _labs_ZpGzFs.count - 1) return;
    
    [_view_ScrollPage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(offset / 3.0);
    }];
    
    if (offset == index * screenWidth) {
        [self setupColorWithIndex:index];
        return;
    }
    
    CGFloat  direction =  offset - _flag;
    _flag= offset;
    
    CGFloat sacle = ((NSInteger)offset) % (NSInteger)screenWidth / screenWidth;
    if (direction >= 0 ) sacle = sacle == 0 ? 1.0f : sacle;
    else sacle = 1 - sacle;
    
    // RGB渐变
    CGFloat er = ((float)((0X4BC8B6 & 0xFF0000) >> 16))/255.0;
    CGFloat eg = ((float)((0X4BC8B6 & 0xFF00) >> 8));
    CGFloat eb = ((float)(0X4BC8B6 & 0xFF))/255.0;
    
    CGFloat sr = ((float)((0XFFFFFF & 0xFF0000) >> 16))/255.0;
    CGFloat sg = ((float)((0XFFFFFF & 0xFF00) >> 8))/255.0;
    CGFloat sb = ((float)(0XFFFFFF & 0xFF))/255.0;
    
    CGFloat r = er - sr;
    CGFloat g = eg - sg;
    CGFloat b = eb - sb;
    
    UIColor *highLightColor = [UIColor colorWithRed:sr + r * sacle green:sg + g * sacle blue:sb + b * sacle alpha:1];
    UIColor *normalColor = [UIColor colorWithRed:er -  r * sacle  green:eg -  g * sacle  blue:eb -  b * sacle alpha:1];
    
    if (direction >= 0) {//右滑
        
        if (((NSInteger)offset) % (NSInteger)screenWidth == 0) index = index - 1;
        _labs_Count[index].textColor = normalColor;
        _labs_ZpGzFs[index].textColor = normalColor;
        
        if (index != _labs_ZpGzFs.count - 1) {
            
            _labs_Count[index + 1].textColor = highLightColor;
            _labs_ZpGzFs[index + 1].textColor = highLightColor;
        }
        
    }else{
        
        _labs_Count[index].textColor = highLightColor;
        _labs_ZpGzFs[index].textColor = highLightColor;
        
        _labs_Count[index + 1].textColor = normalColor;
        _labs_ZpGzFs[index + 1].textColor = normalColor;
    }

}

- (void)setupColorWithIndex:(NSInteger)index {
    
    [_labs_Count makeObjectsPerformSelector:@selector(setTextColor:) withObject:[UIColor whiteColor]];
    [_labs_ZpGzFs makeObjectsPerformSelector:@selector(setTextColor:) withObject:[UIColor whiteColor]];
    _labs_Count[index].textColor = KUIColorFromRGB(0X4BC8B6);
    _labs_ZpGzFs[index].textColor = KUIColorFromRGB(0X4BC8B6);
}

- (IBAction)clickHeadAction:(UITapGestureRecognizer *)sender {
    
    if ([_handle.model_User.userid isEqualToString:_model.userid]) {
        
        BYC_PersonalDataViewController *personalDataVC = [[BYC_PersonalDataViewController alloc] init];
        [self.getBGViewController.navigationController pushViewController:personalDataVC animated:YES];
    }else {
        
        BYC_ShowHeaderImageViewController *showHeaderImageVC = [[BYC_ShowHeaderImageViewController alloc] init];
        showHeaderImageVC.imageUrl = _model.headportrait;
        
        [self.getBGViewController presentViewController:showHeaderImageVC animated:YES completion:nil];
    }
}
- (IBAction)buttonAction:(UIButton *)sender {
    
    
    if (sender.tag == 3) {
        
        [BYC_MyCenterFocusRequestDataHandler whetherSelectFocusWithToUserID:_model handler:_handle completion:^(BOOL success, WhetherFocusForCell status) {
            sender.userInteractionEnabled = YES;
            SearchUserListFocusStateBlock searchUserListFocusStateBlock = ((HL_CenterViewController *)self.getBGViewController).searchUserListFocusStateBlock;
            if (searchUserListFocusStateBlock) searchUserListFocusStateBlock(status);
        }];
    }else {
    
        [QNWSNotificationCenter postNotificationName:_str_Notification2 object:@(sender.tag)];
    }
}
@end
