//
//  WX_MusicEditingViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "WX_MusicEditingViewController.h"
#import "WX_MusicEditingCell.h"
#import "WX_MoreMusicCell.h"
#import "WX_FMDBManager.h"
#import "MJRefresh.h"
#import "WX_ProgressHUD.h"
#import "BYC_HttpServers+WX_MusicEditedVC.h"

@interface WX_MusicEditingViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>
@property(nonatomic, retain) UIScrollView               *customScrollView;
@property(nonatomic, retain) UIImageView                *underlinedImgView;
@property(nonatomic, retain) UIView                     *backView;
@property(nonatomic, retain) UIBarButtonItem            *rightItem;
@property(nonatomic, retain) UIButton                   *rightButton;

@property(nonatomic, retain) NSMutableArray             *alreadyMusicArray;     // 已下载
@property(nonatomic, retain) NSMutableArray             *moreMusicArray;        // 更多音乐
@property(nonatomic, retain) UITableView                *leftTableView;
@property(nonatomic, retain) UITableView                *rightTableView;
@property(nonatomic, assign) CGFloat                    lastMove;

@property(nonatomic, retain) WX_MusicModel              *musicModel;

@property (nonatomic,strong) AVAudioPlayer              *audioPlayer;
@property(nonatomic, retain) NSIndexPath                *lastIndexPath;
@property(nonatomic, retain) NSMutableArray             *indexPathArray;

@property(nonatomic, retain) WX_FMDBManager              *manager;

@property(nonatomic, assign) int                        page;//第几页数据
@property(nonatomic, assign) BOOL                       isMore;

@property(nonatomic, strong) UIView                     *coverView;     /**<   遮盖页面 */

@end

@implementation WX_MusicEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.moreMusicArray     =   [[NSMutableArray alloc]init];
    self.alreadyMusicArray  =   [[NSMutableArray alloc]init];
    self.indexPathArray     =   [[NSMutableArray alloc]init];
    
    [self createFMDB];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(showCoverView:) name:@"showCoverView" object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    self.audioPlayer = nil;
    self.customScrollView.delegate = nil;
    
    [WX_ProgressHUD dismiss];
}

-(void)showCoverView:(NSNotification *)notification
{
    if (!self.coverView) {
        self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.coverView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.coverView];
    }
    [self.view bringSubviewToFront:self.coverView];
    
    if ([notification.object isEqualToString:@"isDown"]) {
        
        self.coverView.hidden = NO;
    }else if([notification.object isEqualToString:@"fail"] || [notification.object isEqualToString:@"success"]){
        self.coverView.hidden = YES;
    }
}
-(void)createFMDB
{
    
    [self.alreadyMusicArray removeAllObjects];
    
    self.manager = [WX_FMDBManager sharedWX_FMDBManager];
    FMResultSet *dataResult = [self.manager.dataBase executeQuery:@"select * from Music"];
    if (dataResult == nil) {
        if (![self.manager.dataBase executeUpdate:@"create table if not exists Music(id integer primary key autoincrement,musicID text,musicName text,musicUrl text,pictureJPG text,musicType text,timeStamp text,musicPath text)"]) {
            QNWSLog(@"数据库---Music表创建失败");
        }
    }
    while ([dataResult next]) {
        WX_MusicModel *model = [[WX_MusicModel alloc]init];
        model.musicName = [dataResult stringForColumn:@"musicID"];
        model.musicName = [dataResult stringForColumn:@"musicName"];
        model.musicUrl = [dataResult stringForColumn:@"musicUrl"];
        model.pictureJPG = [dataResult stringForColumn:@"pictureJPG"];
        model.musicType = [dataResult stringForColumn:@"musicType"];
        model.timeStamp = [dataResult stringForColumn:@"timeStamp"];
        model.musicPath = [dataResult stringForColumn:@"musicPath"];
        
        [self.alreadyMusicArray addObject:model];
    }
    [self.leftTableView reloadData];
}

