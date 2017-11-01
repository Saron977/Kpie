//
//  WX_ShootingScriptViewController.m
//  kpie
//
//  Created by 王傲擎 on 16/3/30.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ShootingScriptViewController.h"
#import "WX_ScriptLibraryViewController.h"
#import "WX_MovieCViewController.h"
#import "WX_ShootScriptCollectionCell.h"
#import "WX_VoideEditingViewController.h"
#import "WX_GuideView.h"
#import "WX_MediaInfoModel.h"
#import "WX_FMDBManager.h"
#import "WX_ScriptModel.h"
#import "UIButton+WebCache.h"
#import "WX_ProgressHUD.h"
#import "WX_AVplayer.h"
#import "WX_ToolClass.h"
#import "BYC_HttpServers+WX_ShootingScriptVC.h"

/// 镜头默认左侧间距 __ 以3个位基准
#define KScriptImgViewLeft (screenWidth -screenWidth*0.2*3)/4
#define KSCriptCellHeightAndWidth 60


@interface WX_ShootingScriptViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSURLConnectionDataDelegate>
{
    NSMutableData                   *_recData;  /**<    接收下载数据  */
    NSString                        *_filePath; /**<    文件路径    */
    NSFileManager                   *_fileManager;
    NSFileHandle                    *_fileHandle;   /**<    文件操作句柄  */
    NSURLConnection                 *_downConnection;   /**<    下载链接对象  */
    WX_ScriptModel                  *_scriptModel;   /**< 需要下载的剧本模型 */
    WX_FMDBManager                  *_manager;
}
@property (nonatomic, strong) UIView                *backView;                  /**<   背景视频图层 */
@property (nonatomic, strong) UIView                *playBackView;              /**<   视频背景图层 */
@property (nonatomic, strong) UIImageView           *playBGImgView;             /**<   视频非播放状态下的默认图 */
//@property (nonatomic, strong) UIView                *shotsA;                    /**<   镜头A */
//@property (nonatomic, strong) UIView                *shotsB;                    /**<   镜头B */
//@property (nonatomic, strong) UIImageView           *shotABGImgView;            /**<   镜头A背景图片 */
//@property (nonatomic, strong) UIImageView           *shotBBGImgView;            /**<   镜头B背景图片 */
//@property (nonatomic, strong) UIImageView           *shotAVideoImgView;         /*<<   镜头A视频图片 */
//@property (nonatomic, strong) UIImageView           *shotBVideoImgView;         /*<<   镜头B视频图片 */
@property (nonatomic, strong) UIView                *scripView;                 /**<   剧本图层 */
@property (nonatomic, strong) UIButton              *replaceBtn;                /**<   替换镜头剧本 */
@property (nonatomic, strong) UIButton              *scriptLibraryBtn;          /**<   剧本库按钮 */
@property (nonatomic, strong) UICollectionView      *scriptCollectionView;      /**<   剧本collectionview */
@property (nonatomic, strong) NSMutableArray        *scriptArray;               /**<   剧本视频数组 */
@property (nonatomic, strong) NSMutableArray        *locationScriptArray;       /**<   本地视频数组  */
@property (nonatomic, strong) UISlider              *slider;                    /**<   进度条 */
@property (nonatomic, strong) AVPlayer              *player;                    /**<   视频播放 */
@property (nonatomic, strong) AVPlayerItem          *item;                      /**<   视频item */
@property (nonatomic, strong) WX_AVplayer           *playView;                  /**<   播放图层 */
@property (nonatomic, strong) NSTimer               *timer;                     /**<   进度条计时器 */
@property (nonatomic, strong) WX_ScriptModel        *playerModel;               /**<   播放模型 */
@property (nonatomic, strong) NSString              *replaceScriptName;         /**<   选中需要被替换的剧本名 */
@property (nonatomic, strong) NSString              *shootScriptName;           /**<   拍摄出需要替换的剧本名 */
@property (nonatomic, strong) NSString              *scriptNum;                 /**<   剧本合成信息数组中的位置 格式: 1_A */
@property (nonatomic, assign) BOOL                  isReplaceScript;            /**<   是否替换镜头 */
@property (nonatomic, assign) BOOL                  isNeedReloadata;            /**<   是否需要重载collectionview */
@property (nonatomic, strong) UIButton              *backupBtn;                 /**<   备用button */
@property (nonatomic, strong) NSMutableArray        *exchangeArray;             /**<   剧本交换数组 */
@property (nonatomic, strong) UIView                *subView;                   /**<   字幕背景图 */
@property (nonatomic, strong) UILabel               *subLabel;                  /**<   字幕label */
@property (nonatomic, assign) BOOL                  isRemoveNof;                /**<   是否移除通知 */
@property (nonatomic, copy)   NSString              *contentStr;                /**<   显示字幕 */
@property (nonatomic, copy)   NSString              *replaceScriptStr;          /**<   替换的镜头 A__B */
@property (nonatomic, strong) WX_GuideView          *guideView;                 /**<   引导页 */
@property (nonatomic, strong) NSArray               *imgArray;                  /**<   引导页图片数组 */

@property (nonatomic, strong) UIScrollView          *scriptScrollView;          /**<   镜头替换Scrollview */
@property (nonatomic, assign) NSInteger             script_Tag;                 /**<   需要替换的镜头位置 0 1 2 3 */
@property (nonatomic, assign) NSInteger             downNum;                    /**<   下载个数 2个 0__1 */
@property (nonatomic, strong) WX_ScriptInfoModel    *replace_infoModel;         /**<   需要替换的镜头信息 InfoModel */
@property (nonatomic, assign) NSInteger             library_Num;                /**<   计算显示 */
@property (nonatomic, assign) BOOL                  libaray_isNeed;             /**<   剧本库界面点击跳转回来 */
@property (nonatomic, strong) UIButton              *collection_First_button;   /**<   第一个Btn */
@property (nonatomic, strong) UIView                *hiddenBackView;            /**<   镜头加载时,覆盖,加载完成隐藏 */
@property (nonatomic, assign) BOOL                  videoD_isLocation;          /**<   来自视频详情跳转过的, 在本地存在不需要下载 */
@property (nonatomic, assign) NSInteger             video_Num;                  /**<   计算显示_来自视频详情 */



@end

@implementation WX_ShootingScriptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItem];
    
    [self createUI];
    
    [self createCollectionView];
    
    [self receiveScriptFromNet];
    
   
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self readInfoFromFMDB];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(removeScriptImg) name:@"removeScriptImg" object:nil];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorFromRGB(0x000000)];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    if(self.isNeedReloadata){
    
//        [self receiveScriptFromNet];
        [self refreshCollectionViewWithFMDB];
        
        self.isNeedReloadata = NO;
    }
    
    if (self.isReplaceScript) {
        
        [self playTheScript:self.backupBtn];
        
        self.isReplaceScript = NO;
    }
    
    if (!self.isRemoveNof) {
        
        self.isRemoveNof = YES;
    }
    

    self.library_Num = 0;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorBaseGreenNormal];

   
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.player pause];
    
//    self.Libtary_ScriptModel = nil;
    
    [self.item removeObserver:self forKeyPath:@"status"];
    
    if (self.isRemoveNof) {
        
        [QNWSNotificationCenter removeObserver:self name:@"removeScriptImg" object:nil];
    }
    if (self.videoD_ScriptModel) {
        self.videoD_ScriptModel = nil;
        self.video_Num = 0;
        self.videoD_isLocation = NO;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.item = nil;
        
//        self.playView = nil;
        
        
        [self.timer invalidate];
        
        self.timer = nil;
        
        self.player = nil;
        

    });
  
}

-(void)removeScriptImg
{
    
    for (int i = 0; i < self.playerModel.videoLenArray.count; i++) {
        UIImageView *imgView = [self.view viewWithTag: 500+i];
        imgView.image = nil;
    }
    
    self.playBackView.hidden = YES;

}

