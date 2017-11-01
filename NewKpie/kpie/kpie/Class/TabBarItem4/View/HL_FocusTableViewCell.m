//
//  HL_FocusTableViewCell.m
//  kpie
//
//  Created by sunheli on 16/7/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_FocusTableViewCell.h"
#import "DateFormatting.h"
#import "BYC_FocusViewController.h"
#import "BYC_MediaPlayer.h"
#import "BYC_View_MediaPlayer.h"
#import "BYC_LoginAndRigesterView.h"
#import "HL_TagTool.h"
#import "HL_TagViewController.h"
#import "UIView+BYC_GetViewController.h"

@interface HL_FocusTableViewCell ()
{
   NSString *descrip_Str;
    NSString *descrip;
    NSString *title;
     NSString *url_Str;
    NSMutableAttributedString *attStr;
}

@property (nonatomic, strong) UIView        *view_userMassage;    /**<  用户基本信息栏*/
@property (nonatomic, strong) UIImageView   *imageV_userIcon;
@property (nonatomic, strong) UILabel       *lable_userNickName;
@property (nonatomic, strong) UIImageView   *imageV_userSex;
@property (nonatomic, strong) UILabel       *lable_ReleaseTime;
@property (nonatomic, strong) UIImageView   *imageV_playedICon;
@property (nonatomic, strong) UILabel       *lable_playedCount;
@property (nonatomic, strong) UIButton      *button_shoot;        /**<     合拍按钮*/
@property (nonatomic, strong) UIButton      *button_Focus;          /**<     添加关注按钮*/

@property (nonatomic, strong) UIView        *view_video;          /**<      视频栏*/
@property (nonatomic, strong) UIImageView   *imageV_videoImage;
@property (nonatomic, strong) UIButton      *button_playVieo;

@property (nonatomic, strong) UITextView       *lable_VideoDescription;

@property (nonatomic, strong) UIView        *View_HscripLine;     /**<     水平分割线*/

@property (nonatomic, strong) UIView        *view_bottomButton;         /**<     底部按钮栏*/
@property (nonatomic, strong) UIButton      *button_forward;      /**<     转发*/
@property (nonatomic, strong) UIButton      *button_comment;      /**<     评论*/
@property (nonatomic, strong) UIButton      *button_like;         /**<     点赞*/
@property (nonatomic, strong) UIView        *view_VscriptLine1;
@property (nonatomic, strong) UIView        *view_VscriptLine2;


@property (nonatomic, strong) BYC_FocusViewController       *focusVC;                   /**< 获得关注 */
/**  存放主题 */
@property (nonatomic, strong) NSMutableArray                *array_Topic;
/**  存放网址 */
@property (nonatomic, strong) NSMutableArray                *array_Url;

/**当前播放的url*/
@property (nonatomic, copy)  NSString  *string_CurrentVideoUrl;

@end

@implementation HL_FocusTableViewCell

-(NSMutableArray *)array_Topic{
    
    if (!_array_Topic) {
        _array_Topic = [NSMutableArray array];
    }
    return _array_Topic;
}
-(NSMutableArray *)array_Url{
    if (!_array_Url) {
        _array_Url = [NSMutableArray array];
    }
    return _array_Url;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initFocusTableViewCell];
        [self setTableViewCellAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = KUIColorFromRGB(0xFCFCFC);
    }
    return self;
}

