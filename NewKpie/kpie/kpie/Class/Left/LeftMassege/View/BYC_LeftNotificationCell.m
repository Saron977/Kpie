//
//  BYC_LeftNotificationCell.m
//  kpie
//
//  Created by 元朝 on 16/1/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_LeftNotificationCell.h"
#import "DateFormatting.h"
#import "BYC_ImageFromColor.h"

@interface BYC_LeftNotificationCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_Header;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Sex;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Pic;
@property (weak, nonatomic) IBOutlet UILabel *label_NickName;
@property (weak, nonatomic) IBOutlet UILabel *label_Title;
@property (weak, nonatomic) IBOutlet UILabel *label_Time;
@property (weak, nonatomic) IBOutlet UILabel *label_State;
@property (weak, nonatomic) IBOutlet UIButton *button_CheckDetails;
@property (weak, nonatomic) IBOutlet UILabel *label_CheckDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Check;


@end

@implementation BYC_LeftNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_button_CheckDetails setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:CGRectMake(0, 0, _button_CheckDetails.kwidth, _button_CheckDetails.kheight)] forState:UIControlStateHighlighted];
    
}

-(void)setModel:(BYC_LeftNotificationModel *)model {

    _model = model;
    
    [_imageV_Header sd_setImageWithURL:[NSURL URLWithString:model.video.users.headportrait] placeholderImage:[UIImage imageNamed:@"Icon-Small"]];
    if (model.video.users.nickname.length > 0) {
       _label_NickName.text = model.video.users.nickname;
        _label_NickName.textColor = KUIColorFromRGB(0x4D606F);
    }
    else{
        _label_NickName.text = @"看拍小助手";
        _label_NickName.textColor = KUIColorBaseGreenNormal;
    }
    
    _label_Title.text = [NSString stringWithFormat:@"%@",model.content] ;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:([model.createdate doubleValue]/1000)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateString = [formatter stringFromDate:date];
    _label_Time.text = dateString;
    [_imageV_Pic sd_setImageWithURL:[NSURL URLWithString:model.video.picturejpg] placeholderImage:[UIImage imageNamed:@"img_shipingmorentu_n"]];
    if (model.video.users.sex == 0) {
        
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nan"];
    }else if(model.video.users.sex == 1) {
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nv-xiao"];
    }else {
        _imageV_Sex.image = [UIImage imageNamed:@"baomi"];
    }
    
    if (model.state == 0) {
        
        _label_State.text = @"向您申请点评Ta的视频，快去看看吧！";
    }else {
        
        _label_State.text = @"已点评";
    }
}



- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1://查看详情
            _imageV_Check.image = KImageNamed(@"icon-ck-n");
            if (self.clickLeftNotificationCellButtonBlock) {
                self.clickLeftNotificationCellButtonBlock(ClickLeftNotificationCellButtonBlockReply ,_model);
            }
            break;
        case 2://点击头像
            if (self.clickLeftNotificationCellButtonBlock) {
                self.clickLeftNotificationCellButtonBlock(ClickLeftNotificationCellButtonBlockHeader ,_model);
            }
            break;
            
        default:
            break;
    }
    
}
- (IBAction)durgOutsideAction:(UIButton *)sender {

    _imageV_Check.image = KImageNamed(@"icon-ck-n");
}
- (IBAction)draginsideAction:(UIButton *)sender {

    _imageV_Check.image = KImageNamed(@"icon-ck-h");
}
- (IBAction)dragExit:(UIButton *)sender {

    _imageV_Check.image = KImageNamed(@"icon-ck-n");
}

- (IBAction)down:(UIButton *)sender {

    _imageV_Check.image = KImageNamed(@"icon-ck-h");
}

- (IBAction)cancel:(UIButton *)sender {

    _imageV_Check.image = KImageNamed(@"icon-ck-n");
}


@end
