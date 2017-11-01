//
//  WX_ShootCViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>


#import "WX_VoideEditingViewController.h"
#import "WX_UploadVideoViewController.h"
#import "WX_MediaCollectionViewCell.h"
#import "BYC_MainTabBarController.h"
#import "WX_MovieCViewController.h"
#import "WX_ShootCViewController.h"
#import "NSDate+TimeInterval.h"
#import "WX_MediaInfoModel.h"
#import "WX_ProgressHUD.h"
#import "WX_FMDBManager.h"
#import "ffmpegutils.h"
#import "WX_AVplayer.h"
#import "WX_AlbumVideoEditingViewController.h"
#import "WX_PhotoSelectedViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BYC_ControllerCustomView.h"

// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface WX_ShootCViewController () <UINavigationBarDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, retain) UICollectionView    *mediaCollectionView;

@property(nonatomic, retain) NSMutableArray      *movieArray;                   /**< 桌面图标*/
@property(nonatomic, retain) NSMutableArray      *selectMovieArray;
@property(nonatomic, retain) NSMutableArray      *dataArray;                    /**< 数据库中获取信息 */
//@property(nonatomic, retain) NSMutableArray      *AlbumMediaArray;              /**< 相册中获取视频信息 */
@property(nonatomic, retain) NSArray             *normalArray;
@property(nonatomic, retain) NSArray             *selectArray;

/* 添加话题时  需要选中的cell */
@property(nonatomic, strong) NSMutableArray      *themeSelectArray;

/* 使用到了通知中心, 需要移除 */
@property(nonatomic, assign) BOOL                isUseNSNotification;

@property(nonatomic, retain) WX_FMDBManager      *manager;

@property(nonatomic, strong) NSMutableArray      *assetsArray;
@property(nonatomic, strong) NSDateFormatter     *dateFormatter;

@property(nonatomic, assign) BOOL                isSelect;
@property(nonatomic, assign) BOOL                isReloadHeadView;
@property(nonatomic, assign) BOOL                isRefresh;
@property(nonatomic, retain) UIScrollView        *backGView;
@property(nonatomic, retain) NSFileManager       *fileManager;
@property(nonatomic ,retain) NSString            *sanBoxPath;

@property(nonatomic, strong) NSMutableArray      *cellSelectArray;      /**<  需要删除视的频数组 */

@end

@implementation WX_ShootCViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
//    [self setTheCell];
    
    [WX_ProgressHUD dismiss];
    
    [self createFMDB];
    
    [self createUI];
    
     [self themeCellSelect];

    
//    [self loadDataFromDataBase];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorBaseGreenNormal];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.themeModel.isAddTheme) {
        
        QNWSLog(@"创作界面 话题为 == %@",self.themeModel.themeStr);
    }
  

    // cell选中状态
    for (WX_ThemeModel *themeModel in self.themeSelectArray) {
        
        for ( int i = 0; i < self.assetsArray.count; i++) {
            NSArray *array = self.assetsArray[i];
            for (int j = 0; j < array.count; j++) {
                WX_MediaInfoModel *mediaModel = self.assetsArray[i][j];
                NSInteger row = j;
                NSInteger section = self.assetsArray.count -1 -i;
                WX_MediaCollectionViewCell *cell = (WX_MediaCollectionViewCell *)[self.mediaCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                
                
                if ([mediaModel.mediaTitle isEqualToString:themeModel.themeTitle]) {
                    cell.selButton.selected = YES;
                    cell.selImgView.hidden = NO;
                    
                    /// 选中
                    if (!cell.selImgView.hidden) {
                        
                        BOOL isHave = NO;
                        for (NSNumber *num in self.cellSelectArray) {
                            if ([num integerValue] == cell.tag +section*1000) {
                                isHave = YES;
                            }
                        }
                        
                        if (!isHave) {
                            if (self.cellSelectArray.count >= 7) {
                                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"最多不能超过7个视频哦" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                [alter show];
                                return;
                            }else{
                                cell.section = section;
                                cell.row = row;
                                [self.cellSelectArray addObject:[NSNumber numberWithInteger:cell.tag +section*1000]];
                            }
                        }
                        
                    }
                }
                
            }
        }
        
    }

}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
 
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.fileManager removeItemAtPath:self.sanBoxPath error:nil];
    
    self.mediaCollectionView = nil;
    
    [self.mediaCollectionView removeFromSuperview];
    
    for (UIView *obj in self.view.subviews) {
        [obj removeFromSuperview];
    }
    

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
}

