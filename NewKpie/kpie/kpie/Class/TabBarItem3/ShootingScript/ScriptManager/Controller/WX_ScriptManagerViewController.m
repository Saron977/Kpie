//
//  WX_ScriptManagerViewController.m
//  kpie
//
//  Created by 王傲擎 on 16/4/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ScriptManagerViewController.h"
#import "WX_ScriptManagerTableViewCell.h"
#import "WX_ProgressHUD.h"
#import "WX_FMDBManager.h"
#import "WX_ScriptModel.h"

#define KManagerTableViewRowHeight  90
@interface WX_ScriptManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton                      *rightButton;                   /**<    全选按钮 */
@property (nonatomic, strong) UITableView                   *managerTableView;              /**<    剧本管理tableview */
@property (nonatomic, strong) NSMutableArray                *managerArray;                  /**<    剧本管理数组 */
@property (nonatomic, strong) WX_FMDBManager                *manager;                       /**<    FMDB调用 */
@property (nonatomic, strong) UIButton                      *deleteBtn;                     /**<    删除按钮 */
@property (nonatomic, strong) NSMutableArray                *deleteArray;                   /**<    删除数组 */
@property (nonatomic, strong) NSMutableArray                *btnArray;                      /**<    btn数组 */



@end

@implementation WX_ScriptManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavigation];
    
    [self createTableView];
    
    [self readInfoFromFMDB];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorFromRGB(0x000000)];

    
    if (self.deleteArray == nil) {
        self.deleteArray = [[NSMutableArray alloc]init];
    }
    
    if (self.btnArray == nil) {
        self.btnArray = [[NSMutableArray alloc]init];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:KUIColorBaseGreenNormal];

}

#pragma mark ------ 从数据库中读取
-(void)readInfoFromFMDB
{
    if (!self.managerArray) {
        self.managerArray = [[NSMutableArray alloc]init];
    }
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
        //  本地视频
        
        
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
            
            [self.managerArray addObject:scriptModel];
            
        }
        
        /// 整合本地视频
        
        for (int i = 0; i < self.managerArray.count; i++) {
            WX_ScriptModel *scriptModel = self.managerArray[i];
            
            for (int j = 0; j < scriptModel.videoLenArray.count; j++) {
                WX_ScriptInfoModel *infoModel = scriptModel.videoLenArray[j];
                
                for (int k = i+1; k < self.managerArray.count; k++) {
                    WX_ScriptModel *newScriptModel = self.managerArray[k];
                    
                    for (WX_ScriptInfoModel *newInfoModel in newScriptModel.videoLenArray) {
                        /// 名字一样 跳出
                        if ([infoModel.videoLen_ShootName isEqualToString:newInfoModel.videoLen_ShootName]) {
                            break;
                        }else if ([[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length-1] isEqualToString:[newInfoModel.videoLen_ShootName substringToIndex:newInfoModel.videoLen_ShootName.length -1]] || [[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length-1] isEqualToString:[newInfoModel.videoLen_ShootName substringToIndex:newInfoModel.videoLen_ShootName.length -2]] || [[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length-2] isEqualToString:[newInfoModel.videoLen_ShootName substringToIndex:newInfoModel.videoLen_ShootName.length -1]]){
                            /// 否侧添加到原数组
                            [scriptModel.videoLenArray addObject:newInfoModel];
                            [self.managerArray removeObject:newScriptModel];
                        }                    }
                }
            }
        }
        
        
        [self tableViewReloadData];
    }
}


