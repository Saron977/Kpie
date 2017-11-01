//
//  WX_EditingMediaViewController.m
//  kpie
//
//  Created by 王傲擎 on 16/7/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_EditingMediaViewController.h"
#import "WX_EditingCollectionViewCell.h"
#import "WX_EditingShootingModel.h"
#import "WX_ToolClass.h"
#import "WX_MediaInfoModel.h"
#import "WX_VoideEditingViewController.h"
#import "kpieutils.h"
#import "ffmpegutils.h"
#import "WX_ProgressHUD.h"
//namespace stdclib {
//#import "kpieutils.h"
//}

@interface WX_EditingMediaViewController ()<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, strong) UIView                *all_View_Back;             /**<   全局背景图 */
@property (nonatomic, strong) UIView                *top_MediaView_Back;        /**<   顶部背景图 */
@property (nonatomic, strong) UIView                *top_View_ImageBack;        /**<   顶部底色 */
@property (nonatomic, strong) UILabel               *top_Label_ReplaceStr;      /**<   顶部替换文字内容 */
@property (nonatomic, strong) UIView                *mid_View_Back;             /**<   中部背景图 */
@property (nonatomic, strong) UICollectionView      *mid_ConllectionView;       /**<   中部选择框 */
@property (nonatomic, strong) UIView                *bottom_View_Back;          /**<   底部背景图 */
@property (nonatomic, strong) UIView                *bottom_TextView_Back;      /**<   底部文字编辑框背景 */
@property (nonatomic, strong) UITextField           *bottom_TextField;          /**<   底部文本输入框 */
@property (nonatomic, strong) UILabel               *bottom_Label_StrNum;       /**<   显示限制文字输入数 */
@property (nonatomic, copy)   NSString              *str_Replace;               /**<   显示文字数 */
@property (nonatomic, assign) NSInteger             int_CellNum;                /**<   需要替换数组内第几个模型 */
@property (nonatomic, copy)   NSString              *str_MaxStrNum;             /**<   显示最大文字数 */
@property (nonatomic, strong) NSMutableArray        *array_StrReplace;          /**<   替换文字数组 */
@property (nonatomic, assign) BOOL                  is_TransformFinish;         /**<   转换完成 */
@property (nonatomic, strong) UIView                *view_Hidden;               /**<   背景页面 */






@end