-(void)initFocusTableViewCell{
    
    //用户基本信息栏
    self.view_userMassage = [[UIView alloc]init];
    
    self.imageV_userIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UMS_User_profile_default"]];
    self.imageV_userIcon.clipsToBounds = YES;
    self.imageV_userIcon.layer.cornerRadius = 15;
    self.imageV_userIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV_userIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeader:)];
    [self.imageV_userIcon addGestureRecognizer:tap];
    
    self.lable_userNickName = [[UILabel alloc]init];
    self.lable_userNickName.font = [UIFont systemFontOfSize:14];
    self.lable_userNickName.textColor = KUIColorFromRGB(0x3C4F5E);
    self.lable_userNickName.text = @"威尼斯先生";
    [self.lable_userNickName sizeToFit];
    
    self.imageV_userSex = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dongtai_icon__xb_nan"]];
    
    self.lable_ReleaseTime = [[UILabel alloc]init];
    self.lable_ReleaseTime.textColor = KUIColorFromRGB(0x6C7B8A);
    self.lable_ReleaseTime.font = [UIFont systemFontOfSize:9];
    self.lable_ReleaseTime.text = @"06-06 06:06";
    [self.lable_ReleaseTime sizeToFit];
    
    self.imageV_playedICon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dongtai_icon_view"]];
    self.lable_playedCount =[[UILabel alloc]init];
    self.lable_playedCount.textColor = KUIColorFromRGB(0x6C7B8A);
    self.lable_playedCount.font =[UIFont systemFontOfSize:9];
    self.lable_playedCount.text = @"播放：22222";
    [self.lable_playedCount sizeToFit];
    
    self.button_shoot =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_shoot setImage:[UIImage imageNamed:@"dongtai_btn_hepai_n"] forState:UIControlStateNormal];
    [self.button_shoot setImage:[UIImage imageNamed:@"dongtai_btn_hepai_h"] forState:UIControlStateSelected];
    [self.button_shoot addTarget:self action:@selector(focusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button_shoot.tag = 1;
    
    self.button_Focus = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_Focus setImage:[UIImage imageNamed:@"video_btn_guanzhu_n"] forState:UIControlStateNormal];
    [self.button_Focus setImage:[UIImage imageNamed:@"video_btn_guanzhu_h"] forState:UIControlStateSelected];
    [self.button_Focus addTarget:self action:@selector(focusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button_Focus.tag = 2;
    
    
    //视频栏
    self.view_video = [[UIView alloc]init];
    
    self.imageV_videoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Chat_record_circle"]];
    self.imageV_videoImage.clipsToBounds = YES;
    self.imageV_videoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV_videoImage.userInteractionEnabled = YES;
    self.imageV_videoImage.tag = 1001;
    
    self.button_playVieo = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_playVieo setImage:[UIImage imageNamed:@"Play_h"] forState:UIControlStateNormal];
    [self.button_playVieo addTarget:self action:@selector(focusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button_playVieo.tag = 3;
    //描述
    self.lable_VideoDescription = [[UITextView alloc]init];
    self.lable_VideoDescription.font = [UIFont systemFontOfSize:14];
    self.lable_VideoDescription.backgroundColor = [UIColor clearColor];
    self.lable_VideoDescription.textColor = KUIColorFromRGB(0x4D606F);
    self.lable_VideoDescription.delegate = self;
    self.lable_VideoDescription.scrollEnabled = NO;
    self.lable_VideoDescription.editable = NO;
    //设置点击时的样式
    NSDictionary *linkAttributes =@{NSForegroundColorAttributeName:KUIColorFromRGB(0xF89117),NSUnderlineColorAttributeName:KUIColorFromRGB(0xF89117),NSUnderlineStyleAttributeName:@(NSUnderlinePatternSolid)};
    self.lable_VideoDescription.linkTextAttributes = linkAttributes;
    
    self.View_HscripLine = [[UIView alloc]init];
    self.View_HscripLine.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    
    //底部按钮
    self.view_bottomButton = [[UIView alloc]init];
    self.button_forward =[self createCategoryBtn:@"分享" action:@selector(focusBtnAction:)];
    [self.button_forward setImage:[UIImage imageNamed:@"dongtai_btn_zhuanfa_n"] forState:UIControlStateNormal];
    [self.button_forward setImage:[UIImage imageNamed:@"dongtai_btn_zhuanfa_h"] forState:UIControlStateSelected];
    self.button_forward.tag = 4;
    self.button_forward.backgroundColor = [UIColor clearColor];
    
    self.button_comment = [self createCategoryBtn:@"666" action:@selector(focusBtnAction:)];
    self.button_comment.tag = 5;
    [self.button_comment setImage:[UIImage imageNamed:@"dongtai_btn_pj_n"] forState:UIControlStateNormal];
    [self.button_comment setImage:[UIImage imageNamed:@"dongtai_btn_pj_h"] forState:UIControlStateSelected];
    
    self.button_like = [self createCategoryBtn:@"888" action:@selector(focusBtnAction:)];
    [self.button_like setImage:[UIImage imageNamed:@"dongtai_btn_zan_n"] forState:UIControlStateNormal];
    [self.button_like setImage:[UIImage imageNamed:@"dongtai_btn_zan_h"] forState:UIControlStateSelected];
    self.button_like.tag = 6;
    
    self.view_VscriptLine1 =[[UIView alloc]init];
    self.view_VscriptLine1.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    self.view_VscriptLine2 = [[UIView alloc]init];
    self.view_VscriptLine2.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    
    [self.view_userMassage addSubview:self.imageV_userIcon];
    [self.view_userMassage addSubview:self.lable_userNickName];
    [self.view_userMassage addSubview:self.imageV_userSex];
    [self.view_userMassage addSubview:self.lable_ReleaseTime];
    [self.view_userMassage addSubview:self.imageV_playedICon];
    [self.view_userMassage addSubview:self.lable_playedCount];
    [self.view_userMassage addSubview:self.button_shoot];
    [self.view_userMassage addSubview:self.button_Focus];
    
    [self.view_video addSubview:self.imageV_videoImage];
    [self.imageV_videoImage addSubview:self.button_playVieo];
    
    [self.view_bottomButton addSubview:self.button_forward];
    [self.view_bottomButton addSubview:self.button_comment];
    [self.view_bottomButton addSubview:self.button_like];
    [self.view_bottomButton addSubview:self.view_VscriptLine1];
    [self.view_bottomButton addSubview:self.view_VscriptLine2];
    
    [self addSubview:self.view_userMassage];
    [self addSubview:self.view_video];
    [self addSubview:self.lable_VideoDescription];
    [self addSubview:self.View_HscripLine];
    [self addSubview:self.view_bottomButton];
}
-(void)setTableViewCellAutoLayout{
    //约束
    [self.view_userMassage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(52);
    }];
    
    [self.imageV_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view_userMassage.mas_left).offset(9);
        make.top.equalTo(self.view_userMassage.mas_top).offset(12);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.lable_userNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_userIcon.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    [self.imageV_userSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lable_userNickName.mas_right).offset(4);
        make.centerY.equalTo(self.lable_userNickName.mas_centerY);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.lable_ReleaseTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_userIcon.mas_right).offset(8);
        make.top.equalTo(self.lable_userNickName.mas_bottom).offset(5);
    }];
    
    [self.imageV_playedICon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lable_ReleaseTime.mas_right).offset(12);
        make.top.equalTo(self.lable_userNickName.mas_bottom).offset(5);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(9);
    }];
    
    [self.lable_playedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_playedICon.mas_right).offset(4);
        make.top.equalTo(self.lable_userNickName.mas_bottom).offset(5);
    }];
    
    [self.button_shoot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_userMassage.mas_centerY);
        make.right.equalTo(self.view_userMassage.mas_right).offset(-46);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(27);
    }];
    
    [self.button_Focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_userMassage.mas_centerY);
        make.left.equalTo(self.button_shoot.mas_right).offset(10);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.view_video mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_userMassage.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(562/2);
    }];
    
    [self.imageV_videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view_video);
    }];
    
    [self.button_playVieo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.imageV_videoImage);
    }];
    
    [self.lable_VideoDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(9);
        make.right.equalTo(self.mas_right).offset(-9);
        make.top.equalTo(self.view_video.mas_bottom).offset(10);
    }];
    
    
    
    [self.view_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.View_HscripLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.view_bottomButton.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.button_forward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view_bottomButton);
        make.width.mas_equalTo((screenWidth-1)/3);
    }];
    
    [self.view_VscriptLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_bottomButton.mas_centerY);
        make.left.equalTo(self.button_forward.mas_right);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(21);
    }];
    
    [self.button_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view_VscriptLine1.mas_right);
        make.top.bottom.equalTo(self.view_bottomButton);
        make.width.mas_equalTo((screenWidth-1)/3);
    }];
    
    [self.view_VscriptLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_bottomButton.mas_centerY);
        make.left.equalTo(self.button_comment.mas_right);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(21);
    }];
    
    [self.button_like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view_VscriptLine2.mas_right);
        make.right.equalTo(self.view_bottomButton.mas_right);
        make.top.bottom.equalTo(self.view_bottomButton);
    }];
}