-(void)dismiss
{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI
{

    self.title = @"添加音乐";
    
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [self.rightButton addTarget:self action:@selector(clickTheRigthButton) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.hidden = YES;
    self.rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem= self.rightItem;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
     backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    

    
    self.backView  = [[UIView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight*0.075)];
    self.backView.backgroundColor = KUIColorFromRGBA(0x000000, 0.5);
    [self.view addSubview:self.backView];
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2, screenHeight*0.075)];
    leftLabel.text = @"已下载";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.tag = 100;
    leftLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTheLabel:)];
    [leftLabel addGestureRecognizer:leftTap];
    [self.backView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, screenHeight*0.075)];
    rightLabel.text = @"更多音乐";
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.tag = 101;
    rightLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTheLabel:)];
    [rightLabel addGestureRecognizer:rightTap];
    [self.backView addSubview:rightLabel];

    self.underlinedImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.backView.frame.size.height-screenHeight*0.0038, screenWidth/2, screenHeight*0.0038)];
    self.underlinedImgView.backgroundColor = KUIColorFromRGB(0x4BC8BD);
    [self.backView addSubview:self.underlinedImgView];

    
    self.customScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.backView.frame.size.height+self.backView.frame.origin.y, screenWidth, screenHeight - self.backView.frame.size.height-self.backView.frame.origin.y)];
    self.customScrollView.contentSize = CGSizeMake(2*screenWidth, 0);
    self.customScrollView.pagingEnabled = YES;
    self.customScrollView.showsHorizontalScrollIndicator = NO;
    self.customScrollView.delegate = self;
    self.customScrollView.bounces = NO;
    self.customScrollView.backgroundColor = [UIColor clearColor];
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.customScrollView.frame.size.width, self.customScrollView.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    [self.customScrollView addSubview:leftView];
    
     self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.customScrollView.frame.size.width, self.customScrollView.frame.size.height) style:UITableViewStylePlain];
    [self.leftTableView registerNib:[UINib nibWithNibName:@"WX_MusicEditingCell" bundle:nil] forCellReuseIdentifier:@"WX_MusicEditingCell"];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.backgroundColor = [UIColor clearColor];
    self.leftTableView.tag = 100;
    [self.leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [leftView addSubview:self.leftTableView];
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(self.customScrollView.frame.size.width, 0, self.customScrollView.frame.size.width, self.customScrollView.frame.size.height)];
    rightView.backgroundColor = [UIColor clearColor];
    [self.customScrollView addSubview:rightView];
    
    self.rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.customScrollView.frame.size.width, self.customScrollView.frame.size.height) style:UITableViewStylePlain];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.backgroundColor = [UIColor clearColor];
    self.rightTableView.tag = 200;
    [self.rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"WX_MoreMusicCell" bundle:nil] forCellReuseIdentifier:@"WX_MoreMusicCell"];
    [rightView addSubview:self.rightTableView];
    
    
    [self.view addSubview:self.customScrollView];
    
    __weak __typeof(self) weakSelf = self;
    
    [self loadDataWithPage:1];
    
    // 下拉刷新
    self.rightTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadDataWithPage:1];
    }];
    // 上拉更新
    self.rightTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page++;
        [weakSelf loadDataWithPage:weakSelf.page];
    }];
}

