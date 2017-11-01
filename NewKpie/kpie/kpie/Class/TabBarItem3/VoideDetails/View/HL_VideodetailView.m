
//
//  HL_VideodetailView.m
//  kpie
//
//  Created by sunheli on 16/7/16.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_VideodetailView.h"

#import "HL_CenterViewController.h"
#import "BYC_LoginAndRigesterView.h"
#import "DateFormatting.h"
#import "HL_TagTool.h"
#import "UIView+BYC_GetViewController.h"
#import "HL_TagViewController.h"

@interface HL_VideodetailView (){
    NSString *descrip_Str;
    NSString *descrip;
    NSString *title;
    NSString *url_Str;
    NSMutableAttributedString *attStr;
  
}

@end
@implementation HL_VideodetailView

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
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self initVideodetailView];
        self.backgroundColor = KUIColorFromRGB(0xFCFCFC);
    }
    return self;
}


-(void)initVideodetailView{
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
    self.lable_ReleaseTime.textColor = KUIColorWordsBlack4;
    self.lable_ReleaseTime.font = [UIFont systemFontOfSize:9];
    self.lable_ReleaseTime.text = @"20分钟前";
    [self.lable_ReleaseTime sizeToFit];
    
    self.imageV_playedICon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VIEW"]];
    self.lable_playedCount =[[UILabel alloc]init];
    self.lable_playedCount.textColor = KUIColorWordsBlack4;
    self.lable_playedCount.font =[UIFont systemFontOfSize:10];
    self.lable_playedCount.text = @"播放：22222";
    [self.lable_playedCount sizeToFit];
    
    self.button_shoot =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_shoot setImage:[UIImage imageNamed:@"tongyong_btn_hepai_n"] forState:UIControlStateNormal];
    [self.button_shoot setImage:[UIImage imageNamed:@"tongyong_btn_hepai_h"] forState:UIControlStateHighlighted];
    [self.button_shoot addTarget:self action:@selector(focusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button_shoot.tag = 1;
    
    //关注
    self.button_Focus = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_Focus setImage:[UIImage imageNamed:@"video_btn_guanzhu_n"] forState:UIControlStateNormal];
    [self.button_Focus setImage:[UIImage imageNamed:@"video_btn_guanzhu_h"] forState:UIControlStateHighlighted];
    [self.button_Focus addTarget:self action:@selector(focusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button_Focus.tag = 2;
    
    self.lable_VideoDescription = [[UITextView alloc]init];
    self.lable_VideoDescription.font = [UIFont systemFontOfSize:15];
    self.lable_VideoDescription.backgroundColor = [UIColor clearColor];
    self.lable_VideoDescription.textColor = KUIColorFromRGB(0x4D606F);
    self.lable_VideoDescription.delegate = self;
    self.lable_VideoDescription.scrollEnabled = NO;
    self.lable_VideoDescription.editable = NO;
    //设置点击时的样式
    NSDictionary *linkAttributes =@{NSForegroundColorAttributeName:KUIColorFromRGB(0xF89117),NSUnderlineColorAttributeName:KUIColorFromRGB(0xF89117),NSUnderlineStyleAttributeName:@(NSUnderlinePatternSolid)};
    self.lable_VideoDescription.linkTextAttributes = linkAttributes;
    
    self.view_script = [[UIView alloc]init];
    self.view_script.backgroundColor = KUIColorFromRGB(0xDEDEDE);
    
   //点赞过的
    _view_like = [[UIView alloc]init];
    
    _lable_likeCount =[[UILabel alloc]init];
    _lable_likeCount.textColor = KUIColorFromRGB(0x999999);
    _lable_likeCount.font = [UIFont systemFontOfSize:12];
    _lable_likeCount.textAlignment = NSTextAlignmentRight;
    _lable_likeCount.text = @"6422人赞过";
    [_lable_likeCount sizeToFit];
    
    
    _button_morelike = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_morelike setImage:[UIImage imageNamed:@"wode_icon_xiayibu_n"] forState:UIControlStateNormal];
    
    _view_script2 = [[UIView alloc]init];
    _view_script2.backgroundColor = KUIColorFromRGB(0xF0F0F0);
    
    
    [_view_userMassage addSubview:_imageV_userIcon];
    [_view_userMassage addSubview:_lable_userNickName];
    [_view_userMassage addSubview:_imageV_userSex];
    [_view_userMassage addSubview:_lable_ReleaseTime];
    [_view_userMassage addSubview:_imageV_playedICon];
    [_view_userMassage addSubview:_lable_playedCount];
    [_view_userMassage addSubview:_button_shoot];
    [_view_userMassage addSubview:_button_Focus];
    [_view_like addSubview:_lable_likeCount];
    [_view_like addSubview:_button_morelike];
    
    [self addSubview:_view_userMassage];
    [self addSubview:_lable_VideoDescription];
    [self addSubview:_view_script];
    [self addSubview:_view_like];
    [self addSubview:_view_script2];
    //约束
    [_view_userMassage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    
    [self.imageV_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view_userMassage.mas_left).offset(12);
        make.top.equalTo(self.view_userMassage.mas_top).offset(15);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.lable_userNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_userIcon.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(15);
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
        make.height.mas_equalTo(14);
    }];
    
    [_lable_playedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV_playedICon.mas_right).offset(4);
        make.top.equalTo(self.lable_userNickName.mas_bottom).offset(5);
    }];
    
    [_button_shoot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_userMassage.mas_centerY);
        make.right.equalTo(self.view_userMassage.mas_right).offset(-56);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(27);
    }];
    
    [_button_Focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_userMassage.mas_centerY);
        make.left.equalTo(self.button_shoot.mas_right).offset(10);
        make.width.mas_equalTo(40);
         make.height.mas_equalTo(24);
    }];
    
    [_lable_VideoDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(9);
        make.right.equalTo(self.mas_right).offset(-9);
        make.top.equalTo(self.view_userMassage.mas_bottom).offset(10);
    }];
    
    [_view_like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(54);
    }];
    [_view_script mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.view_like.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    
    [_button_morelike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_view_like.mas_right).offset(-12);
        make.centerY.equalTo(_view_like.mas_centerY).offset(0);
        make.width.height.mas_equalTo(18);
    }];
    
    [_lable_likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_view_like.mas_centerY);
        make.right.equalTo(_button_morelike.mas_left).offset(-10);
    }];
    
    [_view_script2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_view_like.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    [self initcollectionView];

}

