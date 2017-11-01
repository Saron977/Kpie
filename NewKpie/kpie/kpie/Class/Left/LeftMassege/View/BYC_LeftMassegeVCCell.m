//
//  BYC_LeftMassegeVCCell.m
//  kpie
//
//  Created by 元朝 on 15/12/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LeftMassegeVCCell.h"
#import <UIKit/UIKit.h>
#import "DateFormatting.h"
#import "BYC_PlayVideoButton.h"
@interface BYC_LeftMassegeVCCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Header;
@property (weak, nonatomic) IBOutlet UILabel *label_NickName;
@property (weak, nonatomic) IBOutlet UILabel *label_VideoTitle;
@property (weak, nonatomic) IBOutlet UILabel *label_CommentContent;
@property (weak, nonatomic) IBOutlet UILabel *label_Time;
@property (weak, nonatomic) IBOutlet UILabel *label_CommentToContent;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Sex;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_CornerMask;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_CommentToContentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_CommentContentHeight;

@property (weak, nonatomic) IBOutlet UIButton *button_Look;
@property (weak, nonatomic) IBOutlet UIButton *button_Reply;

@property (nonatomic, strong)  BYC_PlayVideoButton  *view_Video;
@property (nonatomic, strong)  BYC_PlayVideoButton  *view_ToVideo;
@property (nonatomic, strong)  UILabel *label;
@end

@implementation BYC_LeftMassegeVCCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