// 话题模型
-(void)themeCellSelect
{
    if (self.themeSelectArray == nil) {
        self.themeSelectArray = [[NSMutableArray alloc]init];
    }
    if (self.themeModel.isAddTheme) {
        
        [self.themeSelectArray addObject:self.themeModel];
    }
    
   


}

-(void)setTheCell
{
    self.isReloadHeadView = NO;
    
    for ( int i = 0; i < self.assetsArray.count; i++) {
        NSArray *array = self.assetsArray[i];
        for (int j = 0; j < array.count; j++) {
            WX_MediaCollectionViewCell  *cell = (WX_MediaCollectionViewCell *)[self.mediaCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            if (cell.selButton.selected) {
                cell.selButton.selected = !cell.selButton.selected;
                cell.selImgView.hidden = YES;
                cell.selButton.selected = NO;
            }
        }
    }

}

-(void)createFMDB
{
    
    self.manager = [WX_FMDBManager sharedWX_FMDBManager];
    
     FMResultSet *rs = [self.manager.dataBase executeQuery:@"select * from KPieMedia"];
    if (rs == nil) {

        if (![self.manager.dataBase executeUpdate:@"create table if not exists KPieMedia(id integer primary key autoincrement,title text,duration text,createdDate text,imageData text,mediaPath text,albumPath text)"]) {
            QNWSLog(@"数据库---KPieMedia表创建失败");
        }else{
            QNWSLog(@"数据库--KPieMedia表创建成功");
        }
    }
}

-(void)createUI
{
    self.dataArray = [[NSMutableArray alloc]init];
    self.assetsArray = [[NSMutableArray alloc]init];
    self.movieArray = [[NSMutableArray alloc]init];
    self.selectMovieArray = [[NSMutableArray alloc]init];
    self.cellSelectArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"上传";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;

    
    self.normalArray = @[@"icon_dpcz_daoru_n",@"icon_dpcz_xzps_n",@"btn_bg_dpcz_n",@"icon_dpcz_xuanzhe_n"];
    self.selectArray = @[@"icon_dpcz_daoru_h",@"icon_dpcz_xzps_h",@"btn_bg_dpcz_h",@"icon_dpcz_xuanzhe_h"];
    NSArray *titleArray = @[@" 导入视频",@" 新增拍摄"];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
     rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickTheRigthButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.view.backgroundColor = KUIColorFromRGB(0xf0f0f0);
    
    UIView *buttonBGView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight*0.9278, screenWidth, screenHeight*0.074)];
    buttonBGView.backgroundColor = KUIColorFromRGB(0xc5c5c5);
    [self.view addSubview:buttonBGView];
    
    UIImageView *imgView_PartCut = [[UIImageView alloc]initWithFrame:CGRectMake(0, -1, buttonBGView.kwidth, 1)];
    imgView_PartCut.backgroundColor = KUIColorFromRGB(0xc5c5c5);
    [buttonBGView addSubview:imgView_PartCut];

    for (int i = 0; i <2; i++) {
        UIButton *infoButton = [[UIButton alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width/2, 0, self.view.frame.size.width/2-1, buttonBGView.frame.size.height)];
        infoButton.tag = 100+i;
        [infoButton addTarget:self action:@selector(clickInfo:) forControlEvents:UIControlEventTouchUpInside];
        [infoButton setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [infoButton setTitleColor:KUIColorFromRGB(0x4d606f) forState:UIControlStateNormal];
//        [infoButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
        [infoButton setImage:[UIImage imageNamed:self.normalArray[i]] forState:UIControlStateNormal];
        [infoButton setImage:[UIImage imageNamed:self.selectArray[i]] forState:UIControlStateHighlighted];
        [infoButton setBackgroundImage:[UIImage imageNamed:self.normalArray[2]] forState:UIControlStateNormal];
        [infoButton setBackgroundImage:[UIImage imageNamed:self.selectArray[2]] forState:UIControlStateHighlighted];
        [infoButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [infoButton setBackgroundColor:KUIColorFromRGBA(0x4bc8ba, 0.8)];
         [buttonBGView addSubview:infoButton];
    }
    
    self.backGView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight-KHeightNavigationBar-KHeightTabBar)];
    self.backGView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backGView];


    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(70, 70);
    if (!self.mediaCollectionView) {
        self.mediaCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, screenWidth-20, screenHeight - KHeightNavigationBar - buttonBGView.kheight) collectionViewLayout:flowLayout];
        
        self.mediaCollectionView.backgroundColor = [UIColor clearColor];
        self.mediaCollectionView.delegate = self;
        self.mediaCollectionView.dataSource = self;
        self.mediaCollectionView.emptyDataSetSource = self;
        self.mediaCollectionView.emptyDataSetDelegate = self;
        self.mediaCollectionView.showsVerticalScrollIndicator = NO;
        [self.backGView addSubview:self.mediaCollectionView];
        
        [self.mediaCollectionView registerClass:[WX_MediaCollectionViewCell class]forCellWithReuseIdentifier:@"MediaCell"];
        [self.mediaCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    }
    [self loadDataFromDataBase];
    
