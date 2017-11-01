//
//  WX_CommentsTableViewCell.m
//  kpie
//
//  Created by 王傲擎 on 15/12/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_CommentsTableViewCell.h"
#import "HL_CenterViewController.h"
#import "BYC_LoginAndRigesterView.h"
#import "WX_FMDBManager.h"
#import "DateFormatting.h"
#import "EMCDDeviceManager.h"

#define commentLabel screenWidth-commentLabeL.frame.origin.x -(screenWidth -postDataTime.frame.origin.x)/2

@interface WX_CommentsTableViewCell ()

@property (nonatomic, strong) NSMutableArray                  *animationArray;           /**< 动画数组 */
@property (nonatomic, strong) UIImageView                     *animationImgView;         /**< 动画图片 */
@property (nonatomic, strong) NSMutableData                   *recData;                  /**< 接收下载数据 */
@property (nonatomic, strong) NSString                        *filePath;                 /**< 文件路径 */
@property (nonatomic, strong) NSFileManager                   *fileManager;
@property (nonatomic, strong) NSFileHandle                    *fileHandle;               /**< 文件操作句柄 */
@property (nonatomic, strong) NSURLConnection                 *downConnection;           /**< 下载链接对象 */
@property (nonatomic, strong) WX_FMDBManager                  *manager;
@property (nonatomic, strong) EMCDDeviceManager               *EMCDDeviceMananger;

@end

@implementation WX_CommentsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContainView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.opaque = YES;
        self.backgroundColor = KUIColorFromRGB(0xFFFFFF);
        self.alpha = 1;
    }
    return self;
}


