//
//  WX_UploadDisplay.m
//  kpie
//
//  Created by 王傲擎 on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_UploadDisplay.h"
#import "WX_ToolClass.h"
static WX_UploadDisplay *UploadDisplay;

@interface WX_UploadDisplay()
@property (nonatomic, strong) UIView                    *view_Upload;               /**<   图层_上传进度 */
@property (nonatomic, strong) UIImageView               *imgView_Icon;              /**<   图片_上传icon */
@property (nonatomic, strong) UILabel                   *label_Upload;              /**<   label_上传 */
@property (nonatomic, assign) ENUM_UploadDisplayState   state;                      /**<   上传状态 */
@property (nonatomic, assign) UIWindowLevel             windowLevel;                /**<   window 图层 */

@end
@implementation WX_UploadDisplay


/**
 创建进度
 */
+(void)createUploadDisplay
{
    if (!UploadDisplay) {
        UploadDisplay = [[WX_UploadDisplay alloc]init];
        UploadDisplay.backgroundColor = [UIColor blackColor];

        [[UIApplication sharedApplication].keyWindow addSubview:UploadDisplay];
    }
    [UploadDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo([UIApplication sharedApplication].keyWindow);
        make.height.mas_equalTo(KHeightStateBar);
    }];

    [UploadDisplay createUploadDisplayView];
}


/**
 移除进度
 */
+(void)removeFromSuperview
{
    if (UploadDisplay)[UploadDisplay removeUploadDisplayFromSuperview];
}


/**
 返回进度状态

 @return 返回状态
 */
+(ENUM_UploadDisplayState)returnUploadDisplayState
{
    return UploadDisplay.state;
}

/**
 设置进度

 @param value 值
 */
+(void)uploadValue:(CGFloat)value
{
    [UploadDisplay uploadDisplayValue:value];
}


/**
 创建进度
 */
-(void)createUploadDisplayView
{
    _windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel;
    
    [self statusBarSetHidden:YES];
    
    
    self.state = ENUM_UploadDisplayUploading;
    CGSize size_Label = [WX_ToolClass changeSizeWithString:@"上传进度: 100%" FontOfSize:13 bold:ENUM_NormalSystem];
    
    // 背景图层
    _view_Upload = [[UIView alloc]init];
    _view_Upload.backgroundColor = [UIColor clearColor];
    [self addSubview:_view_Upload];
    
    [_view_Upload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.height.equalTo(self);
        make.width.mas_equalTo(size_Label.width+25);
    }];

    
    // 上传进度
    _label_Upload = [[UILabel alloc]init];
    _label_Upload.font = [UIFont systemFontOfSize:13];
    _label_Upload.textColor = [UIColor whiteColor];
    _label_Upload.text = @"上传进度: 0%";
    [self addSubview:_label_Upload];
    
    [_label_Upload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.equalTo(_view_Upload);
        make.left.equalTo(_view_Upload).offset(20);
    }];
    
//    // 上传icon
//    _imgView_Icon = [[UIImageView alloc]init];
//    _imgView_Icon.image = [UIImage imageNamed:@""];
//    [self addSubview:_imgView_Icon];
//    
//    [_imgView_Icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_label_Upload.mas_left).offset(5);
//        make.centerY.equalTo(_label_Upload);
//        make.width.height.equalTo(self);
//    }];
}



/**
 展示进度

 @param value 值
 */
-(void)uploadDisplayValue:(CGFloat)value
{
    _label_Upload.text = [NSString stringWithFormat:@"上传进度: %.0f%%",value*100];
    
    if (value == 1){
        [self removeUploadDisplayFromSuperview];
        self.state = ENUM_UploadDisplayCompleted;
    }
}


/**
 移除进度
 */
-(void)removeUploadDisplayFromSuperview
{
    [self statusBarSetHidden:NO];
    
    [UploadDisplay removeFromSuperview];
    UploadDisplay = nil;
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

}


/**
 设置隐藏状态栏 --- (设置uiwindows的层级关系,由于涉及众多界面,不直接调用 statusBarHidden 方法)

 @param operation 是否隐藏
 */
-(void)statusBarSetHidden:(BOOL)operation
{
    if (operation) {
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelAlert;
    }else{
        [UIApplication sharedApplication].keyWindow.windowLevel = _windowLevel;

    }
}

-(void)dealloc
{
    QNWSLog(@"%s 掉了",__func__);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