-(void)initcollectionView{
        //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 4.0f;
    layout.itemSize = CGSizeMake(30,30);
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView_likeIcon = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, screenWidth-150, 54) collectionViewLayout:layout];
    [_view_like addSubview:_collectionView_likeIcon];
    _collectionView_likeIcon.dataSource = self;
    _collectionView_likeIcon.delegate = self;
    _collectionView_likeIcon.backgroundColor = [UIColor clearColor];
    _collectionView_likeIcon.showsHorizontalScrollIndicator = NO;
    _collectionView_likeIcon.pagingEnabled = YES;
    _collectionView_likeIcon.alwaysBounceHorizontal = NO;
    _collectionView_likeIcon.bounces = NO;
    [_collectionView_likeIcon registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"likeIconCell"];
}

-(void)setLikeArr:(NSArray *)likeArr{
    _likeArr = likeArr;
    [self.collectionView_likeIcon reloadData];
}

-(void)setFocusListModel:(BYC_BaseVideoModel *)focusListModel{
    _focusListModel = focusListModel;
    [self.array_Topic removeAllObjects];
    [self.array_Url removeAllObjects];
    if (_focusListModel.video_Description.length > 0) {
    descrip_Str =[_focusListModel.video_Description stringByReplacingOccurrencesOfString:@"#review#" withString:@""];
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
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attStr.length)];
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
    
    //创建UICollectionView
    [_collectionView_likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view_like.mas_left).offset(10);
        make.centerY.equalTo(_view_like.mas_centerY);
        make.right.equalTo(_lable_likeCount.mas_left).offset(-10);
        make.height.mas_equalTo(54);
    }];
    
    [_imageV_userIcon sd_setImageWithURL:[NSURL URLWithString:focusListModel.users.headportrait] placeholderImage:[UIImage imageNamed:@"icon-tx-160"]];
    
    if (focusListModel.users.nickname.length > 0) {
        CGSize nickNameSize = [focusListModel.users.nickname boundingRectWithSize:CGSizeMake(screenWidth-24,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}context:nil].size;
        _lable_userNickName.text = focusListModel.users.nickname;
        if (nickNameSize.width > 160) {
            [_lable_userNickName mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(160);
                make.height.mas_equalTo(20);
            }];
        }
        else{
            [_lable_userNickName sizeToFit];
        }
    }
    else{
    _lable_userNickName.text = @"昵称";
    [_lable_userNickName sizeToFit];
    }
    
    _lable_ReleaseTime.text = [focusListModel.onmstime substringToIndex:focusListModel.onmstime.length-7];

    if (focusListModel.users.sex == 0) {
        
        _imageV_userSex.image = [UIImage imageNamed:@"tongyong_icon_boy"];
    }else if(focusListModel.users.sex == 1) {
        _imageV_userSex.image = [UIImage imageNamed:@"tongyong_icon_girl"];
    }
    _lable_playedCount.text = [NSString stringWithFormat:@"播放 ：%lu",focusListModel.views];
    _lable_likeCount.text = [NSString stringWithFormat:@"%lu人赞过",focusListModel.favorites];
    if (_focusListModel.scriptid.length > 0) _button_shoot.hidden = NO;
    else _button_shoot.hidden = YES;
}
-(void)focusBtnAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            //合拍
            self.selectButton(BYC_FocusCollectionViewCellSelectedShoot,_focusListModel);
            break;
        case 2:
            //关注按钮
            self.selectButton(BYC_FocusCollectionViewCellSelectedFocus,_focusListModel);
            break;
                default:
            break;
    }

    
}