#pragma nark ----- 获取剧本数组接口
-(void)receiveScriptFromNet
{
    if (!self.scriptArray) {
        self.scriptArray = [[NSMutableArray alloc]init];
    }
    [self.scriptArray removeAllObjects];
    
    [BYC_HttpServers WX_RequestScriptVC_GetEliteListVideoScriptWithParameters:nil success:^(AFHTTPRequestOperation *operation, NSMutableArray *array_Model) {
        if (array_Model.count > 0) {
            [self.scriptArray addObjectsFromArray:array_Model];
        }
        [self refreshCollectionViewWithFMDB];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSLog(@"剧本合拍接口请求失败");
    }];

}

-(void)refreshCollectionViewWithFMDB
{
    [self readLocationScriptFromFMDB];
    
    /// 判断是否有此剧本,没有的话添加
    if (self.videoD_ScriptModel) {
        BOOL isHave = NO;
        for (WX_ScriptModel *scriptModel in self.scriptArray) {
            
                if ([scriptModel.scriptID isEqualToString:self.videoD_ScriptModel.scriptID]) {
                    isHave = YES;
                    break;
                }
            }
        
        if (!isHave) {
            
            [self.scriptArray addObject:self.videoD_ScriptModel];
        }
        
    }
    if (self.scriptArray.count > 0) {
        
        /// 计算在数组中的位置
        NSInteger row = 0;
        
        if (self.videoD_ScriptModel) {
            
            for (int i = 0; i < self.scriptArray.count; i++) {
                WX_ScriptModel *scriptModel = self.scriptArray[i];
                
                if ([scriptModel.scriptID isEqualToString:self.videoD_ScriptModel.scriptID]) {
                    row = i;
                    break;
                }
                
            }
            
            self.video_Num = row;
        }

        
        /// 等待 collectionview 加载完成再执行 以下操作
    [UIView animateWithDuration:0.f animations:^{
        [self.scriptCollectionView reloadData];

    } completion:^(BOOL finished) {
        
        if (self.videoD_ScriptModel) {
            
            [self collectionPlayVideoScripModelWithRow:row];
            
        }
    }];
        
        
    }else{
        return ;
    }

}

/// 播放来自 视频详情跳转 的视频
-(void)collectionPlayVideoScripModelWithRow:(NSInteger)row
{


    /// 跳转到指定镜头
    [self.scriptCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    

}

/// 跳转到指定视频. 播放
-(void)scriptFormVideoDVCWithRow:(NSInteger )row CellButton:(UIButton *)btn
{
    if (self.video_Num == row) {
        

        btn.selected = YES;
        [btn.layer setBorderColor:KUIColorBaseGreenNormal.CGColor];
        [btn.layer setBorderWidth:3.f];
        [btn.layer setCornerRadius:8.0f];
        self.backupBtn = btn;
        
        /// 本地视频存在, 直接播放
        if (self.videoD_isLocation) {
            
            [self playTheScript:btn];
            
        }else{
            /// 不在本地存在, 需要下载
            if (self.scriptArray.count > 0) {
                
                [self setTheBackViewHidden:NO];
                
                WX_ScriptModel *scriptModel = self.scriptArray[row];
                
                _scriptModel = scriptModel;
                
#pragma mark ----- 点击下载
                _downNum = 0;
                
                [WX_ProgressHUD show:@"正在下载"];
                
                _recData = [NSMutableData new];
                
                [self createDownLoadWithScriptNum:0];
                
            }else{
                [WX_ProgressHUD show:@"镜头出错"];
                
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
                
                return;
            }
            
        }
    }
}

#pragma mark ----- 创建 NavigationItem
-(void)createNavigationItem
{
    self.view.backgroundColor = KUIColorFromRGB(0xf0f0f0);
    self.navigationItem.title = @"剧本合拍";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"btn_hepai_guanbi_n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"btn_hepai_guanbi_h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [rightButton setTitleColor:KUIColorFromRGBA(0xffffff, 0.7) forState:UIControlStateNormal];
    [rightButton setTitleColor:KUIColorFromRGBA(0xffffff, 0.6) forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickTheRigthButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;

}

#pragma mark -------- 创建UI
-(void)createUI
{
    
#pragma mark ----- 替换镜头
    self.replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replaceBtn setBackgroundImage:[UIImage imageNamed:@"btn_hepai_thjt_s"] forState:UIControlStateNormal];
    [self.replaceBtn setBackgroundImage:[UIImage imageNamed:@"btn_hepai_thjt_n"] forState:UIControlStateSelected];
    [self.replaceBtn setBackgroundImage:[UIImage imageNamed:@"btn_hepai_thjt_h"] forState:UIControlStateHighlighted];
    [self.replaceBtn addTarget:self action:@selector(replaceScript:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.replaceBtn];
    
    [_replaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
    
#pragma mark ----- 剧本图层
    _scripView = [[UIView alloc]init];
    _scripView.backgroundColor = KUIColorFromRGB(0xfcfcfc);
    [self.view addSubview:_scripView];
    
    [_scripView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@100);
        make.bottom.equalTo(_replaceBtn.mas_top);
        make.left.right.equalTo(self.view);
    }];
    
#pragma mark ----- 局本库按钮
    self.scriptLibraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.scriptLibraryBtn.frame = CGRectMake(screenWidth*0.035, (screenHeight-64)*0.015, screenWidth*0.188, screenWidth*0.188);
    [self.scriptLibraryBtn setBackgroundImage:[UIImage imageNamed:@"btn_hepai_hepaiku_n"] forState:UIControlStateNormal];
    [self.scriptLibraryBtn setBackgroundImage:[UIImage imageNamed:@"btn_hepai_hepaiku_h"] forState:UIControlStateHighlighted];
    [self.scriptLibraryBtn addTarget:self action:@selector(pushScriptLibraryVC:) forControlEvents:UIControlEventTouchUpInside];
    if (KCurrentDeviceIsIphone4) {
        [self.scriptLibraryBtn setTitle:@"剧本库" forState:UIControlStateNormal];
        self.scriptLibraryBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        self.scriptLibraryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -(KSCriptCellHeightAndWidth + 12), 0);
        
    }else{
        
        [self.scriptLibraryBtn setTitle:@"剧本库" forState:UIControlStateNormal];
        self.scriptLibraryBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        self.scriptLibraryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -(KSCriptCellHeightAndWidth + 20), 0);
    }
    [self.scriptLibraryBtn setTitleColor:KUIColorFromRGB(0xc1c1c1) forState:UIControlStateNormal];
    [self.scriptLibraryBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    [self.scripView addSubview:self.scriptLibraryBtn];
    
    [_scriptLibraryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@14);
        make.width.height.mas_equalTo(KSCriptCellHeightAndWidth);
        make.centerY.equalTo(_scripView);
    }];

    /// 背景图层
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight*0.65)];
    self.backView.backgroundColor = KUIColorFromRGB(0x282828);
    [self.view addSubview:self.backView];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_scripView.mas_top);
    }];
    
    /// 视频背景
    self.playBackView = [[UIView alloc]init];
    self.playBackView.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:self.playBackView];
    
    [_playBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backView);
        make.top.equalTo(_backView.mas_top);
        make.height.equalTo(_backView.mas_height).multipliedBy(0.69);
    }];
    
    self.playBGImgView = [[UIImageView alloc]init];
    self.playBGImgView.image = [UIImage imageNamed:@"img_jbhp_bfmrt"];
    [self.playBackView addSubview:self.playBGImgView];
    
    [_playBGImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_playBackView);
    }];
    
    
    
