//
//  WX_MyMovieViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_MyMovieViewController.h"
#import "BYC_AccountModel.h"
#import "BYC_AccountTool.h"
#import "BYC_OtherViewControllerModel.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_CenterCollectionViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_ControllerCustomView.h"
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_HttpServers+HL_PersonalVC.h"

#import "BYC_MyCenterHandler.h"


@interface WX_MyMovieViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    BYC_AccountModel *_userModel;
}
@property(nonatomic, retain) UICollectionView           *works_CollectionView;
@property(nonatomic, assign) BOOL                       isMore;
@property(nonatomic, assign) NSInteger                  deleteNum;

@property (nonatomic, strong) NSMutableArray *array_worksModels;
@end

@implementation WX_MyMovieViewController

-(NSMutableArray *)array_worksModels{
    if (!_array_worksModels) {
        _array_worksModels = [NSMutableArray array];
    }
    return _array_worksModels;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self initCollectionView];
}

-(void)createUI
{
    self.title = @"作品";
    self.view.backgroundColor = KUIColorBackground;

}

- (void)initCollectionView {
    //设置布局
    if (!self.works_CollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = .5f;
        layout.minimumLineSpacing      = 0.f;
        layout.itemSize = CGSizeMake(screenWidth , 70.f);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.works_CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight-KHeightNavigationBar) collectionViewLayout:layout];
        self.works_CollectionView.backgroundColor  = [UIColor whiteColor];
        self.works_CollectionView.showsVerticalScrollIndicator = NO;
        self.works_CollectionView.delegate = self;
        self.works_CollectionView.dataSource = self;
        
        self.works_CollectionView.emptyDataSetSource = self;
        self.works_CollectionView.emptyDataSetDelegate = self;
        
        [self.works_CollectionView registerNib:[UINib nibWithNibName:@"BYC_CenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"centerCollectionViewCell"];
        
#pragma mark --------- 添加手势
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [self.works_CollectionView addGestureRecognizer:longPressGr];
        
        [self.view addSubview:self.works_CollectionView];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    //加载数据
    //获取个人信息
    //loadType:   0--默认加载  1--作品  2--关注  3--粉丝
    //toUserId:   他人主页-----他人的UserId    个人主页 ----self.userInfoModel.userid
    //upType:     0--默认   1--下拉  2--上拉
    //userid     登陆用户Id   self.userInfoModel.userid
    //time：   关注时间
    //videoId: 视频编号
    //time、videoId 上下拉时才用到
    [self loadDataWithParam:@{@"loadType":@1,@"toUserId":[BYC_AccountTool userAccount].userid,@"upType":@0,@"userId":[BYC_AccountTool userAccount].userid}];
    
    // 下拉刷新
    self.works_CollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        BYC_BaseVideoModel *worksModel = [self.array_worksModels firstObject];
        [weakSelf loadDataWithParam:@{@"loadType":@1,@"toUserId":[BYC_AccountTool userAccount].userid,@"upType":@1,@"userId":[BYC_AccountTool userAccount].userid,@"time":worksModel.onmstime,@"videoId":worksModel.videoid}];
    }];
    // 上拉更新
    self.works_CollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        BYC_BaseVideoModel *worksModel = [self.array_worksModels lastObject];
        
        [weakSelf loadDataWithParam:@{@"loadType":@1,@"toUserId":[BYC_AccountTool userAccount].userid,@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"time":worksModel.onmstime,@"videoId":worksModel.videoid}];
    }];
}