#pragma mark    --------------    长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration = 1.0f;
    [self.mediaCollectionView addGestureRecognizer:longPress];
    
}


#pragma mark --------- 长按播放
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.mediaCollectionView];
        NSIndexPath * indexPath = [self.mediaCollectionView indexPathForItemAtPoint:point];
        //        WX_MediaCollectionViewCell *cell = (WX_MediaCollectionViewCell *)[self.mediaCollectionView cellForItemAtIndexPath:indexPath];
        if(indexPath == nil)
            return ;
        WX_MediaInfoModel *model = self.assetsArray[self.assetsArray.count-1-indexPath.section][indexPath.row];
        QNWSLog(@"mediaTitle == %@",model.mediaTitle);
        
        NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *filePath = [docDir stringByAppendingPathComponent:@"Media"];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",model.mediaTitle]];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        QNWSLog(@"filePath == %@",filePath);
        QNWSLog(@"url == %@",url);
        
        // 播放器测试 路径
        MPMoviePlayerViewController *playViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
        MPMoviePlayerController *player = [playViewController moviePlayer];
        player.scalingMode = MPMovieScalingModeAspectFit;
        player.controlStyle = MPMovieControlStyleFullscreen;
        [player play];
        [self.navigationController presentViewController:playViewController animated:YES completion:nil];
        
    }
}
-(void)dismiss:(id)sender
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    BOOL isPop = NO;
    for (UIViewController *controllers in self.navigationController.viewControllers) {
    
        QNWSLog(@"controllers == %@",controllers);
        if ([controllers isKindOfClass:NSClassFromString(@"MMDrawerController")])
        {
            [self.navigationController popToViewController:controllers animated:YES];
            isPop = YES;
        }
    }
    if (!isPop) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.themeModel.isAddTheme) {
        self.themeModel.isAddTheme = NO;
        self.themeModel.themeStr = nil;
    }
    if (self.isUseNSNotification) {
        [QNWSNotificationCenter removeObserver:self name:@"saveThemeModel" object:nil];
    }

}

 //  从数据库读取信息
-(void)loadDataFromDataBase
{
    
    [self.dataArray removeAllObjects];
    
    WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];
    FMResultSet *dataResult = [manager.dataBase executeQuery:@"select * from KPieMedia"];
    while ([dataResult next]) {
        
//        title,duration,createdDate,imageData,mediaPath
        WX_MediaInfoModel *mediaModel = [[WX_MediaInfoModel alloc]init];
        mediaModel.mediaTitle = [dataResult stringForColumn:@"title"];
        mediaModel.DurationStr = [dataResult stringForColumn:@"duration"];
        mediaModel.createDate = [dataResult stringForColumn:@"createdDate"];
        mediaModel.imageDataStr = [dataResult stringForColumn:@"imageData"];
        mediaModel.mediaPath = [dataResult stringForColumn:@"mediaPath"];
        mediaModel.albumPath = [dataResult stringForColumn:@"albumPath"];
        
        [self.dataArray addObject:mediaModel];
    }

    [self.assetsArray removeAllObjects];
