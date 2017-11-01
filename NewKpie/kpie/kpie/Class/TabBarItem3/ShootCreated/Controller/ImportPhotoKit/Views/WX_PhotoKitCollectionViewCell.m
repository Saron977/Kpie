//
//  WX_PhotoKitCollectionViewCell.m
//  Album
//
//  Created by 王傲擎 on 16/8/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_PhotoKitCollectionViewCell.h"
#import "NSDate+WX_TimeInterval.h"
#import "WX_ToolClass.h"


@interface WX_PhotoKitCollectionViewCell()

@property (nonatomic, strong) UIImageView       *imgView_Select;        /**<   图片_选中 */
@property (nonatomic, strong) UIImageView       *imgView_Asset;         /**<   图片_资源 */
@property (nonatomic, strong) UIImageView       *imgView_Video;         /**<   图片_视频 */
@property (nonatomic, strong) UIView            *view_Bottom;           /**<   图层_下方 */
@property (nonatomic, strong) UILabel           *label_Duration;        /**<   label_时间 */
@property (nonatomic, assign) PhtotKitType      photoKitType;           /**<   设置获取类型 */
@property (nonatomic, strong) PHAsset           *asset_PH;              /**<   数据 */



@end

@implementation WX_PhotoKitCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// 创建cell
        self.contentView.layer.masksToBounds    = YES;
        self.contentView.layer.cornerRadius     = 10.f;
        [self createCell];
    }
    return self;
}

-(void)createCell
{
    /// 图片_展示
    _imgView_Asset = [[UIImageView alloc]init];
    _imgView_Asset.userInteractionEnabled = YES;
    [self.contentView addSubview:_imgView_Asset];
    
    [_imgView_Asset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
    
    /// 按钮_选择
    _btn_Selected = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_Selected setBackgroundImage:[UIImage imageNamed:@"icon_dpcz_xuanzhe_n"] forState:UIControlStateNormal];
    [_btn_Selected setBackgroundImage:[UIImage imageNamed:@"icon_dpcz_xuanzhe_h"] forState:UIControlStateSelected];
//    [_btn_Selected addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [_imgView_Asset addSubview:_btn_Selected];
    
    [_btn_Selected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgView_Asset.mas_right).offset(-2);
        make.width.height.mas_equalTo(@30);
        make.top.equalTo(_imgView_Asset.mas_top).offset(2);
    }];
    


    
}

/// 根据类型 设置cell
-(void)initCellTypeWithPhotoKitType:(PhtotKitType)photoKitType PHAsset:(PHAsset *)asset
{
    _photoKitType = photoKitType;
    _asset_PH = asset;
    switch (_photoKitType) {
        case ENUM_Photo:
            /// 照片
        {
            
        }
            break;
        case ENUM_Video:
            /// 视频
        {
            /// 图层_下方
            _view_Bottom = [[UIView alloc]init];
            _view_Bottom.backgroundColor = KUIColorFromRGBA(0x000000, .4f);
            [_imgView_Asset addSubview:_view_Bottom];
            
            [_view_Bottom mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(_imgView_Asset);
                make.height.mas_equalTo(@20);
            }];
            
            /// 播放图片
            _imgView_Video = [[UIImageView alloc]init];
            _imgView_Video.image = [UIImage imageNamed:@"icon_dpcz_video_n"];
            [_view_Bottom addSubview:_imgView_Video];
            
            [_imgView_Video mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_view_Bottom).offset(5);
                make.width.mas_equalTo(@17);
                make.height.mas_equalTo(@12);
                make.centerY.equalTo(_view_Bottom);
            }];
            
            NSString *str_Duration = [NSDate timeDescriptionOfTimeInterval:asset.duration];
            CGSize size_Time = [WX_ToolClass changeSizeWithString:str_Duration FontOfSize:12 bold:ENUM_NormalSystem];
           
            /// 视频时长
            _label_Duration = [[UILabel alloc]init];
            _label_Duration.font = [UIFont systemFontOfSize:12];
            _label_Duration.textColor = [UIColor whiteColor];
            _label_Duration.text = str_Duration;
            [_view_Bottom addSubview:_label_Duration];
            
            [_label_Duration mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_view_Bottom).offset(-5);
                make.centerY.equalTo(_view_Bottom);
                make.width.mas_equalTo(size_Time.width+2);
                make.height.mas_equalTo(size_Time.height);
            }];
            
            
            
        }
            break;
        default:
            break;
    }

}

//-(void)selected:(UIButton*)btn
//{
//    btn.selected = !btn.selected;
//    
//    self.selectedAsset(_asset_PH);
//    
//}
-(void)setImg_Photo:(UIImage *)img_Photo
{
    self.imgView_Asset.image = img_Photo;
}

//-(void)setSelected:(BOOL)selected
//{
//    self.isSelect = selected;
//    _btn_Selected.selected = selected;
//}
@end