#pragma mark ------ 镜头_____Scrollview
    self.scriptScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.backView.bottom, screenWidth, 60)];
    _scriptScrollView.backgroundColor= [UIColor clearColor];
    [_backView addSubview:self.scriptScrollView];
    
    [_scriptScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playBackView.mas_bottom).offset(5);
        make.height.equalTo(@60);
        make.left.right.equalTo(_backView);
    }];
    
    [self createScriptImgViewWithModel:nil];
#pragma mark ------ 字幕
    
    self.subLabel = [[UILabel alloc]init];
    self.subLabel.font = [UIFont systemFontOfSize:12];
    self.subLabel.textColor = KUIColorFromRGB(0xffffff);
    self.subLabel.numberOfLines = 0;
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:self.subLabel];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backView);
        make.height.mas_equalTo(20);
        if (KCurrentDeviceIsIphone5 || KCurrentDeviceIsIphone4) {
            
            make.bottom.equalTo(_backView.mas_bottom).offset(-24);
        }else{
            
            make.top.equalTo(_scriptScrollView.mas_bottom).offset(24);
        }
    }];
    

}

#pragma mark ----- 创建collectionview
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.scriptCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    
    self.scriptCollectionView.backgroundColor = [UIColor clearColor];
    self.scriptCollectionView.showsHorizontalScrollIndicator = NO;
    self.scriptCollectionView.delegate = self;
    self.scriptCollectionView.dataSource = self;
    [self.scripView addSubview:self.scriptCollectionView];
    
    [_scriptCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scriptLibraryBtn.mas_right).offset(10);
        make.right.equalTo(_scripView.mas_right);
        make.top.bottom.equalTo(_scripView);
    }];
    
    [self.scriptCollectionView registerClass:[WX_ShootScriptCollectionCell class]forCellWithReuseIdentifier:@"shootScriptCell"];

    
}



#pragma mark ------- 创建数据库
-(void)readInfoFromFMDB
{
    if (self.locationScriptArray == nil) {
        
        self.locationScriptArray = [[NSMutableArray alloc]init];
    }else{
        
        [self.locationScriptArray removeAllObjects];
    }
    /// 写入数据库
    _manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    FMResultSet *dataResult = [_manager.dataBase executeQuery:@"select * from Script3"];
    if (dataResult == nil) {
#pragma mark ------ 第一次进入, 展示引导页
        /// 第一次进入  展示引导页
        [self firstUseScriptCreateGuideView];
        
        /// 没有数据表
        /// 创建
        
        if (![_manager.dataBase executeUpdate:@"create table if not exists Script3(id integer primary key autoincrement,titleName text,scriptID text,scriptName text,scriptUrl text,pictureJPGUrl text,actioninfo text,timelength text,jpgurl text,content text)"]) {
            QNWSLog(@"数据库---Script表创建失败");
        }else{
            QNWSLog(@"数据库---Script表创建成功");
        }
    }else{
        /// 有数据表
        /// 获取数据
        //  本地视频
       
        while ([dataResult next]) {
            
            WX_ScriptModel *scriptModel = [[WX_ScriptModel alloc]init];
            scriptModel.videoLenArray = [[NSMutableArray alloc]init];
            scriptModel.jpgurl = [dataResult stringForColumn:@"jpgurl"];
            scriptModel.scriptcontent = [dataResult stringForColumn:@"content"];
            scriptModel.scriptname = [dataResult stringForColumn:@"titleName"];
            scriptModel.scriptID = [dataResult stringForColumn:@"scriptID"];
            WX_ScriptInfoModel *infoModel = [[WX_ScriptInfoModel alloc]init];
            infoModel.videoLen_ShootName = [dataResult stringForColumn:@"scriptName"];
            infoModel.videoLen_lensurl = [dataResult stringForColumn:@"scriptUrl"];
            infoModel.videoLen_lensjpgurl = [dataResult stringForColumn:@"pictureJPGUrl"];
            infoModel.videoLen_actioninfo = [dataResult stringForColumn:@"actioninfo"];
            infoModel.videoLen_timelength = [dataResult stringForColumn:@"timelength"];
            
            [scriptModel.videoLenArray addObject:infoModel];
            
            [self.locationScriptArray addObject:scriptModel];
            
        }
        
        /// 整合本地视频
        
        for (int i = 0; i < self.locationScriptArray.count; i++) {
            WX_ScriptModel *locationModel = self.locationScriptArray[i];
            
            for (int j = i+1; j < self.locationScriptArray.count; j++) {
                WX_ScriptModel *newScriptModel = self.locationScriptArray[j];
                
                if ([locationModel.scriptname isEqualToString: newScriptModel.scriptname]) {
                    
                    [locationModel.videoLenArray addObjectsFromArray:newScriptModel.videoLenArray];
                    [self.locationScriptArray removeObject:newScriptModel];
                }
            }
        }
        
    }
}

#pragma mark ----- 第一次使用剧本合拍, 添加引导页
-(void)firstUseScriptCreateGuideView
{
    
    NSInteger heigh = screenHeight;
    switch (heigh) {
        case 480:
            self.imgArray = [[NSArray alloc]initWithObjects:@"img_jbhp_ssyd_4.png",nil];
            break;
        case 568:
            self.imgArray = [[NSArray alloc]initWithObjects:@"img_jbhp_ssyd_5.png",nil];
            break;
        case 667:
            self.imgArray = [[NSArray alloc]initWithObjects:@"img_jbhp_ssyd_6.png",nil];
            break;
            
        default:
            self.imgArray = [[NSArray alloc]initWithObjects:@"img_jbhp_ssyd_6P.png",nil];
            break;
    }
    
    self.guideView = [[WX_GuideView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) WithImgArray:self.imgArray];

}

-(void)readLocationScriptFromFMDB
{
    [self readInfoFromFMDB];
    
    // 存入数据库的视频和 剧本合拍整合
    for (int i = 0; i < self.locationScriptArray.count; i++) {
        WX_ScriptModel *locationScriptModel = self.locationScriptArray[i];
        
        
        if (self.videoD_ScriptModel && !self.videoD_isLocation) {
            if ([locationScriptModel.scriptID isEqualToString:self.videoD_ScriptModel.scriptID]) {
                self.videoD_isLocation = YES;
            }
            
        }
        BOOL isHave = NO;
            // 比较后, 如果原数组没有 本地存储的视频, 那就把本地保存到原数组中
            
            for (WX_ScriptModel *model in self.scriptArray) {

                if ([model.scriptname isEqualToString:locationScriptModel.scriptname]) {
                    isHave = YES;
                }
          
        }
        
        if (!isHave) {
            [self.scriptArray addObject:locationScriptModel];
        }
    }
}