//    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
    for (int i = 0; i < array.count; i ++) {
        WX_MediaInfoModel *model = array[i];
        NSString *dataStr = model.createDate;
        dataStr = [dataStr substringToIndex:10];
        NSMutableArray *tempArray = [@[] mutableCopy];
        
        [tempArray addObject:model];
        for (int j = i+1; j < array.count; j ++) {
            WX_MediaInfoModel *otherModel = array[j];
            NSString *otherData = otherModel.createDate;
            otherData = [otherData substringToIndex:10];
            
            if([dataStr isEqualToString:otherData]){
                [tempArray addObject:otherModel];
                [array removeObjectAtIndex:j];
                j= j-1;
            }
        }
        NSMutableArray *sortArray = [[NSMutableArray alloc]init];
        for (NSInteger k = tempArray.count -1; k >= 0; k--) {
            [sortArray addObject:tempArray[k]];
        }
        [self.assetsArray addObject:sortArray];
    }
    
    [self.dataArray removeAllObjects];

    [self.dataArray addObjectsFromArray:self.assetsArray];
    
    QNWSLog(@"self.dataArray == %@",self.dataArray);

    [self.mediaCollectionView reloadData];
    
    if (!self.mediaCollectionView) {
        
    }
}

-(void)clickTheRigthButton
{
    
    QNWSLog(@"大片创作完成,进入下一步");
    
    [self.selectMovieArray removeAllObjects];
    NSInteger   section;
    NSInteger   row;
    for (int i = 0; i < self.cellSelectArray.count; i++) {
        NSNumber *cellNum = self.cellSelectArray[i];
        section = [cellNum integerValue]/1000;
        row = [cellNum integerValue]%1000 -100;
        
        NSArray *selectArray = self.assetsArray[self.assetsArray.count -1 -section];
        [self.selectMovieArray addObject:selectArray[row]];
    }
    

    
#pragma mark ------------------ 编写关闭视频限制, 编写视频边界操作需打开
#if 1
    if (self.selectMovieArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请至少选择一个视频" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }else if (self.selectMovieArray.count >= 1 && self.selectMovieArray.count <= 7){
        
        [self.cellSelectArray removeAllObjects];
        
        WX_VoideEditingViewController *voideEVC = [[WX_VoideEditingViewController alloc]init];
        if (self.themeModel.isAddTheme) {
            voideEVC.themeModel = self.themeModel;
        }
        [voideEVC receiveTheVoide:self.selectMovieArray];
        [self.navigationController pushViewController:voideEVC animated:YES];
    
    }
#endif
        
#if 0
        
        WX_UploadVideoViewController *uploadVC = [[WX_UploadVideoViewController alloc]init];

//        [uploadVC setImageWithAsset:self.selectMovieArray];
#endif
      
        
        
#if 0
        WX_MediaInfoModel *model = [self.selectMovieArray firstObject];
        [uploadVC setMediaWithModel:model];
        
        [self.navigationController pushViewController:uploadVC  animated:YES];
        
    }else{
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"只能上传一个视频哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
        
        [alter show];
    }
#endif

    
}

-(void)clickInfo:(UIButton *)button
{
    if (button.tag == 100) {
        QNWSLog(@"导入视频");
        if (!self.assetsArray)
            self.assetsArray = [[NSMutableArray alloc] init];
        WX_PhotoSelectedViewController *photoKitVC = [[WX_PhotoSelectedViewController alloc]init];
        [photoKitVC parmsFromPhotoKitWith:ENUM_Video];
        [self.navigationController pushViewController:photoKitVC animated:YES];
        
        /// 有话题时 给通知
        if (self.themeModel.isAddTheme) {
            [QNWSNotificationCenter addObserver:self selector:@selector(saveThemeModel:) name:@"saveThemeModel" object:nil];
            
        }
    }else if(button.tag == 101){
        WX_MovieCViewController *movieVC = [[WX_MovieCViewController alloc]init];
        movieVC.isFromShootVC = YES;
        /// 有话题时 给回调
        if (self.themeModel.isAddTheme) {
            
            movieVC.block = ^(WX_ThemeModel *themeModel){
                QNWSLog(@"themeModel.themeTitle == %@",themeModel.themeTitle);
                [self.themeSelectArray addObject:themeModel];
            };
        }
        [self.navigationController pushViewController:movieVC animated:YES];
        QNWSLog(@"新增拍摄");
    }
}


-(void)saveThemeModel:(NSNotification *)notification
{
    
    self.isUseNSNotification = YES;
    
    NSMutableArray *themeTitleArray = [notification object];
    
    for (NSString *themeTitle in themeTitleArray) {
        
        WX_ThemeModel *themeModel = [[WX_ThemeModel alloc]init];
        
        themeModel.themeTitle = themeTitle;
        
        [self.themeSelectArray addObject:themeModel];
    }
}


