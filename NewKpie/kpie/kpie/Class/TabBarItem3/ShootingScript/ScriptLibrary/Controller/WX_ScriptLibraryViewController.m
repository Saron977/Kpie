//
//  WX_ScriptLibraryViewController.m
//  kpie
//
//  Created by 王傲擎 on 16/3/31.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ScriptLibraryViewController.h"
#import "WX_ShootingScriptViewController.h"
#import "WX_ScriptManagerViewController.h"
#import "WX_ScriptLibraryTableViewCell.h"
#import "WX_ScriptLibraryHeadView.h"
#import "WX_ProgressHUD.h"
#import "WX_ChannelModel.h"
#import "WX_FMDBManager.h"
#import "BYC_HttpServers+WX_ShootingScriptVC.h"

#define KScriptTableViewHeight  45
@interface WX_ScriptLibraryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView                   *scriptTabelView;           /**<   剧本库tableView */
@property (nonatomic, strong) NSMutableArray                *scriptArray;               /**<   剧本库数据 */
@property (nonatomic, strong) NSMutableArray                *channelArray;              /**<   频道数组 */
@property (nonatomic, strong) WX_ScriptLibraryHeadView      *tapHeadView;               /**<   点击的组头 */
@property (nonatomic, assign) NSInteger                     tapSectionNum;              /**<   点击第几段 */
@property (nonatomic, assign) BOOL                          isTapHeadView;              /**<   点击组头 */
@property (nonatomic, strong) WX_FMDBManager                *manager;                   /**<   FMDB调用 */
@property (nonatomic, strong) NSMutableArray                *locationScriptArray;       /**<   本地剧本数组 */
@property (nonatomic, strong) UIView                        *coverView;                 /**<   点击下载后展示遮盖图层 */
@property (nonatomic, strong) NSMutableArray                *sectionArray;              /**<   组头标题数组 */

@property (nonatomic, strong) UIView                        *backView;                  /**<   镜头加载时,覆盖,加载完成隐藏 */
@property (nonatomic, strong) UIView                        *library_BackView;          /**<   剧本库界面背景色 */



@end

@implementation WX_ScriptLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.q
    
    
    [self createTableView];
    
//    [self receiveScriptFromNetWithdic:nil WithReloadData:NO];
    
    [self receiveChannelFromNet];
    
//    [self readInfoFromFMDB];
    
    [self createNavigation];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorFromRGB(0x000000)];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(alreadyDownloadScript) name:@"alreadyDownloadScript" object:nil];
    
    [QNWSNotificationCenter addObserver:self selector:@selector(touchMoreButton:) name:@"touchMoreButton" object:nil];
        
    [self alreadyDownloadScript];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorBaseGreenNormal];

    [QNWSNotificationCenter removeObserver:self name:@"alreadyDownloadScript" object:nil];
    
    [QNWSNotificationCenter removeObserver:self name:@"touchMoreButton" object:nil];
    
    [WX_ProgressHUD dismiss];
}

/// 防止多次点击 下载出错
-(void)touchMoreButton:(NSNotification*)notification
{
    
    [self setTheBackViewHidden:[notification.object boolValue]];
    
    QNWSLog(@"展示遮罩 %zi",[notification.object boolValue]);
}