#pragma mark ------ 创建镜头图片
// 创建镜头图片
-(void)createScriptImgViewWithModel:(WX_ScriptModel *)scriptModel
{
    // 清除镜头视图
    for (UIView *view in self.scriptScrollView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (scriptModel) {
        self.scriptScrollView.contentSize = CGSizeMake((KScriptImgViewLeft+screenWidth*0.2)*scriptModel.videoLenArray.count, 0);
        // 添加镜头视图
        for (int i = 0; i < scriptModel.videoLenArray.count; i++) {
            
            WX_ScriptInfoModel *infoModel = scriptModel.videoLenArray[i];
            
            /// 背景View
            UIView *shotView = [[UIView alloc]init];
            if (scriptModel.videoLenArray.count > 3) {
                
                CGFloat imgViewLeft = (screenWidth -3.5*0.2*screenWidth)/4;
                shotView.frame = CGRectMake(imgViewLeft*(i+1)+i*screenWidth*0.2,  _scriptScrollView.kheight *0.25, screenWidth*0.2, _scriptScrollView.kheight *0.5);
                
            }else if(scriptModel.videoLenArray.count == 3){
                
                shotView.frame = CGRectMake(KScriptImgViewLeft*(i+1)+i*screenWidth*0.2, _scriptScrollView.kheight *0.25, screenWidth*0.2, _scriptScrollView.kheight *0.5);
                
            }else if (scriptModel.videoLenArray.count == 2){
                
                CGFloat imgViewLeft = (screenWidth -screenWidth *0.2 *2)/3;
                shotView.frame = CGRectMake(imgViewLeft*(i+1)+i*screenWidth*0.2, _scriptScrollView.kheight *0.25, screenWidth*0.2, _scriptScrollView.kheight *0.5);
            }
            shotView.backgroundColor = [UIColor clearColor];
            shotView.layer.cornerRadius = 15.f;
            shotView.layer.masksToBounds = YES;
            shotView.userInteractionEnabled = YES;
            shotView.tag = 300 +i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideos:)];
            [shotView addGestureRecognizer:tap];
            [self.scriptScrollView addSubview:shotView];
            
            /// 背景图__镜头框
            UIImageView *shotBGView = [[UIImageView alloc]init];
            shotBGView.frame = shotView.bounds;
            shotBGView.image = [UIImage imageNamed:@"icon_hepai_jtxz_n"];
            shotBGView.tag = 400 +i;
            [shotView addSubview:shotBGView];
            
            /// 镜头序号
            UILabel *shotALabel = [[UILabel alloc]init];
            shotALabel.frame = shotView.bounds;
            shotALabel.text = [NSString stringWithFormat:@"%zi",i+1];
            shotALabel.textColor = KUIColorFromRGB(0xc5c5c5);
            shotALabel.textAlignment = NSTextAlignmentCenter;
            shotALabel.font = [UIFont systemFontOfSize:12];
            shotALabel.tag = 600 +i;
            [shotView addSubview:shotALabel];
            
            /// 视频图
            UIImageView *shotVideoImgView = [[UIImageView alloc]init];
            shotVideoImgView.frame = shotView.bounds;
            if (infoModel.isScriptShoot) {
                NSData *data = [[NSData alloc]initWithBase64EncodedString:infoModel.replace_ImgData options:0];
                shotVideoImgView.image = [UIImage imageWithData:data];
            }else {
                [shotVideoImgView sd_setImageWithURL:[NSURL URLWithString:infoModel.videoLen_lensjpgurl]];
            }
            shotVideoImgView.tag = 500+i;
            
            [shotView addSubview:shotVideoImgView];
            
        
        }
    }else{
        // 默认显示三组镜头

        self.scriptScrollView.contentSize = CGSizeMake((KScriptImgViewLeft+screenWidth*0.2)*3+KScriptImgViewLeft, 0);
        // 添加镜头视图
        for (int i = 0; i < 3; i++) {
            
            /// 背景View
            UIView *shotView = [[UIView alloc]initWithFrame:CGRectMake((screenWidth -screenWidth*0.2*3)/(3+1)*(i+1)+i*screenWidth*0.2, _scriptScrollView.kheight *0.25, screenWidth*0.2, _scriptScrollView.kheight *0.5)];
            shotView.backgroundColor = [UIColor clearColor];
            shotView.layer.cornerRadius = 15.f;
            shotView.layer.masksToBounds = YES;
            shotView.userInteractionEnabled = YES;
            
            [self.scriptScrollView addSubview:shotView];
            
            /// 视频图
            UIImageView *shotVideoImgView = [[UIImageView alloc]init];
            shotVideoImgView.frame = shotView.bounds;
            shotVideoImgView.tag = 500+i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideos:)];
            [shotVideoImgView addGestureRecognizer:tap];
            [shotView addSubview:shotVideoImgView];
            
            
            /// 镜头序号
            UILabel *shotALabel = [[UILabel alloc]init];
            shotALabel.frame = shotView.bounds;
            shotALabel.text = [NSString stringWithFormat:@"%zi",i+1];
            shotALabel.textColor = KUIColorFromRGB(0xc5c5c5);
            shotALabel.textAlignment = NSTextAlignmentCenter;
            shotALabel.font = [UIFont systemFontOfSize:12];
            [shotView addSubview:shotALabel];
            
            
            /// 背景图__镜头框
            UIImageView *shotBGView = [[UIImageView alloc]init];
            shotBGView.frame = shotView.bounds;
            shotBGView.image = [UIImage imageNamed:@"icon_hepai_jtxz_n"];
            [shotView addSubview:shotBGView];
            
            [shotView bringSubviewToFront:shotBGView];
        }
        
    }
    
  
}

#pragma mark-------- 点击镜头 A\B 播放视频
-(void)playVideos:(UITapGestureRecognizer*)tap
{
    QNWSLog(@"tap.view.tag == %zi",tap.view.tag);
    QNWSLog(@"播放视频啦");
    
    if (self.playerModel.scriptname) {
        
        self.playView.hidden = NO;
        for (int i = 0; i < self.scriptScrollView.subviews.count; i++) {
            UIImageView *videoImgView = [self.view viewWithTag:400+i];
            videoImgView.image = [UIImage imageNamed:@"icon_hepai_jtxz_n"];
            videoImgView.alpha = 0.6f;
            UILabel *label = [self.view viewWithTag:600+i];
            label.textColor = KUIColorFromRGB(0xc5c5c5);
        }
        
        UIImageView *videoImgView = [self.view viewWithTag:tap.view.tag +100];
        videoImgView.image = [UIImage imageNamed:@"icon_hepai_jtxz_s"];
        videoImgView.alpha = 0.6f;
        
        self.script_Tag = tap.view.tag - 300;
        
        UILabel *label = [self.view viewWithTag:300+tap.view.tag];
        label.textColor = KUIColorFromRGB(0x2ca298);
        
        WX_ScriptInfoModel *infoModel = self.playerModel.videoLenArray[tap.view.tag -300];
        
        self.replace_infoModel = infoModel;
        
        if (infoModel.isScriptShoot) {
            [self createVideoPlayerWithScriptName:infoModel.replace_ShootName];
            self.contentStr = nil;
        }else {
            [self createVideoPlayerWithScriptName:infoModel.videoLen_ShootName];
            self.contentStr = infoModel.videoLen_actioninfo;
        }
        _subLabel.text = self.contentStr;
        self.replaceBtn.selected = YES;
    }else{
        self.replaceBtn.selected = NO;
        self.playView.hidden = YES;
    }
    
//    [self selectScript];
    
}

#pragma mark ----- 创建播放器
-(void)createVideoPlayerWithScriptName:(NSString*)scriptName
{

    self.playBackView.hidden = NO;
    
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath;
    NSString *str_scriptName = [scriptName substringToIndex:scriptName.length-1];
    for (int i = 0; i < 10; i++) {
        
        if ([[str_scriptName substringFromIndex:str_scriptName.length-1] isEqualToString:[NSString stringWithFormat:@"%zi",i]]) {
            str_scriptName = [str_scriptName substringToIndex:str_scriptName.length-1];
        }
    }
    // 播放镜头
    if ([str_scriptName isEqualToString:self.playerModel.scriptname]) {
         filePath = [docDir stringByAppendingPathComponent:@"Script"];
    }else{
        // 播放用户拍摄
        filePath = [docDir stringByAppendingPathComponent:@"Media"];

    }

    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",scriptName]];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    if (self.item) {
        [self.item removeObserver:self forKeyPath:@"status"];
        
        self.item = nil;
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.player) {
        self.player = nil;
        //        self.playView = nil;
    }
    if (self.playView) {
        [self.playView removeFromSuperview];
    }
    
    if (!self.playView) {
        
        self.playView = [[WX_AVplayer alloc]init];
    }
    
    self.item = [[AVPlayerItem alloc]initWithURL:url];
    
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
    
    self.playView.frame = CGRectMake(0, 0, self.playBackView.frame.size.width, self.playBackView.frame.size.height);
    
    self.playView.player = self.player;
    
    [self.playBackView addSubview:self.playView];
    
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    
    if (self.slider) {
        [self.slider removeFromSuperview];
    }
    self.slider = [[UISlider alloc]init];
