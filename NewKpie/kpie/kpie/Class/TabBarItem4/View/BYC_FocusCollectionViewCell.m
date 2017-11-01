//
//  BYC_FocusCollectionViewCell.m
//  kpie
//
//  Created by 元朝 on 15/10/27.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_FocusCollectionViewCell.h"
#import "DateFormatting.h"
#import "BYC_FocusViewController.h"
#import "BYC_MediaPlayer.h"
#import "BYC_View_MediaPlayer.h"
#import "BYC_LoginAndRigesterView.h"

@interface BYC_FocusCollectionViewCell()

/**视频展示的图*/
@property (weak, nonatomic) IBOutlet UIImageView *imageV_VideoImage;
/**视频标题*/
@property (weak, nonatomic) IBOutlet UILabel *label_VideoTitle;
/**视频描述*/
@property (weak, nonatomic) IBOutlet UILabel *label_VideoDescription;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *imageV_HeaderImage;
/**昵称*/
@property (weak, nonatomic) IBOutlet UILabel *label_NickName;
/**上传时间*/
@property (weak, nonatomic) IBOutlet UILabel *label_UploadTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Sex;
/**播放数量*/
@property (weak, nonatomic) IBOutlet UILabel *label_PlayNum;
/**喜欢*/
@property (weak, nonatomic) IBOutlet UIButton *button_Like;
/**评论*/
@property (weak, nonatomic) IBOutlet UIButton *button_Comment;
/**分享*/
@property (weak, nonatomic) IBOutlet UIButton *button_Share;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_VideoHeight;

@property (nonatomic, strong) BYC_FocusViewController       *focusVC;                   /**< 获得关注 */
@property (strong, nonatomic) BYC_MediaPlayer *mediaPlayer;

/**当前播放的url*/
@property (nonatomic, copy)  NSString  *string_CurrentVideoUrl;
@end
@implementation BYC_FocusCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    if (!(KCurrentDeviceIsIphone6p))
    _constraint_VideoHeight.constant = KWidthOnTheBasisOfIPhone6Size(_constraint_VideoHeight.constant);
    
}


-(void)setModel:(BYC_FocusListModel *)model {

    _model = model;
    [self calculationCellWhetherHide];
    
    
    [_imageV_VideoImage sd_setImageWithURL:[NSURL URLWithString:model.pictureJPG] placeholderImage:nil];
    /// 屏蔽

    _label_VideoDescription.text = model.videoDescription;
    _label_VideoDescription.text = [_label_VideoDescription.text stringByReplacingOccurrencesOfString:@"#review#" withString:@""];
    _label_VideoTitle.text = model.videoTitle;
    [_imageV_HeaderImage sd_setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:nil];
    _label_NickName.text = model.nickName;
    
    _label_UploadTime.text = [[DateFormatting alloc] YesterdayToday:[model.onOffTime stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
    
    if (_model.sex == 0) {
        
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nan"];
    }else if(_model.sex == 1) {
        _imageV_Sex.image = [UIImage imageNamed:@"icon-nv-xiao"];
    }else {
        _imageV_Sex.image = [UIImage imageNamed:@"baomi"];
    }
    
    _label_PlayNum.text = [NSString stringWithFormat:@"%ld",(long)model.views];
    
    if (model.isLike) {//喜欢
        
        [_button_Like setImage:[UIImage imageNamed:@"icon-like-h"] forState:UIControlStateNormal];
    }else {//未喜欢
    
        [_button_Like setImage:[UIImage imageNamed:@"icon-like-n"] forState:UIControlStateNormal];
    }
    
    [_button_Like setTitle:[NSString stringWithFormat:@"%ld",(long)model.favorites] forState:UIControlStateNormal];
    [_button_Comment setTitle:[NSString stringWithFormat:@"%ld",(long)model.comments] forState:UIControlStateNormal];
    
    self.imgRect = _imageV_VideoImage.bounds;
    
    if ([_string_CurrentVideoUrl isEqualToString:model.videoMP4]) {
    
        _playButton.hidden = YES;
        [self.imageV_VideoImage addSubview:[BYC_MediaPlayer sharedBYC_MediaPlayer].view];
    } else {
    
        _playButton.hidden = NO;
        
    }
}

- (void)calculationCellWhetherHide {

   UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UICollectionView class]]) break;
        next = [next nextResponder];
    } while (next != nil);
    
    if (next) {
        
        UICollectionView *collectionView = (UICollectionView *)next;
        BOOL flag = NO;
        BYC_FocusCollectionViewCell *cellPlaying;
        for (BYC_FocusCollectionViewCell *cell in collectionView.visibleCells) {
            
            if (cell.playButton.hidden) {
                cellPlaying = cell;
                flag = YES;
                return;
            }
        }
        
        if (!flag)[self removePlayerView];
        
    }
}