-(void)initContainView{
    //用户头像
    _view_headerIcon = [[UIView alloc]init];
    _view_headerIcon.opaque = YES;
    _imageV_userIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UMS_User_profile_default"]];
    _imageV_userIcon.clipsToBounds = YES;
    _imageV_userIcon.layer.cornerRadius = 15;
    _imageV_userIcon.contentMode = UIViewContentModeScaleAspectFill;
    _imageV_userIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeader:)];
    [_imageV_userIcon addGestureRecognizer:tap];
    
    _imageV_signIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iocn-mingshi"]];
    _imageV_signIcon.opaque = YES;
    _imageV_signIcon.clipsToBounds = YES;
    _imageV_signIcon.layer.cornerRadius = 4;
    _imageV_signIcon.contentMode = UIViewContentModeScaleAspectFill;
    
    _lable_userNickname = [[UILabel alloc]init];
    _lable_userNickname.opaque = YES;
    _lable_userNickname.font = [UIFont systemFontOfSize:14];
    _lable_userNickname.textColor = KUIColorWordsBlack1;
    _lable_userNickname.text = @"小苹果";
    [_lable_userNickname sizeToFit];
    
    _image_userSex = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dongtai_icon__xb_nan"]];
    _image_userSex.opaque = YES;
    _lable_commentTime = [[UILabel alloc]init];
    _lable_commentTime.textColor = KUIColorWordsBlack4;
    _lable_commentTime.font = [UIFont systemFontOfSize:10];
    _lable_commentTime.textAlignment = NSTextAlignmentRight;
    _lable_commentTime.text = @"20分钟前";
    [_lable_commentTime sizeToFit];
    _lable_commentTime.opaque = YES;
    
    _lable_Comment = [[UILabel alloc]init];
    _lable_Comment.textColor = KUIColorWordsBlack3;
    _lable_Comment.font = [UIFont systemFontOfSize:15];
    _lable_Comment.numberOfLines = 0;
    _lable_Comment.text = @"加油。。。。。。。";
    [_lable_Comment sizeToFit];
    _lable_Comment.opaque = YES;
    
    _view_voice  = [[UIView alloc]init];
    _view_voice.backgroundColor = KUIColorBackgroundModule1;
    _view_voice.layer.cornerRadius = 5;
    _view_voice.layer.masksToBounds = YES;
    _view_voice.layer.borderWidth = 1;
    _view_voice.layer.borderColor = KUIColorFromRGB(0x2ca298).CGColor;
    _view_voice.userInteractionEnabled = YES;
    _view_voice.hidden = YES;
    _view_voice.opaque = YES;
    
    self.animationImgView = [[UIImageView alloc]init];
    [_view_voice addSubview:self.animationImgView];
    
    _lable_voiceComment = [[UILabel alloc]init];
    _lable_voiceComment.font = [UIFont systemFontOfSize:12];
    _lable_voiceComment.textColor = KUIColorWordsBlack4;
    _lable_voiceComment.hidden = YES;
    
    _tapView = [[UIView alloc]init];
    _tapView.backgroundColor = [UIColor clearColor];
    _tapView.userInteractionEnabled = YES;
    _tapView.opaque = YES;
    
    [self addSubview:_view_headerIcon];
    [_view_headerIcon addSubview:_imageV_userIcon];
    [_view_headerIcon addSubview:_imageV_signIcon];
    [self addSubview:_lable_userNickname];
    [self addSubview:_image_userSex];
    [self addSubview:_lable_commentTime];
    [self addSubview:_lable_Comment];
    [self addSubview:_view_voice];
    [self addSubview:_lable_voiceComment];
    [self addSubview:_tapView];
    //约束
    [_view_headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.mas_top).offset(12);
        make.width.height.mas_equalTo(40);
    }];
    [_imageV_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_view_headerIcon);
        make.width.height.mas_equalTo(30);
    }];
    [_imageV_signIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageV_userIcon.mas_right).offset(-6);
        make.bottom.equalTo(_imageV_userIcon.mas_top).offset(7);
        make.width.height.mas_equalTo(8);
    }];
    
    [_lable_userNickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_headerIcon.mas_right).offset(6);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    [_image_userSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lable_userNickname.mas_right).offset(4);
        make.centerY.equalTo(_lable_userNickname.mas_centerY);
        make.width.height.mas_equalTo(10);
    }];
    
    [_lable_commentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    [_lable_Comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_headerIcon.mas_right).offset(6);
        make.top.equalTo(_lable_userNickname.mas_bottom).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
    
    
    [_view_voice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_headerIcon.mas_right).offset(6);
        make.top.equalTo(_lable_userNickname.mas_bottom).offset(12);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    [self.animationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_voice.mas_left).offset(3);
        make.centerY.equalTo(_view_voice.mas_centerY);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(25);
    }];
    
    [_lable_voiceComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_voice.mas_right).offset(10);
        make.centerY.equalTo(_view_voice.mas_centerY);
    }];
    [_lable_voiceComment sizeToFit];
    [_tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lable_userNickname.mas_bottom).offset(12);
        make.left.equalTo(_view_headerIcon.mas_right).offset(6);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
    }];
}

