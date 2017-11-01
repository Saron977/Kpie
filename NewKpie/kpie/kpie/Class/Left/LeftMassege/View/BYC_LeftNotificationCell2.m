//
//  BYC_LeftNotificationCell2.m
//  kpie
//
//  Created by 元朝 on 16/1/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_LeftNotificationCell2.h"
#import "DateFormatting.h"

@interface BYC_LeftNotificationCell2()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Header;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Sex;
@property (weak, nonatomic) IBOutlet UILabel *label_NickName;
@property (weak, nonatomic) IBOutlet UILabel *label_Time;
@property (weak, nonatomic) IBOutlet UILabel *label_Content;
@property (weak, nonatomic) IBOutlet UILabel *lable_Title;

@end

@implementation BYC_LeftNotificationCell2

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)setModel:(BYC_LeftNotificationModel *)model {
    
    _model = model;
    
    [_imageV_Header sd_setImageWithURL:[NSURL URLWithString:model.video.users.headportrait] placeholderImage:[UIImage imageNamed:@"Icon-Small"]];
    if (model.video.users.nickname.length > 0) {
        _label_NickName.text = model.video.users.nickname;
    }
    else{
        _label_NickName.text = @"看拍小助手";
        _label_NickName.textColor = KUIColorBaseGreenNormal;
    }
    _label_Content.text = [NSString stringWithFormat:@"%@",model.content] ;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([model.createdate doubleValue]/1000)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateString = [formatter stringFromDate:date];
    _label_Time.text = dateString;
    _lable_Title.text = model.title;
    if (model.users.sex == 0) {
        
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nan"];
    }else if(_model.users.sex == 1) {
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nv-xiao"];
    }else {
        _imageV_Sex.image = [UIImage imageNamed:@"baomi"];
    }
}

- (IBAction)clickHeaderAction:(id)sender {
    
    if (self.clickHeaderAction) {
        self.clickHeaderAction();
    }
}

@end