-(void)setModel:(BYC_LeftMassegeModel *)model {
    
    _model = model;
    
    if (_model.content.length > 0 && _model.users.usertype == 10) {//名师 回复
        
        _button_Look.hidden = NO;
        _button_Reply.hidden = YES;
    }
    
    if (_model.content.length == 0 && _model.users.usertype == 10 ) {//名师 无回复
        
        _button_Look.hidden = NO;
        _button_Reply.hidden = YES;
    }
    
    if (_model.users.usertype != 10) {
        
        _button_Look.hidden = YES;
        _button_Reply.hidden = NO;
    }

    QNWSLog(@"type == %ld",(long)_model.users.usertype);
    
//    NSString *contentString;
    NSString *toContentString;
    
    _label_CommentToContentHeight.constant = model.label_CommentToContentHeight;
    _label_CommentContentHeight.constant = 0.1;
    _label_CommentContent.hidden = YES;
    
    if (!model.isvoice) {//评论和回复都不是语音
        
        _label.hidden = YES;
        _view_Video.hidden = YES;
        _view_ToVideo.hidden = YES;
        _label_CommentToContent.userInteractionEnabled = NO;
        _label_CommentContent.userInteractionEnabled = NO;
        if ([model.content rangeOfString:@"回复"].location !=NSNotFound) {
            
            NSRange rangeToContent = [model.content rangeOfString:@":"]; //现获取要截取的字符串位置
            NSString *resultToContent;
            if (rangeToContent.length > 0) {
                
                resultToContent = [model.content substringFromIndex:rangeToContent.location + 1]; //截取字符串
            }
            toContentString = [NSString stringWithFormat:@"%@: %@",@"回复了你的评论",resultToContent];;
//            contentString = [NSString stringWithFormat:@"%@: %@",@"回复了你的评论",model.content];
        }else {
        
            toContentString = model.content;
//            contentString = @"评论了你的视频";
        }

    }else {//评论或回复是语音

        if (model.content.length > 0) {//有回复
            
            if (model.isvoice) {//评论是语音

                if (_label == nil) {
                    
                    _label = [[UILabel alloc] init];
                    _label.text = @"回复了你的评论: ";
                    _label.textAlignment = NSTextAlignmentLeft;
                    _label.textColor = KUIColorFromRGB(0X9BA0AA);
                    _label.font = [UIFont systemFontOfSize:12];
                    _label.frame = CGRectMake(0, 45 - 12, 90, 12);
                }
//                _label_CommentContent.userInteractionEnabled = YES;
                _label.hidden = NO;
                if ([model.content rangeOfString:@"回复"].location !=NSNotFound) {
                    
                    NSRange rangeToContent = [model.content rangeOfString:@":"]; //现获取要截取的字符串位置
                    NSString *resultToContent;
                    if (rangeToContent.length > 0) {
                        
                        resultToContent = [model.content substringFromIndex:rangeToContent.location + 1]; //截取字符串
                        model.content = resultToContent;
                    }
                    [_label_CommentToContent addSubview:_label];
                    if (_view_Video == nil) {
                        
                        _view_Video = [[BYC_PlayVideoButton alloc] initVideoTime:[model.seconds integerValue] videoUrl:model.content videoCommentID:model.commentid frame:CGRectMake(_label.right, 0, 45, 25)];
                    }else {
                        
                        _view_Video.videoTime = [model.seconds integerValue];
                        _view_Video.videoUrlString = model.content;
                        //videoCommentID需要最后赋值，排在 videoTime videoUrlString 赋值之后
                        _view_Video.videoCommentID = model.commentid;
                    }
                }
                else{
                    if (_view_Video == nil) {
                        
                        _view_Video = [[BYC_PlayVideoButton alloc] initVideoTime:[model.seconds integerValue] videoUrl:model.content videoCommentID:model.commentid frame:CGRectMake(0, 0, 45, 25)];
                    }else {
                        
                        _view_Video.videoTime = [model.seconds integerValue];
                        _view_Video.videoUrlString = model.content;
                        //videoCommentID需要最后赋值，排在 videoTime videoUrlString 赋值之后
                        _view_Video.videoCommentID = model.commentid;
                    }
                }
                _view_Video.hidden = NO;
                _label_CommentToContent.userInteractionEnabled = YES;
                [_label_CommentToContent addSubview:_view_Video];
//                [_label_CommentContent addSubview:_view_Video];
//                if (model.isvoice) {//回复也是语音
//                    _label_CommentToContent.userInteractionEnabled = YES;
//                    if (_view_ToVideo == nil) {
//                        
//                        _view_ToVideo = [[BYC_PlayVideoButton alloc] initVideoTime:[model.seconds integerValue] videoUrl:model.content videoCommentID:model.commentid frame:CGRectMake(0, 0, 45, 45)];
//                    }else {
//                        
//                        _view_ToVideo.videoTime = [model.seconds integerValue];
//                        _view_ToVideo.videoUrlString = model.content;
//                        _view_ToVideo.videoCommentID = model.commentid;
//                    }
//                    _view_ToVideo.hidden = NO;
//                    [_label_CommentToContent addSubview:_view_ToVideo];
//                }
//                else {//回复是文本
//                    
//                    _view_ToVideo.hidden = YES;
//                    _label_CommentToContent.userInteractionEnabled = NO;
//                    NSRange rangeToContent = [model.content rangeOfString:@":"]; //现获取要截取的字符串位置
//                    NSString *resultToContent = [model.content substringFromIndex:rangeToContent.location + 1]; //截取字符串
//                    toContentString = resultToContent;
//                }
            }
//            else {//评论是文本，回复是语音
//                
//                _label.hidden = YES;
//                _view_ToVideo.hidden = NO;
//                _view_Video.hidden = YES;
//                _label_CommentContent.userInteractionEnabled = NO;
//                _label_CommentToContent.userInteractionEnabled = YES;
//                if (_view_ToVideo == nil) {
//                    
//                    _view_ToVideo = [[BYC_PlayVideoButton alloc] initVideoTime:[model.seconds integerValue] videoUrl:model.content videoCommentID:model.commentid frame:CGRectMake(0, 0, 45, 45)];
//                }else {
//                    
//                    _view_ToVideo.videoTime = [model.seconds integerValue];
//                    _view_ToVideo.videoUrlString = model.content;
//                    _view_ToVideo.videoCommentID = model.commentid;
//                }
//                [_label_CommentToContent addSubview:_view_ToVideo];
//                contentString = [NSString stringWithFormat:@"%@: %@",@"回复了你的评论",model.content];
//            }
        }
//        else {//无回复
//            
//            _label.hidden = YES;
//            _label_CommentContent.userInteractionEnabled = NO;
//            _label_CommentToContent.userInteractionEnabled = YES;
//            if (_view_ToVideo == nil) {
//                
//                _view_ToVideo = [[BYC_PlayVideoButton alloc] initVideoTime:[model.seconds integerValue] videoUrl:model.content videoCommentID:model.commentid frame:CGRectMake(0, 0, 45, 45)];
//            }else {
//                
//                _view_ToVideo.videoTime = [model.seconds integerValue];
//                _view_ToVideo.videoUrlString = model.content;
//                _view_ToVideo.videoCommentID = model.commentid;
//            }
//            _view_ToVideo.hidden = NO;
//            _view_Video.hidden = YES;
//            [_label_CommentToContent addSubview:_view_ToVideo];
//            contentString = @"评论了你的视频";
//
//        }
    }
    
    [_imageV_Header sd_setImageWithURL:[NSURL URLWithString:model.users.headportrait] placeholderImage:[UIImage imageNamed:@"icon-tx-160"]];
    _label_NickName.text = model.users.nickname;
    _label_VideoTitle.text = model.video.videotitle;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([model.postdatetime doubleValue]/1000)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateString = [formatter stringFromDate:date];
    _label_Time.text = dateString;
    
    _label_CommentToContent.text = toContentString;
    
    if (model.users.sex == 0) {
        
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nan"];
    }else if(_model.users.sex == 1) {
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nv-xiao"];
    }else {
        _imageV_Sex.image = [UIImage imageNamed:@"baomi"];
    }

    if (model.state == 0) {
        
        _imageV_CornerMask.hidden = NO;
    }else {
    
        _imageV_CornerMask.hidden = YES;
    }
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
            
            if (self.clickButtonBlock) {
                self.clickButtonBlock(ClickButtonBlockReply ,_model);
            }
            break;
        case 2:
            if (self.clickButtonBlock) {
                self.clickButtonBlock(ClickButtonBlockHeader ,_model);
            }
            break;
        case 3:
            if (self.clickButtonBlock) {
                self.clickButtonBlock(ClickButtonBlockLook ,_model);
            }
            break;
        default:
            break;
    }

}


@end