@implementation WX_EditingMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavigation];
    
    [self createUI];
    
    [self createConllection];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _int_CellNum = 0;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    /// 监听方法, 输入中文也可获得位数
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    

}
#pragma mark ------ 创建界面
/// 设置导航栏
-(void)createNavigation
{
    self.navigationItem.title = @"编辑";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorFromRGB(0x4BC8B6) forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickTheRigthButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

/// 创建界面
-(void)createUI
{
    /// 全局背景图
    _all_View_Back = [[UIView alloc]init];
    _all_View_Back.backgroundColor = KUIColorFromRGB(0x202730);
    [self.view addSubview:_all_View_Back];
    
    [_all_View_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    
    /// 视频背景图
    _top_MediaView_Back = [[UIView alloc]init];
    _top_MediaView_Back.backgroundColor = [UIColor whiteColor];
    [_all_View_Back addSubview: _top_MediaView_Back];
    
    [_top_MediaView_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_all_View_Back);
        make.top.equalTo(_all_View_Back.mas_top).offset(64);
        make.height.equalTo(_all_View_Back.mas_height).multipliedBy(0.45);
    }];
    
    /// 顶部底色
    _top_View_ImageBack = [[UIView alloc]init];
    _top_View_ImageBack.backgroundColor = [UIColor clearColor];
    [_top_MediaView_Back addSubview:_top_View_ImageBack];
    
    [_top_View_ImageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_top_MediaView_Back);
    }];
    
    /// 顶部替换文字
    _top_Label_ReplaceStr = [[UILabel alloc]init];
    _top_Label_ReplaceStr.text = @"更改此处文字";
    _top_Label_ReplaceStr.textColor = KUIColorFromRGB(0x000000);
    _top_Label_ReplaceStr.numberOfLines = 0;
    WX_EditingShootingModel *model_Editing = [_array_StrReplace firstObject];
    _top_Label_ReplaceStr.font = [UIFont fontWithName:@"Helvetica-Bold" size:model_Editing.font_StrSize];
    [_top_Label_ReplaceStr sizeToFit];
    _top_Label_ReplaceStr.translatesAutoresizingMaskIntoConstraints = NO;
    _top_Label_ReplaceStr.textAlignment = NSTextAlignmentCenter;
    [_top_View_ImageBack addSubview:_top_Label_ReplaceStr];
    
    [_top_Label_ReplaceStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(_top_View_ImageBack);
    }];
    
    
    /// 中部选择背景图
    _mid_View_Back = [[UIView alloc]init];
    _mid_View_Back.backgroundColor = [UIColor clearColor];
    [_all_View_Back addSubview:_mid_View_Back];
    
    [_mid_View_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_all_View_Back);
        make.top.equalTo(_top_MediaView_Back.mas_bottom);
        make.height.mas_equalTo(@100);
    }];
    
    
    /// 底部文字背景视图
    _bottom_View_Back = [[UIView alloc]init];
    _bottom_View_Back.backgroundColor = [UIColor clearColor];
    [_all_View_Back addSubview:_bottom_View_Back];
    
    [_bottom_View_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_all_View_Back);
        make.top.equalTo(_mid_View_Back.mas_bottom);
        make.bottom.equalTo(_all_View_Back.mas_bottom);
    }];
    
    /// 底部文字编辑框背景
    _bottom_TextView_Back = [[UIView alloc]init];
    _bottom_TextView_Back.backgroundColor = [UIColor whiteColor];
    _bottom_TextView_Back.layer.masksToBounds = YES;
    _bottom_TextView_Back.layer.cornerRadius = 10.f;
    [_bottom_View_Back addSubview:_bottom_TextView_Back];
    
    [_bottom_TextView_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_all_View_Back.mas_left).offset(10);
        make.right.equalTo(_all_View_Back.mas_right).offset(-10);
        make.top.equalTo(_bottom_View_Back.mas_top).offset(10);
        make.height.mas_equalTo(@40);
    }];
    
    
    /// 底部文本输入框
    _bottom_TextField = [[UITextField alloc]init];
    _bottom_TextField.placeholder = @"请在此输入...";
    _bottom_TextField.layer.masksToBounds = YES;
    _bottom_TextField.layer.cornerRadius = 10;
    _bottom_TextField.backgroundColor = [UIColor whiteColor];
    _bottom_TextField.returnKeyType = UIReturnKeyDone;
    _bottom_TextField.delegate = self;
    _bottom_TextField.textColor = KUIColorFromRGB(0x333333);
    _bottom_TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bottom_TextView_Back addSubview:_bottom_TextField];
    
    [_bottom_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottom_TextView_Back);
        make.left.equalTo(_bottom_TextView_Back.mas_left).offset(10);
        make.right.equalTo(_bottom_TextView_Back.mas_right).offset(-10);
    }];
    
    
    /// 显示限制文字输入数
    _str_MaxStrNum = @"50";
    NSString *str_Num = [NSString stringWithFormat:@"0/%@",_str_MaxStrNum];
    CGSize size_StrNum = [WX_ToolClass changeSizeWithString:str_Num FontOfSize:10];
    CGFloat width_StrNum = size_StrNum.width +10;
    _bottom_Label_StrNum = [[UILabel alloc]init];
    _bottom_Label_StrNum.text = str_Num;
    _bottom_Label_StrNum.textColor = KUIColorFromRGB(0x999999);
    _bottom_Label_StrNum.font = [UIFont systemFontOfSize:10];
    [_bottom_View_Back addSubview:_bottom_Label_StrNum];
    
    [_bottom_Label_StrNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottom_TextField.mas_right).offset(-5);
        make.bottom.equalTo(_bottom_TextField.mas_bottom).offset(-2);
        make.width.mas_equalTo(width_StrNum);
        make.height.mas_equalTo(size_StrNum.height);
        
    }];
}

/// 创建collectionview
-(void)createConllection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _mid_ConllectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _mid_ConllectionView.backgroundColor = [UIColor clearColor];
    _mid_ConllectionView.showsHorizontalScrollIndicator = NO;
    _mid_ConllectionView.delegate = self;
    _mid_ConllectionView.dataSource = self;
    [_mid_View_Back addSubview:_mid_ConllectionView];
    [_mid_ConllectionView registerNib:[UINib nibWithNibName:@"WX_EditingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EditingCollectionViewCell"];

    [_mid_ConllectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(_mid_View_Back);
    }];
}