-(void)setModel:(BYC_BaseVideoModel *)model {
    [self.array_Topic removeAllObjects];
    [self.array_Url removeAllObjects];
    _model = model;
    [self.imageV_videoImage sd_setImageWithURL:[NSURL URLWithString:model.picturejpg] placeholderImage:nil];
    if (model.video_Description != nil) {
        
        descrip_Str =[model.video_Description stringByReplacingOccurrencesOfString:@"#review#" withString:@""];
        if ([descrip_Str rangeOfString:@"<lk>"].location !=NSNotFound && [descrip_Str rangeOfString:@"</lk>"].location !=NSNotFound) {
            descrip_Str =[descrip_Str stringByReplacingOccurrencesOfString:@"<lk>" withString:@""];
            descrip_Str =[descrip_Str stringByReplacingOccurrencesOfString:@"</lk>" withString:@""];
        }
        if([descrip_Str rangeOfString:@"#"].location !=NSNotFound){
            self.array_Topic = [HL_TagTool parseTag:descrip_Str];
            if (self.array_Topic.count > 0) {
                title = self.array_Topic[0];
                descrip = [descrip_Str stringByReplacingOccurrencesOfString:title withString:@""];
                if (self.array_Topic.count > 1) {
                    for (NSInteger i = 1; i<self.array_Topic.count; i++) {
                        title = [NSString stringWithFormat:@"%@ %@",title,self.array_Topic[i]];
                        descrip = [descrip stringByReplacingOccurrencesOfString:self.array_Topic[i] withString:@""];
                    }
                }
                
                if (descrip == nil) {
                    attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",title]];
                    [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0xF89117) range:NSMakeRange(0, title.length)];
                }
                else{
                    attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",title,descrip]];
                    [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0xF89117) range:NSMakeRange(0, title.length)];
                    [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(title.length, descrip.length+1)];
                }
 
            }
            else{
                attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",descrip_Str]];
                [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(0, attStr.length)];
            }
        }
        else{
                    attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",descrip_Str]];
                    [attStr addAttribute:NSForegroundColorAttributeName value:KUIColorFromRGB(0x4d606f) range:NSMakeRange(0, attStr.length)];
        }
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attStr.length)];
            //添加链接的方式
            for (NSInteger i = 0; i<self.array_Topic.count; i++) {
                [attStr addAttribute:NSLinkAttributeName
                               value:self.array_Topic[i]
                               range:[[attStr string] rangeOfString:self.array_Topic[i]]];
            }
            self.array_Url = [HL_TagTool parseUrlTag:descrip_Str];
            if (self.array_Url.count > 0) {
                for (NSInteger i = 0; i<self.array_Url.count; i++) {
                    NSString *url = self.array_Url[i];
                    // 添加链接的方式
        //            [attStr addAttribute:NSLinkAttributeName
        //                           value:[NSString stringWithFormat:@"http://%@",url]
        //                           range:[[attStr string] rangeOfString:url]];
                    NSInteger location_url = [[attStr string] rangeOfString:url].location;
                    NSInteger length_url = url.length;
                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                    // 添加链接
                    // 链接图片
                    attch.image = [UIImage imageNamed:@"icon_tongyong_lianjie"];
                    // 设置图片大小
                    attch.bounds = CGRectMake(i,-2,60,15);
                    // 创建带有图片的富文本
                    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                    [attStr replaceCharactersInRange:NSMakeRange(location_url, length_url) withAttributedString:string];
                }
            }        
        self.lable_VideoDescription.attributedText = attStr;
        [self.lable_VideoDescription sizeToFit];

    }
    
    [_imageV_userIcon sd_setImageWithURL:[NSURL URLWithString:model.users.headportrait] placeholderImage:[UIImage imageNamed:@"icon-tx-160"]];
    
    _lable_userNickName.text = model.users.nickname == nil ? @"昵称" : model.users.nickname;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([model.onofftime doubleValue]/1000)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString * dateString = [formatter stringFromDate:date];
    _lable_ReleaseTime.text = dateString;
    
    _lable_ReleaseTime.text = [model.onmstime substringToIndex:model.onmstime.length-7];
    
    
    if (_model.users.sex == 0) {
        
        _imageV_userSex.image = [UIImage imageNamed:@"dongtai_icon__xb_nan"];
    }else if(_model.users.sex == 1) {
        _imageV_userSex.image = [UIImage imageNamed:@"dongtai_icon__xb_nv"];
    }
    _lable_playedCount.text = [NSString stringWithFormat:@"播放：%ld",(long)model.views];
    [self.button_like setImage:model.isfavor ? [UIImage imageNamed:@"dongtai_btn_zan_h"]:[UIImage imageNamed:@"dongtai_btn_zan_n"] forState:UIControlStateNormal];
    if (model.isfavor) {//喜欢
        self.button_like.selected = YES;
    }else {//未喜欢
        
        self.button_like.selected = NO;
    }
    
    [_button_like setTitle:[NSString stringWithFormat:@"%ld",(long)model.favorites] forState:UIControlStateNormal];
    [_button_comment setTitle:[NSString stringWithFormat:@"%ld",(long)model.comments] forState:UIControlStateNormal];
    if (_model.isvr == 2){
        _button_shoot.hidden = NO;
        [_button_shoot mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-12);
        }];
    }
    else _button_shoot.hidden = YES;
    
    _button_Focus.hidden = YES;
}