#pragma mark ------ 创建Navigation
-(void)createNavigation
{
    self.navigationItem.title = @"剧本管理";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"btn_tongyong_guanbi_n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"btn_tongyong_guanbi_h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [self.rightButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"取消全选" forState:UIControlStateSelected];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [self.rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [self.rightButton addTarget:self action:@selector(clickTheRigthButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(0, screenHeight -KHeightTabBar, screenWidth, KHeightTabBar);
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_jbsc_n"] forState:UIControlStateNormal];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_jbsc_d"] forState:UIControlStateSelected];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_jbsc_h"] forState:UIControlStateHighlighted];
    [self.deleteBtn addTarget:self action:@selector(deleteScript:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteBtn];
}

#pragma mark ----- createTableView
-(void)createTableView
{
    self.managerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight)];
    self.managerTableView.backgroundColor = [UIColor clearColor];
    self.managerTableView.dataSource = self;
    self.managerTableView.delegate = self;
    [self.view addSubview:self.managerTableView];
    
    [self.managerTableView registerNib:[UINib nibWithNibName:@"WX_ScriptManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"WX_ScriptManagerTableViewCell"];
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.managerArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedID = @"WX_ScriptManagerTableViewCell";
    WX_ScriptManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WX_ScriptModel *model = self.managerArray[indexPath.row];
    [cell.titleimgView sd_setImageWithURL:[NSURL URLWithString:model.jpgurl]];
//    WX_ScriptInfoModel *infoModel = model.videoLenArray[0];
//    cell.titleLabel.text = [infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length -1];
    cell.titleLabel.text = model.scriptname;
    cell.contentLabel.text = model.scriptcontent;
    cell.tag = 100+ indexPath.row;

    cell.selectBtn.tag = 200+ indexPath.row;
    cell.selectBtn.selected = NO;
    [cell.selectBtn addTarget:self action:@selector(selectScript:) forControlEvents:UIControlEventTouchUpInside];
    if (self.btnArray.count > 0) {
        for (NSString *title_text in self.btnArray) {
            
            if ([title_text isEqualToString: cell.titleLabel.text]) {
                
                cell.selectBtn.selected = YES;
            }
        }
    }else{
        cell.selectBtn.selected = NO;

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KManagerTableViewRowHeight;
}

//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //设置Cell的动画效果为3D效果
//    //设置x和y的初始值为0.1；
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    //x和y的最终值为1
//    [UIView animateWithDuration:0.35 animations:^{
////        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//        cell.layer.transform = CATransform3DIdentity;
//    }];
}

-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ------ 选择剧本
-(void)selectScript:(UIButton *)btn
{
    btn.selected = !btn.selected;
    WX_ScriptManagerTableViewCell *cell = [self.view viewWithTag:btn.tag-100];

    if (btn.selected) {
        
        [self.deleteArray addObject:cell.titleLabel.text];
        [self.btnArray addObject:cell.titleLabel.text];
    }else{
        [self.deleteArray removeObject:cell.titleLabel.text];
        [self.btnArray removeObject:cell.titleLabel.text];
    }
    
}

#pragma mark ------ 全选
-(void)clickTheRigthButton:(UIButton*)btn
{
    if (self.managerArray.count > 0) {
        
        if (!btn.selected) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, -20);
            
//            for (int i = 0; i < self.managerArray.count; i++) {
//                WX_ScriptManagerTableViewCell *cell = [self.view viewWithTag:100+i];
//                cell.selectBtn.selected = YES;
//                [self.deleteArray addObject:cell.titleLabel.text];
//            }
        
            
            for (WX_ScriptModel *model in self.managerArray) {
                WX_ScriptInfoModel *infoModel = model.videoLenArray[0];
                // 删除1-9
                [self.deleteArray addObject:[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length -1]];
                [self.btnArray addObject:[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length -1]];
                
                // 删除 双位 即 10+, 十以上的的数
                for (int i = 0; i < 10; i++) {
                    if ([[infoModel.videoLen_ShootName substringFromIndex:infoModel.videoLen_ShootName.length-2] isEqualToString:[NSString stringWithFormat:@"%zi",i]]) {
                        [self.deleteArray addObject:[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length -2]];
                        [self.btnArray addObject:[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length -2]];
                    }
                }
             
            }
            
        }else{
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
            [self.deleteArray removeAllObjects];
            [self.btnArray removeAllObjects];
        }
        
        btn.selected = !btn.selected;
        self.rightButton.hidden = NO;
        [self.managerTableView reloadData];
    }else{
        self.rightButton.hidden = YES;
    }
    

    
}

#pragma mark ------ 删除按钮
-(void)deleteScript:(UIButton *)btn
{

    for (NSString *title in self.deleteArray) {
        for (int i = 0; i < self.managerArray.count; i++) {
            WX_ScriptModel *scriptModel = self.managerArray[i];
             WX_ScriptInfoModel *infoModel = scriptModel.videoLenArray[0];
            
            if ([[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length -1] isEqualToString:title]) {
                
                [self.managerArray removeObject:scriptModel];
                for (WX_ScriptInfoModel *deleteInfoModel in scriptModel.videoLenArray) {
                    
                    [self removeScriptFromFMDBWithScriptName:deleteInfoModel.videoLen_ShootName];
                    [self removeScriptFromSanBoxWithScriptName:deleteInfoModel.videoLen_ShootName];
                }
                i = i-- < 0 ? 0: i--;
            }else if ([[infoModel.videoLen_ShootName substringToIndex:infoModel.videoLen_ShootName.length -2] isEqualToString:title]){
                [self.managerArray removeObject:scriptModel];
                for (WX_ScriptInfoModel *deleteInfoModel in scriptModel.videoLenArray) {
                    
                    [self removeScriptFromFMDBWithScriptName:deleteInfoModel.videoLen_ShootName];
                    [self removeScriptFromSanBoxWithScriptName:deleteInfoModel.videoLen_ShootName];
                }
                i = i-- < 0 ? 0: i--;
            }
        }
    }
    [self tableViewReloadData];
    
    [QNWSNotificationCenter postNotificationName:@"removeScriptImg" object:nil userInfo:nil];

    
}

#pragma mark ------ 把镜头从表中移除
-(void)removeScriptFromFMDBWithScriptName:(NSString *)scriptName
{
    self.manager = [WX_FMDBManager sharedWX_FMDBManager];
    if (![self.manager.dataBase executeUpdate:@"delete from Script3 where scriptName = ?",scriptName]){
        QNWSLog(@"数据库删除失败");
    }
    
}

#pragma mark ----- 把镜头从沙盒中移除
-(void)removeScriptFromSanBoxWithScriptName:(NSString *)scriptName
{
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    NSString *mediaPath = [path stringByAppendingPathComponent:@"Script"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *delPath=[mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",scriptName]];
    
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
    
    
    QNWSLog(@"剧本%@删除成功",scriptName);
    
}
#pragma mark ----- 重载tableView
-(void)tableViewReloadData
{
    if (self.managerArray.count > 0) {
        self.managerTableView.hidden = NO;
        if (self.managerArray.count*KManagerTableViewRowHeight < screenHeight -KHeightTabBar -64) {
            
            self.managerTableView.kheight = KManagerTableViewRowHeight *self.managerArray.count;
        }else{
            self.managerTableView.kheight = screenHeight -KHeightTabBar -64;
        }
        [self.managerTableView reloadData];
        self.rightButton.hidden = NO;
    }else{
        self.managerTableView.hidden = YES;
        
         self.rightButton.selected = NO;
        
        self.rightButton.hidden = YES;

//        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(rightBtnHidden) userInfo:nil repeats:NO];
    }
    
    self.rightButton.selected = NO;
    
}

//-(void)rightBtnHidden
//{
//    self.rightButton.hidden = YES;
//}

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