#pragma mark ------ 接收数据
-(void)receiveEditingMediaWithArray:(NSMutableArray *)array
{
    _array_StrReplace = [[NSMutableArray alloc]init];

    /// 用 WX_EditingShootingModel 模型接收, 用 WX_MediaInfoModel 模型传入给视频剪辑界面
    for (int i = 0; i < array.count; i++) {
        WX_MediaInfoModel *model_Media = array[i];
        WX_EditingShootingModel *model_Editing = [[WX_EditingShootingModel alloc]init];
        model_Editing.mediaID           =   model_Media.mediaID;
        model_Editing.mediaPath         =   model_Media.mediaPath;
        model_Editing.mediaUrl          =   model_Media.mediaUrl;
        model_Editing.mediaTitle        =   model_Media.mediaTitle;
        model_Editing.imageDataStr      =   model_Media.imageDataStr;
        model_Editing.DurationStr       =   model_Media.DurationStr;
        model_Editing.isVR              =   model_Media.isVR;
        
        NSMutableArray *array_Parameter =   [self getMediaParameterWithParamter:model_Media.media_Parameter];
        
        model_Editing.str_Replace       =   @"更改此处文字";
        model_Editing.templateNO        =   [(NSNumber*)array_Parameter[0] integerValue];
        model_Editing.time_Offset       =   [(NSNumber*)array_Parameter[1] floatValue];
        model_Editing.videoFadeIn       =   [(NSNumber*)array_Parameter[2] floatValue];
        model_Editing.overlayMax        =   [(NSNumber*)array_Parameter[3] floatValue];
        model_Editing.label_Width       =   [(NSNumber*)[[array_Parameter[4] componentsSeparatedByString:@","] firstObject] floatValue];
        model_Editing.label_Height      =   [(NSNumber*)[[array_Parameter[4] componentsSeparatedByString:@","] lastObject] floatValue];
        model_Editing.offset_Label_X    =   [(NSNumber*)[[array_Parameter[5] componentsSeparatedByString:@","] firstObject] floatValue];
        model_Editing.offset_Label_Y    =   [(NSNumber*)[[array_Parameter[5] componentsSeparatedByString:@","] lastObject] floatValue];
        model_Editing.font_StrSize      =   [(NSNumber*)array_Parameter[6] floatValue];

        
        model_Editing.rect_Label = CGRectMake(model_Editing.offset_Label_X, model_Editing.offset_Label_Y, model_Editing.label_Width, model_Editing.label_Height);
        [_array_StrReplace addObject:model_Editing];
    }
}

-(NSMutableArray *)getMediaParameterWithParamter:(NSString*)parameter
{
    NSMutableArray *array_Para = [[NSMutableArray alloc]init];
    NSArray *array_Parameter = [parameter componentsSeparatedByString:@"|"];
    for (NSString *str_Parameter in array_Parameter) {
        NSArray *array_Replace = [str_Parameter componentsSeparatedByString:@"="];
        [array_Para addObject:[array_Replace lastObject]];
    }
    return array_Para;
}

#pragma mark ------ 代理方法
/// textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string// return NO to not change text
{
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _str_Replace = _bottom_TextField.text;
    
    /// 替换数据
    [self saveReplaceStrWithNum:_int_CellNum StrReplace:_str_Replace];
    
    QNWSLog(@"_str_Replace == %@, _str_Replace.length == %zi",_str_Replace,_str_Replace.length);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

/// UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array_StrReplace.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WX_EditingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditingCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QNWSLog(@"点击了第 %zi 个",indexPath.row);
    
    /// 替换数组内模型文字
    if (_str_Replace.length) {
        [self saveReplaceStrWithNum:_int_CellNum StrReplace:_str_Replace];
    }
    
    /// 如果模型内有文字信息, 顶部label 显示文字, 底部textField 显示文字
    WX_EditingShootingModel *model_Editing = _array_StrReplace[indexPath.row];
    _top_Label_ReplaceStr.font = [UIFont boldSystemFontOfSize:model_Editing.font_StrSize];
    if (model_Editing.str_Replace.length) {
        _top_Label_ReplaceStr.text = model_Editing.str_Replace;
        _bottom_TextField.text = model_Editing.str_Replace;
        [self setStrNumLimitWithString:model_Editing.str_Replace];
        
    }
    
    /// 设置 数组 点击第几个, 放在替换模型文字后
    _int_CellNum = indexPath.row;
    
    return YES;
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 25.f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 25.f, 0, 0);
}