#pragma mark --------  UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // 设置返回数组个数

    return self.assetsArray.count;


}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.assetsArray[self.assetsArray.count-1 -section];

    return array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WX_MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];

    //  解决cell 重用问题
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    NSArray *mediaArray = self.assetsArray[self.assetsArray.count-1 - indexPath.section];
//    NSArray *mediaArray = self.assetsArray[indexPath.section];
    WX_MediaInfoModel *model = mediaArray[indexPath.row];
    
    
#if 1
    NSData *imgData = [[NSData alloc]initWithBase64EncodedString:model.imageDataStr options:0];
    
    [cell setCellWithImage:[UIImage imageWithData:imgData] time:model.DurationStr];
#endif
    cell.tag = 100+indexPath.row;
    
    if (self.cellSelectArray.count > 0) {
        
        for (NSNumber *cellNum in self.cellSelectArray) {
            if ([cellNum integerValue]%1000 == cell.tag && [cellNum integerValue]/1000 == indexPath.section) {
                cell.selButton.selected = YES;
                cell.selImgView.hidden = NO;
                break;
            }else{
                cell.selButton.selected = NO;
                cell.selImgView.hidden = YES;
            }
        }
    }else{
        cell.selButton.selected = NO;
        cell.selImgView.hidden = YES;
    }
    
    
    return cell;
}

//返回段头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.assetsArray.count) {
        return CGSizeMake(self.view.frame.size.width, 40);
    }else{
        return CGSizeMake(0, 0);
    }
    
}

//段头段尾复用
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    if (!self.isReloadHeadView) {
//        self.isReloadHeadView = YES;
        //通过kind字符串来区分段头段尾
        UICollectionReusableView *reusableView = nil;
        if ( [kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            //段头复用
            UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
            
            //  解决cell 重用问题
            for (UIView *view in head.subviews) {
                if (view) {
                    [view removeFromSuperview];
                }
            }
    
            
            head.backgroundColor = [UIColor clearColor];
            
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, screenWidth, 30)];
            NSArray *mediaArray = self.assetsArray[self.assetsArray.count-1  -indexPath.section];
            //            NSArray *mediaArray = self.assetsArray[indexPath.section];
            WX_MediaInfoModel *model = [mediaArray firstObject];
            NSString *year = [model.createDate substringWithRange:NSMakeRange(0, 4)];
            NSString *month = [model.createDate substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [model.createDate substringWithRange:NSMakeRange(8, 2)];
            
            timeLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
            timeLabel.font = [UIFont systemFontOfSize:14];
            [timeLabel sizeToFit];
            timeLabel.textColor = KUIColorFromRGB(0x6c7b8a);
            [head addSubview:timeLabel];
            reusableView = head;
            
            
        }
         return reusableView;
   
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WX_MediaCollectionViewCell *cell = (WX_MediaCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    /// 选中
    if (cell.selImgView.hidden) {
        
        BOOL isHave = NO;
        for (NSNumber *num in self.cellSelectArray) {
            if ([num integerValue] == cell.tag +indexPath.section*1000) {
                isHave = YES;
            }
        }
        
        if (!isHave) {
            if (self.cellSelectArray.count >= 7) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"最多不能超过7个视频哦" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alter show];
                return;
            }else{
                cell.section = indexPath.section;
                cell.row = indexPath.row;
                cell.selImgView.hidden = !cell.selImgView.hidden;
                cell.selButton.selected = !cell.selButton.selected;
                [self.cellSelectArray addObject:[NSNumber numberWithInteger:cell.tag +indexPath.section*1000]];
            }
        }
        
    }else{
        
        for (NSNumber *num in self.cellSelectArray) {
            
            if ([num integerValue] == cell.tag +indexPath.section*1000) {
                cell.section = indexPath.section;
                cell.row = indexPath.row;
                cell.selImgView.hidden = !cell.selImgView.hidden;
                cell.selButton.selected = !cell.selButton.selected;
                [self.cellSelectArray removeObject:[NSNumber numberWithInteger:cell.tag +indexPath.section*1000]];
                return;
            }
        }
        
        
    }

}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.layer.transform = CATransform3DMakeScale(.1f, .1f, 1.f);
//    [UIView animateWithDuration:0.35f animations:^{
//        cell.layer.transform = CATransform3DIdentity;
//    }];
}


#pragma mark ------空数据提示
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    BYC_ControllerCustomView *emptyView = [[BYC_ControllerCustomView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight - KHeightNavigationBar - KHeightTabBar) andNotificationObject:self];
    emptyView.imageUrl = @"img_kbzt_smdmy";
    return emptyView;
}


@end