//                   WithFrame:CGRectMake((1-0.6)*screenWidth/2,self.backView.frame.size.height*0.85, screenWidth*(0.6),  0.015*screenHeight)];
    
    
    [self.slider setMaximumTrackTintColor:KUIColorFromRGB(0xececec)];
    [self.slider setMinimumTrackTintColor:KUIColorBaseGreenNormal];
    
    
//    [self.slider setThumbImage:[UIImage imageNamed:@"img_wxs_tm"] forState:UIControlStateNormal];

    UIView *view_Thumb = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 2)];
    view_Thumb.backgroundColor = KUIColorBaseGreenNormal;
    UIImage *img_Thumb = [WX_ToolClass convertViewToImage:view_Thumb];
    [self.slider setThumbImage:img_Thumb forState:UIControlStateNormal];
    
    WX_ScriptInfoModel *infoModel = self.playerModel.videoLenArray[self.script_Tag];
    
    self.slider.maximumValue = [infoModel.videoLen_timelength integerValue];
    
    [self.playBackView addSubview:self.slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_playBackView);
        make.height.mas_equalTo(@5);
    }];
    
    //起定时器来修改播放进度
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moviePlay) userInfo:nil repeats:YES];
    
    // 起定时器控制播放时长,如果有设置播放视频的endTime
    //    QNWSLog(@"editModel.endTime == %zi",[editModel.endTime floatValue]);
    
    
    
    //拉动slider改变进度
//    [self.slider addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];

}
-(void)moviePlay
{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        //获取到当前时间
        long long timeValue = self.item.currentTime.value/self.item.currentTime.timescale;
        
        //设置当前播放时间
        [self.slider setValue:timeValue animated:YES];
    }
    
}

#pragma KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            
            [self playVideo];
            
            
        }
    }
    
}

- (void)playVideo
{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        [self changeBackGroundViewImageWithState:YES];
        
        [self.player play];
        
        //获取总时间
        long long timeLength = self.item.duration.value/self.item.duration.timescale;
        
        //设置slider最大值
        self.slider.maximumValue = timeLength;
        
        self.replaceBtn.selected = YES;
    }else{
        self.replaceBtn.selected = NO;
    }
}


/**
 改变背景图

 @param is YES_改变 NO_不变
 */
-(void)changeBackGroundViewImageWithState:(BOOL)is
{
    if (is)self.playBGImgView.image = [UIImage imageNamed:@"img_jbhp_bfmrt_2"];
    
    else self.playBGImgView.image = [UIImage imageNamed:@"img_jbhp_bfmrt"];

        
}