#pragma mark - 监听

-(void)textFiledEditChanged:(NSNotification *)obj
{
    
    UITextField *textField = (UITextField *)obj.object;

    /// 判断当前输入法是否是中文
    bool isChinese;
    
    /// iOS7.0之后使用
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }else{
        isChinese = true;
    }
    
    NSString *str_TextFiled = textField.text;
    
    /// 中文输入法下
    if (isChinese) {
        UITextRange *selectedRange = [textField markedTextRange];
        /// 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        /// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            QNWSLog(@"输入的是汉字");
            
            [self setStrNumLimitWithString:str_TextFiled];
            
        }else{
            QNWSLog(@"输入的英文还没有转化为汉字的状态");
            QNWSLog(@"str_TextFiled == %@",str_TextFiled);
            QNWSLog(@"str_TextFiled.length == %zi",str_TextFiled.length);
        }
    }else{
        
        [self setStrNumLimitWithString:str_TextFiled];
        
    }
    _str_Replace = str_TextFiled;
    _top_Label_ReplaceStr.text = _bottom_TextField.text;
}


#pragma mark ------ 按钮操作
/// 返回上一级界面
-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 下一步操作
-(void)clickTheRigthButton:(UIButton*)btn
{
    QNWSLog(@"合成了啊 啊啊啊啊啊");
    
    /// 判断是否遗漏
    if (_str_Replace.length) {
        [self saveReplaceStrWithNum:_int_CellNum StrReplace:_str_Replace];
    }

    /// 调用ffmpeg
    [self useFFMepgCreateMedia];
}

-(void)useFFMepgCreateMedia
{
    
    [WX_ProgressHUD show:@"正在转码"];
    self.is_TransformFinish = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self showHiddenView:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    /// 合成
    for (WX_EditingShootingModel *model_Editing in _array_StrReplace) {
        QNWSLog(@"model_Editing == %@",model_Editing);
        
        NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [docArray objectAtIndex:0];
        NSString *img_filePath = [path stringByAppendingPathComponent:@"JoinImage"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:img_filePath withIntermediateDirectories:YES attributes:nil error:nil];
        img_filePath = [img_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.JPEG",[WX_ToolClass getDateWithType:1]]];
        
        /// 需要进行编辑的view
        UIView *view_Img = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 360)];
        view_Img.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:model_Editing.rect_Label];
        label.text = model_Editing.str_Replace;
        label.textColor = _top_Label_ReplaceStr.textColor;
//        label.backgroundColor = [UIColor redColor];
        if (label.text.length <= 20 ) {
            
            label.font = [UIFont boldSystemFontOfSize:model_Editing.font_StrSize];
        }else{
            label.font = [UIFont boldSystemFontOfSize:model_Editing.font_StrSize-5];
        }
        label.numberOfLines = 0;
//        [label sizeToFit];
        label.textAlignment = NSTextAlignmentCenter;
//        label.center = CGPointMake(view_Img.center.x+model_Editing.rect_Label.origin.x/2-5, view_Img.center.y +model_Editing.rect_Label.origin.y/2);

        [view_Img addSubview:label];
        
        
        UIImage *image_Editing = [WX_ToolClass convertViewToImage:view_Img];
        image_Editing = [WX_ToolClass imageWithImageSimple:image_Editing scaledToSize:CGSizeMake(480, 360)];
        BOOL result =[UIImagePNGRepresentation(image_Editing)writeToFile:img_filePath  atomically:YES];
        if (result) {
            QNWSLog(@"合拍图片写入成功,图片路径 filePath == %@",img_filePath);
            model_Editing.str_ImgPath = img_filePath;
        }else{
            QNWSLog(@"合拍图片写入失败");
        }
        
        /// 视频路径
        NSString *media_FilePath = [path stringByAppendingPathComponent:@"JoinShooting"];
        media_FilePath = [media_FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model_Editing.mediaTitle]];
        
        /// 调用ffmpeg 处理视频,图片信息