- (void)removePlayerView {

    [[BYC_MediaPlayer sharedBYC_MediaPlayer].view removeFromSuperview];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1://喜欢
        {
            //未登录跳转去登录
            if (![BYC_AccountTool userAccount]) {
                
                [BYC_LoginAndRigesterView shareLoginAndRigesterView];
                return;
            }
            if (_model.isLike) {//喜欢
                
                dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{

                    BYC_BackFocusListCellModel *backModel = self.selectButton(BYC_FocusCollectionViewCellSelectedLike, _model);
                    
                    if (backModel.isOK) {//点击之后成功便是不喜欢
                        [self replaceModelData:backModel isOK:YES];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [_button_Like setImage:[UIImage imageNamed:@"icon-like-n"] forState:UIControlStateNormal];
                            [_button_Like setTitle:[NSString stringWithFormat:@"%ld",(long)backModel.favorites] forState:UIControlStateNormal];
                            _label_PlayNum.text  = [NSString stringWithFormat:@"%ld",(long)backModel.views];
                            [_button_Comment setTitle:[NSString stringWithFormat:@"%ld",(long)backModel.comments] forState:UIControlStateNormal];
                        });
                    }else {//点击之后失败还是喜欢
                        _model.isLike = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            [_button_Like setImage:[UIImage imageNamed:@"icon-like-h"] forState:UIControlStateNormal];
                        });  
                    }
                });
                
                
            }else {//未喜欢
                
                dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{

                    BYC_BackFocusListCellModel *backModel = self.selectButton(BYC_FocusCollectionViewCellSelectedLike , _model);
                    
                    if (backModel.isOK) {//点击之后成功便是喜欢
                        [self replaceModelData:backModel isOK:NO];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [_button_Like setImage:[UIImage imageNamed:@"icon-like-h"] forState:UIControlStateNormal];
                            [_button_Like setTitle:[NSString stringWithFormat:@"%ld",(long)backModel.favorites] forState:UIControlStateNormal];
                            _label_PlayNum.text  = [NSString stringWithFormat:@"%ld",(long)backModel.views];
                            [_button_Comment setTitle:[NSString stringWithFormat:@"%ld",(long)backModel.comments] forState:UIControlStateNormal];
                        });
                    }else {//点击之后失败还是不喜欢
                        _model.isLike = NO;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [_button_Like setImage:[UIImage imageNamed:@"icon-like-n"] forState:UIControlStateNormal];
                        });
                    }
                });
                               
        }
        }
            break;
        case 2://评论
            self.selectButton(BYC_FocusCollectionViewCellSelectedComment , _model);
            
            break;
        case 3://分享
            //未登录跳转去登录
            if (![BYC_AccountTool userAccount]) {
                
                [BYC_LoginAndRigesterView shareLoginAndRigesterView];
                return;
            }
            self.selectButton(BYC_FocusCollectionViewCellSelectedShare , _model);
            break;
        case 4://打开播放页面
        {
            QNWSLog(@"播放");
            [self playMedia];
        }

            break;
        case 5://点击头像
            //未登录跳转去登录
            if (![BYC_AccountTool userAccount]) {
                
                [BYC_LoginAndRigesterView shareLoginAndRigesterView];
                return;
            }
            self.clickHeaderButtonBlock(YES,_model);
            break;
            
        default:
            break;
    }
}


- (void)playMedia{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPlay:) name:@"CancelPlayOnCurrentCellNotification" object:nil];
    _playButton.hidden = YES;
    self.mediaPlayer = [[BYC_MediaPlayer alloc] initWithURLString:_model.videoMP4 TitleString:nil];
    self.mediaPlayer.view.frame = self.imageV_VideoImage.bounds;
    [self.imageV_VideoImage addSubview:self.mediaPlayer.view];
    self.mediaPlayer.isAboveCell = YES;
    
}

- (void)cancelPlay:(NSNotification *)notification {
    
    NSString *url = notification.userInfo[@"MP4Url"];
    _string_CurrentVideoUrl = url;
    if (![url isEqualToString:_model.videoMP4])
        _playButton.hidden = NO;

}

/**
 *  替换点击数据
 *
 *  @param backModel 替换的数据
 *  @param isOK      YES来自添加喜欢接口 NO来自不喜欢接口
 */
- (void)replaceModelData:(BYC_BackFocusListCellModel *)backModel isOK:(BOOL)isOK {

    if (isOK)_model.isLike = !backModel.isOK;
    else _model.isLike = backModel.isOK;
    
    _model.favorites = backModel.favorites;
    _model.views    = backModel.views;
    _model.comments = backModel.comments;
}

-(void)dealloc {
    
    [[BYC_MediaPlayer sharedBYC_MediaPlayer] stopPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    QNWSLog(@"%s",__func__);
}

@end