- (void)replaceModelData:(BYC_BackFocusListCellModel *)backModel isOK:(BOOL)isOK {
    
    if (isOK)_focusListModel.isfavor = !backModel.isOK;
    else _focusListModel.isfavor = backModel.isOK;
    
    _focusListModel.favorites = backModel.favorites;
    _focusListModel.views    = backModel.views;
    _focusListModel.comments = backModel.comments;
}

+(CGFloat)returnHeightOfFocusHeaderView:(BYC_BaseVideoModel *)model{
    if (model.video_Description.length > 0) {
        CGRect descripRect = [model.video_Description boundingRectWithSize:CGSizeMake(screenWidth-18-16,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        return 45 + 18 + descripRect.size.height + 14 + 16 + 64;
    }
    else return 45 + 18 +  14  + 64;
    
}


#pragma  Mark - collectionDataSourceAndDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _likeArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"likeIconCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
        BYC_AccountModel *likeModel = self.likeArr[indexPath.item];
        _imageV_likeIcon = [[UIImageView alloc]init];
        _imageV_likeIcon.contentMode = UIViewContentModeScaleAspectFill;
        _imageV_likeIcon.clipsToBounds = YES;
        _imageV_likeIcon.layer.cornerRadius = 11;
        [cell.contentView addSubview:_imageV_likeIcon];
        [_imageV_likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.height.mas_equalTo(22);
        }];
    [_imageV_likeIcon sd_setImageWithURL:[NSURL URLWithString:likeModel.headportrait] placeholderImage:[UIImage imageNamed:@"icon-tx-160"]];
        return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_likeArr.count >0) {
          BYC_AccountModel *likeModel = _likeArr[indexPath.item];
        
        [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
            
            HL_CenterViewController *centerVC = [[HL_CenterViewController alloc]init];
            centerVC.str_ToUserID = likeModel.userid;
            [[self getViewController].navigationController pushViewController:centerVC animated:YES];
        }];
    }
}

-(UIViewController *)getViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    UIViewController *vc = [[UIViewController alloc]init];
    return vc;
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if (URL == nil) {
       NSString *topic = [[attStr string] substringWithRange:NSMakeRange(characterRange.location, characterRange.length)];
    NSLog(@"topic===%@",topic);
        HL_TagViewController *tagVC = [[HL_TagViewController alloc]init];
        tagVC.title = topic;
        tagVC.themeStr = topic;
        [self.getBGViewController.navigationController pushViewController:tagVC animated:YES];
    }
    else{
        if (QNWS_CurrentDeviceSystemVersion >= 10.0)
            [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
        else [[UIApplication sharedApplication] openURL:URL];
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


-(void)clickHeader:(UITapGestureRecognizer *)tapGesture{
    self.clickHeaderButtonBlock(_focusListModel);
}



@end