#if KSimulatorRun
        /// char**  文件路径 0_视频路径  1_图片路径
        NSArray *array_FFmpeg = [[NSArray alloc]initWithObjects:media_FilePath, model_Editing.str_ImgPath, nil];
        int argc = (int)array_FFmpeg.count;
        char** argv=(char**)malloc(sizeof(char*)*argc);
        for(int i=0;i<argc;i++)
        {
            argv[i]=(char*)malloc(sizeof(char)*1024);
            strcpy(argv[i],[[array_FFmpeg objectAtIndex:i] UTF8String]);
        }
        
        /// 文件数
        int fileCount = (int)array_FFmpeg.count;
        
        /// 渲染状态
        int templateNO = (int)model_Editing.templateNO;
        
        /// char* 输出文件路径
        NSString *outFilePath = [path stringByAppendingPathComponent:@"Media"];
        [fileManager createDirectoryAtPath:outFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *out_Title = [WX_ToolClass getDateWithType:1];
        outFilePath = [outFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",out_Title]];
        model_Editing.path_OutFile = outFilePath;
        char* outPath_Media = (char*)malloc(sizeof(char)*([model_Editing.path_OutFile length]+1));
        strcpy(outPath_Media, [model_Editing.path_OutFile UTF8String]);
        
        /// char* 打印文件log
        NSString *outlog = @"/var/mobile/Containers/Data/Application/8DA8B057-CC48-4C57-AFB0-EB6D96548DE6/Documents/log.text";
        char* log_Out = (char*)malloc(sizeof(char)*([outlog length]+1));
        strcpy(log_Out, [outlog UTF8String]);
        
        int res = createOverlayVideo(argv,fileCount, templateNO, model_Editing.time_Offset, model_Editing.overlayMax, model_Editing.videoFadeIn, outPath_Media, log_Out);
        if (!res) {
            [WX_ProgressHUD show:@"转换成功"];
            model_Editing.mediaPath = model_Editing.path_OutFile;
            model_Editing.title_Replace = out_Title;
            self.is_TransformFinish = YES;

        }else{
            QNWSLog(@"转换失败");
            [WX_ProgressHUD show:@"转换失败"];
            [self showHiddenView:YES];
        }
        
        /// 释放资源
        for (int i=0; i<fileCount; i++) {
            if (argv[i]) free(argv[i]);
        }
        free(argv);
        free(outPath_Media);
        free(log_Out);
        
#endif
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 通知主线程刷新
            [self addObserver:self forKeyPath:@"isTransformFinish" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        });
        
    }
    });
}

#pragma mark ---------- KVO
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([keyPath isEqualToString:@"isTransformFinish"]) {
        if (self.is_TransformFinish) {
            
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            
            [WX_ProgressHUD dismiss];
            
            /// 隐藏遮盖页面
            [self showHiddenView:YES];
            
            /// 页面跳转
            WX_VoideEditingViewController *videoVC = [[WX_VoideEditingViewController alloc]init];
            [videoVC receiveTheVoide:_array_StrReplace];
            [self.navigationController pushViewController:videoVC animated:YES];
        }
    }
}

/// 是否展示遮盖图层
-(void)showHiddenView:(BOOL)hidden
{
    if (!_view_Hidden) {
        _view_Hidden = [[UIView alloc]init];
        _view_Hidden.backgroundColor = [UIColor clearColor];
        [_all_View_Back addSubview:_view_Hidden];
        [_view_Hidden mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
    }
    _view_Hidden.hidden = hidden;
}

/// 替换数组内模型文字
-(void)saveReplaceStrWithNum:(NSInteger)arrayNum StrReplace:(NSString*)strReplace
{
    WX_EditingShootingModel *model_Editing = _array_StrReplace[arrayNum];
    
    model_Editing.str_Replace = strReplace;
    
    /// 替换完成后, 置空
    _str_Replace = @"";
    
}

/// 替换文字限制
-(void)setStrNumLimitWithString:(NSString *)strReplace;
{
    if (strReplace.length <= 50) {
        _bottom_Label_StrNum.text = [NSString stringWithFormat:@"%zi/50",strReplace.length];
        _bottom_Label_StrNum.textColor = KUIColorFromRGB(0x999999);
    }else{
        strReplace = [strReplace substringToIndex:50];
        _bottom_TextField.text = strReplace;
        _bottom_Label_StrNum.text = [NSString stringWithFormat:@"%zi/50",strReplace.length];
        _bottom_Label_StrNum.textColor = [UIColor redColor];
    }
    
    QNWSLog(@"strReplace == %@",strReplace);
    QNWSLog(@"str_TextFiled.length == %zi",strReplace);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