-(void)clickHeader:(UITapGestureRecognizer *)tapGesture{
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        HL_CenterViewController *centerVC = [[HL_CenterViewController alloc]init];
        centerVC.str_ToUserID = _commentModel.users.userid;
        
        [[self getViewController].navigationController pushViewController:centerVC animated:YES];
        
    }];
}
/// userType
//  用户类型: 0普通用户，10名师，1后台管理员
-(void)setCellWithModel:(WX_CommentModel *)model UserType:(NSInteger)UserType
{
    self.animationArray = [[NSMutableArray alloc]init];
    NSArray *copyArray = @[@"icon-yuyin-voice",@"img-shape1",@"img-shape2",@"img-shape3"];
    for (NSString *str in copyArray) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@",str]];
        [self.animationArray addObject:img];
    }
    _commentModel = model;
    [_imageV_userIcon sd_setImageWithURL:[NSURL URLWithString:model.users.headportrait] placeholderImage:[UIImage imageNamed:@"icon-tx-160"]];
    //名师加“T”标志
    if (UserType == 10) _imageV_signIcon.hidden = NO;
    else if (UserType == 0) _imageV_signIcon.hidden = YES;
    if (model.users.nickname == nil) _lable_userNickname.text = @"昵称";
    else _lable_userNickname.text = model.users.nickname;
    
    CGSize nickNameSize = [model.users.nickname boundingRectWithSize:CGSizeMake(screenWidth-60,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}context:nil].size;
    if (nickNameSize.width > 150) {
       [_lable_userNickname mas_updateConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(150);
           make.height.mas_equalTo(20);
       }];
    }
    else{
     [_lable_userNickname sizeToFit];
    }
    

    /// 判断语音或则文字
    if (model.isvoice) {
        _lable_voiceComment.hidden  = NO;
        _view_voice.hidden          = NO;
        _lable_Comment.hidden       = YES;
        _lable_Comment.text         = nil;
        
        // 语音框frame
        if (model.seconds < 10 && model.seconds > 3) {
            [_view_voice mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(screenWidth*0.5*model.seconds/10);
            }];
            [_tapView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(screenWidth*0.5*model.seconds/10);
            }];
        }
        if (model.seconds <= 3) {
            [_view_voice mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(screenWidth*0.5/10*3);
            }];
            [_tapView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(screenWidth*0.5/10*3);
            }];
        }
        self.animationImgView.image = self.animationArray[0];
        self.animationImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        /// 语音时长
        _lable_voiceComment.text = [NSString stringWithFormat:@"%zi'' ",model.seconds];
        [_lable_voiceComment sizeToFit];

        
    }else{
        _lable_Comment.hidden       = NO;
        _view_voice.hidden          = YES;
        _lable_voiceComment.hidden  = YES;
        //文本评论
        _lable_Comment.text = model.content;
        // 利用富文本 添加表情的评论
        NSString *emojiPath = [[NSBundle mainBundle]pathForResource:@"emoji" ofType:nil];
        NSError *error;
        NSString *emojiStr = [NSString stringWithContentsOfFile:emojiPath encoding:NSUTF8StringEncoding error:&error];
            
        NSMutableArray *emojiArrayM = [[NSMutableArray alloc]init];
            
        if (error == nil) {
            NSArray *emojiArray = [emojiStr componentsSeparatedByString:@"\n"];
            for (NSString *emoji in emojiArray) {
                    
                NSMutableArray *arrayEmoji = [[emoji componentsSeparatedByString:@","] mutableCopy];
                arrayEmoji[1] = [arrayEmoji[1] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                [emojiArrayM addObject:arrayEmoji];
            }
        }
        NSArray *commentArray = [_commentModel.content componentsSeparatedByString:@"["];
        NSString *firstComment  = [commentArray firstObject];
        // 表情从第几位开始
        NSInteger commentIndex = firstComment.length;
        // 表情长度
        NSInteger emojiIndex = 0;
        NSMutableAttributedString *textCommentStr = [[NSMutableAttributedString alloc]initWithString:model.content];
            
        for (int i = 0; i < commentArray.count; i++) {
                
            NSString *contStr = commentArray[i];
            NSArray *array = [contStr componentsSeparatedByString:@"]"];
                
            if (array.count > 1) {
                NSString *strArr = array.firstObject;
                NSString *comEmojiStr = [NSString stringWithFormat:@"[%@]",array.firstObject];
                commentIndex += emojiIndex;
                emojiIndex = strArr.length+2;
                
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                for (NSArray *strArray in emojiArrayM) {
                    if ([strArray.lastObject isEqualToString:comEmojiStr]) {
                            
                        // 添加表情
                        // 表情图片
                        attch.image = [UIImage imageNamed:[strArray firstObject]];
                        // 设置图片大小
                        attch.bounds = CGRectMake(0, -3.5, _lable_Comment.font.lineHeight, _lable_Comment.font.lineHeight);
                            
                        // 创建带有图片的富文本
                        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                            
                        [textCommentStr replaceCharactersInRange:NSMakeRange(commentIndex, emojiIndex) withAttributedString:string];
                            
                        commentIndex = commentIndex -emojiIndex; // 替换几位 要回退几位,坑爹搞了好久
                            
                        emojiIndex++; // 表情位数随着表情个数自增一位
                    }
                    _lable_Comment.text = nil;
                    // 用label的attributedText属性来使用富文本
                    _lable_Comment.attributedText = textCommentStr;
                }
            }
        }
        [_lable_Comment sizeToFit];
        [_tapView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGRectGetHeight(_lable_Comment.frame));
            make.width.mas_equalTo(CGRectGetWidth(_lable_Comment.frame));
        }];
        
       
    }
    
    // 时间