#pragma mark ----- 替换镜头
-(void)replaceScript:(UIButton*)btn
{
    if (self.replace_infoModel) {
        
        if (!self.playerModel) {
            [WX_ProgressHUD show:@"请选择镜头"];
            
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
            
            return;
        }
        
        [self.player pause];
        
        
        WX_MovieCViewController *movieVC = [[WX_MovieCViewController alloc]init];
        movieVC.isFromScriptVC = YES;
        movieVC.scriptBlock = ^(WX_ScriptModel *scriptModel){
            
            WX_ScriptInfoModel *infoModel = scriptModel.videoLenArray[0];
            
            QNWSLog(@"拍摄镜头名 == %@",infoModel.replace_ShootName);
            
            self.isReplaceScript = YES;
            
            self.shootScriptName = infoModel.replace_ShootName;
            
            WX_ScriptInfoModel *replace_infoModel =  self.playerModel.videoLenArray[self.script_Tag];
            
            replace_infoModel.replace_ShootName = infoModel.replace_ShootName;
            
            replace_infoModel.replace_ImgData = infoModel.replace_ImgData;
            
            replace_infoModel.replace_ShootDuration = infoModel.replace_ShootDuration;
            
            replace_infoModel.isScriptShoot = YES;
            
            self.playerModel.isFromShooting = YES;
            
            
        };
        
        [self.playView removeFromSuperview];
        
        
        [self.navigationController pushViewController:movieVC animated:YES];
        
        
    }else{
        [WX_ProgressHUD show:@"请选择镜头"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
        
        return;

    }
    
   

    
}

#pragma mark ----- 进入剧本管理界面
-(void)pushScriptLibraryVC:(UIButton*)btn
{
    self.isNeedReloadata = YES;
    self.isRemoveNof = NO;
    WX_ScriptLibraryViewController *scriptLVC = [[WX_ScriptLibraryViewController alloc]init];
    scriptLVC.libraryBlock = ^(WX_ScriptModel *scriptModel){
        self.libaray_isNeed = YES;
        self.Libtary_ScriptModel = scriptModel;
        WX_ScriptInfoModel *infoModel = scriptModel.videoLenArray[0];
        
        QNWSLog(@"回调 %@ 剧本",infoModel.videoLen_ShootName);
        
    };
    [self.navigationController pushViewController:scriptLVC animated:YES];
}

#pragma mark ------ 下一步
-(void)clickTheRigthButton
{
    /// 把镜头文件拷贝到 Media 文件夹下
    [self.player pause];
    
    NSString *copyName;
    
    if (!self.playerModel) {
        [WX_ProgressHUD show:@"请选择镜头"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
        
        return;
    }else if (!self.playerModel.isFromShooting){
        
        [WX_ProgressHUD show:@"请替换镜头"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
        
        return;
    }
    
    /// 几种镜头出错的情况
    BOOL not_Replace = YES;
    for (WX_ScriptInfoModel *infoModel in self.playerModel.videoLenArray) {
        
        /// 有替换镜头, 置NO
        if (infoModel.isScriptShoot) {
            not_Replace = NO;

        }
        
        // 有替换镜头 但没有图片信息
        if (infoModel.isScriptShoot && !infoModel.replace_ImgData) {
            
            [WX_ProgressHUD show:@"请替换镜头"];
            
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
            
            return;

        }
        //有替换镜头, 但没有标题
        if (infoModel.isScriptShoot && !infoModel.replace_ShootName) {
            [WX_ProgressHUD show:@"请替换镜头"];
            
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
            
            return;

        }
        
        
        
    }
    /// 没有替换镜头
    if (not_Replace) {
        [WX_ProgressHUD show:@"请替换镜头"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
        
        return;
    }
    
    /// 替换镜头, 先把镜头文件拷贝过来 __ 拷贝到拍摄文件的目录下
    if (self.playerModel.isFromShooting) {
        for (WX_ScriptInfoModel *infoModel in self.playerModel.videoLenArray) {
            if (!infoModel.isScriptShoot) {
                
                copyName = [NSString stringWithFormat:@"%@.mp4",infoModel.videoLen_ShootName];
                
                if ([self copyFilefromFolderPath:@"Media" toCopyFolderPath:@"Script" WithFileName:copyName]) {
                    QNWSLog(@"文件拷贝成功");
                }else{
                    QNWSLog(@"文件拷贝失败");
                }

            }
        }
    }
    
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"Media"];
    
    WX_VoideEditingViewController *videoEditVC = [[WX_VoideEditingViewController alloc]init];
    NSMutableArray *videoArray = [[NSMutableArray alloc]init];
    
    /// 模型转换
    for (int i = 0; i < self.playerModel.videoLenArray.count; i++) {
        
        WX_MediaInfoModel *mediaModel = [[WX_MediaInfoModel alloc]init];

        WX_ScriptInfoModel *infoModel = self.playerModel.videoLenArray[i];
        
        /// 替换镜头_ 拍摄好的
        if (infoModel.isScriptShoot) {
            mediaModel.mediaPath = [[NSString stringWithFormat:@"%@",filePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",infoModel.replace_ShootName]];
            mediaModel.mediaTitle = infoModel.replace_ShootName;
            mediaModel.imageDataStr = infoModel.replace_ImgData;
            mediaModel.DurationStr = infoModel.replace_ShootDuration;

        }else{
            
        /// 替换镜头_ 原镜头
            mediaModel.mediaPath = [[NSString stringWithFormat:@"%@",filePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",infoModel.videoLen_ShootName]];
            mediaModel.mediaTitle = infoModel.videoLen_ShootName;
            UIImageView *videoImgView = [self.view viewWithTag:500 +i];
            
            NSData *imgData = UIImagePNGRepresentation(videoImgView.image);
            mediaModel.imageDataStr = [imgData base64EncodedStringWithOptions:0];
            
            if ([infoModel.videoLen_timelength integerValue] == 1) {
                
                mediaModel.DurationStr = [NSString stringWithFormat:@"0:0%@",infoModel.videoLen_timelength];
            }else if ([infoModel.videoLen_timelength integerValue]< 10 ){
                
                 mediaModel.DurationStr = [NSString stringWithFormat:@"0:0%@",infoModel.videoLen_timelength];
            }else if ([infoModel.videoLen_timelength integerValue]< 60 && [infoModel.videoLen_timelength integerValue] >= 10){
                
                mediaModel.DurationStr = [NSString stringWithFormat:@"0:%@",infoModel.videoLen_timelength];
            }else if ( [infoModel.videoLen_timelength integerValue] >= 60){
                
                NSInteger durationTime = [infoModel.videoLen_timelength integerValue];
                if (durationTime%60 > 9) {
                    
                    mediaModel.DurationStr = [NSString stringWithFormat:@"%zi:%zi",durationTime/60,durationTime%60];
                }else if (durationTime%60 <= 9){
                    mediaModel.DurationStr = [NSString stringWithFormat:@"%zi:0%zi",durationTime/60,durationTime%60];
                    
                }
            }

        }
        
        [videoArray addObject:mediaModel];
        
    }
    
    [videoEditVC receiveTheVoide:videoArray];
    
    if (self.playerModel.scriptID) {
        
        videoEditVC.scriptStrid = self.playerModel.scriptID;
        videoEditVC.scriptName = self.playerModel.scriptname;
    }else{
        WX_ScriptInfoModel *infoModel = self.playerModel.videoLenArray.firstObject;
        
        videoEditVC.scriptStrid =  infoModel.videoLen_id;
        videoEditVC.scriptName = [infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length -1];
    }
    
    
    [self.navigationController pushViewController:videoEditVC animated:YES];
    QNWSLog(@"下一步啦");


}

#pragma mark ----- 文教拷贝
-(BOOL)copyFilefromFolderPath:(NSString *)FolderPath toCopyFolderPath:(NSString *)CopyFolderPath WithFileName:(NSString *)fileName
{
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:FolderPath];
    NSError *error;
    _fileManager = [NSFileManager defaultManager];
    if(![_fileManager fileExistsAtPath:filePath]){ //如果不存在
        
        if([_fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]){
            QNWSLog(@"创建 Media 文件夹成功");
        }else{
            QNWSLog(@"创建 Media 文件夹失败,  error == %@",error);
        }
        
    }
    
    NSString *copyPath = [docDir stringByAppendingPathComponent:CopyFolderPath];
    copyPath = [copyPath stringByAppendingPathComponent:fileName];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    
    if ([_fileManager copyItemAtPath:copyPath toPath:filePath error:&error]) {
        QNWSLog(@"文件拷贝成功");
        return YES;
    }else{
        QNWSLog(@"镜头文件拷贝失败, error == %@",error);
        return NO;
    }
    
   
}


-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark ------- UICollectionViewDataSource,UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.scriptArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *iden = @"shootScriptCell";
    
    WX_ShootScriptCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    
    //  解决cell 重用问题
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    WX_ScriptModel *scriptModel = self.scriptArray[indexPath.row];
    

    
    cell.contentView.backgroundColor = [UIColor clearColor];
   
    /// 已下载的会走button
    /// 未下载的会有图层
#pragma mark ---- 设置按钮
    cell.scriptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = self.scriptLibraryBtn.bounds;

    [imgView sd_setImageWithURL:[NSURL URLWithString:scriptModel.jpgurl]];
    imgView.layer.cornerRadius = 8.f;
    imgView.layer.masksToBounds = YES;
    [cell.scriptBtn addSubview:imgView];
    cell.scriptBtn.frame = CGRectMake(0, 0, self.scriptLibraryBtn.kwidth, self.scriptLibraryBtn.kheight);
    cell.scriptBtn.titleEdgeInsets = self.scriptLibraryBtn.titleEdgeInsets;
    [cell.scriptBtn setTitle:scriptModel.scriptname forState:UIControlStateNormal];
    if (KCurrentDeviceIsIphone4) {
        cell.scriptBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        cell.scriptBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -(self.scriptLibraryBtn.kheight + 12), 0);

    }else if (KCurrentDeviceIsIphone5){
        cell.scriptBtn.titleLabel.font = [UIFont systemFontOfSize:8];
    }else if (KCurrentDeviceIsIphone6){
        cell.scriptBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }else if (KCurrentDeviceIsIphone6p){
        cell.scriptBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    [cell.scriptBtn setTitleColor:KUIColorFromRGB(0xc1c1c1) forState:UIControlStateNormal];
    [cell.scriptBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateSelected];
    [cell.scriptBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    [cell.scriptBtn addTarget:self action:@selector(playTheScript:) forControlEvents:UIControlEventTouchUpInside];
    cell.scriptBtn.tag = 100 + indexPath.row;
    QNWSLog(@"cell.scriptBtn.tag == %zi",cell.scriptBtn.tag);
    if (indexPath.row == 0) {
        self.collection_First_button = cell.scriptBtn;
    }
    cell.scriptBtn.enabled = NO;
    [cell.contentView addSubview:cell.scriptBtn];
    
#pragma mark ---- 播放icon
    cell.imgView_PlayIcon = [[UIImageView alloc]init];
    cell.imgView_PlayIcon.frame = CGRectMake(0, 0, 30, 30);
    cell.imgView_PlayIcon.center = cell.scriptBtn.center;
    cell.imgView_PlayIcon.image = [UIImage imageNamed:@"icon_hepai_play_jbxz"];
    cell.imgView_PlayIcon.hidden = YES;
    [cell.contentView addSubview:cell.imgView_PlayIcon];
    
#pragma amrk ---- 未下载图层
    cell.unDownloadView = [[UIView alloc]init];
    cell.unDownloadView.frame = CGRectMake(0, 0, self.scriptLibraryBtn.kwidth, self.scriptLibraryBtn.kheight);
    cell.unDownloadView.layer.masksToBounds = YES;
    cell.unDownloadView.layer.cornerRadius = 8.0f;
//    cell.backgroundColor = [UIColor grayColor];
    cell.unDownloadView.backgroundColor = KUIColorFromRGBA(0x000000, 0.4);
//    cell.unDownloadView.alpha = 0.5f;
    cell.unDownloadView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downScript:)];
    cell.unDownloadView.tag = cell.scriptBtn.tag +100;
    [cell.unDownloadView addGestureRecognizer:tap];
    [cell.contentView addSubview:cell.unDownloadView];
    
//    NSString *str_UnDown = @"未下载";
//    CGSize size_Label_UnDown = [WX_ToolClass changeSizeWithString:str_UnDown FontOfSize:12 bold:ENUM_NormalSystem];
//    UILabel *label_UnDown = [[UILabel alloc]initWithFrame:CGRectMake((KSCriptCellHeightAndWidth-size_Label_UnDown.width)/2, size_Label_UnDown.width*sin(40), size_Label_UnDown.width, size_Label_UnDown.height)];
//    label_UnDown.text = str_UnDown;
//    label_UnDown.textColor = KUIColorBaseGreenNormal;
//    label_UnDown.alpha = 1.f;
//    label_UnDown.font = [UIFont systemFontOfSize:12];
//    [cell.unDownloadView addSubview:label_UnDown];
//    label_UnDown.transform = CGAffineTransformMakeRotation(M_PI/9);
    
    UIImageView *imgView_Upload = [[UIImageView alloc]initWithFrame:CGRectMake((KSCriptCellHeightAndWidth-13-5), (KSCriptCellHeightAndWidth-13-5), 13, 13)];
    imgView_Upload.image = [UIImage imageNamed:@"icon_jbhp_jbxz"];
    [cell.unDownloadView addSubview:imgView_Upload];
    
    for (WX_ScriptModel *locationModel  in self.locationScriptArray) {
        if ([locationModel.scriptname isEqualToString:scriptModel.scriptname]) {
            cell.unDownloadView.hidden = YES;
            cell.scriptBtn.enabled = YES;
            cell.imgView_PlayIcon.hidden = YES;
            if (self.playerModel) {
                if ([self.playerModel.scriptname isEqualToString:scriptModel.scriptname]) {
                    cell.scriptBtn.selected = YES;
                    [cell.scriptBtn.layer setBorderColor:KUIColorFromRGBA(0xffffff, 0.4).CGColor];
                    cell.imgView_PlayIcon.hidden = NO;
//                    [cell.scriptBtn.layer setBorderWidth:3];
//                    [cell.scriptBtn.layer setCornerRadius:8.0];

                }else{
                    cell.scriptBtn.selected = NO;
                    [cell.scriptBtn.layer setBorderColor:[UIColor clearColor].CGColor];
                    cell.imgView_PlayIcon.hidden = YES;
//                    [cell.scriptBtn.layer setCornerRadius:8.0];
//                    [cell.scriptBtn.layer setBorderWidth:1];
                }
            }
            
            break;
        }else{
            cell.unDownloadView.hidden = NO;
            cell.scriptBtn.enabled = NO;
        }
    }
    
    self.library_Num = indexPath.row;
    
    if (self.videoD_ScriptModel && self.video_Num == indexPath.row ) {
        
        [self scriptFormVideoDVCWithRow:indexPath.row CellButton:cell.scriptBtn];
    }
    
    QNWSLog(@"cell.scriptBtn == %@",cell.scriptBtn);
    [self popFromScriptLibraryWithBtn:cell.scriptBtn];
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KSCriptCellHeightAndWidth, KSCriptCellHeightAndWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, screenWidth*0.07);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return screenWidth*0.035f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return screenWidth*0.035f;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = CATransform3DMakeScale(.1f, .1f, 1.f);
    [UIView animateWithDuration:0.35f animations:^{
        cell.layer.transform = CATransform3DIdentity;
    }];
}



#pragma mark ------ 点击播放
// 每次都是播放第一个视频
-(void)playTheScript:(UIButton *)btn
{
    
    self.Libtary_ScriptModel = nil;
    
    for (int i = 100; i < 10 +100; i++) {
        
        WX_ShootScriptCollectionCell *cell = (WX_ShootScriptCollectionCell* )[self.scriptCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i-100 inSection:0]];
        if (btn.tag == i) {
            cell.scriptBtn.selected = YES;
            [cell.scriptBtn.layer setBorderColor:KUIColorFromRGBA(0xffffff, 0.4).CGColor];
            cell.imgView_PlayIcon.hidden = NO;
//            [cell.scriptBtn.layer setBorderWidth:3];
//            [cell.scriptBtn.layer setCornerRadius:8.0];
        }else{
            cell.scriptBtn.selected = NO;
            [cell.scriptBtn.layer setBorderColor:[UIColor clearColor].CGColor];
            cell.imgView_PlayIcon.hidden = YES;
//            [cell.scriptBtn.layer setCornerRadius:8.0];
//            [cell.scriptBtn.layer setBorderWidth:1];
        }
    }
    
 
    if (self.scriptArray.count > 0 ) {
        WX_ScriptModel *scriptModel = self.scriptArray[btn.tag-100];
        self.playerModel = scriptModel;
        
        [self createScriptImgViewWithModel:scriptModel];

        // 播放第一视频
        WX_ScriptInfoModel *infoModel = scriptModel.videoLenArray[0];
        self.script_Tag = 0;
        self.replace_infoModel = infoModel;
        
        if (infoModel.isScriptShoot) {
            [self createVideoPlayerWithScriptName:infoModel.replace_ShootName];
            self.contentStr = nil;
        }else{
            [self createVideoPlayerWithScriptName:infoModel.videoLen_ShootName];
            self.contentStr = infoModel.videoLen_actioninfo;
        }
        _subLabel.text = self.contentStr;
        [self selectScript];
        
        self.playView.hidden = NO;
        
        // 剧本名
        self.replaceScriptName = infoModel.videoLen_ShootName;
        
        self.backupBtn = btn;
        
        QNWSLog(@"播放啦, btn.tag == %zi",btn.tag);
        
        
    }else{
        [WX_ProgressHUD show:@"镜头出错"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
        
        return;
    }
   
    
}

// 从剧本库点击按钮跳转过来, 需要设置选中状态
-(void)popFromScriptLibraryWithBtn:(UIButton*)btn
{
    // 从剧本库 跳转回来
    if (self.Libtary_ScriptModel ) {

        self.playerModel = self.Libtary_ScriptModel;
        WX_ScriptInfoModel *librart_infoModel = self.playerModel.videoLenArray[0];

        int row = 0;
        for (int i = 0; i < self.scriptArray.count; i++) {
            WX_ScriptModel *scriptModel = self.scriptArray[i];
            for (int j = 0; j < scriptModel.videoLenArray.count; j++) {
                WX_ScriptInfoModel *infoModel = scriptModel.videoLenArray[j];
                if ([librart_infoModel.videoLen_ShootName isEqualToString:infoModel.videoLen_ShootName]) {
                    row = i;
                }
            }
        }
        
        if (self.libaray_isNeed) {
            
            /// 跳转到指定镜头
            [self.scriptCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
//            [self createVideoPlayerWithScriptName:librart_infoModel.videoLen_ShootName];
            
            self.libaray_isNeed = NO;

        }
        
//        if (row == 0) {
//            
//            UIButton *btn = self.collection_First_button;
//            btn.selected = YES;
//            [btn.layer setBorderColor:KUIColorBaseGreenNormal.CGColor];
//            [btn.layer setBorderWidth:3.f];
//            [btn.layer setCornerRadius:8.0f];
//            self.backupBtn = btn;
//            
//            [self playTheScript:btn];
//
//        }else
        
            if (self.library_Num == row) {
//            UIButton *btn;
            if (row == 0) {
                btn = self.collection_First_button;

            }else{
                
//                btn = [self.view viewWithTag:100 +row];
            }
            btn.selected = YES;
            [btn.layer setBorderColor:KUIColorBaseGreenNormal.CGColor];
            [btn.layer setBorderWidth:3.f];
            [btn.layer setCornerRadius:8.0f];
            self.backupBtn = btn;
                QNWSLog(@"btn == %@",btn);
                if (btn) {
                    
                    [self playTheScript:btn];
                }
//            [self createScriptImgViewWithModel:self.playerModel];
//            
//            [self selectScript];
        }
    }
}

/// 镜头选框中效果
-(void)selectScript
{
    for (int i = 0; i < self.scriptScrollView.subviews.count; i++) {
        UIImageView *videoImgView = [self.view viewWithTag:400+i];
        UIView *view = [self.view viewWithTag:300 +i];
        UILabel *label = [self.view viewWithTag:600 +i];
        label.textColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        if (i == 0) {
            
            videoImgView.image = [UIImage imageNamed:@"icon_hepai_jtxz_s"];
        }else{
            
            videoImgView.image = [UIImage imageNamed:@"icon_hepai_jtxz_n"];
        }
        videoImgView.alpha = 0.6f;
        [view bringSubviewToFront:videoImgView];
        
        [view insertSubview:label aboveSubview:videoImgView];
    }

}

/// 设置遮罩
-(void)setTheBackViewHidden:(BOOL)hidden
{
    if (!self.hiddenBackView) {
        self.hiddenBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.hiddenBackView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.hiddenBackView];
    }
    self.hiddenBackView.hidden = hidden;
    
}

/// 下载视频
-(void)downScript:(UITapGestureRecognizer*)tap
{
    
    [self.player pause];
    

    if (self.scriptArray.count > 0) {
        
        [self setTheBackViewHidden:NO];
        
        WX_ScriptModel *scriptModel = self.scriptArray[tap.view.tag-200];
        
        _scriptModel = scriptModel;
        
        QNWSLog(@"播放啦, btn.tag == %zi",tap.view.tag);
        
#pragma mark ----- 点击下载
        _downNum = 0;
        
        [WX_ProgressHUD show:@"正在下载"];
        
        _recData = [NSMutableData new];
        
        [self createDownLoadWithScriptNum:0];
        
        UIButton *btn = [self.view viewWithTag:tap.view.tag -100];
        self.backupBtn = btn;

    }else{
        [WX_ProgressHUD show:@"镜头出错"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
        
        return;
    }
  
    
}

#pragma mark ------ 下载剧本
// 现从第一个剧本开始下载
// 等待第一个剧本下载完成后, 再下载第二个剧本
// 以此类推
-(void)createDownLoadWithScriptNum:(NSInteger)scriptNum
{
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    _filePath = [path stringByAppendingPathComponent:@"Script"];
    _fileManager = [NSFileManager defaultManager];
    [_fileManager createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil];

    WX_ScriptInfoModel *infoModel = _scriptModel.videoLenArray[scriptNum];

    _filePath = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",infoModel.videoLen_ShootName]];
    QNWSLog(@"filePath==%@",_filePath);
    
    [self downTheScriptWithUrlStr:infoModel.videoLen_lensurl];
}

-(void)downTheScriptWithUrlStr:(NSString*)urlStr
{
    
        
        QNWSLog(@"urlStr == %@",urlStr);
        //创建可变请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        
        //NSFileManager:文件管理类.管理文件的创建,删除,是否存在
        //NSFileHandle:文件操作类.文件的读,写.文件指针的移动
        _fileManager = [NSFileManager defaultManager];
        
        //判断文件是否存在
        if([_fileManager fileExistsAtPath:_filePath]){
            //存在.接着前面的部分往后追加(断点续传)
            
            //获取文件操作句柄
            _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_filePath];
            
            //将句柄移动到文件末尾
            [_fileHandle seekToEndOfFile];
            
            //获取到已下载文件的长度
            long long fileLength = _fileHandle.offsetInFile;
            
            //设置range头域
            [request addValue:[NSString stringWithFormat:@"bytes=%lld-",fileLength] forHTTPHeaderField:@"Range"];
            
            //发起请求
            _downConnection = [NSURLConnection connectionWithRequest:request delegate:self];
            
        }else{
            //不存在.从零开始下载
            
            //创建这个文件
            [_fileManager createFileAtPath:_filePath contents:nil attributes:nil];
            
            //获取文件操作句柄
            //fileHandleForUpdatingAtPath  读和写
            //fileHandleForReadingAtPath   只读
            //fileHandleForWritingAtPath   只写
            _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_filePath];
            
            //发起网络请求
            _downConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        }
    
}

#pragma mark -NSURLConnectionDataDelegate
//接收到了响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
//    QNWSLog(@"expectedContentLength==%lld",response.expectedContentLength);
    //总长度是2048
    //文件不存在 expectedContentLength   2048
    //文件存在,长度是1024   expectedContentLength  1024
    _recData.length = 0;
    
    
}
//接收到了数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //数据拼接
    [_recData appendData:data];
    
    
}

