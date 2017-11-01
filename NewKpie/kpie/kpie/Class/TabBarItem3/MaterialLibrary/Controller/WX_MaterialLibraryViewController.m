//
//  WX_MaterialLibraryViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_MaterialLibraryViewController.h"
#import "WX_FMDBManager.h"
#import "WX_MediaCollectionViewCell.h"
#import "WX_MediaInfoModel.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_ControllerCustomView.h"

@interface WX_MaterialLibraryViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollisionBehaviorDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property(nonatomic, retain) UICollectionView       *mediaCollectionView;
@property(nonatomic, retain) UIView                 *backGView;
@property(nonatomic, retain) WX_FMDBManager         *manager;
@property(nonatomic, retain)UIButton                *rightButton;

@property(nonatomic, retain) NSMutableArray         *dataArray;
@property(nonatomic, retain) NSMutableArray         *assetsArray;
@property(nonatomic, retain) NSMutableArray         *selectMovieArray;
@property(nonatomic, retain) NSMutableArray         *cellSelectArray;
@end

@implementation WX_MaterialLibraryViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    self.view.backgroundColor = KUIColorFromRGB(0xF0F0F0);
}



-(void)createUI
{
    self.title = @"素材库";
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.assetsArray = [[NSMutableArray alloc]init];
    self.selectMovieArray = [[NSMutableArray alloc]init];
    self.cellSelectArray = [[NSMutableArray alloc]init];
    
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [self.rightButton setTitle:@"删除" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [self.rightButton addTarget:self action:@selector(deleteTheMedia:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    self.rightButton.hidden = YES;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.backGView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight-KHeightNavigationBar)];
    self.backGView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backGView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(75, 75);
    
    self.mediaCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(2, 0, screenWidth-4, screenHeight - KHeightNavigationBar) collectionViewLayout:flowLayout];
    
    self.mediaCollectionView.backgroundColor = [UIColor clearColor];
    self.mediaCollectionView.delegate = self;
    self.mediaCollectionView.dataSource = self;
    self.mediaCollectionView.emptyDataSetDelegate = self;
    self.mediaCollectionView.emptyDataSetSource = self;
    [self.backGView addSubview:self.mediaCollectionView];
    
    [self.mediaCollectionView registerClass:[WX_MediaCollectionViewCell class]forCellWithReuseIdentifier:@"MediaCell"];
    [self.mediaCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    [self loadDataFromDataBase];
    
    if (self.dataArray.count) {
        self.rightButton.hidden = NO;
        #pragma mark    --------------    长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
        longPress.minimumPressDuration = 1.0f;
        [self.mediaCollectionView addGestureRecognizer:longPress];
    }
    
}

-(void)deleteTheMedia:(UIButton *)button
{
    [self.selectMovieArray removeAllObjects];
    NSInteger   section = 0;
    NSInteger   row = 0;
    for (int i = 0; i < self.cellSelectArray.count; i++) {
        NSNumber *cellNum = self.cellSelectArray[i];
        section = [cellNum integerValue]/1000;
        row = [cellNum integerValue]%1000 -100;
       
        NSArray *selectArray = self.assetsArray[section];
        [self.selectMovieArray addObject:selectArray[row]];
    }

    if (self.selectMovieArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请至少选择一个视频" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        
    }else{
        
        for (WX_MediaInfoModel *model in self.selectMovieArray) {
            QNWSLog(@"mediaTitle == %@",model.mediaTitle);
            //删除
            self.manager = [WX_FMDBManager sharedWX_FMDBManager];
            if (![self.manager.dataBase executeUpdate:@"delete from KPieMedia where title = ?",model.mediaTitle])
            {
                QNWSLog(@"数据库删除失败");
            }
            
            NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [docArray objectAtIndex:0];
            NSString *mediaPath = [path stringByAppendingPathComponent:@"Media"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSString *delPath=[mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model.mediaTitle]];
            
            QNWSLog(@"delPath == %@",delPath);
            BOOL blHave= [fileManager fileExistsAtPath:delPath];
            if (!blHave) {
                QNWSLog(@"no  have");
            }else {
                QNWSLog(@" have");
                BOOL blDele= [fileManager removeItemAtPath:delPath error:nil];
                if (blDele) {
                    QNWSLog(@"dele success");
                }else {
                    QNWSLog(@"dele fail");
                }
            }
            
            
            WX_MediaCollectionViewCell *cell = (WX_MediaCollectionViewCell *)[self.mediaCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            cell.selButton.selected = NO;
            cell.selImgView.hidden = YES;
            
            [self.cellSelectArray removeAllObjects];
            
            [self loadDataFromDataBase];
            
        }
        
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
        [self.assetsArray addObject:tempArray];
    }
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.assetsArray];
    
    QNWSLog(@"self.dataArray == %@",self.dataArray);
    
    [self.mediaCollectionView reloadData];
    if (!self.dataArray.count) {
        self.rightButton.hidden = YES;
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
    NSArray *array = self.assetsArray[section];
    
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
    

    
    NSArray *mediaArray = self.assetsArray[indexPath.section];
    WX_MediaInfoModel *model = mediaArray[indexPath.row];
    

    NSData *imgData = [[NSData alloc]initWithBase64EncodedString:model.imageDataStr options:0];
    
    [cell setCellWithImage:[UIImage imageWithData:imgData] time:model.DurationStr];
  
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

    //通过kind字符串来区分段头段尾
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
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.032, 10, screenWidth, 30)];
        NSArray *mediaArray = self.assetsArray[indexPath.section];
        WX_MediaInfoModel *model = [mediaArray firstObject];
//        QNWSLog(@"createDate == %@",model.createDate);
        NSString *year = [model.createDate substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [model.createDate substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [model.createDate substringWithRange:NSMakeRange(8, 2)];
        
        timeLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
        timeLabel.font = [UIFont systemFontOfSize:14];
        [timeLabel sizeToFit];
        timeLabel.textColor = KUIColorWordsBlack1;
        [head addSubview:timeLabel];
        
        return head;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = CATransform3DMakeScale(.1f, .1f, 1.f);
    [UIView animateWithDuration:0.35f animations:^{
        cell.layer.transform = CATransform3DIdentity;
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WX_MediaCollectionViewCell *cell = (WX_MediaCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.section = indexPath.section;
    cell.row = indexPath.row;
//    cell.isClick = !cell.isClick;
    cell.selImgView.hidden = !cell.selImgView.hidden;
    cell.selButton.selected = !cell.selButton.selected;
    QNWSLog(@"数组变化前 self.cellSelectArray == %@",self.cellSelectArray);

    /// 选中
    if (!cell.selImgView.hidden) {
     
        BOOL isHave = NO;
        for (NSNumber *num in self.cellSelectArray) {
            if ([num integerValue] == cell.tag +indexPath.section*1000) {
                isHave = YES;
            }
        }
        
        if (!isHave) {
            [self.cellSelectArray addObject:[NSNumber numberWithInteger:cell.tag +indexPath.section*1000]];
        }
        
    }else{
        
//        cell.selImgView.hidden = !cell.selImgView.hidden;
//        cell.selButton.selected = !cell.selButton.selected;
        
        QNWSLog(@"需要删除 %zi",cell.tag +indexPath.section*1000);
        [self.cellSelectArray removeObject:[NSNumber numberWithInteger:cell.tag +indexPath.section*1000]];

    }
    
    QNWSLog(@"数组变化后 self.cellSelectArray == %@",self.cellSelectArray);
    
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
        WX_MediaInfoModel *model = self.assetsArray[indexPath.section][indexPath.row];
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

#pragma mark ------空数据提示
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    BYC_ControllerCustomView *emptyView = [[BYC_ControllerCustomView alloc]initWithFrame:CGRectMake(0,0, screenWidth, screenHeight - KHeightNavigationBar) andNotificationObject:self];
    emptyView.imageUrl = @"img_kbzt_smdmy";
    return emptyView;
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
