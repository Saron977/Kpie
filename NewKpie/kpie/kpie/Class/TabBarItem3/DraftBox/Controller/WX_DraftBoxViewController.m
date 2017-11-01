//
//  WX_DraftBoxViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_DraftBoxViewController.h"
#import "WX_FMDBManager.h"
#import "WX_DraftBoxTableViewCell.h"
#import "WX_DBBoxModel.h"
#import "WX_UploadVideoViewController.h"
#import "BYC_MainNavigationController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "WX_MovieCViewController.h"

@interface WX_DraftBoxViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic, retain) UITableView            *draftBoxTableView;
@property(nonatomic, retain) UILabel                *nilLabel;
@property(nonatomic, retain) WX_FMDBManager         *manager;

@property(nonatomic, retain) NSMutableArray         *dataArray;



@end

@implementation WX_DraftBoxViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createUI];
}

-(void)createUI{
    self.title = @"草稿箱";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"参与" style:UIBarButtonItemStylePlain target:self action:@selector(jion)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.draftBoxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight-KHeightNavigationBar) style:UITableViewStylePlain];
    self.draftBoxTableView.dataSource = self;
    self.draftBoxTableView.delegate = self;
    self.draftBoxTableView.emptyDataSetSource = self;
    self.draftBoxTableView.emptyDataSetDelegate = self;
    self.draftBoxTableView.backgroundColor = KUIColorFromRGB(0xF0F0F0);
    self.draftBoxTableView.scrollEnabled = YES;
    self.draftBoxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.draftBoxTableView];
    [self.draftBoxTableView registerNib:[UINib nibWithNibName:@"WX_DraftBoxTableViewCell" bundle:nil] forCellReuseIdentifier:@"WX_DraftBoxTableViewCell"];
    [self loadDataFromDataBase];
}

#pragma mark------参与
-(void)jion{
    QNWSLog(@"------参与-------");
    WX_MovieCViewController *movieVC = [[WX_MovieCViewController alloc]init];
    [self.navigationController pushViewController:movieVC animated:YES];
    

}

//  从数据库读取信息
-(void)loadDataFromDataBase
{
    [self.dataArray removeAllObjects];
    
    WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    self.manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    FMResultSet *rs = [self.manager.dataBase executeQuery:@"select * from DraftBox1"];
    if (rs == nil) {
        
        if (![self.manager.dataBase executeUpdate:@"create table if not exists DraftBox1(id integer primary key autoincrement,title text,mediaTitle text,mediaPath text,imgDataStr text,contents text,glocation text,type text,videoID text)"]) {
            QNWSLog(@"数据库---DraftBox1表创建失败");
        }else{
            QNWSLog(@"数据库--KPieMedia表创建成功");
        }
    }else{
        FMResultSet *dataResult = [manager.dataBase executeQuery:@"select * from DraftBox1"];
        while ([dataResult next]) {
            
            WX_DBBoxModel *draftModel = [[WX_DBBoxModel alloc]init];
            draftModel.title = [dataResult stringForColumn:@"title"];
            draftModel.mediaPath = [dataResult stringForColumn:@"mediaPath"];
            draftModel.imgDataStr = [dataResult stringForColumn:@"imgDataStr"];
            draftModel.contents = [dataResult stringForColumn:@"contents"];
            draftModel.location = [dataResult stringForColumn:@"glocation"];
            draftModel.mediaTitle = [dataResult stringForColumn:@"mediaTitle"];
            draftModel.media_Type = [dataResult intForColumn:@"type"];
            draftModel.videoID = [dataResult stringForColumn:@"videoID"];
            [self.dataArray addObject:draftModel];
        }
#pragma mark ------------------------------- 数据库读取
        
        QNWSLog(@"self.dataArray == %@",self.dataArray);
        [self.draftBoxTableView reloadData];
    }

    
}


#pragma mark --------  UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WX_DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WX_DraftBoxTableViewCell"];
    WX_DBBoxModel *model = self.dataArray[indexPath.row];
    [cell cellWithModel:model];
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"caogaoxiang_btn_fabu_n"] forState:UIControlStateNormal];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"caogaoxiang_btn_fabu_h"] forState:UIControlStateHighlighted];
    uploadBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    uploadBtn.tag = indexPath.row;
    [uploadBtn addTarget:self action:@selector(clickTheUpLoadBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:uploadBtn];
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.right.equalTo(cell.contentView.mas_right).offset(-12);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(55);
    }];
    UIView *btnView = [[UIView alloc]init];
    btnView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapToSee = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSee:)];
    [btnView addGestureRecognizer:tapToSee];
    btnView.tag = 100+indexPath.row;
    [cell.contentView addSubview:btnView];
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(uploadBtn);
        make.width.mas_equalTo(@65);
        make.height.equalTo(cell.contentView);
    }];
    
    UIView *tapToSeeView = [[UIView alloc]init];
    tapToSeeView.tag = 200+indexPath.row;
    UITapGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playTheVideo:)];
    tapToSeeView.userInteractionEnabled = YES;
    [tapToSeeView addGestureRecognizer:tapPlay];
    [cell.contentView addSubview:tapToSeeView];
    
    [tapToSeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(cell.contentView);
        make.right.equalTo(btnView.mas_left);
        make.height.equalTo(cell.contentView);
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tapToSee:(UITapGestureRecognizer *)tap
{
    UIButton *button = [self.view viewWithTag:tap.view.tag-100];
    [self clickTheUpLoadBtn:button];
}

-(void)clickTheUpLoadBtn:(UIButton *)button
{
    QNWSLog(@"button.tag == %ld",button.tag);

    WX_DBBoxModel *model = self.dataArray[button.tag];
    WX_UploadVideoViewController *uploadVC = [[WX_UploadVideoViewController alloc]init];
    [uploadVC setFromDraftBoxModel:model];
    [self.navigationController pushViewController:uploadVC animated:YES];
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WX_DBBoxModel *model = self.dataArray[indexPath.row];
       
        self.manager = [WX_FMDBManager sharedWX_FMDBManager];
        if (![self.manager.dataBase executeUpdate:@"delete from DraftBox1 where mediaTitle = ?",model.mediaTitle])
        {
            QNWSLog(@"数据库删除失败");
        }
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.draftBoxTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self loadDataFromDataBase];
    }
    
   
}


#pragma mark ----------- 点击播放
/// 点击播放
-(void)playTheVideo:(UITapGestureRecognizer *)tap{
    
    WX_DBBoxModel *model = self.dataArray[tap.view.tag-200];
    // 沙盒
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
#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"img_kbzt_smdmy"];
    return image;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -50;
}

@end