#pragma mark ------ 获取频道接口
-(void)receiveChannelFromNet
{
    if (!self.channelArray) {
        self.channelArray = [[NSMutableArray alloc]init];
    }
    
    if (!self.scriptArray) {
        self.scriptArray = [[NSMutableArray alloc]init];
    }
    
    if (!self.sectionArray) {
        self.sectionArray = [[NSMutableArray alloc]init];
    }
    
    [WX_ProgressHUD show:@"加载中"];
    
    [self setTheBackViewHidden:NO];
    
    
    [BYC_HttpServers Get:[NSString stringWithFormat:@"%@/null",KQNWS_GetChannelListVideoScript] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *data_Dic = responseObject[@"data"];
        // 获取剧本分组
        NSArray *array_ScriptChannel = data_Dic[@"ScriptChannelData"];
        
        NSInteger total = array_ScriptChannel.count;
        
        dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);


        for (int i = 0; i < total; i++) {
            NSDictionary *dic_ScriptChannel = array_ScriptChannel[i];
            WX_ChannelModel *channelModel = [WX_ChannelModel initModelWithDic:dic_ScriptChannel];
            [self.channelArray addObject:channelModel];
            QNWSLog(@"channelModel.channelName == %@",channelModel.channelName);
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

            
            if (!i) {
                // 最近剧本
                NSArray *array_NearlyScript = data_Dic[@"ScriptData"];
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for (NSMutableDictionary *dic in array_NearlyScript) {
                    WX_ScriptModel *model_Script = [WX_ScriptModel initModelWithDic:dic];
                    [array addObject:model_Script];
                }
                [self.scriptArray addObject:array];
                [self.sectionArray addObject:channelModel];
                QNWSLog(@"只执行一次");
                QNWSLog(@"channelModel.channelName == %@",channelModel.channelName);
                
            }
        
            
            dispatch_async(serialQueue, ^{
                
                if (i == total-1) {
                    WX_ChannelModel *model_Channel_Dic = self.channelArray[i];
                    [dic setValue:model_Channel_Dic.channelID forKey:@"channelId"];
                    [self receiveScriptFromNetWithdic:dic WithReloadData:YES];
                }else{
                    WX_ChannelModel *model_Channel_Dic = self.channelArray[i];
                    [dic setValue:model_Channel_Dic.channelID forKey:@"channelId"];
                    [self receiveScriptFromNetWithdic:dic WithReloadData:NO];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSLog(@"剧本频道名接口请求失败");
        [WX_ProgressHUD show:@"加载失败"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];

    }];
//
}

#pragma mark ----- 获取剧本接口
-(void)receiveScriptFromNetWithdic:(NSMutableDictionary *)dic WithReloadData:(BOOL)isReloadData
{

    [WX_ProgressHUD show:@"加载中"];
    
    [self setTheBackViewHidden:NO];

    [BYC_HttpServers Get:[NSString stringWithFormat:@"%@/%@",KQNWS_GetChannelListVideoScript,dic[@"channelId"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSDictionary *dic_Data = responseObject[@"data"];
        NSArray *array_ScriptData = dic_Data[@"ScriptData"];
        if (array_ScriptData.count>0) {
            
            for (NSMutableDictionary *dic in array_ScriptData) {
                
                WX_ScriptModel *scriptModel = [WX_ScriptModel initModelWithDic:dic];
                [array addObject:scriptModel];
            }

            [self.scriptArray addObject:array];
            
            if (!dic) {
                WX_ChannelModel *channelModel = [[WX_ChannelModel alloc]init];
                channelModel.channelName = @"最近更新";
                //            channelModel.CTNum = [NSString stringWithFormat:@"%zi",total];
                
                [self.sectionArray insertObject:channelModel atIndex:0];
                
                [self.channelArray insertObject:channelModel atIndex:0];
            }else{
                
                for (WX_ChannelModel *model in self.channelArray) {
                    if ([model.channelID isEqualToString:dic[@"channelId"]]) {
                        QNWSLog(@"获取组头名 %@",model.channelName);
                        [self.sectionArray addObject:model];
                    }
                }
            }
            
            /// 优化视频排序
            
            if (self.scriptArray.count >0) {
                
                if (self.channelArray.count == self.sectionArray.count) {
                    
                    for (int i = 0; i < self.channelArray.count ; i++) {
                        WX_ChannelModel *sorceModel = self.channelArray[i];
                        
                        for (int j = 0; j < self.sectionArray.count; j++) {
                            WX_ChannelModel *channelModel = self.sectionArray[j];
                            if ([sorceModel.channelName isEqualToString:channelModel.channelName]) {
                                
                                [self.sectionArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                                
                                //                            [self.scriptArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                            }
                        }
                    }
                    
                    for (int i = 0; i < self.channelArray.count; i++) {
                        
                        WX_ChannelModel *channelModel = self.channelArray[i];
                        NSArray *array = self.scriptArray[i];
                        if ([channelModel.CTNum integerValue] != array.count) {
                            
                            for (int j = 0; j < self.scriptArray.count; j++) {
                                NSArray *scriptArray = self.scriptArray[j];
                                
                                if ([channelModel.CTNum integerValue] == scriptArray.count) {
                                    [self.scriptArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                                    break;
                                }
                            }
                        }
                        
                    }
                    
                    for (int i = 0; i < self.channelArray.count; i++) {
                        WX_ChannelModel *channelModel = self.channelArray[i];
                        NSArray *array = self.scriptArray[i];
                        QNWSLog(@"channelModel.CTNum == %@",channelModel.CTNum);
                        QNWSLog(@"array.count = %zi",array.count);
                    }
                    
                    
                    
                }
                
                for (int i = 0; i < self.sectionArray.count; i++) {
                    WX_ChannelModel *model = self.sectionArray[i];
                    if ([model.channelName isEqualToString:@"其他"]) {
                        
                        [self.sectionArray exchangeObjectAtIndex:i withObjectAtIndex:self.sectionArray.count-1];
                        
                        [self.scriptArray exchangeObjectAtIndex:i withObjectAtIndex:self.sectionArray.count-1];
                    }
                }
                
                
            }
        }
        
        if (isReloadData) {
            
            QNWSLog(@"排序后");
            for (WX_ChannelModel *model in self.sectionArray) {
                QNWSLog(@"model.channelName == %@",model.channelName);
                
                [WX_ProgressHUD dismiss];
                [self setTheBackViewHidden:YES];
            }
            
            self.scriptTabelView.hidden = NO;
            
            
            [self.scriptTabelView reloadData];
            
            [WX_ProgressHUD dismiss];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSLog(@"剧本频道名接口请求失败");
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];

    }];

}

-(void)setTheBackViewHidden:(BOOL)hidden
{
    if (!self.backView) {
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.backView.backgroundColor = [UIColor clearColor];
        [_library_BackView addSubview:self.backView];
    }
    self.backView.hidden = hidden;
    
}

#pragma mark ------ 从数据库中读取
-(void)readInfoFromFMDB
{
    if (!self.locationScriptArray) {
        self.locationScriptArray = [[NSMutableArray alloc]init];
    }
    [self.locationScriptArray removeAllObjects];
    /// 写入数据库
    _manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    FMResultSet *dataResult = [_manager.dataBase executeQuery:@"select * from Script3"];
    if (dataResult == nil) {
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
        /// 本地视频
        
        while ([dataResult next]) {
            
            WX_ScriptModel *scriptModel = [[WX_ScriptModel alloc]init];
            scriptModel.videoLenArray = [[NSMutableArray alloc]init];
            scriptModel.jpgurl = [dataResult stringForColumn:@"jpgurl"];
            scriptModel.scriptcontent = [dataResult stringForColumn:@"content"];
            scriptModel.scriptID = [dataResult stringForColumn:@"scriptID"];
            scriptModel.scriptname = [dataResult stringForColumn:@"titleName"];
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
        
        /// 整合本地视频
        
//        for (int i = 0; i < self.locationScriptArray.count; i++) {
//            WX_ScriptModel *scriptModel = self.locationScriptArray[i];
//            
//            for (int j = 0; j < scriptModel.videoLenArray.count; j++) {
//                WX_ScriptInfoModel *infoModel = scriptModel.videoLenArray[j];
//                
//                for (int k = i+1; k < self.locationScriptArray.count; k++) {
//                    WX_ScriptModel *newScriptModel = self.locationScriptArray[k];
//                    
//                    for (WX_ScriptInfoModel *newInfoModel in newScriptModel.videoLenArray) {
//                        /// 名字一样 跳出
//                        if ([infoModel.videoLen_ShootName isEqualToString:newInfoModel.videoLen_ShootName]) {
//                            break;
//                        }else if ([[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length-1] isEqualToString:[newInfoModel.videoLen_ShootName substringToIndex:newInfoModel.videoLen_ShootName.length -1]]){
//                            /// 否侧添加到原数组
//                            [scriptModel.videoLenArray addObject:newInfoModel];
//                            [self.locationScriptArray removeObject:newScriptModel];
//                        }
//                    }
//                }
//            }
//        }
    }
    

}

-(void)alreadyDownloadScript
{
    [self readInfoFromFMDB];
    
    [self.scriptTabelView reloadData];
    
    self.coverView.hidden = YES;
}
#pragma mark ------ 创建Navigation
-(void)createNavigation
{
    self.navigationItem.title = @"剧本库";
    
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
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"剧本管理" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, -20);
    [rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickTheRigthButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
//    self.view.backgroundColor = KUIColorFromRGB(0x1D232B);

//    self.view.backgroundColor = [UIColor blueColor];
    
    
}

#pragma mark ------ 创建TablView
-(void)createTableView
{
    if (!_library_BackView) {
        _library_BackView = [[UIView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight)];
        _library_BackView.backgroundColor = KUIColorFromRGB(0xf0f0f0);
        [self.view addSubview:_library_BackView];
    }
    self.scriptTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.scriptTabelView.dataSource = self;
    self.scriptTabelView.delegate = self;
    self.scriptTabelView.backgroundColor = [UIColor clearColor];
    [_library_BackView addSubview:self.scriptTabelView];
    self.scriptTabelView.hidden = YES;
    [self.scriptTabelView registerNib:[UINib nibWithNibName:@"WX_ScriptLibraryTableViewCell" bundle:nil] forCellReuseIdentifier:@"WX_ScriptLibraryTableViewCell"];
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.scriptArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = self.scriptArray[section];
    
    WX_ChannelModel *channelModel = self.sectionArray[section];
    
    if (channelModel.isPull) {
        return 0;
    }
    
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedID = @"WX_ScriptLibraryTableViewCell";
    
    WX_ScriptLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    
    if (cell == nil){
        
        cell = [[WX_ScriptLibraryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    }
    NSArray *array = self.scriptArray[indexPath.section];
    
    if (array.count > indexPath.row) {
        
        WX_ScriptModel *scriptModel = array[indexPath.row];
        
        [cell.scriptTitleImgView sd_setImageWithURL:[NSURL URLWithString:scriptModel.jpgurl]];
        cell.scriptTitleLabel.text = scriptModel.scriptname;
        cell.scriptDescribeLabel.text = scriptModel.scriptcontent;
        cell.scriptModel = scriptModel;
        cell.pushImgView.tag = indexPath.section*100 +indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPush:)];
        [cell.pushImgView addGestureRecognizer:tap];
        cell.pushImgView.hidden = YES;
        
        if (self.locationScriptArray.count > 0) {
            
            for (WX_ScriptModel *model in self.locationScriptArray) {
                if ([scriptModel.scriptname isEqualToString:model.scriptname]) {
                    cell.downloadBtn.selected = YES;
                    cell.pushImgView.hidden = NO;
                    break;
                }else{
                    cell.downloadBtn.selected = NO;
                    cell.pushImgView.hidden = YES;
                }
            }
        }else{
            cell.pushImgView.hidden = YES;
            cell.downloadBtn.selected = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KScriptTableViewHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WX_ScriptLibraryHeadView *headView = [[WX_ScriptLibraryHeadView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 45)];
    
    WX_ChannelModel *channelModel = self.sectionArray[section];
    
    headView.titleLabel.text = [NSString stringWithFormat:@"%@",channelModel.channelName];
    headView.scriptNumLabel.text = [NSString stringWithFormat:@"%@",channelModel.CTNum];
    headView.backgroundColor = KUIColorFromRGB(0xfcfcfc);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPullDown:)];
    [headView addGestureRecognizer:tap];
    
    headView.tag = 100 +section;
    if (channelModel.isPull) {
        headView.pullImgView.image = [UIImage imageNamed:@"btn_xiangxia_n"];
    }else{
        headView.pullImgView.image = [UIImage imageNamed:@"btn_xiangshang_n"];

    }
    return headView;
}

//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //设置Cell的动画效果为3D效果
//    //设置x和y的初始值为0.1；
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    //x和y的最终值为1
//    [UIView animateWithDuration:0.35 animations:^{
//        //        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//        cell.layer.transform = CATransform3DIdentity;
//    }];
}

#pragma mark ------ 点击组头收起/ 放下
-(void)tapPullDown:(UITapGestureRecognizer *)tap
{
    WX_ChannelModel *channelModel = self.sectionArray[tap.view.tag -100];
    channelModel.isPull = !channelModel.isPull;
    
    self.tapSectionNum = 0;
    NSUInteger sectionNum = self.sectionArray.count;
    for (int i = 0; i < self.sectionArray.count; i++) {
        NSArray *array = self.scriptArray[i];
        WX_ChannelModel *model = self.sectionArray[i];
        if (model.isPull && array.count > 0) {
            self.tapSectionNum++;
        }
        if (array.count == 0) {
            sectionNum--;
        }
    }
    
    
    if (self.tapSectionNum == sectionNum ) {
        
        self.scriptTabelView.kheight = KScriptTableViewHeight*self.tapSectionNum ;
        
        self.scriptTabelView.scrollEnabled = NO;
    }else{
        self.scriptTabelView.kheight = screenHeight;
        
        self.scriptTabelView.scrollEnabled = YES;
    }
    
    [self.scriptTabelView reloadData];
    
}

// 点击手势,下载后再次点击跳转
-(void)clickPush:(UITapGestureRecognizer *)tap
{
    NSInteger section = tap.view.tag/100;
    NSArray *array = self.scriptArray[section];
    NSInteger row = tap.view.tag%100;
    WX_ScriptModel *model = array[row];

    WX_ScriptInfoModel *infoModel = model.videoLenArray[0];
    
    QNWSLog(@"点击了, %@",infoModel.videoLen_ShootName);
    if (self.libraryBlock) {
        self.libraryBlock(model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissTheHUD
{
    [WX_ProgressHUD dismiss];
}
-(void)clickTheRigthButton
{
    WX_ScriptManagerViewController *scriptManagerVC = [[WX_ScriptManagerViewController alloc]init];
    
    [self.navigationController pushViewController:scriptManagerVC animated:YES];
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