#pragma mark - 网络请求
- (void)loadDataWithParam:(NSDictionary *)param{
    //网络请求
    QNWSWeakSelf(self);
    [BYC_HttpServers requestPersonalVCDataWithParameters:param success:^(BYC_MyCenterHandler *handler) {
        if (self.works_CollectionView.header.isRefreshing) {
            if (handler.handler_Works.mArr_Models.count >0) {
                [self.array_worksModels removeAllObjects];
                [self.array_worksModels addObjectsFromArray:handler.handler_Works.mArr_Models];
            }
            [self.works_CollectionView.header endRefreshing];
        }else if (self.works_CollectionView.footer.isRefreshing) {
            [self.works_CollectionView.footer endRefreshing];
            // 结束刷新
            if (handler.handler_Works.mArr_Models.count == 0) {
                [self.works_CollectionView.footer endRefreshingWithNoMoreData];
            }
            else{
                NSMutableArray *arr_videoData = [handler.handler_Works.mArr_Models mutableCopy];
                for (int i = 0; i<arr_videoData.count; i++) {
                    
                    for (BYC_BaseVideoModel *videoModel2 in weakself.array_worksModels) {
                        if ([((BYC_BaseVideoModel *)arr_videoData[i]).videoid isEqualToString:videoModel2.videoid]){
                            [arr_videoData removeObjectAtIndex:i];
                        }
                    }
                }
                if (arr_videoData.count == 0) {
                    [self.works_CollectionView.footer endRefreshingWithNoMoreData];
                }
                else [self.array_worksModels addObjectsFromArray:arr_videoData];
            }
        }else {
            [self.array_worksModels removeAllObjects];
            self.array_worksModels = [handler.handler_Works.mArr_Models mutableCopy];
        }
        [self.works_CollectionView reloadData];
    } failure:^(NSError *error) {
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        if (self.works_CollectionView.footer.isRefreshing) {
            [self.works_CollectionView.footer endRefreshing];
        }
        else if (self.works_CollectionView.header.isRefreshing){
            [self.works_CollectionView.header endRefreshing];
        }
    }];
}

#pragma Mark - collection的DataSource 和 Delegate方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array_worksModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"centerCollectionViewCell";
    
    BYC_CenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    cell.model = self.array_worksModels[indexPath.row];
    QNWSLog(@"cell == %@",cell);
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 通知中心
    NSNotification *notification = [NSNotification notificationWithName:@"hiddenTheButton" object:nil userInfo:@{@"1":@"1"}];
    [QNWSNotificationCenter postNotification:notification];
    BYC_HomeViewControllerModel *model = self.array_worksModels[indexPath.section*20+indexPath.row];
    [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 1://返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 2://关注
            
            break;
            
        default:
            break;
    }
}


#pragma mark --------- 长按删除
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.works_CollectionView];
        NSIndexPath * indexPath = [self.works_CollectionView indexPathForItemAtPoint:point];
        BYC_CenterCollectionViewCell *cell = (BYC_CenterCollectionViewCell *)[self.works_CollectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        if(indexPath == nil)
            return ;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您想要删除作品么" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        [alert show];
        self.deleteNum = indexPath.row;
        QNWSLog(@"indexPath.row == %ld",indexPath.row);
    }
}

#pragma mark ---------- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.array_worksModels.count > 0) {
        if (buttonIndex == 0) {
            [self.view showHUDWithTitle:@"正在删除" WithState:BYC_MBProgressHUDShowTurnplateProgress];
            QNWSLog(@"删除啦");
            BYC_HomeViewControllerModel  *model = self.array_worksModels[self.deleteNum];
            NSArray *arr_param = @[model.userid,model.videoid];
            [self deleteVideoWithDic:arr_param];
            
            QNWSLog(@"videoTitle == %@",model.videotitle);
            QNWSLog(@"deleteNum == %ld",self.deleteNum);
            QNWSLog(@"model.videoDescription == %@",model.video_Description);
        }
        else if (buttonIndex == 1){
            BYC_CenterCollectionViewCell *cell = (BYC_CenterCollectionViewCell *)[self.works_CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.deleteNum inSection:0]];
            cell.backgroundColor = [UIColor clearColor];
            return;
        }
}
    }

#pragma mark --------- 删除
-(void)deleteVideoWithDic:(NSArray *)arr_param
{
    [BYC_HttpServers requestVideosWithDeleteParames:arr_param success:^(BOOL isSuccess) {
        if (isSuccess) {
        [self initCollectionView];
        //通知动态页面删除相关视频
        [QNWSNotificationCenter postNotificationName:KNotification_DeletePhoneVideo object:nil];
        }
    } failure:^(NSError *error) {
        QNWSLog(@"删除接口请求失败, error == %@",error);
        [self.view showAndHideHUDWithTitle:@"删除失败" WithState:BYC_MBProgressHUDHideProgress];

    }];
    BYC_CenterCollectionViewCell *cell = (BYC_CenterCollectionViewCell *)[self.works_CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.deleteNum inSection:0]];
    cell.backgroundColor = [UIColor clearColor];
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