-(void)focusBtnAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            //合拍
            self.selectButton(HL_FocusTableViewCellSelectedShoot,_model);
            break;
        case 2:
            //关注按钮
            
            break;
        case 3:
            //播放按钮
            self.clickPlayButtonBlock(sender);
            break;
        case 4:
            //转发
            self.selectButton(HL_FocusTableViewCellSelectedForward,_model);
            break;
        case 5:
            //评论
            self.selectButton(HL_FocusTableViewCellSelectedComment,_model);
            break;
        case 6:
        {
            //点赞
            //未登录跳转去登录
            [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
                
                if (_model.isfavor) {//喜欢
                    
                    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                        
                        self.selectButton(HL_FocusTableViewCellSelectedLike, _model);
                    });
                    
                    
                }else {//未喜欢
                    
                    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                        
                    self.selectButton(HL_FocusTableViewCellSelectedLike, _model);
                   });
                }
            }];
    }
            break;
        default:
            break;
    }
}

-(void)clickHeader:(UITapGestureRecognizer *)tapGesture{
    self.clickHeaderButtonBlock(_model);
}

- (UIButton *)createCategoryBtn:(NSString *)btn_title action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:KUIColorFromRGB(0x3C4A55) forState:UIControlStateNormal];
    [button setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateSelected];
    [button setTitle:btn_title forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(CGFloat)returnCellHeightOfFocus:(BYC_BaseVideoModel *)model{
    if (model.video_Description.length > 0) {
        CGRect descripRect = [model.video_Description boundingRectWithSize:CGSizeMake(screenWidth-9-12-16,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}context:nil];
        return 52 + 562/2 + descripRect.size.height+ 12 + 14 + 45 + 16;
    }
    else return 52 + 562/2 + 12 + 45;
    
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if (URL == nil) {
        NSString *topic = [[attStr string] substringWithRange:NSMakeRange(characterRange.location, characterRange.length)];
        NSLog(@"topic===%@",topic);
        //标签跳转
        HL_TagViewController *tagVC = [[HL_TagViewController alloc]init];
        tagVC.title = topic;
        tagVC.themeStr = topic;
        [self.getBGViewController.navigationController pushViewController:tagVC animated:YES];
        
    }
    return YES;
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    NSInteger index = textAttachment.bounds.origin.x;
    url_Str = self.array_Url[index];
    if ([url_Str rangeOfString:@"://"].location ==NSNotFound) {
        if (QNWS_CurrentDeviceSystemVersion >= 10.0)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url_Str]] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
        else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url_Str]]];
    }
    else{
        if (QNWS_CurrentDeviceSystemVersion >= 10.0)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_Str] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
        else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_Str]];
    }
    return YES;
}

@end