#pragma mark ------------ NSURLConnectionDataDelegate
//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_downNum < _scriptModel.videoLenArray.count) {
        
        //写入沙盒
        [_fileHandle writeData:_recData];
        
        WX_ScriptInfoModel *infoModel = _scriptModel.videoLenArray[_downNum];
        
        if (![_manager.dataBase executeUpdate:@"insert into Script3(titleName,scriptID,scriptName,scriptUrl,pictureJPGUrl,actioninfo,timelength,jpgurl,content) values(?,?,?,?,?,?,?,?,?)",_scriptModel.scriptname,_scriptModel.scriptID,infoModel.videoLen_ShootName,infoModel.videoLen_lensurl,infoModel.videoLen_lensjpgurl,infoModel.videoLen_actioninfo,infoModel.videoLen_timelength,infoModel.videoLen_lensjpgurl,_scriptModel.scriptcontent]){
            QNWSLog(@"视频拍摄数据库信息----- 插入失败");
        }else{
            QNWSLog(@"写入信息成功");
        }
        
        
        if (_downNum < _scriptModel.videoLenArray.count -1) {
            
            [self createDownLoadWithScriptNum:_downNum+1];
        }else{
            [WX_ProgressHUD showSuccess:@"下载成功"];
            
            [self setTheBackViewHidden:YES];
            
            [self readInfoFromFMDB];
            
            // 隐藏cell 遮罩
            for (int i = 0; i < self.scriptArray.count; i++) {
                WX_ScriptModel *scriptModel = self.scriptArray[i];
                
                for (WX_ScriptModel *locationModel in self.locationScriptArray) {
                    if ([locationModel.scriptname isEqualToString:scriptModel.scriptname]) {
                        WX_ShootScriptCollectionCell *cell = (WX_ShootScriptCollectionCell* )[self.scriptCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        
                        cell.scriptBtn.enabled = YES;
                        
                        cell.unDownloadView.hidden = YES;

                    }else{
                        WX_ShootScriptCollectionCell *cell = (WX_ShootScriptCollectionCell* )[self.scriptCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        
                        if (!cell.unDownloadView.hidden) {
                            cell.scriptBtn.enabled = NO;
                            
                            cell.unDownloadView.hidden = NO;

                    }

                        /// 播放这组镜头的第一个视频
                        [self playTheScript:self.backupBtn];
                        
                    }
                }
                
            }
        }
        
        _downNum++;
    }else{
   
        [WX_ProgressHUD showSuccess:@"下载失败"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
        
    }
    
}
//下载失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    QNWSLog(@"下载失败,error=%@",error);
    
    [WX_ProgressHUD show:@"下载失败"];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(downFailremoveTheHUD) userInfo:nil repeats:NO];

    
}

#pragma mark ------ 下载失败, 清空模型
-(void)downFailremoveTheHUD
{
    [WX_ProgressHUD dismiss];
    
    self.playerModel = nil;
    
    for (int i = 0; i < self.playerModel.videoLenArray.count; i++) {
        UIImageView *imgView = [self.view viewWithTag:i];
        imgView.image = nil;
    }
    
    [self setTheBackViewHidden:YES];
    
    self.playView.hidden = YES;
    
    self.replaceScriptStr = nil;
    
    [self.timer invalidate];
    
    self.slider.value = 0.f;
}

#pragma mark ----- 镜头出错
-(void)dismissTheHUD
{
    [WX_ProgressHUD dismiss];
    
//    self.playerModel = nil;
    
//    self.shotAVideoImgView = nil;
//    
//    self.shotBVideoImgView = nil;
    
//    self.playView.hidden = YES;
    
    [self setTheBackViewHidden:YES];
    
    [self.timer invalidate];
    
    self.slider.value = 0.f;
    
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