//    NSString *timeStr = [[DateFormatting alloc]YesterdayToday:[model.postDateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
//    _lable_commentTime.text = timeStr;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([model.postdatetime doubleValue]/1000)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString * dateString = [formatter stringFromDate:date];
    _lable_commentTime.text = dateString;
    if (model.sex) {
            /// 女
            _image_userSex.image = [UIImage imageNamed:@"tongyong_icon_girl"];
    }else{
            /// 男
            _image_userSex.image = [UIImage imageNamed:@"tongyong_icon_boy"];
        }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheComment)];
    [_tapView addGestureRecognizer:tap];
    [self bringSubviewToFront:_tapView];

}

+(CGFloat)cellHeightWithString:(WX_CommentModel *)commentModel
{
    if (![commentModel.content isEqualToString:@""]) {
        CGRect commentRect = [commentModel.content boundingRectWithSize:CGSizeMake(screenWidth-60,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}context:nil];
        CGSize textSize = [commentModel.content sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        CGFloat textRow = (commentRect.size.height / textSize.height);
        return 12 + 30 + commentRect.size.height + 12 + textRow;
    }
    else return 12 + 30 + 12;
    
}
#pragma mark ---------- 点击评论,回复
/// 点击评论,回复
-(void)tapTheComment
{
    
    if (_lable_Comment.hidden) {
        /// 评论 隐藏 为语音
        [QNWSNotificationCenter postNotificationName:@"stopAnimation" object:nil];
         [self playVoiceAnimation];
        [self playVoice];

    }else {
        [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
            
            /// 评论不隐藏 回复
            if ([self.userArray containsObject:_commentModel]) {
                
                NSInteger num = [self.userArray indexOfObject:_commentModel];
                
                [QNWSNotificationCenter postNotificationName:@"notiComments" object:[NSNumber numberWithInteger:num]];
            }
            
        }];
    }
    
 
}

#pragma mark ------------- 语音文件播放
/// 点击播放 语音文件
-(void)playVoice
{
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    _filePath = [path stringByAppendingPathComponent:@"Voice"];
    _fileManager = [NSFileManager defaultManager];
    [_fileManager createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil];
    _filePath = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",_commentModel.commentID]];
    QNWSLog(@"filePath == %@",_filePath);

    NSString *urlAsString = _commentModel.content;
    NSURL    *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    /* 下载的数据 */
    if (data != nil){
        [QNWSNotificationCenter postNotificationName:@"voicePase" object:nil];
        QNWSLog(@"下载成功");
        if ([data writeToFile:_filePath atomically:YES]) {
            QNWSLog(@"保存成功");
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:_filePath completion:^(NSError *error) {
                if (!error) {
                    QNWSLog(@"语音文件播放成功");
                    [self stopVoiceAnimation];
                    [QNWSNotificationCenter postNotificationName:@"voicePlay" object:nil];
              
                }else{
                    [self stopVoiceAnimation];
                    QNWSLog(@"error == %@",error);
                }
            }];
        }else{
            [self stopVoiceAnimation];
            QNWSLog(@"保存失败");
        }
    }else{
        [self stopVoiceAnimation];
        QNWSLog(@"音频文件下载失败,error == %@", error);
    }

    
  
}

#pragma mark --------- 动画效果
-(void)playVoiceAnimation
{
    self.animationImgView.animationImages = self.animationArray;
    
    //动画时间(将数组中所有图片跑一遍用的时间)
    self.animationImgView.animationDuration = 2.0;
    
    //动画循环次数.0代表无限循环
    self.animationImgView.animationRepeatCount = 0;
    
    //开始动画
    [self.animationImgView startAnimating];

}


-(void)stopVoiceAnimation
{
    [self.animationImgView stopAnimating];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