- (void)loadDataWithPage:(int)page {
    
    NSDictionary *parameters = @{@"page":[NSNumber numberWithInt:_page],@"rows":@"20"};
    //网络请求    
    [BYC_HttpServers WX_RequestScriptVC_GetMusicWithParameters:parameters success:^(AFHTTPRequestOperation *operation, NSMutableArray *array_Model) {
        if (array_Model.count > 0) {
            if (self.rightTableView.footer.isRefreshing) {
                
                // 结束刷新
                [self.moreMusicArray removeAllObjects];
                [self.moreMusicArray addObjectsFromArray:array_Model];
                [self.rightTableView.footer endRefreshing];
                
            }else {
                
                if (self.rightTableView.header.isRefreshing) {
                    [self.moreMusicArray addObjectsFromArray:array_Model];
                    NSMutableArray *mmArray = [self.moreMusicArray mutableCopy];
                    [self.moreMusicArray removeAllObjects];
                    for (int i = 0; i < array_Model.count; i ++) {
                        WX_MusicModel *model1 = array_Model[i];
                        
                        for (int j = i+1; j < mmArray.count; j ++) {
                            WX_MusicModel *model2 = mmArray[j];
                            
                            if([model1.musicID isEqualToString:model2.musicID]){
                                [mmArray removeObjectAtIndex:j];
                                j= j-1;
                            }
                        }
                    }
                    
                    [self.moreMusicArray addObjectsFromArray:mmArray];
                    
                    // 结束刷新
                    [self.rightTableView.header endRefreshing];
                }else {
                    
                    self.moreMusicArray = array_Model;
                    
                }
                
                
            }
            [self.rightTableView reloadData];

        }else {
            
            QNWSLog(@"加载完毕！！！");
            if (self.rightTableView.header.isRefreshing) {
                [self.rightTableView.header endRefreshing];
            }
            
            if (self.rightTableView.footer.isRefreshing) {
                [self.rightTableView.footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (self.rightTableView.footer.isRefreshing) {
            
            // 变为没有更多数据的状态
            if (self.isMore) {
                
                [self.rightTableView.footer endRefreshingWithNoMoreData];
            }else {
                
                [self.rightTableView.footer endRefreshing];
            }
        }
        if (self.rightTableView.header.isRefreshing) {
            [self.rightTableView.header endRefreshing];
        }
        
    }];
    
    [self setButtonSelected];

}


-(void)clickTheLabel:(UITapGestureRecognizer *)tap
{
    UILabel *selectLabel = [self.view viewWithTag:tap.view.tag];
    selectLabel.textColor = KUIColorFromRGB(0x3c4f5e);
    
    self.underlinedImgView.frame = CGRectMake(tap.view.frame.origin.x, self.backView.frame.size.height-screenHeight*0.0038, tap.view.frame.size.width, screenHeight*0.0038);
    self.customScrollView.contentOffset = CGPointMake((tap.view.tag-100)*self.customScrollView.frame.size.width, 0);
    
    UILabel *otherLabel = [self.view viewWithTag:201-tap.view.tag];
    otherLabel.textColor = KUIColorFromRGB(0x3c4f5e);
    QNWSLog(@"tap.view.tag == %zi",tap.view.tag);
    if (tap.view.tag == 101) {
         self.navigationItem.rightBarButtonItem = nil;
    }else{
        [self createFMDB];
        if ((!self.navigationItem.rightBarButtonItem)) {
              self.navigationItem.rightBarButtonItem = self.rightItem;
        }
      

    }
}

-(void)setButtonSelected
{
    for (int i = 0; i < self.alreadyMusicArray.count; i++) {
        WX_MusicModel *almodel = self.alreadyMusicArray[i];
        for (int j = 0; j < self.moreMusicArray.count; j++) {
            WX_MusicModel *model = self.moreMusicArray[j];
            if ([almodel.musicName isEqualToString: model.musicName]) {
                WX_MoreMusicCell *cell = [[WX_MoreMusicCell alloc]init];
                cell.downButton.selected = YES;
                cell.userInteractionEnabled = NO;
            }
        }
    }
}

#pragma mark ------- UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.x) {
        CGFloat move = scrollView.contentOffset.x/self.customScrollView.frame.size.width*self.underlinedImgView.frame.size.width;
        self.underlinedImgView.frame = CGRectMake(move, self.backView.frame.size.height-screenHeight*0.0038, screenWidth/2, screenHeight*0.0038);
        if (self.lastMove > move) {
            [self createFMDB];
        }
        
        if (move < screenWidth/4) {
            UILabel *selectLabel = [self.view viewWithTag:100];
            selectLabel.textColor = KUIColorFromRGB(0x4BC8BD);
            
            UILabel *otherLabel = [self.view viewWithTag:101];
            otherLabel.textColor = [UIColor whiteColor];
            if ((!self.navigationItem.rightBarButtonItem)) {
                self.navigationItem.rightBarButtonItem = self.rightItem;
            }
        }else if(move > screenWidth/4){
            UILabel *selectLabel = [self.view viewWithTag:101];
            selectLabel.textColor = KUIColorFromRGB(0x4BC8BD);
            
            UILabel *otherLabel = [self.view viewWithTag:100];
            otherLabel.textColor = [UIColor whiteColor];
            
            self.navigationItem.rightBarButtonItem = nil;
        }

        self.lastMove = move;
    }

}

#pragma mark ------------ UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        return self.alreadyMusicArray.count;
    }
    if (tableView.tag == 200) {
      return  self.moreMusicArray.count;
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (tableView.tag == 100) {
        static NSString *identifier = @"WX_MusicEditingCell";
        
        WX_MusicEditingCell *musicCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (musicCell == nil) {
            musicCell = [[WX_MusicEditingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        musicCell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-musicCellbackground-h"]];
        musicCell.textLabel.highlightedTextColor = KUIColorFromRGB(0x4BC8BD);
        WX_MusicModel *model = self.alreadyMusicArray[indexPath.row];
        musicCell.titleLabel.text = model.musicName;
        musicCell.classLabel.text = model.musicType;
        
        cell.tag = 400 + indexPath.row;
        
        return musicCell;
    }
    
    if (tableView.tag == 200) {
        
        static NSString *MoreMusicIdentifier = @"WX_MoreMusicCell";
        WX_MoreMusicCell *moreCell = [tableView dequeueReusableCellWithIdentifier:MoreMusicIdentifier];
        if (moreCell == nil) {
            moreCell = [[WX_MoreMusicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreMusicIdentifier];
        }
        
        moreCell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-musicCellbackground-h"]];
        moreCell.textLabel.highlightedTextColor = KUIColorFromRGB(0x4BC8BD);
        WX_MusicModel *model = self.moreMusicArray[indexPath.row];
        
        
        
        for (int i = 0; i < self.alreadyMusicArray.count; i++) {
            WX_MusicModel *alModel = self.alreadyMusicArray[i];
            BOOL isSame = NO;
            WX_MusicModel *model = self.moreMusicArray[indexPath.row];
            if ([alModel.musicName isEqualToString:model.musicName]) {
                isSame = YES;
                if (isSame) {
                    moreCell.downButton.selected = YES;
                    moreCell.downButton.userInteractionEnabled = NO;
                    break;
                }
            }

            if (!isSame){
                moreCell.downButton.selected = NO;
                moreCell.downButton.userInteractionEnabled = YES;
            }
        }

        moreCell.titleLabel.text = model.musicName;
        moreCell.model = model;
        moreCell.downButton.tag = 300+indexPath.row;

        moreCell.block = ^(BOOL isDown){
            if (isDown) {
                [self createFMDB];
                [self.rightTableView reloadData];
            }
        };
        return moreCell;

        
    }
    return cell;

}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        WX_MusicEditingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = YES;
        cell.titleLabel.textColor = KUIColorFromRGB(0x4BC8BD);
        cell.classLabel.textColor = KUIColorFromRGB(0x4BC8BD);
        cell.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-h."];
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-musicCellbackground-h"]];

        if (cell.isSelected) {
            WX_MusicModel *model = self.alreadyMusicArray[indexPath.row];
            
            if ([self.audioPlayer isPlaying]) {
                self.audioPlayer = nil;
            }
            [self audioPlayerWithModel:model];
            [self.audioPlayer play];
            
            self.musicModel = model;
            [self.indexPathArray addObject:indexPath];
            QNWSLog(@"_indexPathArray == %@",_indexPathArray);
            self.rightButton.hidden = NO;
        }
        /// indexPathArray 内只能有一个元素,保存的是选中音乐的下标,不可能会有多个
        /// 防止多选
        if (_indexPathArray.count>1) {
            for (int i = 0; i < _indexPathArray.count; i++) {
                if (i < _indexPathArray.count -1) {
                    NSIndexPath *indexPath_Cancel = _indexPathArray[i];
                    WX_MusicEditingCell *cell_Cancel = [tableView cellForRowAtIndexPath:indexPath_Cancel];
                    cell_Cancel.isSelected = NO;
                    cell_Cancel.titleLabel.textColor = KUIColorFromRGB(0x3c4f5e);
                    cell_Cancel.classLabel.textColor = KUIColorFromRGB(0x3c4f5e);
                    cell_Cancel.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-n."];
                    cell_Cancel.selectedBackgroundView = [[UIImageView alloc]initWithImage:nil];
                    QNWSLog(@"cell_Cancel.titleLabel.text == %@",cell_Cancel.titleLabel.text);
                    [_indexPathArray removeObject:indexPath_Cancel];
                }
            }
        }
        QNWSLog(@"_indexPathArray == %@",_indexPathArray);

    }
    if (tableView.tag == 101) {
        WX_MoreMusicCell *moreCell = [tableView cellForRowAtIndexPath:indexPath];
        moreCell.downButton.userInteractionEnabled = NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        
        WX_MusicEditingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.titleLabel.textColor = KUIColorFromRGB(0x3c4f5e);
        cell.classLabel.textColor = KUIColorFromRGB(0x3c4f5e);
        cell.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-n."];
        cell.isSelected = NO;
        if (!cell.isSelected) {
            //                [self.audioPlayer stop];
            //                self.audioPlayer = nil;
            
        }

//        if ((self.indexPathArray.count -2)) {
//            WX_MusicEditingCell *cell = [tableView cellForRowAtIndexPath:self.indexPathArray[self.indexPathArray.count-2]];
//            cell.titleLabel.textColor = KUIColorFromRGB(0x3c4f5e);
//            cell.classLabel.textColor = KUIColorFromRGB(0x3c4f5e);
//            cell.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-n."];
//            cell.isSelected = NO;
//            if (!cell.isSelected) {
////                [self.audioPlayer stop];
////                self.audioPlayer = nil;
//                
//            }
//        }else if (self.indexPathArray.count -1){
//            WX_MusicEditingCell *cell = [tableView cellForRowAtIndexPath:[self.indexPathArray firstObject]];
//            cell.titleLabel.textColor = KUIColorFromRGB(0x3c4f5e);
//            cell.classLabel.textColor = KUIColorFromRGB(0x3c4f5e);
//            cell.selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-n."];
//            cell.isSelected = NO;
//            if (!cell.isSelected) {
////                [self.audioPlayer stop];
////                self.audioPlayer = nil;
//                
//            }
//        }
       
    }
    
    
}


-(void)clickTheRigthButton
{
    if (self.block) {
        self.block(self.musicModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
-(AVAudioPlayer *)audioPlayerWithModel:(WX_MusicModel *)model
{
    if (!_audioPlayer) {
        
        NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *filePath = [docDir stringByAppendingPathComponent:@"Music"];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp3",model.musicName]];
        NSError *error=nil;
        //初始化播放器
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            QNWSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

#pragma matk ----------------- AVAudioPlayerDelegate
#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    QNWSLog(@"音乐播放完成...");
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
